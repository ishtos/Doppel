import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedbackScreen extends ConsumerWidget {
  const FeedbackScreen({super.key, required this.feedbackId});

  final String feedbackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // TODO: Replace with real data from provider
    const overallScore = 72;
    const pronunciationScore = 75;
    const rhythmScore = 68;
    const intonationScore = 73;

    return Scaffold(
      appBar: AppBar(
        title: Text('フィードバック', style: theme.textTheme.titleMedium),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Overall score
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: CircularProgressIndicator(
                              value: overallScore / 100,
                              strokeWidth: 10,
                              color: _scoreColor(overallScore, theme),
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          Text(
                            '$overallScore',
                            style: theme.textTheme.displayLarge,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SubScoreTile(
                          label: '発音',
                          score: pronunciationScore,
                          theme: theme,
                        ),
                        _SubScoreTile(
                          label: 'リズム',
                          score: rhythmScore,
                          theme: theme,
                        ),
                        _SubScoreTile(
                          label: '抑揚',
                          score: intonationScore,
                          theme: theme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Problem words
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('改善ポイント', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        InputChip(
                          avatar: const Icon(Icons.volume_up, size: 16),
                          label: const Text('through'),
                          backgroundColor:
                              theme.colorScheme.error.withValues(alpha: 0.1),
                          onPressed: () {},
                        ),
                        InputChip(
                          avatar: const Icon(Icons.volume_up, size: 16),
                          label: const Text('world'),
                          backgroundColor:
                              theme.colorScheme.error.withValues(alpha: 0.1),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // AI Coach message
            Card(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
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
                            'AIコーチ',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '全体的に良いリズムで読めています！'
                            '"through" の /θ/ の発音に注意しましょう。'
                            '舌先を上の歯に軽く当てて息を出すイメージです。',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Detailed analysis
            ExpansionTile(
              title: Text('詳細分析', style: theme.textTheme.titleSmall),
              children: const [
                ListTile(
                  title: Text('文ごとの分析は今後実装予定です'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.list),
                    label: const Text('ライブラリへ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.replay),
                    label: const Text('もう一度'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _scoreColor(int score, ThemeData theme) {
    if (score >= 80) return theme.colorScheme.tertiary;
    if (score >= 60) return theme.colorScheme.secondary;
    return theme.colorScheme.error;
  }
}

class _SubScoreTile extends StatelessWidget {
  const _SubScoreTile({
    required this.label,
    required this.score,
    required this.theme,
  });

  final String label;
  final int score;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$score', style: theme.textTheme.titleSmall),
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
