import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/utils/score_utils.dart';
import '../providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerWidget {
  const FeedbackScreen({super.key, required this.feedbackId});

  final String feedbackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final feedback = ref.watch(feedbackByIdProvider(feedbackId));

    if (feedback == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('フィードバックが見つかりません')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('フィードバック', style: theme.textTheme.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
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
                    _AnimatedScoreIndicator(
                      score: feedback.overallScore,
                      color: ScoreUtils.scoreColor(
                        feedback.overallScore,
                        theme.colorScheme,
                      ),
                      theme: theme,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ScoreUtils.scoreLabel(feedback.overallScore),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SubScoreTile(
                          label: '発音',
                          score: feedback.pronunciationScore,
                          theme: theme,
                        ),
                        _SubScoreTile(
                          label: 'リズム',
                          score: feedback.rhythmScore,
                          theme: theme,
                        ),
                        _SubScoreTile(
                          label: '抑揚',
                          score: feedback.intonationScore,
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
            if (feedback.problemWords.isNotEmpty)
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
                        children: feedback.problemWords.map((pw) {
                          return InputChip(
                            avatar: const Icon(Icons.volume_up, size: 16),
                            label: Text('${pw.word} ${pw.phoneme}'),
                            backgroundColor: theme.colorScheme.error
                                .withValues(alpha: 0.1),
                            onPressed: () {},
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // AI Coach message
            Card(
              color:
                  theme.colorScheme.primary.withValues(alpha: 0.05),
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
                            feedback.coachMessage,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/library'),
                    icon: const Icon(Icons.list),
                    label: const Text('ライブラリへ'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () =>
                        context.go('/lesson/${feedback.lessonId}'),
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
}

class _AnimatedScoreIndicator extends StatefulWidget {
  const _AnimatedScoreIndicator({
    required this.score,
    required this.color,
    required this.theme,
  });

  final int score;
  final Color color;
  final ThemeData theme;

  @override
  State<_AnimatedScoreIndicator> createState() =>
      _AnimatedScoreIndicatorState();
}

class _AnimatedScoreIndicatorState extends State<_AnimatedScoreIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.score / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: _animation.value,
                  strokeWidth: 10,
                  color: widget.color,
                  backgroundColor:
                      widget.theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              Text(
                '${(_animation.value * 100).round()}',
                style: widget.theme.textTheme.displayLarge,
              ),
            ],
          ),
        );
      },
    );
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
          Text(
            '$score',
            style: theme.textTheme.titleSmall?.copyWith(
              color: ScoreUtils.scoreColor(score, theme.colorScheme),
            ),
          ),
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
