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

/// Category-based performance analysis. // FIXED: カテゴリ別パフォーマンス分析プロバイダー追加
final categoryPerformanceProvider = Provider<List<CategoryPerformance>>((ref) {
  final feedbackRepo = ref.watch(feedbackRepositoryProvider);
  final lessonRepo = ref.watch(lessonRepositoryProvider);
  final feedbacks = feedbackRepo.findAll();

  // Group feedbacks by lesson category
  final categoryMap = <String, List<FeedbackModel>>{};
  for (final f in feedbacks) {
    final lesson = lessonRepo.findById(f.lessonId);
    if (lesson != null) {
      categoryMap.putIfAbsent(lesson.category, () => []).add(f);
    }
  }

  if (categoryMap.isEmpty) return [];

  return categoryMap.entries.map((entry) {
    final list = entry.value;
    final count = list.length;
    final avgScore =
        list.map((f) => f.overallScore).reduce((a, b) => a + b) / count;
    return CategoryPerformance(
      category: entry.key,
      practiceCount: count,
      averageScore: avgScore,
    );
  }).toList()
    ..sort((a, b) => b.averageScore.compareTo(a.averageScore));
});

/// Performance data for a single lesson category.
class CategoryPerformance {
  const CategoryPerformance({
    required this.category,
    required this.practiceCount,
    required this.averageScore,
  });

  final String category;
  final int practiceCount;
  final double averageScore;
}
