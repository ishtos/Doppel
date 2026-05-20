import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/lesson/data/models/lesson_model.dart';
import 'package:doppel/features/lesson/data/repositories/lesson_repository.dart';
import 'package:doppel/features/lesson/presentation/screens/lesson_screen.dart';
import 'package:doppel/features/feedback/data/repositories/feedback_repository.dart';
import 'package:doppel/features/progress/data/repositories/progress_repository.dart';
import 'package:doppel/shared/providers/db_providers.dart';
import 'package:doppel/shared/services/audio_service.dart';
import 'package:doppel/shared/services/tts_service.dart';
import 'package:doppel/shared/services/speech_analysis_service.dart';
import 'package:doppel/shared/services/ai_coach_service.dart';

const _testLessonId = 'test-lesson-001';

const _testLesson = LessonModel(
  id: _testLessonId,
  title: 'Test Lesson Title',
  category: 'ニュース',
  difficulty: 2,
  transcriptText: 'This is a test transcript for the lesson screen.',
  audioAssetPath: 'assets/audio/test.mp3',
  durationSeconds: 120,
  wordCount: 10,
);

void main() {
  late Box<Map> lessonsBox;
  late Box<Map> feedbacksBox;
  late Box<Map> progressBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_lesson');

    for (final name in ['test_lessons_l', 'test_feedbacks_l', 'test_progress_l']) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box<Map>(name).close();
      }
    }

    lessonsBox = await Hive.openBox<Map>('test_lessons_l');
    feedbacksBox = await Hive.openBox<Map>('test_feedbacks_l');
    progressBox = await Hive.openBox<Map>('test_progress_l');

    await lessonsBox.clear();
    await feedbacksBox.clear();
    await progressBox.clear();

    await lessonsBox.put(_testLessonId, _testLesson.toJson());
  });

  tearDown(() async {
    await lessonsBox.clear();
    await feedbacksBox.clear();
    await progressBox.clear();
    await Hive.close();
  });

  Widget buildTestWidget({String lessonId = _testLessonId}) {
    return ProviderScope(
      overrides: [
        lessonsBoxProvider.overrideWithValue(lessonsBox),
        feedbacksBoxProvider.overrideWithValue(feedbacksBox),
        progressBoxProvider.overrideWithValue(progressBox),
        lessonRepositoryProvider.overrideWithValue(
          LessonRepository(lessonsBox),
        ),
        feedbackRepositoryProvider.overrideWithValue(
          FeedbackRepository(feedbacksBox),
        ),
        progressRepositoryProvider.overrideWithValue(
          ProgressRepository(
            progressBox: progressBox,
            feedbackBox: feedbacksBox,
          ),
        ),
        ttsServiceProvider.overrideWith(
          (ref) => _FakeTtsNotifier(),
        ),
        audioRecorderProvider.overrideWith(
          (ref) => _FakeAudioRecorderNotifier(),
        ),
        speechAnalysisServiceProvider.overrideWithValue(
          SpeechAnalysisService(AiCoachService()),
        ),
        aiCoachServiceProvider.overrideWithValue(AiCoachService()),
      ],
      child: MaterialApp(
        home: LessonScreen(lessonId: lessonId),
      ),
    );
  }

  group('LessonScreen', () {
    testWidgets('displays lesson title in AppBar', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Test Lesson Title'), findsOneWidget);
    });

    testWidgets('displays transcript text', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.text('This is a test transcript for the lesson screen.'),
        findsOneWidget,
      );
    });

    testWidgets('displays TTS play button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.text('お手本を聴く'), findsOneWidget);
    });

    testWidgets('displays WPM badge', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.textContaining('WPM'), findsOneWidget);
    });

    testWidgets('displays speed slider', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.speed), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('displays record button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('displays text hide toggle button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('toggling text visibility changes icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off), findsNothing);

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('shows not found for invalid lesson ID', (tester) async {
      await tester.pumpWidget(buildTestWidget(lessonId: 'nonexistent'));
      await tester.pumpAndSettle();

      expect(find.text('レッスンが見つかりません'), findsOneWidget);
    });

    testWidgets('does not show past scores when no feedbacks', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('前回:'), findsNothing);
      expect(find.text('詳細'), findsNothing);
    });

    testWidgets('shows back navigation button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}

class _FakeTtsNotifier extends TtsNotifier {
  _FakeTtsNotifier() : super();

  @override
  Future<void> speak(String text) async {
    state = state.copyWith(isSpeaking: true);
  }

  @override
  Future<void> stop() async {
    state = state.copyWith(isSpeaking: false);
  }

  @override
  Future<void> setSpeed(double speed) async {
    state = state.copyWith(speed: speed);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _FakeAudioRecorderNotifier extends AudioRecorderNotifier {
  _FakeAudioRecorderNotifier() : super();

  @override
  Future<bool> tryStartRecording() async {
    state = state.copyWith(isRecording: true);
    return true;
  }

  @override
  Future<String?> stopRecording() async {
    state = state.copyWith(isRecording: false);
    return null;
  }

  @override
  Future<void> cancelRecording() async {
    state = state.copyWith(isRecording: false);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
