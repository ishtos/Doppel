import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../../shared/services/audio_service.dart';
import '../../../../shared/services/speech_analysis_service.dart';
import '../../../../shared/services/tts_service.dart';
import '../providers/lesson_provider.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = ref.watch(lessonByIdProvider(widget.lessonId));
    final ttsState = ref.watch(ttsServiceProvider);
    final recorderState = ref.watch(audioRecorderProvider);

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('レッスンが見つかりません')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title, style: theme.textTheme.titleMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Stop TTS when leaving
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
                  Text('分析中...'),
                ],
              ),
            )
          : Column(
              children: [
                // Transcript area
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      lesson.transcriptText,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.8,
                      ),
                    ),
                  ),
                ),

                // Waveform comparison area
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'お手本',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin:
                                const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: ttsState.isSpeaking
                                  ? _WaveformPlaceholder(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.6),
                                    )
                                  : Icon(
                                      Icons.graphic_eq,
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3),
                                      size: 32,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'あなた',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin:
                                const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary
                                  .withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: recorderState.isRecording
                                  ? _WaveformPlaceholder(
                                      color: theme.colorScheme.secondary,
                                    )
                                  : Icon(
                                      Icons.graphic_eq,
                                      color: theme.colorScheme.secondary
                                          .withValues(alpha: 0.3),
                                      size: 32,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Playback controls (TTS)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Play/Stop model audio via TTS
                          IconButton.filled(
                            icon: Icon(
                              ttsState.isSpeaking
                                  ? Icons.stop
                                  : Icons.volume_up,
                            ),
                            onPressed: () => ref
                                .read(ttsServiceProvider.notifier)
                                .speak(lesson.transcriptText),
                            tooltip: ttsState.isSpeaking ? '停止' : 'お手本を再生',
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ttsState.isSpeaking ? '再生中...' : 'お手本を聴く',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          // WPM badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_estimateWpm(lesson.wordCount, lesson.durationSeconds, ttsState.speed)} WPM',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Speed slider row
                      Row(
                        children: [
                          const Icon(Icons.speed, size: 18),
                          Expanded(
                            child: Slider(
                              value: ttsState.speed,
                              min: 0.3,
                              max: 1.0,
                              divisions: 7,
                              label: '${ttsState.speed.toStringAsFixed(1)}x',
                              onChanged: (v) => ref
                                  .read(ttsServiceProvider.notifier)
                                  .setSpeed(v),
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            child: Text(
                              '${ttsState.speed.toStringAsFixed(1)}x',
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Record button
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Center(
                    child: GestureDetector(
                      onTap: () => _handleRecordTap(lesson.id, lesson.transcriptText),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: recorderState.isRecording ? 112 : 96,
                        height: recorderState.isRecording ? 112 : 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: recorderState.isRecording
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color: (recorderState.isRecording
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.primary)
                                  .withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          recorderState.isRecording
                              ? Icons.stop
                              : Icons.mic,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  /// Estimate words-per-minute based on lesson metadata and TTS speed.
  int _estimateWpm(int wordCount, int durationSeconds, double speed) {
    if (durationSeconds <= 0) return 0;
    // Native WPM from lesson data, scaled by TTS speed
    final nativeWpm = (wordCount / durationSeconds * 60).round();
    return (nativeWpm * speed).round();
  }

  Future<void> _handleRecordTap(String lessonId, String transcript) async {
    // Stop TTS if playing
    ref.read(ttsServiceProvider.notifier).stop();

    final recorder = ref.read(audioRecorderProvider.notifier);
    final recorderState = ref.read(audioRecorderProvider);

    if (recorderState.isRecording) {
      // Stop recording and analyze
      final path = await recorder.stopRecording();
      await _analyzeAndNavigate(lessonId, transcript, path);
    } else {
      // Try to start recording; if it fails (e.g. simulator), skip to analysis
      final started = await recorder.tryStartRecording();
      if (!started) {
        await _analyzeAndNavigate(lessonId, transcript, null);
      }
    }
  }

  Future<void> _analyzeAndNavigate(
    String lessonId,
    String transcript,
    String? audioPath,
  ) async {
    setState(() => _isAnalyzing = true);

    try {
      final analysis = ref.read(speechAnalysisServiceProvider);
      final feedback = await analysis.analyze(
        lessonId: lessonId,
        modelTranscript: transcript,
        userAudioPath: audioPath,
      );

      // Save feedback
      final feedbackRepo = ref.read(feedbackRepositoryProvider);
      await feedbackRepo.save(feedback);

      // Record practice in progress
      final progressRepo = ref.read(progressRepositoryProvider);
      await progressRepo.recordPractice(durationMinutes: 3);

      if (mounted) {
        setState(() => _isAnalyzing = false);
        context.go('/feedback/${feedback.id}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isAnalyzing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('分析中にエラーが発生しました。もう一度お試しください。'),
            action: SnackBarAction(
              label: '閉じる',
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }
}

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
            final height = 8.0 + sinValue * 20.0;
            return Container(
              width: 3,
              height: height.clamp(4.0, 36.0),
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
