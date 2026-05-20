import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/presentation/screens/feedback_screen.dart';
import 'package:doppel/features/feedback/data/repositories/feedback_repository.dart';
import 'package:doppel/shared/providers/db_providers.dart';
import 'package:doppel/shared/services/audio_service.dart';
import 'package:doppel/shared/services/ai_coach_service.dart';

Map _toPlainMap(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map;

const _testFeedbackId = 'test-feedback-001';
const _testLessonId = 'lesson-001';

final _testFeedback = FeedbackModel(
  id: _testFeedbackId,
  lessonId: _testLessonId,
  overallScore: 75,
  pronunciationScore: 80,
  rhythmScore: 70,
  intonationScore: 75,
  problemWords: [
    const ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.6),
    const ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.5),
  ],
  coachMessage: '良い調子です！発音の改善がスコアアップの鍵です。',
  createdAt: DateTime(2026, 5, 20, 10, 0),
  modelTranscript: 'The quick brown fox jumps over the lazy dog',
  userTranscript: 'The quick brown fox jumps the lazy dog',
);

void main() {
  late Box<Map> feedbacksBox;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });


  setUp(() async {
    Hive.init('./test_hive_feedback');

    if (Hive.isBoxOpen('test_feedbacks')) {
      await Hive.box<Map>('test_feedbacks').close();
    }
    feedbacksBox = await Hive.openBox<Map>('test_feedbacks');
    await feedbacksBox.clear();
    await feedbacksBox.put(_testFeedbackId, _toPlainMap(_testFeedback.toJson()));
  });

  // No tearDown — setUp re-initializes the box before each test,
  // and the test process exits after completion.

  Widget buildTestWidget() {
    return ProviderScope(
      overrides: [
        feedbacksBoxProvider.overrideWithValue(feedbacksBox),
        feedbackRepositoryProvider.overrideWithValue(
          FeedbackRepository(feedbacksBox),
        ),
        audioPlayerProvider.overrideWith(
          (ref) => _FakeAudioPlayerNotifier(),
        ),
        aiCoachServiceProvider.overrideWithValue(AiCoachService()),
      ],
      child: MaterialApp(
        home: const FeedbackScreen(feedbackId: _testFeedbackId),
      ),
    );
  }

  group('FeedbackScreen', () {
    testWidgets('displays overall score', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // 75 appears twice: once as overall score in the animated indicator,
      // and once as intonation sub-score
      expect(find.text('75'), findsNWidgets(2));
    });

    testWidgets('displays score label', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('良い'), findsOneWidget);
    });

    testWidgets('displays sub-scores', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('発音'), findsOneWidget);
      expect(find.text('リズム'), findsOneWidget);
      expect(find.text('抑揚'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('70'), findsOneWidget);
    });

    testWidgets('displays transcript comparison card', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('お手本'), findsOneWidget);
      expect(find.text('あなたの発話'), findsOneWidget);
    });

    testWidgets('displays diff legend', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('抜けた単語'), findsOneWidget);
      expect(find.text('余分な単語'), findsOneWidget);
    });

    testWidgets('displays problem words', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.text('through /θ/'), findsOneWidget);
      expect(find.text('world /r/'), findsOneWidget);
    });

    testWidgets('displays AI coach message', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('AIコーチ'), findsOneWidget);
      expect(
        find.text('良い調子です！発音の改善がスコアアップの鍵です。'),
        findsOneWidget,
      );
    });

    testWidgets('displays AI regenerate button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('AIで再生成'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('displays action buttons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('ライブラリへ'), findsOneWidget);
      expect(find.text('もう一度'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    testWidgets('shows not found message for invalid ID', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            feedbacksBoxProvider.overrideWithValue(feedbacksBox),
            feedbackRepositoryProvider.overrideWithValue(
              FeedbackRepository(feedbacksBox),
            ),
            audioPlayerProvider.overrideWith(
              (ref) => _FakeAudioPlayerNotifier(),
            ),
          ],
          child: const MaterialApp(
            home: FeedbackScreen(feedbackId: 'nonexistent-id'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('フィードバックが見つかりません'), findsOneWidget);
    });

    testWidgets('does not show audio playback when no recording',
        (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('自分の録音を聴く'), findsNothing);
    });

    testWidgets('shows audio playback when recording exists', (tester) async {
      final feedbackWithAudio = _testFeedback.copyWith(
        userAudioPath: '/tmp/test_audio.m4a',
      );
      await feedbacksBox.put(_testFeedbackId, _toPlainMap(feedbackWithAudio.toJson()));

      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('自分の録音を聴く'), findsOneWidget);
    });

  });
}

class _FakeAudioPlayerNotifier extends AudioPlayerNotifier {
  _FakeAudioPlayerNotifier() : super();

  @override
  Future<void> playFile(String filePath) async {
    state = state.copyWith(isPlaying: true);
  }

  @override
  Future<void> stopPlayback() async {
    state = state.copyWith(isPlaying: false);
  }

  @override
  void dispose() {
    // Skip AudioPlayer disposal — not available in test environment
  }
}
