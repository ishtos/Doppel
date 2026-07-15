import 'dart:math';

import 'models/user_progress_model.dart';

/// Merges two progress snapshots without ever losing progress: each counter
/// takes the larger value and the most recent practice date wins.
///
/// Used to reconcile a restored server snapshot with local state (D-2:
/// "progress-preferring merge"), so a reinstall or a second device can never
/// roll a user's streak, minutes, or completion count backwards. The merge is
/// commutative — `mergeProgress(a, b)` and `mergeProgress(b, a)` are equal.
UserProgressModel mergeProgress(UserProgressModel a, UserProgressModel b) {
  return UserProgressModel(
    userId: a.userId,
    currentStreak: max(a.currentStreak, b.currentStreak),
    longestStreak: max(a.longestStreak, b.longestStreak),
    totalPracticeMinutes: max(a.totalPracticeMinutes, b.totalPracticeMinutes),
    completedLessons: max(a.completedLessons, b.completedLessons),
    lastPracticeDate: a.lastPracticeDate.isAfter(b.lastPracticeDate)
        ? a.lastPracticeDate
        : b.lastPracticeDate,
  );
}
