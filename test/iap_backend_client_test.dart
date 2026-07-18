import 'package:doppel/shared/services/ai_backend.dart';
import 'package:doppel/shared/services/iap_backend.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  final proxy = AiBackendConfig(
    proxyUrl: 'https://proxy.example.workers.dev',
    proxyToken: 'app-token',
  );

  group('IapBackendClient', () {
    test('verify posts to /iap/verify with the app token and parses entitled',
        () async {
      String? path;
      String? token;
      final client = MockClient((req) async {
        path = req.url.path;
        token = req.headers['X-App-Token'];
        return http.Response(
          '{"entitled":true,"expiresDate":"2026-08-01T00:00:00Z"}',
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final iap = IapBackendClient(proxy, httpClient: client);

      final ent = await iap.verify(appAccountToken: 'tok', receipt: 'r');
      expect(ent, isNotNull);
      expect(ent!.entitled, isTrue);
      expect(ent.expiresDate, isNotNull);
      expect(path, '/iap/verify');
      expect(token, 'app-token');
    });

    test('entitlement GETs with appAccountToken and parses not-entitled',
        () async {
      final client = MockClient((req) async {
        expect(req.headers['X-App-Account-Token'], 'tok');
        return http.Response('{"entitled":false}', 200,
            headers: {'content-type': 'application/json'});
      });
      final iap = IapBackendClient(proxy, httpClient: client);

      final ent = await iap.entitlement(appAccountToken: 'tok');
      expect(ent, isNotNull);
      expect(ent!.entitled, isFalse);
    });

    test('non-200 response yields null', () async {
      final client = MockClient((_) async => http.Response('{}', 500));
      final iap = IapBackendClient(proxy, httpClient: client);
      expect(await iap.verify(appAccountToken: 'tok', receipt: 'r'), isNull);
    });

    test('direct mode (no proxy): unavailable, no network, returns null',
        () async {
      var called = false;
      final client = MockClient((_) async {
        called = true;
        return http.Response('{}', 200);
      });
      final iap = IapBackendClient(
        AiBackendConfig(apiKey: 'sk-test'),
        httpClient: client,
      );
      expect(iap.isAvailable, isFalse);
      expect(await iap.verify(appAccountToken: 'tok', receipt: 'r'), isNull);
      expect(await iap.entitlement(appAccountToken: 'tok'), isNull);
      expect(called, isFalse);
    });
  });
}
