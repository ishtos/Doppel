import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/home/presentation/providers/home_provider.dart';

void main() {
  group('DailyGoalProgress', () {
    test('progress is 0.0 when goal is 0', () {
      const progress = DailyGoalProgress(goal: 0, completed: 0);
      expect(progress.progress, 0.0);
      expect(progress.isAchieved, true);
    });

    test('progress is 0.0 when completed is 0', () {
      const progress = DailyGoalProgress(goal: 3, completed: 0);
      expect(progress.progress, 0.0);
      expect(progress.isAchieved, false);
    });

    test('progress is 0.5 when half completed', () {
      const progress = DailyGoalProgress(goal: 4, completed: 2);
      expect(progress.progress, 0.5);
      expect(progress.isAchieved, false);
    });

    test('progress clamps to 1.0 when completed exceeds goal', () {
      const progress = DailyGoalProgress(goal: 3, completed: 5);
      expect(progress.progress, 1.0);
      expect(progress.isAchieved, true);
    });

    test('isAchieved is true when completed equals goal', () {
      const progress = DailyGoalProgress(goal: 3, completed: 3);
      expect(progress.progress, 1.0);
      expect(progress.isAchieved, true);
    });

    test('isAchieved is false when completed is one short', () {
      const progress = DailyGoalProgress(goal: 3, completed: 2);
      expect(progress.isAchieved, false);
    });

    test('progress with goal of 1', () {
      const zero = DailyGoalProgress(goal: 1, completed: 0);
      const one = DailyGoalProgress(goal: 1, completed: 1);
      expect(zero.progress, 0.0);
      expect(zero.isAchieved, false);
      expect(one.progress, 1.0);
      expect(one.isAchieved, true);
    });
  });

  group('ImprovementPoint', () {
    test('copyWith updates count', () {
      final point = ImprovementPoint(
        word: 'through',
        phoneme: '/θ/',
        errorRate: 0.7,
        lessonTitle: 'Test Lesson',
        feedbackId: 'fb-001',
        date: DateTime(2026, 4, 27),
        count: 1,
      );

      final updated = point.copyWith(count: 3);
      expect(updated.count, 3);
      expect(updated.word, 'through');
      expect(updated.phoneme, '/θ/');
      expect(updated.errorRate, 0.7);
    });

    test('copyWith without arguments preserves all fields', () {
      final now = DateTime(2026, 4, 27);
      final point = ImprovementPoint(
        word: 'really',
        phoneme: '/r/',
        errorRate: 0.5,
        lessonTitle: 'Lesson A',
        feedbackId: 'fb-002',
        date: now,
        count: 2,
      );

      final copy = point.copyWith();
      expect(copy.word, point.word);
      expect(copy.phoneme, point.phoneme);
      expect(copy.errorRate, point.errorRate);
      expect(copy.lessonTitle, point.lessonTitle);
      expect(copy.feedbackId, point.feedbackId);
      expect(copy.date, point.date);
      expect(copy.count, point.count);
    });
  });

  group('WeeklyStats', () {
    test('stores practice count, average score, and total minutes', () {
      const stats = WeeklyStats(
        practiceCount: 5,
        averageScore: 78,
        totalMinutes: 15,
      );

      expect(stats.practiceCount, 5);
      expect(stats.averageScore, 78);
      expect(stats.totalMinutes, 15);
    });
  });

  group('RecentActivity', () {
    test('stores all required fields', () {
      final activity = RecentActivity(
        feedbackId: 'fb-001',
        lessonTitle: 'Morning News',
        score: 85,
        date: DateTime(2026, 4, 27),
      );

      expect(activity.feedbackId, 'fb-001');
      expect(activity.lessonTitle, 'Morning News');
      expect(activity.score, 85);
      expect(activity.date, DateTime(2026, 4, 27));
    });
  });
}
