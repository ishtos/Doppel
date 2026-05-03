import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/settings/presentation/providers/settings_provider.dart';
import 'package:doppel/main.dart';
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

  Widget buildApp() {
    return ProviderScope(
      overrides: [
        settingsProvider.overrideWith(
          (ref) => _OnboardedSettingsNotifier(),
        ),
      ],
      child: const DoppelApp(),
    );
  }

  group('Lesson screen', () {
    testWidgets('shows lesson title and transcript text',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.text('Morning News Report'), findsOneWidget);
      expect(find.textContaining('Good morning and welcome'), findsOneWidget);
    });

    testWidgets('shows TTS play button and label',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('お手本を聴く'), findsOneWidget);
    });

    testWidgets('shows speed slider', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.byType(Slider), findsOneWidget);
      expect(find.byIcon(Icons.speed), findsOneWidget);
    });

    testWidgets('shows WPM badge', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.textContaining('WPM'), findsOneWidget);
    });

    testWidgets('shows record button with mic icon',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('shows visibility toggle button',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('shows back button', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('shows lesson not found for invalid ID',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/non-existent-lesson');
      await tester.pumpAndSettle();

      expect(find.text('レッスンが見つかりません'), findsOneWidget);
    });

    testWidgets('speed label shows correct initial value',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/lesson/lesson-001');
      await tester.pumpAndSettle();

      // Default speed is 0.5, which maps to 1.0x
      expect(find.text('1.0x'), findsOneWidget);
    });
  });
}

class _OnboardedSettingsNotifier extends SettingsNotifier {
  _OnboardedSettingsNotifier() : super() {
    state = const SettingsState(hasCompletedOnboarding: true);
  }
}
