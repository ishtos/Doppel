import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../../shared/services/audio_service.dart';
import '../../../../shared/services/speech_analysis_service.dart';
import '../../../../shared/services/tts_service.dart';
import '../../../../shared/utils/score_utils.dart';
import '../../../feedback/data/models/feedback_model.dart';
import '../../../feedback/presentation/providers/feedback_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/lesson_provider.dart';
import '../providers/shadowing_session_provider.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  bool _isAnalyzing = false;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    // Freemium gate: free users may practice one lesson per day. Evaluate after
    // the first frame so settings (loaded async) are available; fail-open if
    // not yet loaded. Re-entering the same day's lesson stays allowed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final settings = ref.read(settingsProvider.notifier);
      if (settings.canAccessLesson(widget.lessonId)) {
        settings.registerLessonAccess(widget.lessonId);
      } else {
        setState(() => _locked = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = ref.watch(lessonByIdProvider(widget.lessonId));
    final session = ref.watch(shadowingSessionProvider(widget.lessonId));
    final ttsState = ref.watch(ttsServiceProvider);
    final recorderState = ref.watch(audioRecorderProvider);
    final pastFeedbacks = ref.watch(feedbacksByLessonProvider(widget.lessonId));

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('レッスンが見つかりません')),
      );
    }

    if (_locked) {
      return _buildPaywall(context, theme);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title, style: theme.textTheme.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(ttsServiceProvider.notifier).stop();
            context.go('/home');
          },
        ),
      ),
      body: _isAnalyzing
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('採点中...'),
                ],
              ),
            )
          : !session.hasChunks
              ? const Center(child: Text('このレッスンには練習できる文がありません'))
              : Column(
                  children: [
                    // Past score banner (reused)
                    if (pastFeedbacks.isNotEmpty)
                      _PastScoreBanner(
                        feedbacks: pastFeedbacks,
                        onDetails: () =>
                            _showPastResults(context, theme, pastFeedbacks),
                      ),

                    // Progress bar + chunk counter
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: Row(
                        children: [
                          Text(
                            '${session.currentIndex + 1} / ${session.chunks.length}',
                            style: theme.textTheme.labelLarge,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: session.progressFraction,
                                minHeight: 6,
                                backgroundColor: theme
                                    .colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '${session.recordedCount}録音',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Mode toggles
                    _ModeToggleRow(lessonId: widget.lessonId),

                    // Chunk list
                    Expanded(
                      child: _ChunkListView(lessonId: widget.lessonId),
                    ),

                    // Waveform (reused) — visible while speaking or recording
                    if (ttsState.isSpeaking || recorderState.isRecording)
                      Container(
                        height: 56,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: recorderState.isRecording
                              ? theme.colorScheme.error.withValues(alpha: 0.05)
                              : theme.colorScheme.primary
                                  .withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: _WaveformPlaceholder(
                            color: recorderState.isRecording
                                ? theme.colorScheme.error.withValues(alpha: 0.7)
                                : theme.colorScheme.primary
                                    .withValues(alpha: 0.6),
                          ),
                        ),
                      ),

                    // Chunk control bar (listen / loop / replay / nav + speed)
                    _ChunkControlBar(
                      lessonId: widget.lessonId,
                      wpm: _estimateWpm(
                        lesson.wordCount,
                        lesson.durationSeconds,
                        ttsState.speed,
                      ),
                      speedLabel: _speedLabel(ttsState.speed),
                    ),

                    // Record mode toggle (通し / 一文ずつ)
                    _RecordModeToggle(lessonId: widget.lessonId),

                    // Record bar
                    _RecordBar(
                      lessonId: widget.lessonId,
                      onScore: () => _scoreAndNavigate(lesson.id),
                    ),
                  ],
                ),
    );
  }

  Widget _buildPaywall(BuildContext context, ThemeData theme) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/library'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_clock,
                  size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 24),
              Text(
                '本日の無料レッスンは終了しました',
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                '無料プランでは1日1レッスンまで練習できます。'
                'また明日挑戦するか、プレミアムで回数無制限にできます。',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go('/library'),
                  icon: const Icon(Icons.menu_book_outlined),
                  label: const Text('ライブラリに戻る'),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                // TODO(iap): replace with a real in-app purchase flow
                // (StoreKit / RevenueCat). For now this just unlocks locally.
                onPressed: () async {
                  await ref.read(settingsProvider.notifier).setPremium(true);
                  if (mounted) setState(() => _locked = false);
                },
                child: const Text('プレミアムにする（準備中）'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scoreAndNavigate(String lessonId) async {
    final notifier = ref.read(shadowingSessionProvider(lessonId).notifier);

    // Stop any playback / flush an in-progress recording first, then read the
    // (now up-to-date) session state for scoring.
    final mode = ref.read(shadowingSessionProvider(lessonId)).recordMode;
    ref.read(ttsServiceProvider.notifier).stop();
    if (ref.read(audioRecorderProvider).isRecording) {
      await (mode == RecordMode.whole
          ? notifier.stopWholeRecording()
          : notifier.stopRecordCurrent());
    }
    final session = ref.read(shadowingSessionProvider(lessonId));

    setState(() => _isAnalyzing = true);

    try {
      final analysis = ref.read(speechAnalysisServiceProvider);
      final feedback = session.recordMode == RecordMode.whole
          ? await analysis.analyze(
              lessonId: lessonId,
              modelTranscript: session.chunks.join(' '),
              userAudioPath: session.wholeRecordingPath,
            )
          : await analysis.analyzeChunks(
              lessonId: lessonId,
              modelChunks: session.chunks,
              chunkAudioPaths: session.orderedAudioPaths,
            );

      await ref.read(feedbackRepositoryProvider).save(feedback);
      await ref
          .read(progressRepositoryProvider)
          .recordPractice(durationMinutes: 3);

      if (mounted) {
        setState(() => _isAnalyzing = false);
        context.go('/feedback/${feedback.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('採点中にエラーが発生しました。もう一度お試しください。'),
            action: SnackBarAction(label: '閉じる', onPressed: () {}),
          ),
        );
      }
    }
  }

  void _showPastResults(
      BuildContext context, ThemeData theme, List<FeedbackModel> feedbacks) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('過去の成績', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ...feedbacks.take(10).map((fb) {
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: ScoreUtils.scoreColor(
                    fb.overallScore,
                    theme.colorScheme,
                  ).withValues(alpha: 0.15),
                  child: Text(
                    '${fb.overallScore}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: ScoreUtils.scoreColor(
                        fb.overallScore,
                        theme.colorScheme,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                title: Text(
                  '発音${fb.pronunciationScore} / リズム${fb.rhythmScore} / 抑揚${fb.intonationScore}',
                  style: theme.textTheme.bodySmall,
                ),
                subtitle: Text(
                  _formatDate(fb.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/feedback/${fb.id}');
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  /// Map iOS speechRate (0.25-0.6) to user-facing label (0.5x-1.2x).
  String _speedLabel(double rate) {
    final display = (rate / 0.5).toStringAsFixed(1);
    return '${display}x';
  }

  /// Estimate words-per-minute based on lesson metadata and TTS speed.
  int _estimateWpm(int wordCount, int durationSeconds, double speed) {
    if (durationSeconds <= 0) return 0;
    final nativeWpm = (wordCount / durationSeconds * 60).round();
    return (nativeWpm * (speed / 0.5)).round();
  }
}

// ── Past score banner ──

class _PastScoreBanner extends StatelessWidget {
  const _PastScoreBanner({required this.feedbacks, required this.onDetails});

  final List<FeedbackModel> feedbacks;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final best = feedbacks
        .map((f) => f.overallScore)
        .reduce((a, b) => a > b ? a : b);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      child: Row(
        children: [
          Icon(Icons.history,
              size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            '前回: ${feedbacks.first.overallScore}点',
            style: theme.textTheme.bodySmall?.copyWith(
              color: ScoreUtils.scoreColor(
                  feedbacks.first.overallScore, theme.colorScheme),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 16),
          Text('最高: $best点',
              style: theme.textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(width: 16),
          Text('${feedbacks.length}回練習',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const Spacer(),
          TextButton(
            onPressed: onDetails,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('詳細'),
          ),
        ],
      ),
    );
  }
}

// ── Mode toggles (hide-text, auto-advance) ──

class _ModeToggleRow extends ConsumerWidget {
  const _ModeToggleRow({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(shadowingSessionProvider(lessonId));
    final notifier = ref.read(shadowingSessionProvider(lessonId).notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          FilterChip(
            selected: session.hideText,
            onSelected: (_) => notifier.toggleHideText(),
            avatar: Icon(
              session.hideText ? Icons.visibility_off : Icons.visibility,
              size: 18,
            ),
            label: const Text('テキスト非表示'),
          ),
          const SizedBox(width: 8),
          FilterChip(
            selected: session.autoAdvance,
            onSelected: (_) => notifier.toggleAutoAdvance(),
            avatar: const Icon(Icons.skip_next, size: 18),
            label: const Text('自動で次へ'),
          ),
          const Spacer(),
          if (session.loopMode)
            Text('区間リピート中',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}

// ── Record mode toggle ──

class _RecordModeToggle extends ConsumerWidget {
  const _RecordModeToggle({required this.lessonId});

  final String lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
        shadowingSessionProvider(lessonId).select((s) => s.recordMode));
    final notifier = ref.read(shadowingSessionProvider(lessonId).notifier);
    final isRecording =
        ref.watch(audioRecorderProvider.select((s) => s.isRecording));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<RecordMode>(
              segments: const [
                ButtonSegment(
                  value: RecordMode.whole,
                  label: Text('通し'),
                  icon: Icon(Icons.notes, size: 18),
                ),
                ButtonSegment(
                  value: RecordMode.perChunk,
                  label: Text('一文ずつ'),
                  icon: Icon(Icons.format_list_numbered, size: 18),
                ),
              ],
              selected: {mode},
              // Disable switching mid-recording to avoid dropping a take.
              onSelectionChanged: isRecording
                  ? null
                  : (sel) => notifier.setRecordMode(sel.first),
              showSelectedIcon: false,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chunk list ──

class _ChunkListView extends ConsumerStatefulWidget {
  const _ChunkListView({required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<_ChunkListView> createState() => _ChunkListViewState();
}

class _ChunkListViewState extends ConsumerState<_ChunkListView> {
  final _controller = ScrollController();
  final _currentKey = GlobalKey();
  int _lastIndex = -1;
  bool _wasSpeaking = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Keep the current chunk visible (upper third) so the list follows along
  /// while reading. Uses the current item's context — which is always built
  /// here since navigation is tap / next / prev — and falls back to a
  /// proportional estimate if it is somehow off-screen.
  void _scrollToCurrent() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final ctx = _currentKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.35,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else if (_controller.hasClients) {
        final session = ref.read(shadowingSessionProvider(widget.lessonId));
        final count = session.chunks.length;
        if (count == 0) return;
        final max = _controller.position.maxScrollExtent;
        _controller.animateTo(
          ((session.currentIndex / count) * max).clamp(0.0, max),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = ref.watch(shadowingSessionProvider(widget.lessonId));
    final notifier =
        ref.read(shadowingSessionProvider(widget.lessonId).notifier);
    final isSpeaking =
        ref.watch(ttsServiceProvider.select((s) => s.isSpeaking));

    // Follow the reading position: scroll on chunk change, or when playback
    // starts (so tapping "聴く" brings the current chunk into view).
    final indexChanged = session.currentIndex != _lastIndex;
    final startedSpeaking = isSpeaking && !_wasSpeaking;
    _lastIndex = session.currentIndex;
    _wasSpeaking = isSpeaking;
    if (indexChanged || startedSpeaking) {
      _scrollToCurrent();
    }

    return ListView.builder(
      controller: _controller,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: session.chunks.length,
      itemBuilder: (context, i) {
        final isCurrent = i == session.currentIndex;
        final status = session.statusOf(i);
        final recorded = status == ChunkStatus.recorded;
        final masked = session.hideText && !recorded;

        final Color bg;
        if (isCurrent) {
          bg = theme.colorScheme.primary.withValues(alpha: 0.12);
        } else {
          bg = Colors.transparent;
        }

        return Card(
          key: isCurrent ? _currentKey : null,
          elevation: isCurrent ? 1 : 0,
          color: bg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isCurrent
                ? BorderSide(color: theme.colorScheme.primary, width: 1.5)
                : BorderSide.none,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () async {
              await notifier.goTo(i);
              await notifier.listenCurrent();
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Per-chunk status icon is only meaningful in per-chunk mode
                  // (whole-passage mode has no per-chunk recording state).
                  if (session.recordMode != RecordMode.whole)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 10),
                      child: recorded
                          ? Icon(Icons.check_circle,
                              size: 20, color: theme.colorScheme.tertiary)
                          : Icon(
                              isCurrent
                                  ? Icons.play_circle_fill
                                  : Icons.circle_outlined,
                              size: 20,
                              color: isCurrent
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                            ),
                    ),
                  Expanded(
                    child: masked
                        ? Row(
                            children: [
                              Icon(Icons.visibility_off,
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant),
                              const SizedBox(width: 8),
                              Text('テキスト非表示',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color:
                                          theme.colorScheme.onSurfaceVariant)),
                            ],
                          )
                        : Text(
                            session.chunks[i],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.3,
                              fontWeight: isCurrent
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: isCurrent
                                  ? theme.colorScheme.onSurface
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Chunk control bar ──

class _ChunkControlBar extends ConsumerWidget {
  const _ChunkControlBar({
    required this.lessonId,
    required this.wpm,
    required this.speedLabel,
  });

  final String lessonId;
  final int wpm;
  final String speedLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(shadowingSessionProvider(lessonId));
    final notifier = ref.read(shadowingSessionProvider(lessonId).notifier);
    final ttsState = ref.watch(ttsServiceProvider);
    final hasOwnRecording =
        session.recordingPaths[session.currentIndex] != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                tooltip: '前の文',
                onPressed: session.isFirst ? null : () => notifier.prev(),
              ),
              // Listen to the whole passage (reads chunk by chunk while the
              // list scrolls along). Tap an individual chunk to hear just it.
              IconButton.filled(
                icon: Icon((session.readingAll || ttsState.isSpeaking)
                    ? Icons.stop
                    : Icons.volume_up),
                tooltip: (session.readingAll || ttsState.isSpeaking)
                    ? '停止'
                    : '全文を聴く',
                onPressed: () => notifier.listenAll(),
              ),
              // A-B loop toggle
              IconButton(
                icon: Icon(
                  Icons.repeat,
                  color: session.loopMode ? theme.colorScheme.primary : null,
                ),
                tooltip: session.loopMode ? '区間リピート ON' : '区間リピート OFF',
                isSelected: session.loopMode,
                onPressed: () {
                  notifier.toggleLoop();
                  if (!session.loopMode && !ttsState.isSpeaking) {
                    // Was off, now turning on → start looping.
                    notifier.listenCurrent();
                  }
                },
              ),
              // Replay own recording
              IconButton(
                icon: const Icon(Icons.record_voice_over),
                tooltip: '自分の録音を再生',
                onPressed: hasOwnRecording
                    ? () => notifier.replayCurrentRecording()
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                tooltip: '次の文',
                onPressed: session.isLast ? null : () => notifier.next(),
              ),
            ],
          ),
          // Speed slider (reused mapping)
          Row(
            children: [
              const Icon(Icons.speed, size: 18),
              Expanded(
                child: Slider(
                  value: ttsState.speed,
                  min: 0.25,
                  max: 0.6,
                  divisions: 7,
                  label: speedLabel,
                  onChanged: (v) =>
                      ref.read(ttsServiceProvider.notifier).setSpeed(v),
                ),
              ),
              SizedBox(width: 42, child: Text(speedLabel, style: theme.textTheme.labelLarge)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$wpm WPM',
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Record bar ──

class _RecordBar extends ConsumerWidget {
  const _RecordBar({required this.lessonId, required this.onScore});

  final String lessonId;
  final VoidCallback onScore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(shadowingSessionProvider(lessonId));
    final notifier = ref.read(shadowingSessionProvider(lessonId).notifier);
    final recorderState = ref.watch(audioRecorderProvider);
    final isRecording = recorderState.isRecording;
    final isWhole = session.recordMode == RecordMode.whole;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cancel (while recording)
          AnimatedOpacity(
            opacity: isRecording ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !isRecording,
              child: GestureDetector(
                onTap: () => isWhole
                    ? notifier.cancelWholeRecording()
                    : notifier.cancelRecordCurrent(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Icon(Icons.close,
                      size: 24, color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            ),
          ),
          SizedBox(width: isRecording ? 20 : 0),
          // Record / Stop
          GestureDetector(
            onTap: () {
              if (isRecording) {
                isWhole
                    ? notifier.stopWholeRecording()
                    : notifier.stopRecordCurrent();
              } else {
                isWhole
                    ? notifier.startWholeRecording()
                    : notifier.startRecordCurrent();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isRecording ? 84 : 72,
              height: isRecording ? 84 : 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: (isRecording
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(isRecording ? Icons.stop : Icons.mic,
                  size: 28, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20),
          // Score button
          FilledButton.icon(
            onPressed: session.canScore && !isRecording ? onScore : null,
            icon: const Icon(Icons.grading, size: 18),
            label: const Text('採点'),
          ),
        ],
      ),
    );
  }
}

// ── Waveform placeholder (reused) ──

class _WaveformPlaceholder extends StatefulWidget {
  const _WaveformPlaceholder({required this.color});

  final Color color;

  @override
  State<_WaveformPlaceholder> createState() => _WaveformPlaceholderState();
}

class _WaveformPlaceholderState extends State<_WaveformPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(24, (i) {
            final phase = (i / 24) * 2 * pi;
            final sinValue = sin(_controller.value * 2 * pi + phase);
            final height = 8.0 + sinValue * 18.0;
            return Container(
              width: 3,
              height: height.clamp(4.0, 32.0),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
