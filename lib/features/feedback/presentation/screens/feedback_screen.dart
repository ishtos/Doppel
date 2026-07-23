import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/analytics/analytics_events.dart';
import '../../../../shared/analytics/analytics_provider.dart';
import '../../../../shared/services/audio_service.dart';
import '../../../../shared/services/tts_service.dart';
import '../../../../shared/utils/score_utils.dart';
import '../../../../shared/utils/text_diff.dart';
import '../../data/models/feedback_model.dart';
import '../providers/feedback_provider.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key, required this.feedbackId});

  final String feedbackId;

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  // Celebration fires once, when the score count-up finishes on a high score.
  bool _celebrated = false;
  bool _showBurst = false;

  @override
  void initState() {
    super.initState();
    // Fire once when the feedback screen opens (build re-runs on playback
    // state changes, so instrument here instead).
    final feedback = ref.read(feedbackByIdProvider(widget.feedbackId));
    ref.read(analyticsProvider).capture(
      AnalyticsEvents.feedbackViewed,
      properties: {
        'feedback_id': widget.feedbackId,
        'overall_score': feedback?.overallScore,
      },
    );
  }

  /// Called when the animated score finishes counting up. Rewards a strong
  /// result with haptics + a one-shot celebration burst.
  void _onScoreRevealed(int score) {
    if (_celebrated || !mounted) return;
    _celebrated = true;
    if (score >= 90) {
      HapticFeedback.heavyImpact();
    } else if (score >= 80) {
      HapticFeedback.mediumImpact();
    } else {
      return;
    }
    setState(() => _showBurst = true);
  }

  /// Copy a shareable score summary to the clipboard (dependency-free share).
  void _copyResult(FeedbackModel feedback) {
    final d = feedback.createdAt.toLocal();
    final date =
        '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    final summary = 'Doppel シャドウイング結果 ($date)\n'
        '総合 ${feedback.overallScore} / 発音 ${feedback.pronunciationScore} '
        '/ リズム ${feedback.rhythmScore} / 抑揚 ${feedback.intonationScore}';
    Clipboard.setData(ClipboardData(text: summary));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('結果をコピーしました'),
        duration: Duration(seconds: 2),
      ),
    );
  }

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
          tooltip: '戻る',
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: '結果をコピー',
            onPressed: () => _copyResult(feedback),
          ),
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
                      width: 180,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_showBurst) const _CelebrationBurst(),
                          _AnimatedScoreIndicator(
                            score: feedback.overallScore,
                            color: ScoreUtils.scoreColor(
                              feedback.overallScore,
                              theme.colorScheme,
                            ),
                            theme: theme,
                            onComplete: () =>
                                _onScoreRevealed(feedback.overallScore),
                          ),
                        ],
                      ),
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

            // Simulated-score notice: when there is no recognized transcript,
            // the scores are a rough simulation (no audio analysis) rather than
            // a real measurement — say so plainly so the numbers aren't
            // over-trusted.
            if (feedback.userTranscript == null) ...[
              _SimulatedScoreNotice(theme: theme),
              const SizedBox(height: 20),
            ],

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
                            tooltip: '「${pw.word}」を再生',
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              ref
                                  .read(ttsServiceProvider.notifier)
                                  .speak(pw.word);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // AI Coach message with retry support
            _AiCoachCard(
              feedbackId: feedback.id,
              coachMessage: feedback.coachMessage,
              isFallback: feedback.coachIsFallback,
              theme: theme,
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
    this.onComplete,
  });

  final int score;
  final Color color;
  final ThemeData theme;
  final VoidCallback? onComplete;

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
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onComplete?.call();
    });
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

class _SimulatedScoreNotice extends StatelessWidget {
  const _SimulatedScoreNotice({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline,
              size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '簡易採点です（音声解析を利用できませんでした）。'
              'スコアはおおよその目安としてご覧ください。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
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
                  '音声認識テキストなし（簡易採点）',
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

// FIXED: AI Coach card extracted as separate widget with retry support
class _AiCoachCard extends ConsumerWidget {
  const _AiCoachCard({
    required this.feedbackId,
    required this.coachMessage,
    required this.isFallback,
    required this.theme,
  });

  final String feedbackId;
  final String coachMessage;
  final bool isFallback;
  final ThemeData theme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regenerateState = ref.watch(coachRegenerateProvider(feedbackId));
    final displayMessage =
        regenerateState.message ?? coachMessage;

    return Card(
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                      if (regenerateState.status ==
                          CoachRegenerateStatus.loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('AIコーチが考え中...'),
                            ],
                          ),
                        )
                      else
                        Text(
                          displayMessage,
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            // Surface a coach fallback: the stored message is a local template
            // because the cloud call failed (distinct from the by-design
            // offline case). Hidden once regenerated successfully this session.
            if (isFallback &&
                regenerateState.message == null &&
                regenerateState.status != CoachRegenerateStatus.loading)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'AIコーチに接続できず、簡易メッセージを表示しています。'
                        '「AIで再生成」で再試行できます。',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // FIXED: Error message display
            if (regenerateState.status == CoachRegenerateStatus.error)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 16,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          regenerateState.errorMessage ?? 'エラーが発生しました',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // FIXED: Regenerate button row
            if (regenerateState.status != CoachRegenerateStatus.loading)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      ref
                          .read(coachRegenerateProvider(feedbackId).notifier)
                          .regenerate();
                    },
                    icon: Icon(
                      regenerateState.status == CoachRegenerateStatus.error
                          ? Icons.refresh
                          : Icons.auto_awesome,
                      size: 16,
                    ),
                    label: Text(
                      regenerateState.status == CoachRegenerateStatus.error
                          ? 'リトライ'
                          : 'AIで再生成',
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      textStyle: theme.textTheme.labelMedium,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── One-shot celebration burst behind the score ring (high scores) ──

class _CelebrationBurst extends StatefulWidget {
  const _CelebrationBurst();

  @override
  State<_CelebrationBurst> createState() => _CelebrationBurstState();
}

class _CelebrationBurstState extends State<_CelebrationBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = [scheme.primary, scheme.secondary, scheme.tertiary];
    return ExcludeSemantics(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            size: const Size(180, 140),
            painter: _BurstPainter(t: _controller.value, colors: colors),
          ),
        ),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter({required this.t, required this.colors});

  final double t; // 0..1 animation progress
  final List<Color> colors;
  static const _count = 18;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final eased = Curves.easeOut.transform(t);
    final maxR = size.shortestSide * 0.55;
    final opacity = (1 - t).clamp(0.0, 1.0);
    for (var i = 0; i < _count; i++) {
      final angle = (2 * pi * i / _count) + (i.isEven ? 0.0 : 0.18);
      final dist = eased * maxR * (0.7 + (i % 3) * 0.15);
      final pos = center + Offset(cos(angle) * dist, sin(angle) * dist);
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity);
      final r = (3.0 - t * 1.5).clamp(1.0, 3.0);
      canvas.drawCircle(pos, r, paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => oldDelegate.t != t;
}
