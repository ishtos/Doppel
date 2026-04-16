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
    final categoryPerformance = ref.watch(categoryPerformanceProvider); // FIXED: カテゴリ別パフォーマンス追加

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

            // FIXED: カテゴリ別パフォーマンスセクション追加
            _CategoryPerformanceSection(
              categoryPerformance: categoryPerformance,
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

// FIXED: カテゴリ別パフォーマンス分析ウィジェット
class _CategoryPerformanceSection extends StatelessWidget {
  const _CategoryPerformanceSection({
    required this.categoryPerformance,
    required this.theme,
  });

  final List<CategoryPerformance> categoryPerformance;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text('カテゴリ別スコア', style: theme.textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 16),
            if (categoryPerformance.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '練習データがまだありません',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else ...[
              SizedBox(
                height: 200, // FIXED: 縦棒グラフなので固定高さに修正
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final perf = categoryPerformance[group.x];
                          return BarTooltipItem(
                            '${perf.category}\n${perf.averageScore.round()}点 (${perf.practiceCount}回)',
                            TextStyle(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            final idx = value.toInt();
                            if (idx < 0 || idx >= categoryPerformance.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                _shortenCategory(
                                    categoryPerformance[idx].category),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 50,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value == 50 || value == 100) {
                              return Text(
                                '${value.toInt()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 50,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: categoryPerformance
                        .asMap()
                        .entries
                        .map((entry) {
                      final idx = entry.key;
                      final perf = entry.value;
                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: perf.averageScore,
                            color: _barColor(idx, categoryPerformance.length),
                            width: 20,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Practice count chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categoryPerformance.map((perf) {
                  return Chip(
                    avatar: CircleAvatar(
                      radius: 10,
                      backgroundColor: theme.colorScheme.primary
                          .withValues(alpha: 0.15),
                      child: Text(
                        '${perf.practiceCount}',
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    label: Text(
                      '${perf.category} ${perf.averageScore.round()}点',
                      style: theme.textTheme.bodySmall,
                    ),
                    backgroundColor: theme.colorScheme.surface,
                    side: BorderSide(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _shortenCategory(String category) {
    switch (category) {
      case 'ニュース':
        return 'ニュース';
      case 'ビジネス':
        return 'ビジネス';
      case '日常会話':
        return '日常';
      case 'TEDスタイル':
        return 'TED';
      case 'スポーツ':
        return 'スポーツ';
      case '時事ネタ':
        return '時事';
      default:
        return category;
    }
  }

  Color _barColor(int index, int total) {
    if (total <= 1) return theme.colorScheme.primary;
    if (index == 0) return theme.colorScheme.tertiary; // Best category
    if (index == total - 1) return theme.colorScheme.error; // Weakest category
    return theme.colorScheme.primary;
  }
}
