import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  bool _isRecording = false;
  double _speed = 1.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('レッスン', style: theme.textTheme.titleMedium),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Transcript area
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                'This is a sample transcript for the shadowing lesson. '
                'The highlighted words will change as the audio plays.',
                style: theme.textTheme.bodyLarge,
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
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('波形表示エリア')),
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
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('録音波形エリア')),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Playback controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_5),
                  onPressed: () {},
                ),
                Expanded(
                  child: Slider(
                    value: _speed,
                    min: 0.5,
                    max: 1.5,
                    divisions: 4,
                    label: '${_speed}x',
                    onChanged: (v) => setState(() => _speed = v),
                  ),
                ),
                Text(
                  '${_speed}x',
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
                onTap: () => setState(() => _isRecording = !_isRecording),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isRecording ? 112 : 96,
                  height: _isRecording ? 112 : 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording
                                ? theme.colorScheme.error
                                : theme.colorScheme.primary)
                            .withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
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
}
