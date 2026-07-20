import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider =
    StateNotifierProvider.autoDispose<TtsNotifier, TtsState>(
  (ref) => TtsNotifier(),
);

class TtsState {
  const TtsState({
    this.isSpeaking = false,
    this.speed = 0.5,
  });

  final bool isSpeaking;
  final double speed;

  TtsState copyWith({bool? isSpeaking, double? speed}) {
    return TtsState(
      isSpeaking: isSpeaking ?? this.isSpeaking,
      speed: speed ?? this.speed,
    );
  }
}

class TtsNotifier extends StateNotifier<TtsState> {
  TtsNotifier() : super(const TtsState()) {
    _ready = _init();
  }

  final _tts = FlutterTts();

  /// Completes once [_init] has registered the completion handlers and set
  /// `awaitSpeakCompletion`. Speak calls await this so they never run before the
  /// completion wiring is in place (otherwise the future they return could
  /// never resolve). Never rejects — [_init] swallows its own errors.
  late final Future<void> _ready;

  /// Completer used by [speakOnce] to await natural completion of a single
  /// utterance (chunk). Non-null only while a [speakOnce] call is in flight.
  Completer<void>? _speakCompleter;

  Future<void> _init() async {
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(state.speed);
      await _tts.setPitch(1.0);
      // Required so the completion handler fires only after audio finishes,
      // which the chunk A-B loop / auto-advance depends on.
      await _tts.awaitSpeakCompletion(true);

      _tts.setStartHandler(() {
        if (mounted) state = state.copyWith(isSpeaking: true);
      });

      _tts.setCompletionHandler(() {
        if (mounted) state = state.copyWith(isSpeaking: false);
        _completeSpeak();
      });

      _tts.setCancelHandler(() {
        if (mounted) state = state.copyWith(isSpeaking: false);
        _completeSpeak();
      });

      _tts.setErrorHandler((msg) {
        if (mounted) state = state.copyWith(isSpeaking: false);
        _completeSpeak();
      });
    } catch (_) {
      // Best-effort init; speak still attempts to work.
    }
  }

  /// Resolve any pending [speakOnce] future exactly once.
  void _completeSpeak() {
    final completer = _speakCompleter;
    _speakCompleter = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete();
    }
  }

  Future<void> speak(String text) async {
    await _ready;
    if (state.isSpeaking) {
      await stop();
      return;
    }
    await _tts.setSpeechRate(state.speed);
    await _tts.speak(text);
  }

  /// Speak [text] once and complete the returned future when the utterance
  /// finishes (or is cancelled / errors). Unlike [speak] this does NOT toggle
  /// stop when already speaking — it stops the current utterance first, then
  /// speaks the new one. Used by the chunk shadowing loop.
  Future<void> speakOnce(String text) async {
    await _ready;
    // Cancel any in-flight utterance and resolve its future.
    if (state.isSpeaking || _speakCompleter != null) {
      await _tts.stop();
      _completeSpeak();
    }

    final completer = Completer<void>();
    _speakCompleter = completer;
    await _tts.setSpeechRate(state.speed);
    // Fire the utterance but do NOT await it: with awaitSpeakCompletion the
    // returned future blocks until the completion callback fires, which hangs
    // forever if that callback is missed. Instead we await our own completer
    // (resolved by the completion handler) with an estimated-duration timeout
    // fallback, so the read-along loop always advances instead of hanging.
    unawaited(_tts.speak(text).catchError((_) {}));
    return completer.future.timeout(
      _estimatedDuration(text),
      onTimeout: _completeSpeak,
    );
  }

  // Generous estimate of how long [text] takes to speak, used only as the
  // fallback timeout above; normal completion resolves well before this.
  Duration _estimatedDuration(String text) {
    final words =
        text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final wordsPerSecond = 1.0 + state.speed * 2.0; // ~2.0 wps at speed 0.5
    final seconds = words / wordsPerSecond + 2.5; // headroom
    return Duration(
      milliseconds: (seconds * 1000).clamp(3000, 30000).toInt(),
    );
  }

  Future<void> stop() async {
    await _tts.stop();
    state = state.copyWith(isSpeaking: false);
    _completeSpeak();
  }

  Future<void> setSpeed(double speed) async {
    await _tts.setSpeechRate(speed);
    state = state.copyWith(speed: speed);
  }

  @override
  void dispose() {
    _tts.stop();
    _completeSpeak();
    super.dispose();
  }
}
