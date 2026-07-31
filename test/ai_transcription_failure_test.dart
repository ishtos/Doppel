import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/shared/analytics/analytics_service.dart';
import 'package:doppel/shared/services/ai_backend.dart';
import 'package:doppel/shared/services/ai_coach_service.dart';
import 'package:doppel/shared/services/speech_analysis_service.dart';

/// Records captured events so we can assert the failure is reported.
class _RecordingAnalytics implements AnalyticsService {
  final List<String> events = [];
  final List<Map<String, Object?>> props = [];

  @override
  void capture(String event, {Map<String, Object?> properties = const {}}) {
    events.add(event);
    props.add(properties);
  }

  @override
  void identify(String distinctId) {}

  @override
  Future<void> flush() async {}
}

void main() {
  // A configured-but-reachable-in-name-only proxy makes `isAvailable` true, so
  // transcription is attempted. The bogus audio path makes the attempt fail
  // deterministically inside _transcribe (no real network needed). The coach
  // uses its own default (unavailable) backend → local, so no network either.
  SpeechAnalysisService buildService(_RecordingAnalytics analytics) {
    return SpeechAnalysisService(
      AiCoachService(),
      backend: AiBackendConfig(proxyUrl: 'https://proxy.invalid'),
      analytics: analytics,
    );
  }

  test('cloud transcription failure records analysisError + fires event',
      () async {
    final analytics = _RecordingAnalytics();
    final feedback = await buildService(analytics).analyze(
      lessonId: 'lesson-1',
      modelTranscript: 'hello world this is a short test passage',
      userAudioPath: '/tmp/doppel-nonexistent-audio.m4a',
      cloudEnabled: true,
    );

    // Attempt failed → simulated scores, but now with a recorded reason.
    expect(feedback.userTranscript, isNull);
    expect(feedback.analysisError, 'network');

    expect(analytics.events, contains('ai_transcription_failed'));
    final i = analytics.events.indexOf('ai_transcription_failed');
    expect(analytics.props[i]['reason'], 'network');
  });

  test('consent off makes no attempt: no analysisError, no event', () async {
    final analytics = _RecordingAnalytics();
    final feedback = await buildService(analytics).analyze(
      lessonId: 'lesson-1',
      modelTranscript: 'hello world',
      userAudioPath: '/tmp/doppel-nonexistent-audio.m4a',
      cloudEnabled: false, // by-design offline
    );

    expect(feedback.analysisError, isNull);
    expect(analytics.events, isNot(contains('ai_transcription_failed')));
  });

  test('analysisError round-trips through JSON (Hive storage contract)',
      () async {
    final analytics = _RecordingAnalytics();
    final feedback = await buildService(analytics).analyze(
      lessonId: 'lesson-1',
      modelTranscript: 'hello world',
      userAudioPath: '/tmp/doppel-nonexistent-audio.m4a',
      cloudEnabled: true,
    );

    expect(feedback.toJson()['analysisError'], 'network');
    expect(FeedbackModel.fromJson(feedback.toJson()).analysisError, 'network');
  });
}
