import 'package:flutter/material.dart';

class PracticeCalendar extends StatelessWidget {
  const PracticeCalendar({super.key, required this.practiceData});

  final Map<DateTime, int> practiceData;

  static const _weekCount = 13;
  static const _dayLabels = ['月', '', '水', '', '金', '', ''];
  static const _monthNames = [
    '',
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisMonday = today.subtract(Duration(days: today.weekday - 1));
    final startMonday =
        thisMonday.subtract(const Duration(days: (_weekCount - 1) * 7));

    return LayoutBuilder(
      builder: (context, constraints) {
        const labelWidth = 22.0;
        final cellTotal = (constraints.maxWidth - labelWidth) / _weekCount;
        final gap = (cellTotal * 0.12).clamp(1.5, 3.0);
        final cellSize = cellTotal - gap;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthRow(startMonday, cellTotal, labelWidth, theme),
            const SizedBox(height: 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDayLabels(labelWidth, cellTotal, theme),
                ...List.generate(_weekCount, (w) {
                  return Column(
                    children: List.generate(7, (d) {
                      final date =
                          startMonday.add(Duration(days: w * 7 + d));
                      final future = date.isAfter(today);
                      final count =
                          future ? 0 : (practiceData[date] ?? 0);
                      return Container(
                        width: cellSize,
                        height: cellSize,
                        margin: EdgeInsets.all(gap / 2),
                        decoration: BoxDecoration(
                          color: future
                              ? Colors.transparent
                              : _color(count, theme),
                          borderRadius: BorderRadius.circular(3),
                          border: date == today
                              ? Border.all(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                  width: 1.5,
                                )
                              : null,
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
            const SizedBox(height: 8),
            _buildLegend(cellSize.clamp(8.0, 12.0), theme),
          ],
        );
      },
    );
  }

  Widget _buildMonthRow(
    DateTime start,
    double cellTotal,
    double labelWidth,
    ThemeData theme,
  ) {
    final style = theme.textTheme.labelSmall?.copyWith(
      fontSize: 10,
      color: theme.colorScheme.onSurfaceVariant,
    );
    int? prev;
    return Padding(
      padding: EdgeInsets.only(left: labelWidth),
      child: Row(
        children: List.generate(_weekCount, (w) {
          final mon = start.add(Duration(days: w * 7));
          final m = mon.month;
          final label = m != prev ? _monthNames[m] : '';
          prev = m;
          return SizedBox(width: cellTotal, child: Text(label, style: style));
        }),
      ),
    );
  }

  Widget _buildDayLabels(
    double width,
    double cellTotal,
    ThemeData theme,
  ) {
    final style = theme.textTheme.labelSmall?.copyWith(
      fontSize: 9,
      color: theme.colorScheme.onSurfaceVariant,
    );
    return SizedBox(
      width: width,
      child: Column(
        children: _dayLabels
            .map((l) => SizedBox(
                  height: cellTotal,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(l, style: style),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildLegend(double size, ThemeData theme) {
    final style = theme.textTheme.labelSmall?.copyWith(
      fontSize: 10,
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('少ない', style: style),
        const SizedBox(width: 4),
        for (var i = 0; i <= 3; i++)
          Container(
            width: size,
            height: size,
            margin: const EdgeInsets.only(right: 2),
            decoration: BoxDecoration(
              color: _color(i, theme),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        const SizedBox(width: 4),
        Text('多い', style: style),
      ],
    );
  }

  Color _color(int count, ThemeData theme) {
    if (count == 0) {
      return theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    }
    if (count == 1) return theme.colorScheme.primary.withValues(alpha: 0.3);
    if (count == 2) return theme.colorScheme.primary.withValues(alpha: 0.6);
    return theme.colorScheme.primary;
  }
}
