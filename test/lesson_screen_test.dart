import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/shared/data/seed_data.dart';

import 'helpers/test_helpers.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupMockPlatformChannels();
    setupMockSharedPreferences();
    await setupTestHive('./test_hive_lesson');

    final lessonsBox = Hive.box<Map>('lessons');
    for (final lesson in seedLessons) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }
  });

  tearDown(() async {
    tearDownMockPlatformChannels();
    await Hive.close();
  });

  group('Lesson screen', () {
    testWidgets('shows lesson title', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.text('Morning News Report'), findsOneWidget);
    });

    testWidgets('shows transcript text', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.textContaining('Good morning'), findsOneWidget);
    });

    testWidgets('shows record button with mic icon', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('shows TTS play button and label', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('お手本を聴く'), findsOneWidget);
    });

    testWidgets('shows speed control', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.byIcon(Icons.speed), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('shows default speed label', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.text('1.0x'), findsOneWidget);
    });

    testWidgets('shows visibility toggle', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows WPM badge', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.textContaining('WPM'), findsOneWidget);
    });

    testWidgets('back button navigates to home', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('nonexistent lesson shows error message', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'nonexistent');
      expect(find.text('レッスンが見つかりません'), findsOneWidget);
    });
  });

  group('Lesson screen - past score banner', () {
    testWidgets('shows past score when feedbacks exist', (tester) async {
      final feedback = createTestFeedback(
        id: 'fb-past-1',
        lessonId: 'lesson-001',
        overallScore: 78,
      );
      await seedTestFeedback(feedback);

      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.textContaining('前回:'), findsOneWidget);
      expect(find.textContaining('78点'), findsOneWidget);
      expect(find.textContaining('最高:'), findsOneWidget);
      expect(find.text('1回練習'), findsOneWidget);
      expect(find.text('詳細'), findsOneWidget);
    });

    testWidgets('hides past score when no feedbacks', (tester) async {
      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.textContaining('前回:'), findsNothing);
      expect(find.text('詳細'), findsNothing);
    });

    testWidgets('shows correct practice count for multiple feedbacks',
        (tester) async {
      await seedTestFeedback(createTestFeedback(
        id: 'fb-multi-1',
        lessonId: 'lesson-001',
        overallScore: 60,
      ));
      await seedTestFeedback(createTestFeedback(
        id: 'fb-multi-2',
        lessonId: 'lesson-001',
        overallScore: 85,
      ));

      await pumpLessonScreen(tester, lessonId: 'lesson-001');
      expect(find.text('2回練習'), findsOneWidget);
      expect(find.textContaining('最高:'), findsOneWidget);
    });
  });
}
