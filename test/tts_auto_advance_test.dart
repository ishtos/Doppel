import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/services/tts_service.dart';

// Regression for "read-aloud doesn't auto-advance": if the platform's
// flutter_tts completion callback is never delivered, speakOnce must still
// resolve (via the estimated-duration timeout) so the listen-all loop advances
// instead of hanging on the first chunk.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('flutter_tts');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      // Accept every call, but NEVER deliver a completion callback — simulating
      // a platform (e.g. the iOS simulator) that drops it.
      return 1;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('speakOnce resolves via the timeout fallback when completion never fires',
      () async {
    final tts = TtsNotifier();
    addTearDown(tts.dispose);

    // Must complete rather than hang. The outer timeout fails the test (instead
    // of hanging the suite) if the fallback regresses.
    await tts.speakOnce('hi').timeout(
          const Duration(seconds: 10),
          onTimeout: () => fail('speakOnce hung — timeout fallback did not fire'),
        );
  });
}
