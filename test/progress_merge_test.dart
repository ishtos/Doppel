import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/progress/data/models/user_progress_model.dart';
import 'package:doppel/features/progress/data/progress_merge.dart';

UserProgressModel _p({
  int streak = 0,
  int longest = 0,
  int minutes = 0,
  int completed = 0,
  DateTime? last,
}) =>
    UserProgressModel(
      userId: 'default',
      currentStreak: streak,
      longestStreak: longest,
      totalPracticeMinutes: minutes,
      completedLessons: completed,
      lastPracticeDate: last ?? DateTime(2026, 1, 1),
    );

void main() {
  test('takes the larger of each counter', () {
    final a = _p(streak: 10, longest: 12, minutes: 300, completed: 50);
    final b = _p(streak: 3, longest: 20, minutes: 100, completed: 60);
    final m = mergeProgress(a, b);
    expect(m.currentStreak, 10);
    expect(m.longestStreak, 20);
    expect(m.totalPracticeMinutes, 300);
    expect(m.completedLessons, 60);
  });

  test('keeps the most recent practice date, either argument order', () {
    final older = _p(last: DateTime(2026, 7, 10));
    final newer = _p(last: DateTime(2026, 7, 14));
    expect(mergeProgress(older, newer).lastPracticeDate, DateTime(2026, 7, 14));
    expect(mergeProgress(newer, older).lastPracticeDate, DateTime(2026, 7, 14));
  });

  test('is commutative', () {
    final a = _p(streak: 5, longest: 9, minutes: 120, completed: 30, last: DateTime(2026, 7, 12));
    final b = _p(streak: 7, longest: 7, minutes: 200, completed: 25, last: DateTime(2026, 7, 11));
    expect(mergeProgress(a, b), mergeProgress(b, a));
  });

  test('currentStreak follows the more recent snapshot, not max (no phantom streak)', () {
    // A: a big streak that went stale (last practiced weeks ago).
    final stale = _p(streak: 30, longest: 30, last: DateTime(2026, 7, 1));
    // B: a fresh, small streak practiced today.
    final fresh = _p(streak: 3, longest: 5, last: DateTime(2026, 7, 16));
    final m = mergeProgress(stale, fresh);
    expect(m.currentStreak, 3, reason: 'must not resurrect the stale 30-day streak');
    expect(m.longestStreak, 30, reason: 'all-time peak still preserved');
    expect(m.lastPracticeDate, DateTime(2026, 7, 16));
    // Commutative.
    expect(mergeProgress(fresh, stale).currentStreak, 3);
  });

  test('never downgrades local progress against an empty remote', () {
    final local = _p(streak: 8, longest: 8, minutes: 240, completed: 40, last: DateTime(2026, 7, 13));
    final emptyRemote = _p(); // fresh install: all zeros, old date
    final m = mergeProgress(local, emptyRemote);
    expect(m.currentStreak, 8);
    expect(m.completedLessons, 40);
    expect(m.lastPracticeDate, DateTime(2026, 7, 13));
  });
}
