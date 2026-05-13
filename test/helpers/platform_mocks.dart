import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void setupMockPlatformChannels() {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_tts'),
    (MethodCall call) async {
      switch (call.method) {
        case 'speak':
        case 'stop':
        case 'setLanguage':
        case 'setSpeechRate':
        case 'setPitch':
        case 'setVolume':
        case 'isLanguageAvailable':
          return 1;
        case 'getLanguages':
        case 'getVoices':
          return <dynamic>[];
        default:
          return null;
      }
    },
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('com.ryanheise.just_audio.methods'),
    (MethodCall call) async {
      switch (call.method) {
        case 'init':
          return <String, dynamic>{};
        case 'disposePlayer':
          return <String, dynamic>{};
        default:
          return null;
      }
    },
  );
}

void tearDownMockPlatformChannels() {
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_tts'),
    null,
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('com.ryanheise.just_audio.methods'),
    null,
  );
}
