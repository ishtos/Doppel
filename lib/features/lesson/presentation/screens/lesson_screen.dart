import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../../shared/services/audio_service.dart';
import '../../../../shared/services/speech_analysis_service.dart';
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
    final playerState = ref.watch(audioPlayerProvider);
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
          onPressed: () => context.go('/home'),
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
                              child: playerState.isPlaying
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

                // Playback controls
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_5),
                        onPressed: () =>
                            ref.read(audioPlayerProvider.notifier).rewind5s(),
                      ),
                      IconButton(
                        icon: Icon(
                          playerState.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () => ref
                            .read(audioPlayerProvider.notifier)
                            .togglePlay(),
                      ),
                      Expanded(
                        child: Slider(
                          value: playerState.speed,
                          min: 0.5,
                          max: 1.5,
                          divisions: 4,
                          label: '${playerState.speed}x',
                          onChanged: (v) => ref
                              .read(audioPlayerProvider.notifier)
                              .setSpeed(v),
                        ),
                      ),
                      Text(
                        '${playerState.speed}x',
                        style: theme.textTheme.labelLarge,
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

  Future<void> _handleRecordTap(String lessonId, String transcript) async {
    final recorder = ref.read(audioRecorderProvider.notifier);
    final recorderState = ref.read(audioRecorderProvider);

    if (recorderState.isRecording) {
      // Stop recording and analyze
      final path = await recorder.stopRecording();
      setState(() => _isAnalyzing = true);

      try {
        final analysis = ref.read(speechAnalysisServiceProvider);
        final feedback = await analysis.analyze(
          lessonId: lessonId,
          modelTranscript: transcript,
          userAudioPath: path,
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
            SnackBar(content: Text('分析エラー: $e')),
          );
        }
      }
    } else {
      await recorder.startRecording();
    }
  }
}

class _WaveformPlaceholder extends StatelessWidget {
  const _WaveformPlaceholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(20, (i) {
        final height = 8.0 + (i % 5) * 6.0;
        return Container(
          width: 3,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}
