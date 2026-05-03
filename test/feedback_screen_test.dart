import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/settings/presentation/providers/settings_provider.dart';
import 'package:doppel/main.dart';
import 'package:doppel/shared/data/seed_data.dart';

const _testFeedbackId = 'test-feedback-001';
const _testLessonId = 'lesson-001';

FeedbackModel _makeFeedback({
  String id = _testFeedbackId,
  String lessonId = _testLessonId,
  int overallScore = 78,
  int pronunciationScore = 82,
  int rhythmScore = 75,
  int intonationScore = 77,
  List<ProblemWord>? problemWords,
  String coachMessage = 'よく頑張りました！発音のリズムに注意しましょう。',
  String? userTranscript,
  String? modelTranscript,
  String? userAudioPath,
}) {
  return FeedbackModel(
    id: id,
    lessonId: lessonId,
    overallScore: overallScore,
    pronunciationScore: pronunciationScore,
    rhythmScore: rhythmScore,
    intonationScore: intonationScore,
    problemWords: problemWords ??
        const [
          ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.6),
          ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.5),
        ],
    coachMessage: coachMessage,
    createdAt: DateTime(2026, 5, 3, 10, 30),
    userTranscript: userTranscript,
    modelTranscript: modelTranscript,
    userAudioPath: userAudioPath,
  );
}

class _OnboardedSettingsNotifier extends SettingsNotifier {
  _OnboardedSettingsNotifier() : super() {
    state = const SettingsState(hasCompletedOnboarding: true);
  }
}

void main() {
  late Box<Map> lessonsBox;
  late Box<Map> feedbacksBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_feedback');

    if (Hive.isBoxOpen('lessons')) await Hive.box<Map>('lessons').close();
    if (Hive.isBoxOpen('feedbacks')) await Hive.box<Map>('feedbacks').close();
    if (Hive.isBoxOpen('progress')) await Hive.box<Map>('progress').close();

    lessonsBox = await Hive.openBox<Map>('lessons');
    feedbacksBox = await Hive.openBox<Map>('feedbacks');
    await Hive.openBox<Map>('progress');

    if (lessonsBox.isEmpty) {
      for (final lesson in seedLessons) {
        await lessonsBox.put(lesson.id, lesson.toJson());
      }
    }
  });

  tearDown(() async {
    await feedbacksBox.clear();
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

  group('Feedback screen', () {
    testWidgets('shows score, sub-scores, and coach message',
        (WidgetTester tester) async {
      final feedback = _makeFeedback();
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('発音'), findsOneWidget);
      expect(find.text('リズム'), findsOneWidget);
      expect(find.text('抑揚'), findsOneWidget);

      expect(find.text('フィードバック'), findsOneWidget);

      expect(find.text('AIコーチ'), findsOneWidget);
      expect(find.text(feedback.coachMessage), findsOneWidget);

      expect(find.text('ライブラリへ'), findsOneWidget);
      expect(find.text('もう一度'), findsOneWidget);
    });

    testWidgets('shows problem words section',
        (WidgetTester tester) async {
      final feedback = _makeFeedback(
        problemWords: const [
          ProblemWord(word: 'think', phoneme: '/θ/', errorRate: 0.7),
        ],
      );
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('改善ポイント'), findsOneWidget);
      expect(find.text('think /θ/'), findsOneWidget);
    });

    testWidgets('shows transcript comparison when transcripts available',
        (WidgetTester tester) async {
      final feedback = _makeFeedback(
        modelTranscript: 'Good morning and welcome',
        userTranscript: 'Good morning welcome',
      );
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('テキスト比較'), findsOneWidget);
      expect(find.text('お手本'), findsOneWidget);
      expect(find.text('あなたの発話'), findsOneWidget);
      expect(find.text('抜けた単語'), findsOneWidget);
      expect(find.text('余分な単語'), findsOneWidget);
    });

    testWidgets('shows simulator mode when no user transcript',
        (WidgetTester tester) async {
      final feedback = _makeFeedback(
        modelTranscript: 'Good morning',
        userTranscript: null,
      );
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(
          find.text('音声認識テキストなし（シミュレーターモード）'), findsOneWidget);
    });

    testWidgets('shows regenerate button for AI coach',
        (WidgetTester tester) async {
      final feedback = _makeFeedback();
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('AIで再生成'), findsOneWidget);
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('shows share icon in app bar',
        (WidgetTester tester) async {
      final feedback = _makeFeedback();
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('does not show audio playback when no audio path',
        (WidgetTester tester) async {
      final feedback = _makeFeedback(userAudioPath: null);
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('自分の録音を聴く'), findsNothing);
    });

    testWidgets('high score shows correct label',
        (WidgetTester tester) async {
      final feedback = _makeFeedback(overallScore: 95);
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('素晴らしい！'), findsOneWidget);
    });

    testWidgets('low score shows correct label',
        (WidgetTester tester) async {
      final feedback = _makeFeedback(overallScore: 45);
      await feedbacksBox.put(feedback.id, feedback.toJson());

      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/${feedback.id}');
      await tester.pumpAndSettle();

      expect(find.text('頑張ろう'), findsOneWidget);
    });

    testWidgets('feedback not found shows error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final navContext = tester.element(find.byType(Scaffold).first);
      GoRouter.of(navContext).go('/feedback/non-existent-id');
      await tester.pumpAndSettle();

      expect(find.text('フィードバックが見つかりません'), findsOneWidget);
    });
  });
}
