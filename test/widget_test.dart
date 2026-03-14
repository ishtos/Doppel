import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/main.dart';
import 'package:doppel/shared/data/seed_data.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive');
    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) {
      await Hive.box<Map>('feedbacks').close();
    }
    if (Hive.isBoxOpen('progress')) {
      await Hive.box<Map>('progress').close();
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
    await Hive.close();
  });

  group('Home screen', () {
    testWidgets('renders app title and greeting',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Doppel'), findsOneWidget);
      expect(find.text('ホーム'), findsOneWidget);
    });

    testWidgets('shows today lesson card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('今日のレッスン'), findsOneWidget);
      expect(find.text('Morning News Report'), findsOneWidget);
    });

    testWidgets('shows weekly stats section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('今週'), findsOneWidget);
      expect(find.text('平均'), findsOneWidget);
      expect(find.text('時間'), findsOneWidget);
    });

    testWidgets('shows recent activity section', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('最近の練習'), findsOneWidget);
    });

    testWidgets('has settings icon button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  group('Navigation', () {
    testWidgets('bottom navigation has 3 tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('ホーム'), findsOneWidget);
      expect(find.text('ライブラリ'), findsOneWidget);
      expect(find.text('進捗'), findsOneWidget);
    });

    testWidgets('navigate to library screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ライブラリ'));
      await tester.pumpAndSettle();

      expect(find.text('ライブラリ'), findsNWidgets(2)); // title + nav
      expect(find.text('Morning News Report'), findsOneWidget);
    });

    testWidgets('navigate to progress screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('進捗'));
      await tester.pumpAndSettle();

      expect(find.text('スコア推移'), findsOneWidget);
      expect(find.text('苦手パターン'), findsOneWidget);
    });
  });

  group('Library screen', () {
    testWidgets('shows category filters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ライブラリ'));
      await tester.pumpAndSettle();

      // 'すべて' appears in both category and difficulty filters
      expect(find.text('すべて'), findsNWidgets(2));
      expect(find.text('ニュース'), findsOneWidget);
      expect(find.text('ビジネス'), findsOneWidget);
    });

    testWidgets('shows difficulty filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ライブラリ'));
      await tester.pumpAndSettle();

      expect(find.text('初級'), findsOneWidget);
      expect(find.text('中級'), findsOneWidget);
      expect(find.text('上級'), findsOneWidget);
    });

    testWidgets('has search button', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('ライブラリ'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });

  group('Progress screen', () {
    testWidgets('shows stats grid', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('進捗'));
      await tester.pumpAndSettle();

      expect(find.text('累計練習'), findsOneWidget);
      expect(find.text('完了レッスン'), findsOneWidget);
      expect(find.text('最長連続'), findsOneWidget);
    });

    testWidgets('shows weekly/monthly toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('進捗'));
      await tester.pumpAndSettle();

      expect(find.text('週'), findsOneWidget);
      expect(find.text('月'), findsOneWidget);
    });

    testWidgets('shows weekly review card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: DoppelApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('進捗'));
      await tester.pumpAndSettle();

      expect(find.text('今週のレビュー'), findsOneWidget);
    });
  });
}
