import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../features/lesson/data/models/lesson_model.dart';
import 'seed_data.dart';

/// Seeds and migrates the lessons box from the bundled [seedLessons].
///
/// - New lessons (by id) are inserted — covers first launch (empty box → all
///   added) and app updates that ship additional lessons.
/// - For lessons the user already has, the bundled *content* is refreshed while
///   the user's own state (bookmark / completion / last practiced) is preserved.
///   Freezed value equality means only genuinely-changed lessons are rewritten,
///   so steady-state launches write nothing.
///
/// This lets content updates (e.g. shortened passages) reach existing installs
/// on the next launch without a reinstall.
Future<void> syncSeedLessons(Box<Map> lessonsBox) async {
  for (final lesson in seedLessons) {
    final existing = lessonsBox.get(lesson.id);
    if (existing == null) {
      await lessonsBox.put(lesson.id, lesson.toJson());
      continue;
    }
    final prev = LessonModel.fromJson(Map<String, dynamic>.from(existing));
    // Overwrite content from the seed, but keep the user's state.
    final merged = lesson.copyWith(
      isBookmarked: prev.isBookmarked,
      isCompleted: prev.isCompleted,
      lastPracticedAt: prev.lastPracticedAt,
    );
    if (merged != prev) {
      await lessonsBox.put(lesson.id, merged.toJson());
    }
  }
}
