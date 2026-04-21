import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/day_activity.dart';
import '../providers/progress_provider.dart';

class StreakCalendar extends ConsumerWidget {
  const StreakCalendar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final activity = ref.watch(monthlyActivityProvider);
    final now = DateTime.now();

    final year = selectedMonth.year;
    final month = selectedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday;

    final practicedDays = activity.length;
    final avgScore = activity.isEmpty
        ? 0.0
        : activity.values.map((a) => a.avgScore).reduce((a, b) => a + b) /
            activity.length;

    final canGoForward =
        year < now.year || (year == now.year && month < now.month);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('練習カレンダー', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            _MonthNavigation(
              year: year,
              month: month,
              canGoForward: canGoForward,
              onPrevious: () {
                ref.read(selectedMonthProvider.notifier).state =
                    DateTime(year, month - 1);
              },
              onNext: canGoForward
                  ? () {
                      ref.read(selectedMonthProvider.notifier).state =
                          DateTime(year, month + 1);
                    }
                  : null,
            ),
            const SizedBox(height: 8),
            _WeekdayHeaders(theme: theme),
            const SizedBox(height: 4),
            _CalendarGrid(
              year: year,
              month: month,
              daysInMonth: daysInMonth,
              firstWeekday: firstWeekday,
              activity: activity,
              today: now,
              theme: theme,
            ),
            const SizedBox(height: 12),
            _Legend(theme: theme),
            const SizedBox(height: 8),
            _MonthlySummary(
              theme: theme,
              practicedDays: practicedDays,
              avgScore: avgScore,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthNavigation extends StatelessWidget {
  const _MonthNavigation({
    required this.year,
    required this.month,
    required this.canGoForward,
    required this.onPrevious,
    required this.onNext,
  });

  final int year;
  final int month;
  final bool canGoForward;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
        ),
        Text(
          '$year年$month月',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

class _WeekdayHeaders extends StatelessWidget {
  const _WeekdayHeaders({required this.theme});

  final ThemeData theme;

  static const _weekdays = ['月', '火', '水', '木', '金', '土', '日'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _weekdays
          .map((day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.year,
    required this.month,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.activity,
    required this.today,
    required this.theme,
  });

  final int year;
  final int month;
  final int daysInMonth;
  final int firstWeekday;
  final Map<DateTime, DayActivity> activity;
  final DateTime today;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    var dayCounter = 1;
    final emptyCells = firstWeekday - 1;

    for (var row = 0; row < 6; row++) {
      if (dayCounter > daysInMonth) break;

      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;

        if (cellIndex < emptyCells || dayCounter > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 36)));
        } else {
          final date = DateTime(year, month, dayCounter);
          final dayActivity = activity[date];
          final isToday = date.year == today.year &&
              date.month == today.month &&
              date.day == today.day;

          cells.add(Expanded(
            child: _DayCell(
              day: dayCounter,
              activity: dayActivity,
              isToday: isToday,
              theme: theme,
            ),
          ));
          dayCounter++;
        }
      }

      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(children: cells),
      ));
    }

    return Column(children: rows);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.activity,
    required this.isToday,
    required this.theme,
  });

  final int day;
  final DayActivity? activity;
  final bool isToday;
  final ThemeData theme;

  double _intensityFromScore(int score) {
    if (score >= 80) return 0.7;
    if (score >= 60) return 0.45;
    if (score >= 40) return 0.25;
    return 0.15;
  }

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    if (activity != null) {
      bgColor = theme.colorScheme.tertiary
          .withValues(alpha: _intensityFromScore(activity!.bestScore));
    }

    return Container(
      height: 36,
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: bgColor ??
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
        border: isToday
            ? Border.all(color: theme.colorScheme.primary, width: 2)
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                fontWeight: isToday ? FontWeight.bold : null,
                color: activity != null
                    ? theme.colorScheme.onTertiaryContainer
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (activity != null && activity!.practiceCount > 1)
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.onTertiaryContainer
                      .withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '少',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 4),
        for (final alpha in [0.15, 0.25, 0.45, 0.7])
          Container(
            width: 14,
            height: 14,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: alpha),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        const SizedBox(width: 4),
        Text(
          '多',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _MonthlySummary extends StatelessWidget {
  const _MonthlySummary({
    required this.theme,
    required this.practicedDays,
    required this.avgScore,
  });

  final ThemeData theme;
  final int practicedDays;
  final double avgScore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.local_fire_department,
            size: 16, color: theme.colorScheme.secondary),
        const SizedBox(width: 4),
        Text('$practicedDays日練習', style: theme.textTheme.bodySmall),
        if (practicedDays > 0) ...[
          const SizedBox(width: 16),
          Icon(Icons.star, size: 16, color: theme.colorScheme.secondary),
          const SizedBox(width: 4),
          Text('平均 ${avgScore.round()}点', style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}
