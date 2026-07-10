import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/services/audio_service.dart';
import '../../../../shared/services/tts_service.dart';
import '../../../../shared/utils/sentence_splitter.dart';
import 'lesson_provider.dart';

/// Per-chunk practice status.
enum ChunkStatus { notStarted, recording, recorded }

/// How the user records audio for scoring.
/// [whole] records the whole passage in a single take; [perChunk] records each
/// sentence separately (the original shadowing-loop behaviour).
enum RecordMode { whole, perChunk }

/// Sentence/breath-group chunks for a lesson, computed once at runtime.
/// Keyed by lessonId. Returns an empty list if the lesson is missing.
final lessonChunksProvider = Provider.family<List<String>, String>((ref, id) {
  final lesson = ref.watch(lessonByIdProvider(id));
  if (lesson == null) return const [];
  return splitIntoChunks(lesson.transcriptText);
});

/// Shadowing session state for one lesson.
final shadowingSessionProvider = StateNotifierProvider.autoDispose
    .family<ShadowingSessionNotifier, ShadowingSessionState, String>(
  (ref, lessonId) {
    final chunks = ref.watch(lessonChunksProvider(lessonId));
    return ShadowingSessionNotifier(ref, chunks);
  },
);

class ShadowingSessionState {
  const ShadowingSessionState({
    this.chunks = const [],
    this.currentIndex = 0,
    this.statuses = const {},
    this.recordingPaths = const {},
    this.loopMode = false,
    this.hideText = false,
    this.autoAdvance = true,
    this.recordMode = RecordMode.whole,
    this.wholeRecordingPath,
    this.wholeRecorded = false,
  });

  final List<String> chunks;
  final int currentIndex;
  final Map<int, ChunkStatus> statuses;
  final Map<int, String> recordingPaths;
  final bool loopMode;
  final bool hideText;
  final bool autoAdvance;

  /// Whole-passage vs per-chunk recording. Defaults to [RecordMode.whole].
  final RecordMode recordMode;

  /// Single continuous recording of the whole passage (whole mode).
  final String? wholeRecordingPath;

  /// True once a whole-passage recording has been attempted (true even when the
  /// path is null, e.g. simulator without a mic → simulated-score fallback).
  final bool wholeRecorded;

  ChunkStatus statusOf(int index) => statuses[index] ?? ChunkStatus.notStarted;

  bool get hasChunks => chunks.isNotEmpty;

  int get recordedCount =>
      statuses.values.where((s) => s == ChunkStatus.recorded).length;

  /// 0.0–1.0 fraction of chunks recorded.
  double get progressFraction =>
      chunks.isEmpty ? 0.0 : recordedCount / chunks.length;

  /// True once enough has been recorded to score, per the active mode.
  bool get canScore => recordMode == RecordMode.whole
      ? wholeRecorded
      : recordedCount > 0;

  bool get isLast => currentIndex >= chunks.length - 1;
  bool get isFirst => currentIndex <= 0;

  /// Per-chunk audio paths aligned to [chunks] (null = not recorded).
  List<String?> get orderedAudioPaths =>
      List.generate(chunks.length, (i) => recordingPaths[i]);

  ShadowingSessionState copyWith({
    List<String>? chunks,
    int? currentIndex,
    Map<int, ChunkStatus>? statuses,
    Map<int, String>? recordingPaths,
    bool? loopMode,
    bool? hideText,
    bool? autoAdvance,
    RecordMode? recordMode,
    String? wholeRecordingPath,
    bool? wholeRecorded,
    bool clearWholeRecording = false,
  }) {
    return ShadowingSessionState(
      chunks: chunks ?? this.chunks,
      currentIndex: currentIndex ?? this.currentIndex,
      statuses: statuses ?? this.statuses,
      recordingPaths: recordingPaths ?? this.recordingPaths,
      loopMode: loopMode ?? this.loopMode,
      hideText: hideText ?? this.hideText,
      autoAdvance: autoAdvance ?? this.autoAdvance,
      recordMode: recordMode ?? this.recordMode,
      wholeRecordingPath: clearWholeRecording
          ? null
          : (wholeRecordingPath ?? this.wholeRecordingPath),
      wholeRecorded: wholeRecorded ?? this.wholeRecorded,
    );
  }
}

class ShadowingSessionNotifier extends StateNotifier<ShadowingSessionState> {
  ShadowingSessionNotifier(this._ref, List<String> chunks)
      : super(ShadowingSessionState(chunks: chunks));

  final Ref _ref;
  bool _disposed = false;

  TtsNotifier get _tts => _ref.read(ttsServiceProvider.notifier);
  AudioRecorderNotifier get _recorder =>
      _ref.read(audioRecorderProvider.notifier);
  AudioPlayerNotifier get _player => _ref.read(audioPlayerProvider.notifier);

  // ── Navigation ──

  Future<void> goTo(int index) async {
    if (index < 0 || index >= state.chunks.length) return;
    await _stopEverything();
    state = state.copyWith(currentIndex: index);
  }

  Future<void> next() => goTo(state.currentIndex + 1);
  Future<void> prev() => goTo(state.currentIndex - 1);

  // ── Listen (model TTS) ──

  /// Speak the current chunk once. If loop mode is on, keep repeating until the
  /// user turns it off, navigates away, or the session is disposed.
  Future<void> listenCurrent() async {
    if (!state.hasChunks) return;
    final index = state.currentIndex;

    // If already speaking, treat this as a stop toggle. Also disable loop mode
    // so the do-while below breaks instead of restarting.
    if (_ref.read(ttsServiceProvider).isSpeaking) {
      if (state.loopMode) state = state.copyWith(loopMode: false);
      await _tts.stop();
      return;
    }

    // Repeat while loop mode stays on and we're still on the same chunk.
    do {
      await _tts.speakOnce(state.chunks[index]);
      if (_disposed || !state.loopMode || state.currentIndex != index) break;
      // Brief gap between repeats for a natural rhythm (and to avoid a hot
      // loop on platforms where TTS completion resolves instantly).
      await Future<void>.delayed(const Duration(milliseconds: 400));
    } while (!_disposed && state.loopMode && state.currentIndex == index);
  }

  // ── Record (user) ──

  Future<void> startRecordCurrent() async {
    if (!state.hasChunks) return;
    await _tts.stop();

    final index = state.currentIndex;

    // Re-recording: delete the previous take to avoid disk bloat.
    await _deleteRecording(index);

    final started = await _recorder.tryStartRecording();
    if (started) {
      _setStatus(index, ChunkStatus.recording);
    } else {
      // No microphone (e.g. simulator): mark the chunk as attempted (no path)
      // so the session can still be scored via the simulated fallback, and
      // advance as usual.
      _setStatus(index, ChunkStatus.recorded);
      if (state.autoAdvance && !state.isLast) {
        await next();
      }
    }
  }

  Future<void> stopRecordCurrent() async {
    final index = state.currentIndex;
    final path = await _recorder.stopRecording();

    if (path != null) {
      final paths = Map<int, String>.from(state.recordingPaths)..[index] = path;
      final statuses = Map<int, ChunkStatus>.from(state.statuses)
        ..[index] = ChunkStatus.recorded;
      state = state.copyWith(recordingPaths: paths, statuses: statuses);
    } else {
      _setStatus(index, ChunkStatus.recorded);
    }

    if (state.autoAdvance && !state.isLast) {
      await next();
    }
  }

  Future<void> cancelRecordCurrent() async {
    await _recorder.cancelRecording();
    _setStatus(state.currentIndex, ChunkStatus.notStarted);
  }

  /// Replay the user's own recording of the current chunk, if any.
  Future<void> replayCurrentRecording() async {
    final path = state.recordingPaths[state.currentIndex];
    if (path == null) return;
    await _tts.stop();
    await _player.playFile(path);
  }

  // ── Record (whole passage) ──

  /// Start a single continuous recording of the whole passage.
  Future<void> startWholeRecording() async {
    await _tts.stop();
    await _deleteWholeRecording();
    // Reset any prior take so re-recording starts clean.
    state = state.copyWith(wholeRecorded: false, clearWholeRecording: true);

    final started = await _recorder.tryStartRecording();
    if (!started) {
      // No microphone (e.g. simulator): mark as recorded so scoring can still
      // run via the simulated-score fallback, mirroring per-chunk behaviour.
      state = state.copyWith(wholeRecorded: true);
    }
  }

  Future<void> stopWholeRecording() async {
    final path = await _recorder.stopRecording();
    if (path != null) {
      state = state.copyWith(wholeRecordingPath: path, wholeRecorded: true);
    } else {
      state = state.copyWith(wholeRecorded: true);
    }
  }

  Future<void> cancelWholeRecording() async {
    await _recorder.cancelRecording();
    await _deleteWholeRecording();
    state = state.copyWith(wholeRecorded: false, clearWholeRecording: true);
  }

  /// Replay the whole-passage recording, if any.
  Future<void> replayWholeRecording() async {
    final path = state.wholeRecordingPath;
    if (path == null) return;
    await _tts.stop();
    await _player.playFile(path);
  }

  // ── Modes ──

  void setRecordMode(RecordMode mode) {
    if (mode == state.recordMode) return;
    state = state.copyWith(recordMode: mode);
  }

  void toggleRecordMode() => setRecordMode(
        state.recordMode == RecordMode.whole
            ? RecordMode.perChunk
            : RecordMode.whole,
      );

  void toggleLoop() => state = state.copyWith(loopMode: !state.loopMode);
  void toggleHideText() => state = state.copyWith(hideText: !state.hideText);
  void toggleAutoAdvance() =>
      state = state.copyWith(autoAdvance: !state.autoAdvance);

  // ── Helpers ──

  void _setStatus(int index, ChunkStatus status) {
    final statuses = Map<int, ChunkStatus>.from(state.statuses)
      ..[index] = status;
    state = state.copyWith(statuses: statuses);
  }

  Future<void> _stopEverything() async {
    await _tts.stop();
    // In whole-passage mode keep an in-progress recording running so the user
    // can navigate chunks (to read along) while recording straight through.
    if (state.recordMode == RecordMode.whole) return;
    if (_ref.read(audioRecorderProvider).isRecording) {
      await _recorder.cancelRecording();
      _setStatus(state.currentIndex, ChunkStatus.notStarted);
    }
  }

  Future<void> _deleteWholeRecording() async {
    final path = state.wholeRecordingPath;
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort cleanup.
    }
  }

  Future<void> _deleteRecording(int index) async {
    final path = state.recordingPaths[index];
    if (path == null) return;
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Best-effort cleanup.
    }
    final paths = Map<int, String>.from(state.recordingPaths)..remove(index);
    state = state.copyWith(recordingPaths: paths);
  }

  @override
  void dispose() {
    _disposed = true;
    // Fire-and-forget stop; the underlying notifiers may already be disposed.
    try {
      _tts.stop();
    } catch (_) {}
    super.dispose();
  }
}
