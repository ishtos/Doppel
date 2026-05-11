import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/presentation/screens/feedback_screen.dart';
import 'package:doppel/shared/data/seed_data.dart';

void main() {
  // FIXED: テスト用フィードバックデータを全フィールド指定して網羅的にテスト
  final testFeedback = FeedbackModel(
    id: 'test-fb-001',
    lessonId: 'lesson-001',
    overallScore: 78,
    pronunciationScore: 82,
    rhythmScore: 75,
    intonationScore: 77,
    problemWords: const [
      ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.6),
      ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.5),
    ],
    coachMessage: '良い調子です！発音の改善がスコアアップの鍵です。',
    createdAt: DateTime(2026, 5, 11, 10, 30),
    userTranscript: 'Good morning and welcome to the morning news',
    modelTranscript: 'Good morning and welcome to the morning news report',
    userAudioPath: '/tmp/test-recording.m4a',
  );

  // FIXED: userTranscript なしのケースも用意
  final testFeedbackMinimal = FeedbackModel(
    id: 'test-fb-002',
    lessonId: 'lesson-001',
    overallScore: 65,
    pronunciationScore: 60,
    rhythmScore: 68,
    intonationScore: 67,
    problemWords: const [],
    coachMessage: 'もう少し練習しましょう。',
    createdAt: DateTime(2026, 5, 11, 9, 0),
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_feedback');

    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) await Hive.box<Map>('feedbacks').close();
    if (Hive.isBoxOpen('progress')) await Hive.box<Map>('progress').close();

    final lessonsBox = await Hive.openBox<Map>('lessons');
    final feedbacksBox = await Hive.openBox<Map>('feedbacks');
    await Hive.openBox<Map>('progress');

    if (lessonsBox.isEmpty) {
      for (final lesson in seedLessons) {
        await lessonsBox.put(lesson.id, lesson.toJson());
      }
    }

    await feedbacksBox.put(testFeedback.id, testFeedback.toJson());
    await feedbacksBox.put(testFeedbackMinimal.id, testFeedbackMinimal.toJson());
  });

  tearDown(() async {
    await Hive.close();
  });

  // FIXED: 各テスト用に独立した GoRouter を生成し、オンボーディング redirect を回避
  Widget buildWidget(String feedbackId) {
    final router = GoRouter(
      initialLocation: '/feedback/$feedbackId',
      routes: [
        GoRoute(
          path: '/feedback/:feedbackId',
          builder: (_, state) => FeedbackScreen(
            feedbackId: state.pathParameters['feedbackId']!,
          ),
        ),
        GoRoute(path: '/home', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/library', builder: (_, __) => const SizedBox()),
        GoRoute(path: '/lesson/:id', builder: (_, __) => const SizedBox()),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('FeedbackScreen - not found', () {
    testWidgets('shows not found message for invalid feedback ID',
        (tester) async {
      await tester.pumpWidget(buildWidget('nonexistent'));
      await tester.pumpAndSettle();

      expect(find.text('フィードバックが見つかりません'), findsOneWidget);
    });
  });

  group('FeedbackScreen - score display', () {
    testWidgets('displays overall score after animation', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('78'), findsOneWidget);
    });

    testWidgets('displays score label based on overall score', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('良い'), findsOneWidget);
    });

    testWidgets('displays all sub-score labels', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('発音'), findsOneWidget);
      expect(find.text('リズム'), findsOneWidget);
      expect(find.text('抑揚'), findsOneWidget);
    });

    testWidgets('displays sub-score values', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('82'), findsOneWidget);
      expect(find.text('75'), findsOneWidget);
      expect(find.text('77'), findsOneWidget);
    });
  });

  group('FeedbackScreen - transcript comparison', () {
    testWidgets('shows transcript comparison section with both transcripts',
        (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('お手本'), findsOneWidget);
      expect(find.text('あなたの発話'), findsOneWidget);
    });

    testWidgets('shows diff legend when both transcripts present',
        (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('抜けた単語'), findsOneWidget);
      expect(find.text('余分な単語'), findsOneWidget);
    });

    testWidgets('shows simulator fallback when no user transcript',
        (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-002'));
      await tester.pumpAndSettle();

      expect(find.text('音声認識テキストなし（シミュレーターモード）'), findsOneWidget);
    });
  });

  group('FeedbackScreen - problem words', () {
    testWidgets('displays problem words as chips', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.text('through /θ/'), findsOneWidget);
      expect(find.text('world /r/'), findsOneWidget);
    });

    testWidgets('hides problem words section when empty', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-002'));
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsNothing);
    });
  });

  group('FeedbackScreen - AI coach', () {
    testWidgets('displays AI coach card with message', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('AIコーチ'), findsOneWidget);
      expect(
        find.text('良い調子です！発音の改善がスコアアップの鍵です。'),
        findsOneWidget,
      );
    });

    testWidgets('shows regenerate button', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('AIで再生成'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('shows psychology icon in coach avatar', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });
  });

  group('FeedbackScreen - navigation & actions', () {
    testWidgets('has app bar with title and back button', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('フィードバック'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('has share button in app bar', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('displays library and retry action buttons', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('ライブラリへ'), findsOneWidget);
      expect(find.text('もう一度'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });
  });

  group('FeedbackScreen - audio playback', () {
    testWidgets('shows playback tile when audio path exists', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-001'));
      await tester.pumpAndSettle();

      expect(find.text('自分の録音を聴く'), findsOneWidget);
      expect(find.text('録音した音声を再生します'), findsOneWidget);
    });

    testWidgets('hides playback tile when no audio path', (tester) async {
      await tester.pumpWidget(buildWidget('test-fb-002'));
      await tester.pumpAndSettle();

      expect(find.text('自分の録音を聴く'), findsNothing);
    });
  });
}
