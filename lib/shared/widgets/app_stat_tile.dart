import 'package:flutter/material.dart';

/// Visual style for [AppStatTile].
enum StatTileVariant {
  /// Fixed-size chip used in horizontal rows (Home weekly stats).
  compact,

  /// Card that expands to fill its slot (Progress stats grid).
  card,
}

/// A small icon + value + label stat tile, shared across Home and Progress so
/// the two stay visually consistent. Previously each screen kept its own
/// private `_StatTile` / `_StatCard` with duplicated styling.
class AppStatTile extends StatelessWidget {
  const AppStatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.variant = StatTileVariant.card,
  });

  final IconData icon;
  final String value;
  final String label;
  final StatTileVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = variant == StatTileVariant.compact;

    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: compact ? 20 : 24, color: theme.colorScheme.secondary),
        SizedBox(height: compact ? 4 : 8),
        Text(value, style: theme.textTheme.titleSmall),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    if (compact) {
      return Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: content,
      );
    }
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: content),
    );
  }
}
