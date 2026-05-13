import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/presentation/screens/feedback_screen.dart';
import 'package:doppel/shared/data/seed_data.dart';

import 'helpers/platform_mocks.dart';

// FIXED: テストデータのスコアを全て異なる値に設定し、アサーション時の曖昧さを排除
final _testFeedback = FeedbackModel(
  id: 'test-fb-1',
  lessonId: 'lesson-001',
  overallScore: 74,
  pronunciationScore: 82,
  rhythmScore: 68,
  intonationScore: 71,
  problemWords: const [
    ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.6),
    ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.5),
  ],
  coachMessage: '良い調子です！発音の改善がスコアアップの鍵です。',
  createdAt: DateTime(2026, 5, 13),
  userTranscript: 'Good morning and welcome to the news',
  modelTranscript: 'Good morning and welcome to the morning news report',
);

final _testFeedbackNoTranscript = FeedbackModel(
  id: 'test-fb-2',
  lessonId: 'lesson-001',
  overallScore: 65,
  pronunciationScore: 70,
  rhythmScore: 60,
  intonationScore: 65,
  problemWords: const [],
  coachMessage: '練習を続けましょう！',
  createdAt: DateTime(2026, 5, 12),
);

void main() {
  late Box<Map> feedbacksBox;
  late Box<Map> lessonsBox;
  late Box<Map> progressBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupMockPlatformChannels();

    Hive.init('./test_hive_feedback_screen');

    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) await Hive.box<Map>('feedbacks').close();
    if (Hive.isBoxOpen('progress')) await Hive.box<Map>('progress').close();

    lessonsBox = await Hive.openBox<Map>('lessons');
    feedbacksBox = await Hive.openBox<Map>('feedbacks');
    progressBox = await Hive.openBox<Map>('progress');

    for (final lesson in seedLessons) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }

    await feedbacksBox.put(_testFeedback.id, _testFeedback.toJson());
    await feedbacksBox.put(
      _testFeedbackNoTranscript.id,
      _testFeedbackNoTranscript.toJson(),
    );
  });

  tearDown(() async {
    await feedbacksBox.clear();
    await lessonsBox.clear();
    await progressBox.clear();
    await Hive.close();
    tearDownMockPlatformChannels();
  });

  Widget buildScreen(String feedbackId) {
    return ProviderScope(
      child: MaterialApp(
        home: FeedbackScreen(feedbackId: feedbackId),
      ),
    );
  }

  group('FeedbackScreen', () {
    testWidgets('shows not-found message for invalid feedback ID',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('nonexistent-id'));
      await tester.pumpAndSettle();

      expect(find.text('フィードバックが見つかりません'), findsOneWidget);
    });

    testWidgets('renders app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('フィードバック'), findsOneWidget);
    });

    testWidgets('renders back and share buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('renders sub-score labels', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('発音'), findsOneWidget);
      expect(find.text('リズム'), findsOneWidget);
      expect(find.text('抑揚'), findsOneWidget);
    });

    testWidgets('renders distinct sub-score values',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('82'), findsOneWidget);
      expect(find.text('68'), findsOneWidget);
      expect(find.text('71'), findsOneWidget);
    });

    testWidgets('renders score label for overall score',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      // overallScore 74 -> ScoreUtils.scoreLabel(74) = '良い'
      expect(find.text('良い'), findsOneWidget);
    });

    testWidgets('renders transcript comparison section',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('お手本'), findsOneWidget);
      expect(find.text('あなたの発話'), findsOneWidget);
    });

    testWidgets('renders diff legend when both transcripts present',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('抜けた単語'), findsOneWidget);
      expect(find.text('余分な単語'), findsOneWidget);
    });

    testWidgets('renders problem words section', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.text('through /θ/'), findsOneWidget);
      expect(find.text('world /r/'), findsOneWidget);
    });

    testWidgets('renders AI coach card with message',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('AIコーチ'), findsOneWidget);
      expect(find.text('良い調子です！発音の改善がスコアアップの鍵です。'), findsOneWidget);
      expect(find.byIcon(Icons.psychology), findsOneWidget);
    });

    testWidgets('renders AI regenerate button', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('AIで再生成'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('renders action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-1'));
      await tester.pumpAndSettle();

      expect(find.text('ライブラリへ'), findsOneWidget);
      expect(find.text('もう一度'), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
      expect(find.byIcon(Icons.replay), findsOneWidget);
    });

    // FIXED: トランスクリプト無しのケースもテスト
    testWidgets('shows simulator mode text when no transcripts',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-2'));
      await tester.pumpAndSettle();

      expect(
        find.text('音声認識テキストなし（シミュレーターモード）'),
        findsOneWidget,
      );
    });

    testWidgets('hides problem words section when empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildScreen('test-fb-2'));
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsNothing);
    });
  });
}
