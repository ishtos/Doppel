import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doppel/features/progress/data/models/user_progress_model.dart';
import 'package:doppel/features/progress/data/repositories/progress_repository.dart';
import 'package:doppel/shared/services/ai_backend.dart';
import 'package:doppel/shared/services/progress_backup_service.dart';
import 'package:doppel/shared/services/progress_backup_startup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Box<Map> progressBox;
  late Box<Map> feedbackBox;

  final proxy = AiBackendConfig(proxyUrl: 'https://p.example', proxyToken: 't');

  UserProgressModel u(int streak, int completed, DateTime last) =>
      UserProgressModel(
        userId: 'default',
        currentStreak: streak,
        longestStreak: streak,
        totalPracticeMinutes: completed * 5,
        completedLessons: completed,
        lastPracticeDate: last,
      );

  setUp(() async {
    SharedPreferences.setMockInitialValues({'app_account_token': 'tok'});
    Hive.init('./test_hive_restore');
    progressBox = await Hive.openBox<Map>('progress_restore');
    feedbackBox = await Hive.openBox<Map>('feedback_restore');
    await progressBox.clear();
  });

  tearDown(() async {
    await progressBox.clear();
    await feedbackBox.clear();
    await Hive.close();
  });

  test('merges a higher remote snapshot into local progress', () async {
    final repo =
        ProgressRepository(progressBox: progressBox, feedbackBox: feedbackBox);
    await repo.saveProgress(u(2, 3, DateTime(2026, 7, 10)));

    final remote = u(9, 40, DateTime(2026, 7, 14));
    final client = MockClient((_) async => http.Response(
        jsonEncode({'data': remote.toJson(), 'updatedAt': 1700000000000}), 200));
    final service = ProgressBackupService(proxy, httpClient: client);

    await restoreProgressBackup(
        progressBox: progressBox, feedbackBox: feedbackBox, service: service);

    final merged = repo.getProgress();
    expect(merged.completedLessons, 40);
    expect(merged.currentStreak, 9);
    expect(merged.lastPracticeDate, DateTime(2026, 7, 14));
  });

  test('keeps local progress when the remote is empty', () async {
    final repo =
        ProgressRepository(progressBox: progressBox, feedbackBox: feedbackBox);
    await repo.saveProgress(u(5, 20, DateTime(2026, 7, 12)));

    final client = MockClient(
        (_) async => http.Response('{"data":null,"updatedAt":null}', 200));
    final service = ProgressBackupService(proxy, httpClient: client);

    await restoreProgressBackup(
        progressBox: progressBox, feedbackBox: feedbackBox, service: service);

    final after = repo.getProgress();
    expect(after.completedLessons, 20);
    expect(after.currentStreak, 5);
  });

  test('is a no-op when the backup service is unavailable (direct mode)',
      () async {
    final repo =
        ProgressRepository(progressBox: progressBox, feedbackBox: feedbackBox);
    await repo.saveProgress(u(5, 20, DateTime(2026, 7, 12)));

    var called = false;
    final client = MockClient((_) async {
      called = true;
      return http.Response('{}', 200);
    });
    final service =
        ProgressBackupService(AiBackendConfig(apiKey: 'sk'), httpClient: client);

    await restoreProgressBackup(
        progressBox: progressBox, feedbackBox: feedbackBox, service: service);

    expect(called, isFalse);
    expect(repo.getProgress().completedLessons, 20);
  });
}
