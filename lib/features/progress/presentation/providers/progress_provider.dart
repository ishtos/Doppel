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
