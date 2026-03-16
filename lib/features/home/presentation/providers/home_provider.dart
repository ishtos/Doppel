import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../lesson/data/models/lesson_model.dart';
import '../../../progress/data/models/user_progress_model.dart';

/// User progress for home screen display.
final homeProgressProvider = Provider<UserProgressModel>((ref) {
  return ref.watch(progressRepositoryProvider).getProgress();
});

/// Today's recommended lesson.
final todayLessonProvider = Provider<LessonModel?>((ref) {
  final repo = ref.watch(lessonRepositoryProvider);
  final lessons = repo.findAll();
  if (lessons.isEmpty) return null;

  // Recommend the first incomplete lesson
  final incomplete = lessons.where((l) => !l.isCompleted).toList();
  return incomplete.isNotEmpty ? incomplete.first : lessons.first;
});

/// Recent activity (latest feedbacks with lesson info).
final recentActivityProvider = Provider<List<RecentActivity>>((ref) {
  final feedbackRepo = ref.watch(feedbackRepositoryProvider);
  final lessonRepo = ref.watch(lessonRepositoryProvider);
  final feedbacks = feedbackRepo.findRecent(limit: 5);

  return feedbacks.map((f) {
    final lesson = lessonRepo.findById(f.lessonId);
    return RecentActivity(
      feedbackId: f.id,
      lessonTitle: lesson?.title ?? '不明なレッスン',
      score: f.overallScore,
      date: f.createdAt,
    );
  }).toList();
});

/// Aggregated improvement points from recent feedbacks.
final recentImprovementPointsProvider =
    Provider<List<ImprovementPoint>>((ref) {
  final feedbackRepo = ref.watch(feedbackRepositoryProvider);
  final lessonRepo = ref.watch(lessonRepositoryProvider);
  final feedbacks = feedbackRepo.findRecent(limit: 10);

  // Aggregate problem words, keeping the most recent occurrence.
  final seen = <String, ImprovementPoint>{};
  for (final f in feedbacks) {
    final lessonTitle =
        lessonRepo.findById(f.lessonId)?.title ?? '不明なレッスン';
    for (final pw in f.problemWords) {
      final key = pw.word.toLowerCase();
      if (!seen.containsKey(key)) {
        seen[key] = ImprovementPoint(
          word: pw.word,
          phoneme: pw.phoneme,
          errorRate: pw.errorRate,
          lessonTitle: lessonTitle,
          feedbackId: f.id,
          date: f.createdAt,
          count: 1,
        );
      } else {
        seen[key] = seen[key]!.copyWith(count: seen[key]!.count + 1);
      }
    }
  }

  // Sort by count descending, then by errorRate descending.
  final points = seen.values.toList()
    ..sort((a, b) {
      final c = b.count.compareTo(a.count);
      return c != 0 ? c : b.errorRate.compareTo(a.errorRate);
    });

  return points.take(8).toList();
});

/// Weekly stats for home screen.
final weeklyStatsProvider = Provider<WeeklyStats>((ref) {
  final progressRepo = ref.watch(progressRepositoryProvider);

  final weekFeedbacks = progressRepo.getScoreHistory(days: 7);
  final count = weekFeedbacks.length;
  final avgScore = count > 0
      ? (weekFeedbacks.map((f) => f.overallScore).reduce((a, b) => a + b) /
              count)
          .round()
      : 0;

  // Estimate weekly minutes from recent feedbacks
  final weeklyMinutes = count * 3; // ~3 min per lesson

  return WeeklyStats(
    practiceCount: count,
    averageScore: avgScore,
    totalMinutes: weeklyMinutes,
  );
});

class RecentActivity {
  const RecentActivity({
    required this.feedbackId,
    required this.lessonTitle,
    required this.score,
    required this.date,
  });

  final String feedbackId;
  final String lessonTitle;
  final int score;
  final DateTime date;
}

class ImprovementPoint {
  const ImprovementPoint({
    required this.word,
    required this.phoneme,
    required this.errorRate,
    required this.lessonTitle,
    required this.feedbackId,
    required this.date,
    required this.count,
  });

  final String word;
  final String phoneme;
  final double errorRate;
  final String lessonTitle;
  final String feedbackId;
  final DateTime date;
  final int count;

  ImprovementPoint copyWith({int? count}) {
    return ImprovementPoint(
      word: word,
      phoneme: phoneme,
      errorRate: errorRate,
      lessonTitle: lessonTitle,
      feedbackId: feedbackId,
      date: date,
      count: count ?? this.count,
    );
  }
}

class WeeklyStats {
  const WeeklyStats({
    required this.practiceCount,
    required this.averageScore,
    required this.totalMinutes,
  });

  final int practiceCount;
  final int averageScore;
  final int totalMinutes;
}
