import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doppel/main.dart';
import 'package:doppel/shared/data/seed_data.dart';
import 'package:doppel/features/feedback/data/models/feedback_model.dart';

void main() {
  late Box<Map> lessonsBox;
  late Box<Map> feedbacksBox;
  late Box<Map> progressBox;

  final testFeedback = FeedbackModel(
    id: 'test-fb-1',
    lessonId: 'lesson-001',
    overallScore: 85,
    pronunciationScore: 88,
    rhythmScore: 82,
    intonationScore: 84,
    problemWords: [
      const ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.5),
      const ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.6),
    ],
    coachMessage: 'Great practice session!',
    createdAt: DateTime.now(),
    modelTranscript: 'Good morning and welcome',
    userTranscript: 'Good morning welcome',
  );

  final secondFeedback = FeedbackModel(
    id: 'test-fb-2',
    lessonId: 'lesson-007',
    overallScore: 72,
    pronunciationScore: 70,
    rhythmScore: 75,
    intonationScore: 71,
    problemWords: [
      const ProblemWord(word: 'economy', phoneme: '/ə/', errorRate: 0.4),
    ],
    coachMessage: 'Keep working on it!',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    Hive.init('./test_hive_home_fb');
    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) await Hive.box<Map>('feedbacks').close();
    if (Hive.isBoxOpen('progress')) await Hive.box<Map>('progress').close();

    lessonsBox = await Hive.openBox<Map>('lessons');
    feedbacksBox = await Hive.openBox<Map>('feedbacks');
    progressBox = await Hive.openBox<Map>('progress');

    if (lessonsBox.isEmpty) {
      for (final lesson in seedLessons) {
        await lessonsBox.put(lesson.id, lesson.toJson());
      }
    }
  });

  tearDown(() async {
    await feedbacksBox.clear();
    await progressBox.clear();
    await Hive.close();
  });

  group('Home screen with feedback data', () {
    testWidgets('shows recent activity when feedbacks exist',
        (WidgetTester tester) async {
      await feedbacksBox.put(testFeedback.id, testFeedback.toJson());

      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('最近の練習'), findsOneWidget);
      expect(find.text('Morning News Report'), findsWidgets);
    });

    testWidgets('shows feedback score in recent activity',
        (WidgetTester tester) async {
      await feedbacksBox.put(testFeedback.id, testFeedback.toJson());

      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('85点'), findsOneWidget);
    });

    testWidgets('shows multiple recent activities',
        (WidgetTester tester) async {
      await feedbacksBox.put(testFeedback.id, testFeedback.toJson());
      await feedbacksBox.put(secondFeedback.id, secondFeedback.toJson());

      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('85点'), findsOneWidget);
      expect(find.text('72点'), findsOneWidget);
    });

    testWidgets('shows improvement points from feedback problem words',
        (WidgetTester tester) async {
      await feedbacksBox.put(testFeedback.id, testFeedback.toJson());

      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.text('through /θ/'), findsOneWidget);
      expect(find.text('world /r/'), findsOneWidget);
    });

    testWidgets('weekly stats reflect practice data',
        (WidgetTester tester) async {
      await feedbacksBox.put(testFeedback.id, testFeedback.toJson());
      await feedbacksBox.put(secondFeedback.id, secondFeedback.toJson());

      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('2回'), findsOneWidget); // 2 practice sessions
    });

    testWidgets('shows empty state message when no feedbacks',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('まだ練習記録がありません'), findsOneWidget);
    });

    testWidgets('daily goal progress shows on home screen',
        (WidgetTester tester) async {
      await feedbacksBox.put(testFeedback.id, testFeedback.toJson());

      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      // Default daily goal is 3, with 1 practice today
      expect(find.text('1/3'), findsWidgets);
    });
  });
}
