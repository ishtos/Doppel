import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/score_utils.dart';
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

            // Practice calendar
            _PracticeCalendar(
              practiceMap: ref.watch(practiceCalendarProvider),
              theme: theme,
            ),
            const SizedBox(height: 20),

            // Sub-score averages
            _SubScoreSection(
              averages: ref.watch(subScoreAveragesProvider),
              theme: theme,
            ),
            const SizedBox(height: 20),

            // Category scores
            _CategoryScoreSection(
              categoryScores: ref.watch(categoryScoresProvider),
              theme: theme,
            ),
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

class _PracticeCalendar extends StatelessWidget {
  const _PracticeCalendar({
    required this.practiceMap,
    required this.theme,
  });

  final Map<DateTime, int> practiceMap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final thisMonday = today.subtract(Duration(days: today.weekday - 1));
    final startDate = thisMonday.subtract(const Duration(days: 21));

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
                Icon(Icons.calendar_month,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text('練習カレンダー', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${startDate.month}/${startDate.day} ～ ${today.month}/${today.day}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['月', '火', '水', '木', '金', '土', '日'].map((d) {
                return Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            ...List.generate(4, (week) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: List.generate(7, (day) {
                    final date =
                        startDate.add(Duration(days: week * 7 + day));
                    final count = practiceMap[date] ?? 0;
                    final isToday = date == today;
                    final isFuture = date.isAfter(today);

                    return Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isFuture
                                ? Colors.transparent
                                : _cellColor(count),
                            borderRadius: BorderRadius.circular(6),
                            border: isToday
                                ? Border.all(
                                    color: theme.colorScheme.primary,
                                    width: 2,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${date.day}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: isFuture
                                    ? theme.colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.3)
                                    : count >= 2
                                        ? theme.colorScheme.onPrimary
                                        : count == 1
                                            ? theme.colorScheme.onSurface
                                            : theme.colorScheme
                                                .onSurfaceVariant,
                                fontWeight:
                                    isToday ? FontWeight.w700 : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _CalendarLegend(
                    color: _cellColor(0), label: '0回', theme: theme),
                const SizedBox(width: 8),
                _CalendarLegend(
                    color: _cellColor(1), label: '1回', theme: theme),
                const SizedBox(width: 8),
                _CalendarLegend(
                    color: _cellColor(2), label: '2回', theme: theme),
                const SizedBox(width: 8),
                _CalendarLegend(
                    color: _cellColor(3), label: '3+', theme: theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _cellColor(int count) {
    if (count == 0) {
      return theme.colorScheme.surfaceContainerHighest
          .withValues(alpha: 0.5);
    }
    if (count == 1) return theme.colorScheme.primary.withValues(alpha: 0.3);
    if (count == 2) return theme.colorScheme.primary.withValues(alpha: 0.6);
    return theme.colorScheme.primary;
  }
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({
    required this.color,
    required this.label,
    required this.theme,
  });

  final Color color;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _SubScoreSection extends StatelessWidget {
  const _SubScoreSection({
    required this.averages,
    required this.theme,
  });

  final SubScoreAverages averages;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hasData = averages.pronunciation > 0 ||
        averages.rhythm > 0 ||
        averages.intonation > 0;

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
                Icon(Icons.equalizer,
                    size: 18, color: theme.colorScheme.secondary),
                const SizedBox(width: 6),
                Text('スキル別平均', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            if (!hasData)
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
            else ...[
              _SubScoreBar(
                label: '発音',
                score: averages.pronunciation,
                icon: Icons.record_voice_over,
                theme: theme,
              ),
              const SizedBox(height: 8),
              _SubScoreBar(
                label: 'リズム',
                score: averages.rhythm,
                icon: Icons.music_note,
                theme: theme,
              ),
              const SizedBox(height: 8),
              _SubScoreBar(
                label: '抑揚',
                score: averages.intonation,
                icon: Icons.show_chart,
                theme: theme,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubScoreBar extends StatelessWidget {
  const _SubScoreBar({
    required this.label,
    required this.score,
    required this.icon,
    required this.theme,
  });

  final String label;
  final double score;
  final IconData icon;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.secondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              color:
                  ScoreUtils.scoreColor(score.round(), theme.colorScheme),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            '${score.round()}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: ScoreUtils.scoreColor(
                  score.round(), theme.colorScheme),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _CategoryScoreSection extends StatelessWidget {
  const _CategoryScoreSection({
    required this.categoryScores,
    required this.theme,
  });

  final Map<String, double> categoryScores;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.category,
                    size: 18, color: theme.colorScheme.tertiary),
                const SizedBox(width: 6),
                Text('カテゴリ別スコア', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 12),
            if (categoryScores.isEmpty)
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
              ...categoryScores.entries.map((entry) {
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
                            value: entry.value / 100,
                            color: ScoreUtils.scoreColor(
                              entry.value.round(),
                              theme.colorScheme,
                            ),
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 36,
                        child: Text(
                          '${entry.value.round()}',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: ScoreUtils.scoreColor(
                              entry.value.round(),
                              theme.colorScheme,
                            ),
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
