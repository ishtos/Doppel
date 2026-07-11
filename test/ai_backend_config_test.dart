import 'package:doppel/shared/services/ai_backend.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiBackendConfig', () {
    test('direct mode: uses OpenAI URLs and a bearer header', () {
      final c = AiBackendConfig(apiKey: 'sk-test');
      expect(c.usesProxy, isFalse);
      expect(c.isAvailable, isTrue);
      expect(c.chatUrl, 'https://api.openai.com/v1/chat/completions');
      expect(c.transcriptionUrl,
          'https://api.openai.com/v1/audio/transcriptions');
      expect(c.authHeaders(), {'Authorization': 'Bearer sk-test'});
    });

    test('proxy mode: routes to the proxy and sends X-App-Token, not the key',
        () {
      final c = AiBackendConfig(
        apiKey: '', // no key embedded in the app
        proxyUrl: 'https://proxy.example.workers.dev',
        proxyToken: 'app-token',
      );
      expect(c.usesProxy, isTrue);
      expect(c.isAvailable, isTrue);
      expect(c.chatUrl,
          'https://proxy.example.workers.dev/v1/chat/completions');
      expect(c.transcriptionUrl,
          'https://proxy.example.workers.dev/v1/audio/transcriptions');
      expect(c.authHeaders(), {'X-App-Token': 'app-token'});
      // The OpenAI key is never sent from the client in proxy mode.
      expect(c.authHeaders().containsKey('Authorization'), isFalse);
    });

    test('proxy mode: trailing slash is normalized', () {
      final c = AiBackendConfig(proxyUrl: 'https://proxy.example.workers.dev/');
      expect(c.chatUrl,
          'https://proxy.example.workers.dev/v1/chat/completions');
    });

    test('proxy mode without a token sends no auth header', () {
      final c = AiBackendConfig(proxyUrl: 'https://proxy.example.workers.dev');
      expect(c.authHeaders(), isEmpty);
    });

    test('neither proxy nor key: not available', () {
      final c = AiBackendConfig(apiKey: '', proxyUrl: '');
      expect(c.isAvailable, isFalse);
    });
  });
}
