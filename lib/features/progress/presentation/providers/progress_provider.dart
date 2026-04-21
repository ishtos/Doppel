import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../feedback/data/models/feedback_model.dart';
import '../../data/models/day_activity.dart';
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

// FIXED: カレンダー表示用の月選択状態
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

// FIXED: 選択月の日別練習アクティビティ
final monthlyActivityProvider = Provider<Map<DateTime, DayActivity>>((ref) {
  final month = ref.watch(selectedMonthProvider);
  return ref
      .watch(progressRepositoryProvider)
      .getMonthlyActivity(month.year, month.month);
});
