import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider =
    StateNotifierProvider.autoDispose<TtsNotifier, TtsState>(
  (ref) => TtsNotifier(),
);

class TtsState {
  const TtsState({
    this.isSpeaking = false,
    this.speed = 0.45,
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

  Future<void> _init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(state.speed);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      if (mounted) state = state.copyWith(isSpeaking: true);
    });

    _tts.setCompletionHandler(() {
      if (mounted) state = state.copyWith(isSpeaking: false);
    });

    _tts.setCancelHandler(() {
      if (mounted) state = state.copyWith(isSpeaking: false);
    });

    _tts.setErrorHandler((msg) {
      if (mounted) state = state.copyWith(isSpeaking: false);
    });
  }

  Future<void> speak(String text) async {
    if (state.isSpeaking) {
      await stop();
      return;
    }
    await _tts.setSpeechRate(state.speed);
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> setSpeed(double speed) async {
    await _tts.setSpeechRate(speed);
    state = state.copyWith(speed: speed);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}
