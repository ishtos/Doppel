import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/achievements.dart';
import '../providers/achievement_provider.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final achievements = ref.watch(achievementsProvider);
    final unlockedCount = ref.watch(unlockedCountProvider);

    final grouped = <AchievementCategory, List<AchievementStatus>>{};
    for (final a in achievements) {
      grouped.putIfAbsent(a.definition.category, () => []).add(a);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('実績', style: theme.textTheme.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _SummaryCard(
              unlockedCount: unlockedCount,
              totalCount: achievements.length,
              theme: theme,
            ),
            const SizedBox(height: 24),
            ...AchievementCategory.values.map((category) {
              final items = grouped[category];
              if (items == null || items.isEmpty) {
                return const SizedBox.shrink();
              }
              return _CategorySection(
                category: category,
                items: items,
                theme: theme,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.unlockedCount,
    required this.totalCount,
    required this.theme,
  });

  final int unlockedCount;
  final int totalCount;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount > 0 ? unlockedCount / totalCount : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 32,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                Text(
                  '$unlockedCount / $totalCount',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: theme.colorScheme.secondary,
                backgroundColor:
                    theme.colorScheme.secondary.withValues(alpha: 0.15),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '実績達成率 ${(progress * 100).round()}%',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.items,
    required this.theme,
  });

  final AchievementCategory category;
  final List<AchievementStatus> items;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            achievementCategoryLabel(category),
            style: theme.textTheme.titleSmall,
          ),
        ),
        ...items.map((item) => _AchievementTile(status: item, theme: theme)),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.status,
    required this.theme,
  });

  final AchievementStatus status;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final def = status.definition;
    final unlocked = status.isUnlocked;

    final iconColor = unlocked
        ? theme.colorScheme.secondary
        : theme.colorScheme.onSurface.withValues(alpha: 0.25);
    final titleStyle = unlocked
        ? theme.textTheme.titleSmall
        : theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          );
    final descStyle = theme.textTheme.bodySmall?.copyWith(
      color: unlocked
          ? theme.colorScheme.onSurfaceVariant
          : theme.colorScheme.onSurface.withValues(alpha: 0.3),
    );

    return Card(
      elevation: unlocked ? 2 : 0,
      color: unlocked
          ? null
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: unlocked
              ? theme.colorScheme.secondary.withValues(alpha: 0.15)
              : theme.colorScheme.onSurface.withValues(alpha: 0.06),
          child: Icon(def.icon, color: iconColor, size: 22),
        ),
        title: Text(def.title, style: titleStyle),
        subtitle: Text(def.description, style: descStyle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (unlocked)
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.tertiary,
                size: 20,
              )
            else
              Text(
                status.progressLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
