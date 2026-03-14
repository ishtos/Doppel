import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../features/feedback/data/repositories/feedback_repository.dart';
import '../../features/lesson/data/repositories/lesson_repository.dart';
import '../../features/progress/data/repositories/progress_repository.dart';

// Hive box providers
final lessonsBoxProvider = Provider<Box<Map>>((ref) {
  return Hive.box<Map>('lessons');
});

final feedbacksBoxProvider = Provider<Box<Map>>((ref) {
  return Hive.box<Map>('feedbacks');
});

final progressBoxProvider = Provider<Box<Map>>((ref) {
  return Hive.box<Map>('progress');
});

// Repository providers
final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(ref.watch(lessonsBoxProvider));
});

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepository(ref.watch(feedbacksBoxProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository(
    progressBox: ref.watch(progressBoxProvider),
    feedbackBox: ref.watch(feedbacksBoxProvider),
  );
});
