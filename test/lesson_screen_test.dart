import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/app/theme.dart';
import 'package:doppel/features/lesson/presentation/screens/lesson_screen.dart';
import 'package:doppel/shared/data/seed_data.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (call) async => 1,
    );

    Hive.init('./test_hive_lesson');
    for (final name in ['lessons', 'feedbacks', 'progress']) {
      if (Hive.isBoxOpen(name)) await Hive.box<Map>(name).close();
    }

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
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
    await Hive.close();
  });

  Widget buildTestWidget({String lessonId = 'lesson-001'}) {
    final router = GoRouter(
      initialLocation: '/lesson/$lessonId',
      routes: [
        GoRoute(
          path: '/lesson/:lessonId',
          builder: (context, state) => LessonScreen(
            lessonId: state.pathParameters['lessonId']!,
          ),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('Home')),
        ),
        GoRoute(
          path: '/feedback/:feedbackId',
          builder: (_, __) => const Scaffold(body: Text('Feedback')),
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

  group('Lesson screen', () {
    testWidgets('shows lesson title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('Morning News Report'), findsOneWidget);
    });

    testWidgets('shows transcript text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.textContaining('Good morning'), findsOneWidget);
    });

    testWidgets('shows record button with mic icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('shows TTS play button and label', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('お手本を聴く'), findsOneWidget);
    });

    testWidgets('shows speed control', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.speed), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('shows visibility toggle', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows WPM badge', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      expect(find.textContaining('WPM'), findsOneWidget);
    });

    testWidgets('back button navigates to home', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('nonexistent lesson shows error message', (tester) async {
      await tester.pumpWidget(buildTestWidget(lessonId: 'nonexistent'));
      await tester.pumpAndSettle();
      expect(find.text('レッスンが見つかりません'), findsOneWidget);
    });
  });
}
