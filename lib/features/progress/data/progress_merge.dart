import 'dart:math';

import 'models/user_progress_model.dart';

/// Merges two progress snapshots without losing progress: cumulative counters
/// take the larger value, and the current streak follows whichever snapshot
/// practiced most recently.
///
/// Used to reconcile a restored server snapshot with local state (D-2:
/// "progress-preferring merge"), so a reinstall or a second device can never
/// roll a user's minutes/completion count backwards. The merge is commutative.
///
/// `currentStreak` is NOT max()'d: a streak only means something relative to its
/// own `lastPracticeDate` (it resets on a gap), so a stale-but-high streak must
/// not resurrect as "active". It is taken from the more recent snapshot;
/// `longestStreak` still keeps the all-time peak via max.
///
/// Note: independent max on cumulative counters is a safe lower bound (never
/// rolls back) but is NOT lossless for concurrent offline use on two devices —
/// e.g. +5 on A and +3 on B from the same base yields +5, not +8. True
/// multi-device losslessness would need per-lesson event records.
UserProgressModel mergeProgress(UserProgressModel a, UserProgressModel b) {
  final int currentStreak;
  final DateTime lastPracticeDate;
  if (a.lastPracticeDate.isAfter(b.lastPracticeDate)) {
    currentStreak = a.currentStreak;
    lastPracticeDate = a.lastPracticeDate;
  } else if (b.lastPracticeDate.isAfter(a.lastPracticeDate)) {
    currentStreak = b.currentStreak;
    lastPracticeDate = b.lastPracticeDate;
  } else {
    // Same practice day → keep the higher streak (also keeps it commutative).
    currentStreak = max(a.currentStreak, b.currentStreak);
    lastPracticeDate = a.lastPracticeDate;
  }
  return UserProgressModel(
    userId: a.userId,
    currentStreak: currentStreak,
    longestStreak: max(a.longestStreak, b.longestStreak),
    totalPracticeMinutes: max(a.totalPracticeMinutes, b.totalPracticeMinutes),
    completedLessons: max(a.completedLessons, b.completedLessons),
    lastPracticeDate: lastPracticeDate,
  );
}
