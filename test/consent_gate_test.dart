import 'package:doppel/shared/services/ai_backend.dart';
import 'package:doppel/shared/services/ai_coach_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('AiCoachService cloud-consent gate', () {
    test('no network call when cloudEnabled is false (even with a key)',
        () async {
      var called = false;
      final client = MockClient((_) async {
        called = true;
        return http.Response('{}', 200);
      });
      final svc = AiCoachService(
          backend: AiBackendConfig(apiKey: 'sk-test'), httpClient: client);

      final msg = await svc.generateFeedback(
        pronunciationScore: 70,
        rhythmScore: 65,
        intonationScore: 60,
        problemWords: const ['world'],
        cloudEnabled: false,
      );

      expect(called, isFalse); // no audio/data left the device
      expect(msg.text, isNotEmpty); // local template returned
      expect(msg.isFallback, isFalse); // local by design, not a failure
    });

    test('no network call when there is no API key (even if cloudEnabled)',
        () async {
      var called = false;
      final client = MockClient((_) async {
        called = true;
        return http.Response('{}', 200);
      });
      final svc = AiCoachService(
          backend: AiBackendConfig(apiKey: ''), httpClient: client);

      final msg = await svc.generateFeedback(
        pronunciationScore: 70,
        rhythmScore: 65,
        intonationScore: 60,
        problemWords: const ['world'],
        cloudEnabled: true,
      );

      expect(called, isFalse);
      expect(msg.text, isNotEmpty);
      expect(msg.isFallback, isFalse);
    });

    test('calls the network when cloudEnabled is true and a key is set',
        () async {
      var called = false;
      String? sentBody;
      final client = MockClient((request) async {
        called = true;
        sentBody = request.body;
        return http.Response(
          '{"choices":[{"message":{"content":"よくできました"}}]}',
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });
      final svc = AiCoachService(
          backend: AiBackendConfig(apiKey: 'sk-test'), httpClient: client);

      final msg = await svc.generateFeedback(
        pronunciationScore: 90,
        rhythmScore: 88,
        intonationScore: 85,
        problemWords: const [],
        cloudEnabled: true,
      );

      expect(called, isTrue);
      expect(msg.text, 'よくできました');
      expect(msg.isFallback, isFalse);
      // GPT-5 models require max_completion_tokens (max_tokens → 400). Guard it.
      expect(sentBody, contains('max_completion_tokens'));
      expect(sentBody, contains('reasoning_effort'));
      expect(sentBody, isNot(contains('"max_tokens"')));
    });

    test('cloud failure marks the message as a fallback', () async {
      final client = MockClient((_) async => http.Response('err', 500));
      final svc = AiCoachService(
          backend: AiBackendConfig(apiKey: 'sk-test'), httpClient: client);

      final msg = await svc.generateFeedback(
        pronunciationScore: 70,
        rhythmScore: 65,
        intonationScore: 60,
        problemWords: const ['world'],
        cloudEnabled: true,
      );

      expect(msg.isFallback, isTrue); // cloud attempted but failed
      expect(msg.text, isNotEmpty); // local template used
    });
  });
}
