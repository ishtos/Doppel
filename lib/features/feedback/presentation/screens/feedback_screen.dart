import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/services/audio_service.dart';
import '../../../../shared/utils/score_utils.dart';
import '../../../../shared/utils/text_diff.dart';
import '../providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key, required this.feedbackId});

  final String feedbackId;

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final feedback = ref.watch(feedbackByIdProvider(widget.feedbackId));
    final playerState = ref.watch(audioPlayerProvider);

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

            // Transcript comparison with diff highlighting
            if (feedback.userTranscript != null ||
                feedback.modelTranscript != null)
              _TranscriptComparisonCard(
                modelTranscript: feedback.modelTranscript,
                userTranscript: feedback.userTranscript,
                theme: theme,
              ),
            const SizedBox(height: 20),

            // User audio playback
            if (feedback.userAudioPath != null)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.secondary,
                    child: Icon(
                      playerState.isPlaying
                          ? Icons.stop
                          : Icons.play_arrow,
                      color: theme.colorScheme.onSecondary,
                    ),
                  ),
                  title: Text(playerState.isPlaying ? '再生中...' : '自分の録音を聴く'),
                  subtitle: const Text('録音した音声を再生します'),
                  onTap: () {
                    final player = ref.read(audioPlayerProvider.notifier);
                    if (playerState.isPlaying) {
                      player.stopPlayback();
                    } else {
                      player.playFile(feedback.userAudioPath!);
                    }
                  },
                ),
              ),
            if (feedback.userAudioPath != null)
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

class _TranscriptComparisonCard extends StatelessWidget {
  const _TranscriptComparisonCard({
    required this.modelTranscript,
    required this.userTranscript,
    required this.theme,
  });

  final String? modelTranscript;
  final String? userTranscript;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hasBoth = modelTranscript != null && userTranscript != null;
    final diff = hasBoth
        ? computeWordDiff(modelTranscript!, userTranscript!)
        : null;

    final baseStyle = theme.textTheme.bodyMedium?.copyWith(height: 1.6);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('テキスト比較', style: theme.textTheme.titleSmall),
            if (hasBoth) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  _LegendDot(
                    color: theme.colorScheme.error.withValues(alpha: 0.25),
                    label: '抜けた単語',
                    theme: theme,
                  ),
                  const SizedBox(width: 12),
                  _LegendDot(
                    color: theme.colorScheme.tertiary.withValues(alpha: 0.25),
                    label: '余分な単語',
                    theme: theme,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),

            // Model transcript
            if (modelTranscript != null) ...[
              Text('お手本',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: diff != null
                    ? RichText(
                        text: buildDiffTextSpan(
                          spans: diff.modelSpans,
                          highlightType: DiffType.missing,
                          highlightColor:
                              theme.colorScheme.error.withValues(alpha: 0.25),
                          baseStyle: baseStyle,
                        ),
                      )
                    : Text(modelTranscript!, style: baseStyle),
              ),
              const SizedBox(height: 12),
            ],

            // User transcript
            if (userTranscript != null) ...[
              Text('あなたの発話',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: diff != null
                    ? RichText(
                        text: buildDiffTextSpan(
                          spans: diff.userSpans,
                          highlightType: DiffType.extra,
                          highlightColor:
                              theme.colorScheme.tertiary.withValues(alpha: 0.25),
                          baseStyle: baseStyle,
                        ),
                      )
                    : Text(userTranscript!, style: baseStyle),
              ),
            ] else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '音声認識テキストなし（シミュレーターモード）',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
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
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
