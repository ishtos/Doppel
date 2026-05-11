import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/lesson/presentation/screens/lesson_screen.dart';
import 'package:doppel/shared/data/seed_data.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_lesson');

    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) await Hive.box<Map>('feedbacks').close();
    if (Hive.isBoxOpen('progress')) await Hive.box<Map>('progress').close();

    final lessonsBox = await Hive.openBox<Map>('lessons');
    await Hive.openBox<Map>('feedbacks');
    await Hive.openBox<Map>('progress');

    if (lessonsBox.isEmpty) {
      for (final lesson in seedLessons) {
        await lessonsBox.put(lesson.id, lesson.toJson());
      }
    }
  });

  tearDown(() async {
    await Hive.close();
  });

  // FIXED: 各テスト用に独立した GoRouter を生成し、オンボーディング redirect を回避
  Widget buildWidget(String lessonId) {
    final router = GoRouter(
      initialLocation: '/lesson/$lessonId',
      routes: [
        GoRoute(
          path: '/lesson/:lessonId',
          builder: (_, state) => LessonScreen(
            lessonId: state.pathParameters['lessonId']!,
          ),
        ),
        GoRoute(path: '/home', builder: (_, __) => const SizedBox()),
        GoRoute(
          path: '/feedback/:id',
          builder: (_, __) => const SizedBox(),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('LessonScreen - not found', () {
    testWidgets('shows not found message for invalid lesson ID',
        (tester) async {
      await tester.pumpWidget(buildWidget('nonexistent'));
      await tester.pumpAndSettle();

      expect(find.text('レッスンが見つかりません'), findsOneWidget);
    });
  });

  group('LessonScreen - lesson content', () {
    testWidgets('displays lesson title in app bar', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.text('Morning News Report'), findsOneWidget);
    });

    testWidgets('displays transcript text', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Good morning and welcome'),
        findsOneWidget,
      );
    });

    testWidgets('has back button in app bar', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('LessonScreen - playback controls', () {
    testWidgets('shows TTS playback button and label', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.text('お手本を聴く'), findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
    });

    testWidgets('shows speed slider with icon', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
    });

    testWidgets('shows WPM badge', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.textContaining('WPM'), findsOneWidget);
    });

    testWidgets('shows default speed label', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      // Default speed 0.5 / 0.5 = 1.0x
      expect(find.text('1.0x'), findsOneWidget);
    });
  });

  group('LessonScreen - recording', () {
    testWidgets('shows record button with mic icon', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });
  });

  group('LessonScreen - text visibility', () {
    testWidgets('shows text visibility toggle button', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('toggles visibility icon on tap', (tester) async {
      await tester.pumpWidget(buildWidget('lesson-001'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
