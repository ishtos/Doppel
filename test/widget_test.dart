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

  testWidgets('App renders home screen with lesson data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: DoppelApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Doppel'), findsOneWidget);
    expect(find.text('ホーム'), findsOneWidget);
    expect(find.text('今日のレッスン'), findsOneWidget);
    expect(find.text('Morning News Report'), findsOneWidget);
  });

  testWidgets('Bottom navigation has 3 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: DoppelApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('ホーム'), findsOneWidget);
    expect(find.text('ライブラリ'), findsOneWidget);
    expect(find.text('進捗'), findsOneWidget);
  });

  testWidgets('Navigate to library screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: DoppelApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('ライブラリ'));
    await tester.pumpAndSettle();

    expect(find.text('ライブラリ'), findsNWidgets(2)); // title + nav
    expect(find.text('Morning News Report'), findsOneWidget);
  });

  testWidgets('Navigate to progress screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: DoppelApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('進捗'));
    await tester.pumpAndSettle();

    expect(find.text('スコア推移'), findsOneWidget);
    expect(find.text('苦手パターン'), findsOneWidget);
  });
}
