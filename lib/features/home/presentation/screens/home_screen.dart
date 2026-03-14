import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/home_provider.dart';
import '../../../../shared/utils/score_utils.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'おはようございます';
    if (hour < 18) return 'こんにちは';
    return 'こんばんは';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final progress = ref.watch(homeProgressProvider);
    final todayLesson = ref.watch(todayLessonProvider);
    final weeklyStats = ref.watch(weeklyStatsProvider);
    final recentActivity = ref.watch(recentActivityProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Doppel', style: theme.textTheme.displayMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(_greeting(), style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                'Day ${progress.currentStreak}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 24),

              // Today's Lesson Card
              if (todayLesson != null)
                Hero(
                  tag: 'lesson-${todayLesson.id}',
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          context.go('/lesson/${todayLesson.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '今日のレッスン',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        todayLesson.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Chip(
                                        label: Text(_difficultyLabel(
                                            todayLesson.difficulty)),
                                        backgroundColor: theme
                                            .colorScheme.primary
                                            .withValues(alpha: 0.1),
                                        labelStyle: TextStyle(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 12),
                          LinearProgressIndicator(
                            value: weeklyStats.practiceCount / 5,
                            color: theme.colorScheme.primary,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                          ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Weekly Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatTile(
                    label: '今週',
                    value: '${weeklyStats.practiceCount}回',
                    icon: Icons.mic,
                    theme: theme,
                  ),
                  _StatTile(
                    label: '平均',
                    value: '${weeklyStats.averageScore}点',
                    icon: Icons.trending_up,
                    theme: theme,
                  ),
                  _StatTile(
                    label: '時間',
                    value: '${weeklyStats.totalMinutes}分',
                    icon: Icons.timer,
                    theme: theme,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Activity
              Text('最近の練習', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              if (recentActivity.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'まだ練習記録がありません',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                ...recentActivity.map((activity) => ListTile(
                      leading: Icon(
                        Icons.mic,
                        color: ScoreUtils.scoreColor(
                          activity.score,
                          theme.colorScheme,
                        ),
                      ),
                      title: Text(activity.lessonTitle),
                      subtitle: Text(
                        DateFormat('M/d HH:mm').format(activity.date),
                      ),
                      trailing: Text(
                        '${activity.score}点',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: ScoreUtils.scoreColor(
                            activity.score,
                            theme.colorScheme,
                          ),
                        ),
                      ),
                    )),
            ],
          ),
        ),
      ),
    );
  }

  String _difficultyLabel(int d) {
    switch (d) {
      case 1:
        return '初級';
      case 2:
        return '中級';
      case 3:
        return '上級';
      default:
        return '';
    }
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
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
    return Container(
      width: 100,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.secondary),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleSmall),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
