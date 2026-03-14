import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// ── Playback Provider ──

final audioPlayerProvider =
    StateNotifierProvider.autoDispose<AudioPlayerNotifier, AudioPlayerState>(
  (ref) => AudioPlayerNotifier(),
);

class AudioPlayerState {
  const AudioPlayerState({
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.speed = 1.0,
    this.isLoaded = false,
  });

  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final double speed;
  final bool isLoaded;

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    double? speed,
    bool? isLoaded,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      speed: speed ?? this.speed,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(const AudioPlayerState());

  final _player = AudioPlayer();

  Future<void> loadAsset(String assetPath) async {
    try {
      final duration = await _player.setAsset(assetPath);
      state = state.copyWith(
        duration: duration ?? Duration.zero,
        isLoaded: true,
        position: Duration.zero,
      );
      _listenToPosition();
    } catch (_) {
      // Asset not found — no-op for demo data
    }
  }

  Future<void> loadUrl(String url) async {
    final duration = await _player.setUrl(url);
    state = state.copyWith(
      duration: duration ?? Duration.zero,
      isLoaded: true,
      position: Duration.zero,
    );
    _listenToPosition();
  }

  void _listenToPosition() {
    _player.positionStream.listen((pos) {
      if (mounted) {
        state = state.copyWith(position: pos);
      }
    });
    _player.playerStateStream.listen((playerState) {
      if (mounted) {
        state = state.copyWith(
          isPlaying: playerState.playing,
        );
        if (playerState.processingState == ProcessingState.completed) {
          state = state.copyWith(isPlaying: false, position: Duration.zero);
          _player.seek(Duration.zero);
          _player.pause();
        }
      }
    });
  }

  Future<void> play() async {
    await _player.play();
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlay() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> rewind5s() async {
    final newPos = state.position - const Duration(seconds: 5);
    await seek(newPos < Duration.zero ? Duration.zero : newPos);
  }

  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

// ── Recording Provider ──

final audioRecorderProvider =
    StateNotifierProvider.autoDispose<AudioRecorderNotifier, AudioRecorderState>(
  (ref) => AudioRecorderNotifier(),
);

class AudioRecorderState {
  const AudioRecorderState({
    this.isRecording = false,
    this.recordingPath,
    this.amplitude = 0.0,
  });

  final bool isRecording;
  final String? recordingPath;
  final double amplitude;

  AudioRecorderState copyWith({
    bool? isRecording,
    String? recordingPath,
    double? amplitude,
  }) {
    return AudioRecorderState(
      isRecording: isRecording ?? this.isRecording,
      recordingPath: recordingPath ?? this.recordingPath,
      amplitude: amplitude ?? this.amplitude,
    );
  }
}

class AudioRecorderNotifier extends StateNotifier<AudioRecorderState> {
  AudioRecorderNotifier() : super(const AudioRecorderState());

  final _recorder = AudioRecorder();

  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    if (!await hasPermission()) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/recording_${const Uuid().v4()}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );

    state = state.copyWith(isRecording: true, recordingPath: path);
  }

  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    state = state.copyWith(isRecording: false);
    return path;
  }

  Future<void> toggleRecording() async {
    if (state.isRecording) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
