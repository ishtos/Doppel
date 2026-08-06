import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/shared/services/ai_backend.dart';
import 'package:doppel/shared/services/ai_coach_service.dart';
import 'package:doppel/shared/services/speech_analysis_service.dart';

void main() {
  // A configured-but-reachable-in-name-only proxy makes `isAvailable` true, so
  // transcription is attempted. The bogus audio path makes the attempt fail
  // deterministically inside _transcribe (no real network needed). The coach
  // uses its own default (unavailable) backend → local, so no network either.
  SpeechAnalysisService buildService() {
    return SpeechAnalysisService(
      AiCoachService(),
      backend: AiBackendConfig(proxyUrl: 'https://proxy.invalid'),
    );
  }

  test('cloud transcription failure records a diagnosable analysisError',
      () async {
    final feedback = await buildService().analyze(
      lessonId: 'lesson-1',
      modelTranscript: 'hello world this is a short test passage',
      userAudioPath: '/tmp/doppel-nonexistent-audio.m4a',
      cloudEnabled: true,
    );

    // Attempt failed → simulated scores, but now with a recorded reason the
    // feedback screen can surface (no analytics backend needed).
    expect(feedback.userTranscript, isNull);
    expect(feedback.analysisError, 'network');
  });

  test('consent off makes no attempt: analysisError stays null', () async {
    final feedback = await buildService().analyze(
      lessonId: 'lesson-1',
      modelTranscript: 'hello world',
      userAudioPath: '/tmp/doppel-nonexistent-audio.m4a',
      cloudEnabled: false, // by-design offline
    );

    expect(feedback.analysisError, isNull);
  });

  test('analysisError round-trips through JSON (Hive storage contract)',
      () async {
    final feedback = await buildService().analyze(
      lessonId: 'lesson-1',
      modelTranscript: 'hello world',
      userAudioPath: '/tmp/doppel-nonexistent-audio.m4a',
      cloudEnabled: true,
    );

    expect(feedback.toJson()['analysisError'], 'network');
    expect(FeedbackModel.fromJson(feedback.toJson()).analysisError, 'network');
  });
}
