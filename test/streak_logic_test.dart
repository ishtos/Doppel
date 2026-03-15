import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/progress/data/repositories/progress_repository.dart';

void main() {
  late Box<Map> progressBox;
  late Box<Map> feedbackBox;
  late ProgressRepository repo;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_streak');

    progressBox = await Hive.openBox<Map>('streak_progress');
    feedbackBox = await Hive.openBox<Map>('streak_feedbacks');

    repo = ProgressRepository(
      progressBox: progressBox,
      feedbackBox: feedbackBox,
    );
  });

  tearDown(() async {
    await progressBox.clear();
    await feedbackBox.clear();
    await Hive.close();
  });

  group('Streak calculation', () {
    test('first practice sets streak to 1', () async {
      await repo.recordPractice(durationMinutes: 3);
      final progress = repo.getProgress();
      expect(progress.currentStreak, 1);
      expect(progress.completedLessons, 1);
      expect(progress.totalPracticeMinutes, 3);
    });

    test('same-day practice keeps streak unchanged', () async {
      await repo.recordPractice(durationMinutes: 3);
      await repo.recordPractice(durationMinutes: 5);

      final progress = repo.getProgress();
      expect(progress.currentStreak, 1);
      expect(progress.completedLessons, 2);
      expect(progress.totalPracticeMinutes, 8);
    });

    test('longestStreak updates correctly', () async {
      await repo.recordPractice(durationMinutes: 3);
      final progress = repo.getProgress();
      expect(progress.longestStreak, 1);
    });

    test('default progress returns zero streak', () {
      final progress = repo.getProgress();
      expect(progress.currentStreak, 0);
      expect(progress.longestStreak, 0);
      expect(progress.totalPracticeMinutes, 0);
      expect(progress.completedLessons, 0);
    });
  });
}
