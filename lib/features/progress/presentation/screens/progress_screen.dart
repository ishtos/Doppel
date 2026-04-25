import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/progress_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  bool _isWeekly = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = ref.watch(userProgressProvider);
    final days = _isWeekly ? 7 : 30;
    final scoreHistory = ref.watch(scoreHistoryProvider(days));
    final weakPatterns = ref.watch(weakPatternsProvider);

    // Build chart spots
    final spots = scoreHistory.isEmpty
        ? List.generate(days, (i) => FlSpot(i.toDouble(), 0))
        : scoreHistory.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.overallScore.toDouble());
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('進捗', style: theme.textTheme.titleLarge),
        actions: [
          ToggleButtons(
            isSelected: [_isWeekly, !_isWeekly],
            onPressed: (i) => setState(() => _isWeekly = i == 0),
            borderRadius: BorderRadius.circular(8),
            constraints:
                const BoxConstraints(minWidth: 48, minHeight: 32),
            children: const [Text('週'), Text('月')],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('スコア推移', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: (spots.length - 1).toDouble().clamp(1, double.infinity),
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: theme.colorScheme.primary,
                              barWidth: 3,
                              dotData: FlDotData(
                                show: scoreHistory.isNotEmpty,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (spots) {
                                return spots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.round()}点',
                                    TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Practice Calendar
            _PracticeCalendarSection(theme: theme),
            const SizedBox(height: 20),

            // Weak points
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('苦手パターン', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 12),
                    if (weakPatterns.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'データがまだありません',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    else
                      ...weakPatterns.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  entry.key,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: entry.value,
                                    color: theme.colorScheme.error,
                                    backgroundColor: theme
                                        .colorScheme.error
                                        .withValues(alpha: 0.1),
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${(entry.value * 100).round()}%',
                                style: theme.textTheme.labelLarge,
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: '累計練習',
                    value: '${(progress.totalPracticeMinutes / 60).toStringAsFixed(1)}時間',
                    icon: Icons.timer,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: '完了レッスン',
                    value: '${progress.completedLessons}回',
                    icon: Icons.check_circle,
                    theme: theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: '最長連続',
                    value: '${progress.longestStreak}日',
                    icon: Icons.local_fire_department,
                    theme: theme,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Weekly review
            Card(
              color:
                  theme.colorScheme.primary.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.colorScheme.primary,
                      child: Icon(
                        Icons.psychology,
                        color: theme.colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '今週のレビュー',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            progress.completedLessons == 0
                                ? 'レッスンを始めると、AIコーチが毎週あなたの進捗をレビューします。'
                                : '今週は${scoreHistory.length}回練習しました。${progress.currentStreak}日連続で頑張っています！',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeCalendarSection extends ConsumerStatefulWidget {
  const _PracticeCalendarSection({required this.theme});

  final ThemeData theme;

  @override
  ConsumerState<_PracticeCalendarSection> createState() =>
      _PracticeCalendarSectionState();
}

class _PracticeCalendarSectionState
    extends ConsumerState<_PracticeCalendarSection> {
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month);
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    if (!_displayedMonth.isBefore(currentMonth)) return;
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final practiceDays = ref.watch(practiceDaysProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final currentMonth = DateTime(now.year, now.month);
    final canGoNext = _displayedMonth.isBefore(currentMonth);

    final daysInMonth = DateUtils.getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    final firstWeekday = DateTime(_displayedMonth.year, _displayedMonth.month, 1)
        .weekday; // 1=Mon, 7=Sun

    int monthPracticeCount = 0;
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_displayedMonth.year, _displayedMonth.month, day);
      if (practiceDays.contains(date)) monthPracticeCount++;
    }

    const weekDays = ['月', '火', '水', '木', '金', '土', '日'];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text('練習カレンダー', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),

            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                Text(
                  '${_displayedMonth.year}年${_displayedMonth.month}月',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: canGoNext
                        ? null
                        : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  onPressed: canGoNext ? _nextMonth : null,
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Weekday headers
            Row(
              children: weekDays.map((d) {
                return Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),

            // Day grid
            ..._buildWeekRows(
              theme: theme,
              daysInMonth: daysInMonth,
              firstWeekday: firstWeekday,
              practiceDays: practiceDays,
              today: today,
            ),
            const SizedBox(height: 12),

            // Monthly summary
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$monthPracticeCount日練習 / $daysInMonth日',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWeekRows({
    required ThemeData theme,
    required int daysInMonth,
    required int firstWeekday,
    required Set<DateTime> practiceDays,
    required DateTime today,
  }) {
    final rows = <Widget>[];
    final offset = firstWeekday - 1; // Mon=0 offset
    final totalCells = offset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    for (int row = 0; row < rowCount; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        final index = row * 7 + col;
        final dayNum = index - offset + 1;

        if (dayNum < 1 || dayNum > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 36)));
          continue;
        }

        final date = DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          dayNum,
        );
        final isPracticed = practiceDays.contains(date);
        final isToday = date == today;

        cells.add(
          Expanded(
            child: Container(
              height: 36,
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: isPracticed
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : null,
                border: isToday
                    ? Border.all(color: theme.colorScheme.primary, width: 1.5)
                    : null,
                borderRadius: BorderRadius.circular(8),
              ),
              // FIXED: Stack を Container 直下に配置し Positioned が Container 基準になるよう修正
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '$dayNum',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isPracticed
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          isPracticed || isToday ? FontWeight.w700 : null,
                    ),
                  ),
                  if (isPracticed)
                    Positioned(
                      bottom: 2,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }
      rows.add(Row(children: cells));
    }

    return rows;
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 24, color: theme.colorScheme.secondary),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.titleSmall),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
