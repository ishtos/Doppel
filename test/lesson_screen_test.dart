import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/lesson/presentation/screens/lesson_screen.dart';
import 'package:doppel/shared/data/seed_data.dart';

import 'helpers/platform_mocks.dart';

void main() {
  late Box<Map> feedbacksBox;
  late Box<Map> lessonsBox;
  late Box<Map> progressBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupMockPlatformChannels();

    Hive.init('./test_hive_lesson_screen');

    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) await Hive.box<Map>('feedbacks').close();
    if (Hive.isBoxOpen('progress')) await Hive.box<Map>('progress').close();

    lessonsBox = await Hive.openBox<Map>('lessons');
    feedbacksBox = await Hive.openBox<Map>('feedbacks');
    progressBox = await Hive.openBox<Map>('progress');

    for (final lesson in seedLessons) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }
  });

  tearDown(() async {
    await feedbacksBox.clear();
    await lessonsBox.clear();
    await progressBox.clear();
    await Hive.close();
    tearDownMockPlatformChannels();
  });

  Widget buildScreen(String lessonId) {
    return ProviderScope(
      child: MaterialApp(
        home: LessonScreen(lessonId: lessonId),
      ),
    );
  }

  group('LessonScreen', () {
    testWidgets('shows not-found message for invalid lesson ID',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('nonexistent-id'));
      await tester.pumpAndSettle();

      expect(find.text('レッスンが見つかりません'), findsOneWidget);
    });

    testWidgets('renders lesson title in app bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.text('Morning News Report'), findsOneWidget);
    });

    testWidgets('renders back button', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders transcript text', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Good morning and welcome'),
        findsOneWidget,
      );
    });

    testWidgets('renders TTS playback button', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('お手本を聴く'), findsOneWidget);
    });

    testWidgets('renders speed slider', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
    });

    testWidgets('renders record button with mic icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('renders visibility toggle button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('renders WPM badge', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      // lesson-001: wordCount=281, duration=169s, speed=0.5
      // nativeWpm = (281/169*60).round() = 100
      // WPM = (100 * (0.5/0.5)).round() = 100
      expect(find.text('100 WPM'), findsOneWidget);
    });

    testWidgets('does not show past score banner without feedback',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.text('前回:'), findsNothing);
      expect(find.text('詳細'), findsNothing);
    });

    // FIXED: 過去のフィードバック有りの場合もテスト
    testWidgets('shows past score banner when feedback exists',
        (WidgetTester tester) async {
      final pastFeedback = FeedbackModel(
        id: 'past-fb-1',
        lessonId: 'lesson-001',
        overallScore: 78,
        pronunciationScore: 80,
        rhythmScore: 75,
        intonationScore: 79,
        problemWords: const [],
        coachMessage: 'Great job!',
        createdAt: DateTime(2026, 5, 12),
      );
      await feedbacksBox.put(pastFeedback.id, pastFeedback.toJson());

      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.textContaining('前回'), findsOneWidget);
      expect(find.textContaining('78点'), findsOneWidget);
      expect(find.text('1回練習'), findsOneWidget);
      expect(find.text('詳細'), findsOneWidget);
    });

    testWidgets('does not show waveform in idle state',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.text('テキスト非表示中'), findsNothing);
    });
  });
}
