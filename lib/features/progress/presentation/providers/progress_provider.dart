import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../feedback/data/models/feedback_model.dart';
import '../../data/models/user_progress_model.dart';

/// User progress data.
final userProgressProvider = Provider<UserProgressModel>((ref) {
  return ref.watch(progressRepositoryProvider).getProgress();
});

/// Score history for chart (weekly or monthly).
final scoreHistoryProvider =
    Provider.family<List<FeedbackModel>, int>((ref, days) {
  return ref.watch(progressRepositoryProvider).getScoreHistory(days: days);
});

/// Weak pronunciation patterns.
final weakPatternsProvider = Provider<Map<String, double>>((ref) {
  return ref.watch(progressRepositoryProvider).getWeakPatterns();
});

/// Practice days map for calendar heatmap (last 28 days).
final practiceCalendarProvider = Provider<Map<DateTime, int>>((ref) {
  final feedbacks =
      ref.watch(progressRepositoryProvider).getScoreHistory(days: 28);
  final dayMap = <DateTime, int>{};
  for (final f in feedbacks) {
    final day =
        DateTime(f.createdAt.year, f.createdAt.month, f.createdAt.day);
    dayMap[day] = (dayMap[day] ?? 0) + 1;
  }
  return dayMap;
});

/// Category-wise average scores (sorted by score descending).
final categoryScoresProvider = Provider<Map<String, double>>((ref) {
  final feedbackRepo = ref.watch(feedbackRepositoryProvider);
  final lessonRepo = ref.watch(lessonRepositoryProvider);
  final feedbacks = feedbackRepo.findAll();

  final grouped = <String, List<int>>{};
  for (final f in feedbacks) {
    final lesson = lessonRepo.findById(f.lessonId);
    if (lesson != null) {
      grouped.putIfAbsent(lesson.category, () => []).add(f.overallScore);
    }
  }

  final entries = grouped.entries
      .map((e) =>
          MapEntry(e.key, e.value.reduce((a, b) => a + b) / e.value.length))
      .toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return Map.fromEntries(entries);
});

/// Sub-score averages (pronunciation, rhythm, intonation) from last 30 days.
final subScoreAveragesProvider = Provider<SubScoreAverages>((ref) {
  final feedbacks =
      ref.watch(progressRepositoryProvider).getScoreHistory(days: 30);
  if (feedbacks.isEmpty) {
    return const SubScoreAverages(
        pronunciation: 0, rhythm: 0, intonation: 0);
  }

  final len = feedbacks.length;
  final p =
      feedbacks.map((f) => f.pronunciationScore).reduce((a, b) => a + b) /
          len;
  final r =
      feedbacks.map((f) => f.rhythmScore).reduce((a, b) => a + b) / len;
  final i =
      feedbacks.map((f) => f.intonationScore).reduce((a, b) => a + b) / len;

  return SubScoreAverages(pronunciation: p, rhythm: r, intonation: i);
});

class SubScoreAverages {
  const SubScoreAverages({
    required this.pronunciation,
    required this.rhythm,
    required this.intonation,
  });

  final double pronunciation;
  final double rhythm;
  final double intonation;
}
