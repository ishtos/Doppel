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

// Box-change "revision" streams. Hive boxes don't notify Riverpod on their
// own, so derived read-providers watch these to recompute when the box changes
// (e.g. after recordPractice / feedback save). The incrementing int makes each
// change a distinct value so dependents actually rebuild.
final progressRevisionProvider = StreamProvider<int>((ref) {
  final box = ref.watch(progressBoxProvider);
  var n = 0;
  return box.watch().map((_) => ++n);
});

final feedbacksRevisionProvider = StreamProvider<int>((ref) {
  final box = ref.watch(feedbacksBoxProvider);
  var n = 0;
  return box.watch().map((_) => ++n);
});

final lessonsRevisionProvider = StreamProvider<int>((ref) {
  final box = ref.watch(lessonsBoxProvider);
  var n = 0;
  return box.watch().map((_) => ++n);
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
