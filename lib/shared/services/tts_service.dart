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
    _init();
  }

  final _tts = FlutterTts();

  /// Completer used by [speakOnce] to await natural completion of a single
  /// utterance (chunk). Non-null only while a [speakOnce] call is in flight.
  Completer<void>? _speakCompleter;

  Future<void> _init() async {
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
    // Cancel any in-flight utterance and resolve its future.
    if (state.isSpeaking || _speakCompleter != null) {
      await _tts.stop();
      _completeSpeak();
    }

    final completer = Completer<void>();
    _speakCompleter = completer;
    await _tts.setSpeechRate(state.speed);
    await _tts.speak(text);
    return completer.future;
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
