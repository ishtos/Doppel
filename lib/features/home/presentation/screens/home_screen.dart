import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../providers/home_provider.dart';
import '../../../../shared/analytics/day2_tracker.dart';
import '../../../../shared/utils/score_utils.dart';
import '../../../../shared/widgets/app_stat_tile.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Retention: fire day2_return once per launch (home is the landing screen
    // for returning users). Registered here — not in build — so it isn't
    // re-scheduled on every rebuild.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) maybeCaptureDay2Return(ref);
    });
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'おはようございます';
    if (hour < 18) return 'こんにちは';
    return 'こんばんは';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = ref.watch(homeProgressProvider);
    final todayLesson = ref.watch(todayLessonProvider);
    final weeklyStats = ref.watch(weeklyStatsProvider);
    final recentActivity = ref.watch(recentActivityProvider);
    final goalProgress = ref.watch(dailyGoalProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Doppel', style: theme.textTheme.displayMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '設定',
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting + Daily Goal Progress
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_greeting(), style: theme.textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(
                          'Day ${progress.currentStreak}',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _DailyGoalIndicator(goalProgress: goalProgress, theme: theme),
                ],
              ),
              const SizedBox(height: 24),

              // Today's Lesson Card
              if (todayLesson != null)
                Hero(
                  tag: 'lesson-${todayLesson.id}',
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => context.go('/lesson/${todayLesson.id}'),
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
                                        label: Text(
                                          _difficultyLabel(
                                            todayLesson.difficulty,
                                          ),
                                        ),
                                        backgroundColor: theme
                                            .colorScheme
                                            .primary
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
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: goalProgress.progress,
                                    color: goalProgress.isAchieved
                                        ? theme.colorScheme.tertiary
                                        : theme.colorScheme.primary,
                                    backgroundColor: theme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${goalProgress.completed}/${goalProgress.goal}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // FIXED: お気に入りレッスンセクション追加
              _BookmarkedLessonsSection(theme: theme),

              // Weekly Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppStatTile(
                    variant: StatTileVariant.compact,
                    label: '今週',
                    value: '${weeklyStats.practiceCount}回',
                    icon: Icons.mic,
                  ),
                  AppStatTile(
                    variant: StatTileVariant.compact,
                    label: '平均',
                    value: '${weeklyStats.averageScore}点',
                    icon: Icons.trending_up,
                  ),
                  AppStatTile(
                    variant: StatTileVariant.compact,
                    label: '時間',
                    value: '${weeklyStats.totalMinutes}分',
                    icon: Icons.timer,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Improvement Points
              _ImprovementPointsSection(theme: theme),
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
                ...recentActivity.map(
                  (activity) => ListTile(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${activity.score}点',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: ScoreUtils.scoreColor(
                              activity.score,
                              theme.colorScheme,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    onTap: () => context.go('/feedback/${activity.feedbackId}'),
                  ),
                ),
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

// FIXED: お気に入りレッスン横スクロールセクション
class _BookmarkedLessonsSection extends ConsumerWidget {
  const _BookmarkedLessonsSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarked = ref.watch(bookmarkedLessonsProvider);

    if (bookmarked.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bookmark, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text('お気に入りレッスン', style: theme.textTheme.titleSmall),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: bookmarked.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final lesson = bookmarked[index];
              return SizedBox(
                width: 180,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => context.go('/lesson/${lesson.id}'),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            lesson.title,
                            style: theme.textTheme.labelLarge,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.headphones,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lesson.category,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ImprovementPointsSection extends ConsumerWidget {
  const _ImprovementPointsSection({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(recentImprovementPointsProvider);

    if (points.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 18,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 6),
            Text('改善ポイント', style: theme.textTheme.titleSmall),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: points.map((point) {
                return ActionChip(
                  avatar: point.count > 1
                      ? CircleAvatar(
                          radius: 10,
                          backgroundColor: theme.colorScheme.error,
                          child: Text(
                            '${point.count}',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onError,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.volume_up,
                          size: 16,
                          color: theme.colorScheme.error,
                        ),
                  label: Text('${point.word} ${point.phoneme}'),
                  backgroundColor: theme.colorScheme.error.withValues(
                    alpha: 0.08,
                  ),
                  side: BorderSide.none,
                  onPressed: () => context.go('/feedback/${point.feedbackId}'),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _DailyGoalIndicator extends StatelessWidget {
  const _DailyGoalIndicator({required this.goalProgress, required this.theme});

  final DailyGoalProgress goalProgress;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final color = goalProgress.isAchieved
        ? theme.colorScheme.tertiary
        : theme.colorScheme.primary;

    return Semantics(
      label: goalProgress.isAchieved
          ? 'デイリー目標達成'
          : 'デイリー目標 ${goalProgress.completed} / ${goalProgress.goal}',
      child: ExcludeSemantics(
        child: SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: CustomPaint(
                  painter: _CircularGoalPainter(
                    progress: goalProgress.progress,
                    color: color,
                    backgroundColor: color.withValues(alpha: 0.15),
                  ),
                ),
              ),
              if (goalProgress.isAchieved)
                Icon(Icons.check, size: 22, color: color)
              else
                Text(
                  '${goalProgress.completed}/${goalProgress.goal}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircularGoalPainter extends CustomPainter {
  _CircularGoalPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 5.0;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularGoalPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
