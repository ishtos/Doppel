import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/app/theme.dart';
import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/presentation/screens/feedback_screen.dart';
import 'package:doppel/shared/data/seed_data.dart';

void main() {
  const testFeedbackId = 'test-feedback-001';

  final testFeedback = FeedbackModel(
    id: testFeedbackId,
    lessonId: 'lesson-001',
    overallScore: 75,
    pronunciationScore: 80,
    rhythmScore: 70,
    intonationScore: 75,
    problemWords: const [
      ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.6),
      ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.5),
    ],
    coachMessage: '良い調子です！発音の改善がスコアアップの鍵です。',
    createdAt: DateTime(2026, 5, 4, 10, 0),
    modelTranscript: 'Good morning and welcome to the news report',
    userTranscript: 'Good morning and welcome the news',
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Mock audio platform channels to prevent MissingPluginException
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.ryanheise.just_audio.methods'),
      (call) async => {},
    );

    Hive.init('./test_hive_feedback');
    for (final name in ['lessons', 'feedbacks', 'progress']) {
      if (Hive.isBoxOpen(name)) await Hive.box<Map>(name).close();
    }

    final lessonsBox = await Hive.openBox<Map>('lessons');
    final feedbacksBox = await Hive.openBox<Map>('feedbacks');
    await Hive.openBox<Map>('progress');

    if (lessonsBox.isEmpty) {
      for (final lesson in seedLessons) {
        await lessonsBox.put(lesson.id, lesson.toJson());
      }
    }

    await feedbacksBox.put(testFeedbackId, testFeedback.toJson());
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('com.ryanheise.just_audio.methods'),
      null,
    );
    await Hive.close();
  });

  Widget buildTestWidget({String? feedbackId}) {
    final id = feedbackId ?? testFeedbackId;
    final router = GoRouter(
      initialLocation: '/feedback/$id',
      routes: [
        GoRoute(
          path: '/feedback/:feedbackId',
          builder: (context, state) => FeedbackScreen(
            feedbackId: state.pathParameters['feedbackId']!,
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('Home')),
        ),
        GoRoute(
          path: '/library',
          builder: (_, __) => const Scaffold(body: Text('Library')),
        ),
        GoRoute(
          path: '/lesson/:lessonId',
          builder: (_, __) => const Scaffold(body: Text('Lesson')),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        theme: AppTheme.light(),
        routerConfig: router,
      ),
    );
  }

  /// Pump and drain any platform exceptions from audio plugin initialization.
  Future<void> pumpFeedbackScreen(
    WidgetTester tester, {
    String? feedbackId,
  }) async {
    await tester.pumpWidget(buildTestWidget(feedbackId: feedbackId));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    // Drain platform exceptions from audio plugin async init
    while (tester.takeException() != null) {}
    // Let score animation complete (800ms duration)
    await tester.pump(const Duration(seconds: 1));
    while (tester.takeException() != null) {}
  }

  group('Feedback screen', () {
    testWidgets('shows title in app bar', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('フィードバック'), findsOneWidget);
    });

    testWidgets('shows overall score after animation', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('75'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows score label', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('良い'), findsOneWidget);
    });

    testWidgets('shows sub-score labels', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('発音'), findsOneWidget);
      expect(find.text('リズム'), findsOneWidget);
      expect(find.text('抑揚'), findsOneWidget);
    });

    testWidgets('shows sub-score values', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('70'), findsOneWidget);
    });

    testWidgets('shows AI coach section', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('AIコーチ'), findsOneWidget);
      expect(find.textContaining('良い調子です'), findsOneWidget);
    });

    testWidgets('shows regenerate button', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('AIで再生成'), findsOneWidget);
    });

    testWidgets('shows action buttons', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('ライブラリへ'), findsOneWidget);
      expect(find.text('もう一度'), findsOneWidget);
    });

    testWidgets('shows transcript comparison section', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('お手本'), findsOneWidget);
      expect(find.text('あなたの発話'), findsOneWidget);
    });

    testWidgets('shows diff legend', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('抜けた単語'), findsOneWidget);
      expect(find.text('余分な単語'), findsOneWidget);
    });

    testWidgets('shows problem words', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.textContaining('through'), findsOneWidget);
      expect(find.textContaining('world'), findsOneWidget);
    });

    testWidgets('shows share button', (tester) async {
      await pumpFeedbackScreen(tester);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('library button navigates', (tester) async {
      await pumpFeedbackScreen(tester);
      await tester.tap(find.text('ライブラリへ'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      while (tester.takeException() != null) {}
      expect(find.text('Library'), findsOneWidget);
    });

    testWidgets('retry button navigates to lesson', (tester) async {
      await pumpFeedbackScreen(tester);
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
}
