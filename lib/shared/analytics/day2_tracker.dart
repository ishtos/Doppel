import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/db_providers.dart';
import 'analytics_events.dart';
import 'analytics_provider.dart';

/// Calendar-day difference (time-of-day ignored). 0 = same day, 1 = next day.
int calendarDaysBetween(DateTime from, DateTime to) {
  final a = DateTime(from.year, from.month, from.day);
  final b = DateTime(to.year, to.month, to.day);
  return b.difference(a).inDays;
}

/// The day gap to report for a `day2_return`, or null when the user is not
/// returning on a later calendar day than their last practice (same day, or a
/// future timestamp from clock skew).
int? day2ReturnGap(DateTime lastPractice, DateTime now) {
  final days = calendarDaysBetween(lastPractice, now);
  return days >= 1 ? days : null;
}

bool _fired = false;

/// Fires `day2_return` at most once per app launch, when the user returns on a
/// later day than their last practice. Safe to call from a `build` method (the
/// launch-scoped guard makes repeat calls no-ops).
void maybeCaptureDay2Return(WidgetRef ref, {DateTime? now}) {
  if (_fired) return;
  _fired = true;
  final progress = ref.read(progressRepositoryProvider).getProgress();
  final gap = day2ReturnGap(progress.lastPracticeDate, now ?? DateTime.now());
  if (gap == null) return;
  ref.read(analyticsProvider).capture(
    AnalyticsEvents.day2Return,
    properties: {
      'days_since_last': gap,
      'current_streak': progress.currentStreak,
    },
  );
}

@visibleForTesting
void resetDay2ReturnGuard() => _fired = false;
