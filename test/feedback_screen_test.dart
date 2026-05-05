import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/shared/data/seed_data.dart';

import 'helpers/test_helpers.dart';

void main() {
  const testFeedbackId = 'test-feedback-001';

  final testFeedback = createTestFeedback(
    id: testFeedbackId,
    lessonId: 'lesson-001',
    overallScore: 76,
    pronunciationScore: 80,
    rhythmScore: 70,
    intonationScore: 65,
    coachMessage: '良い調子です！発音の改善がスコアアップの鍵です。',
    modelTranscript: 'Good morning and welcome to the news report',
    userTranscript: 'Good morning and welcome the news',
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupMockPlatformChannels();
    setupMockSharedPreferences();
    await setupTestHive('./test_hive_feedback');

    final lessonsBox = Hive.box<Map>('lessons');
    for (final lesson in seedLessons) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }
    await seedTestFeedback(testFeedback);
  });

  tearDown(() async {
    tearDownMockPlatformChannels();
    await Hive.close();
  });

  group('Feedback screen', () {
    testWidgets('shows title in app bar', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('フィードバック'), findsOneWidget);
    });

    testWidgets('shows overall score after animation', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('76'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows score label', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      // 76 -> '良い' (70-79 range)
      expect(find.text('良い'), findsOneWidget);
    });

    testWidgets('shows sub-score labels', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('発音'), findsOneWidget);
      expect(find.text('リズム'), findsOneWidget);
      expect(find.text('抑揚'), findsOneWidget);
    });

    testWidgets('shows sub-score values', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('70'), findsOneWidget);
      expect(find.text('65'), findsOneWidget);
    });

    testWidgets('shows AI coach section', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('AIコーチ'), findsOneWidget);
      expect(find.textContaining('良い調子です'), findsOneWidget);
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });

    testWidgets('shows regenerate button', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('AIで再生成'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('ライブラリへ'), findsOneWidget);
      expect(find.text('もう一度'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    testWidgets('shows transcript comparison section', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('お手本'), findsOneWidget);
      expect(find.text('あなたの発話'), findsOneWidget);
    });

    testWidgets('shows diff legend', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('抜けた単語'), findsOneWidget);
      expect(find.text('余分な単語'), findsOneWidget);
    });

    testWidgets('shows problem words', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.textContaining('through'), findsOneWidget);
      expect(find.textContaining('world'), findsOneWidget);
    });

    testWidgets('shows share button', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('shows back button', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('library button navigates', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      await tester.tap(find.text('ライブラリへ'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
      expect(find.text('Library'), findsOneWidget);
    });

    testWidgets('retry button navigates to lesson', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      await tester.tap(find.text('もう一度'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
      expect(find.text('Lesson'), findsOneWidget);
    });

    testWidgets('nonexistent feedback shows error', (tester) async {
      await pumpFeedbackScreen(tester, feedbackId: 'nonexistent');
      expect(find.text('フィードバックが見つかりません'), findsOneWidget);
    });
  });

  group('Feedback screen - audio playback', () {
    testWidgets('shows playback tile when userAudioPath is set',
        (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-audio',
        lessonId: 'lesson-001',
        userAudioPath: '/tmp/test_audio.m4a',
      );
      await seedTestFeedback(feedback);

      await pumpFeedbackScreen(tester, feedbackId: 'fb-audio');
      expect(find.text('自分の録音を聴く'), findsOneWidget);
      expect(find.text('録音した音声を再生します'), findsOneWidget);
    });

    testWidgets('hides playback tile when no userAudioPath', (tester) async {
      // testFeedback has no userAudioPath by default
      await pumpFeedbackScreen(tester, feedbackId: testFeedbackId);
      expect(find.text('自分の録音を聴く'), findsNothing);
    });
  });

  group('Feedback screen - empty problem words', () {
    testWidgets('hides problem words section when list is empty',
        (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-no-problems',
        lessonId: 'lesson-001',
        problemWords: const [],
      );
      await seedTestFeedback(feedback);

      await pumpFeedbackScreen(tester, feedbackId: 'fb-no-problems');
      expect(find.text('改善ポイント'), findsNothing);
    });
  });

  group('Feedback screen - simulator fallback', () {
    testWidgets('shows fallback message when no user transcript',
        (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-no-transcript',
        lessonId: 'lesson-001',
        modelTranscript: 'The world is changing.',
        userTranscript: null,
      );
      await seedTestFeedback(feedback);

      await pumpFeedbackScreen(tester, feedbackId: 'fb-no-transcript');
      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('音声認識テキストなし（シミュレーターモード）'), findsOneWidget);
    });
  });

  group('Feedback screen - score label ranges', () {
    testWidgets('score >= 90 shows 素晴らしい！', (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-excellent',
        lessonId: 'lesson-001',
        overallScore: 92,
      );
      await seedTestFeedback(feedback);

      await pumpFeedbackScreen(tester, feedbackId: 'fb-excellent');
      expect(find.text('素晴らしい！'), findsOneWidget);
    });

    testWidgets('score 60-69 shows もう少し', (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-almost',
        lessonId: 'lesson-001',
        overallScore: 63,
      );
      await seedTestFeedback(feedback);

      await pumpFeedbackScreen(tester, feedbackId: 'fb-almost');
      expect(find.text('もう少し'), findsOneWidget);
    });

    testWidgets('score < 60 shows 頑張ろう', (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-low',
        lessonId: 'lesson-001',
        overallScore: 45,
      );
      await seedTestFeedback(feedback);

      await pumpFeedbackScreen(tester, feedbackId: 'fb-low');
      expect(find.text('頑張ろう'), findsOneWidget);
    });
  });
}
