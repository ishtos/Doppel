import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../data/models/feedback_model.dart';

/// Single feedback by ID.
final feedbackByIdProvider =
    Provider.family<FeedbackModel?, String>((ref, id) {
  return ref.watch(feedbackRepositoryProvider).findById(id);
});

/// Recent feedbacks list.
final recentFeedbacksProvider = Provider<List<FeedbackModel>>((ref) {
  return ref.watch(feedbackRepositoryProvider).findRecent(limit: 10);
});

/// Feedbacks for a specific lesson.
final feedbacksByLessonProvider =
    Provider.family<List<FeedbackModel>, String>((ref, lessonId) {
  return ref.watch(feedbackRepositoryProvider).findByLessonId(lessonId);
});
