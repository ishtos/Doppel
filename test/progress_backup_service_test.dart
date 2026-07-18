import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:doppel/features/progress/data/models/user_progress_model.dart';
import 'package:doppel/shared/services/ai_backend.dart';
import 'package:doppel/shared/services/progress_backup_service.dart';

void main() {
  final proxy = AiBackendConfig(
    proxyUrl: 'https://proxy.example.workers.dev',
    proxyToken: 'app-token',
  );

  UserProgressModel sample() => UserProgressModel(
        userId: 'default',
        currentStreak: 4,
        longestStreak: 9,
        totalPracticeMinutes: 120,
        completedLessons: 30,
        lastPracticeDate: DateTime(2026, 7, 13, 8),
      );

  group('sync', () {
    test('POSTs data + token to /progress/sync and returns true on 200', () async {
      String? path;
      String? token;
      Map<String, dynamic>? body;
      final client = MockClient((req) async {
        path = req.url.path;
        token = req.headers['X-App-Token'];
        body = jsonDecode(req.body) as Map<String, dynamic>;
        return http.Response('{"ok":true}', 200);
      });
      final svc = ProgressBackupService(proxy, httpClient: client);

      final ok = await svc.sync(appAccountToken: 'tok', progress: sample());
      expect(ok, isTrue);
      expect(path, '/progress/sync');
      expect(token, 'app-token');
      expect(body!['appAccountToken'], 'tok');
      expect((body!['data'] as Map)['completedLessons'], 30);
    });

    test('returns false on non-200 (no downgrade)', () async {
      final client = MockClient((_) async => http.Response('{}', 500));
      final svc = ProgressBackupService(proxy, httpClient: client);
      expect(await svc.sync(appAccountToken: 'tok', progress: sample()), isFalse);
    });
  });

  group('fetch', () {
    test('parses a stored snapshot and its timestamp', () async {
      final client = MockClient((req) async {
        expect(req.headers['X-App-Account-Token'], 'tok');
        return http.Response(
          jsonEncode({'data': sample().toJson(), 'updatedAt': 1700000000000}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final svc = ProgressBackupService(proxy, httpClient: client);

      final snap = await svc.fetch(appAccountToken: 'tok');
      expect(snap, isNotNull);
      expect(snap!.progress.completedLessons, 30);
      expect(snap.progress.currentStreak, 4);
      expect(snap.updatedAt, DateTime.fromMillisecondsSinceEpoch(1700000000000));
    });

    test('null when nothing is stored yet (data: null)', () async {
      final client = MockClient(
        (_) async => http.Response('{"data":null,"updatedAt":null}', 200),
      );
      final svc = ProgressBackupService(proxy, httpClient: client);
      expect(await svc.fetch(appAccountToken: 'tok'), isNull);
    });
  });

  group('delete', () {
    test('DELETEs with the token header and returns true on 200', () async {
      String? method;
      String? token;
      final client = MockClient((req) async {
        method = req.method;
        token = req.headers['X-App-Account-Token'];
        return http.Response('{"ok":true}', 200);
      });
      final svc = ProgressBackupService(proxy, httpClient: client);
      expect(await svc.delete(appAccountToken: 'tok'), isTrue);
      expect(method, 'DELETE');
      expect(token, 'tok');
    });
  });

  group('direct mode (no proxy configured)', () {
    test('is unavailable and makes no network call', () async {
      var called = false;
      final client = MockClient((_) async {
        called = true;
        return http.Response('{}', 200);
      });
      final svc = ProgressBackupService(
        AiBackendConfig(apiKey: 'sk-test'),
        httpClient: client,
      );
      expect(svc.isAvailable, isFalse);
      expect(await svc.sync(appAccountToken: 'tok', progress: sample()), isFalse);
      expect(await svc.fetch(appAccountToken: 'tok'), isNull);
      expect(called, isFalse);
    });
  });
}
