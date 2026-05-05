import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doppel/app/theme.dart';
import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/presentation/screens/feedback_screen.dart';
import 'package:doppel/features/lesson/data/models/lesson_model.dart';
import 'package:doppel/features/lesson/presentation/screens/lesson_screen.dart';

FeedbackModel createTestFeedback({
  String id = 'test-feedback-1',
  String lessonId = 'lesson-1',
  int overallScore = 75,
  int pronunciationScore = 80,
  int rhythmScore = 70,
  int intonationScore = 75,
  String coachMessage = 'テストコーチメッセージです。発音の改善がスコアアップの鍵です。',
  String? userTranscript,
  String? modelTranscript,
  String? userAudioPath,
  List<ProblemWord>? problemWords,
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
          ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.5),
          ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.4),
        ],
    coachMessage: coachMessage,
    createdAt: DateTime(2026, 5, 5, 10, 30),
    userTranscript: userTranscript,
    modelTranscript: modelTranscript,
    userAudioPath: userAudioPath,
  );
}

LessonModel createTestLesson({
  String id = 'lesson-1',
  String title = 'Test Lesson Title',
  String category = 'ニュース',
  int difficulty = 1,
  String transcriptText =
      'The world is changing rapidly with new technologies emerging every day.',
  int durationSeconds = 120,
  int wordCount = 100,
  bool isBookmarked = false,
}) {
  return LessonModel(
    id: id,
    title: title,
    category: category,
    difficulty: difficulty,
    transcriptText: transcriptText,
    audioAssetPath: '',
    durationSeconds: durationSeconds,
    wordCount: wordCount,
    isBookmarked: isBookmarked,
  );
}

Future<void> setupTestHive(String path) async {
  Hive.init(path);
  for (final name in ['lessons', 'feedbacks', 'progress']) {
    if (Hive.isBoxOpen(name)) await Hive.box<Map>(name).close();
  }
  final lessonsBox = await Hive.openBox<Map>('lessons');
  final feedbacksBox = await Hive.openBox<Map>('feedbacks');
  final progressBox = await Hive.openBox<Map>('progress');
  await lessonsBox.clear();
  await feedbacksBox.clear();
  await progressBox.clear();
}

Future<void> seedTestFeedback(FeedbackModel feedback) async {
  final box = Hive.box<Map>('feedbacks');
  await box.put(feedback.id, feedback.toJson());
}

Future<void> seedTestLesson(LessonModel lesson) async {
  final box = Hive.box<Map>('lessons');
  await box.put(lesson.id, lesson.toJson());
}

void setupMockSharedPreferences() {
  SharedPreferences.setMockInitialValues({
    'onboarding_completed': true,
    'theme_mode': 0,
    'tts_speed': 0.5,
    'daily_goal': 3,
    'reminder_enabled': false,
  });
}

void setupMockPlatformChannels() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('flutter_tts'),
    (MethodCall call) async {
      switch (call.method) {
        case 'speak':
        case 'stop':
        case 'setLanguage':
        case 'setSpeechRate':
        case 'setPitch':
        case 'setVolume':
        case 'awaitSpeakCompletion':
          return 1;
        case 'isLanguageAvailable':
          return 1;
        case 'getLanguages':
          return <String>['en-US'];
        case 'getVoices':
          return <Map<String, String>>[];
        case 'getDefaultEngine':
          return 'com.google.android.tts';
        default:
          return null;
      }
    },
  );
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.ryanheise.just_audio.methods'),
    (call) async => {},
  );
}

void tearDownMockPlatformChannels() {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('flutter_tts'), null);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('com.ryanheise.just_audio.methods'),
    null,
  );
}

Widget buildFeedbackTestApp({required String feedbackId}) {
  final router = GoRouter(
    initialLocation: '/feedback/$feedbackId',
    routes: [
      GoRoute(
        path: '/feedback/:feedbackId',
        builder: (context, state) => FeedbackScreen(
          feedbackId: state.pathParameters['feedbackId']!,
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const Scaffold(body: Text('Home')),
      ),
      GoRoute(
        path: '/library',
        builder: (_, __) => const Scaffold(body: Text('Library')),
      ),
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (_, __) => const Scaffold(body: Text('Lesson')),
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

Widget buildLessonTestApp({required String lessonId}) {
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

Future<void> pumpFeedbackScreen(
  WidgetTester tester, {
  required String feedbackId,
}) async {
  await tester.pumpWidget(buildFeedbackTestApp(feedbackId: feedbackId));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  while (tester.takeException() != null) {}
  await tester.pump(const Duration(seconds: 1));
  while (tester.takeException() != null) {}
}

Future<void> pumpLessonScreen(
  WidgetTester tester, {
  required String lessonId,
}) async {
  await tester.pumpWidget(buildLessonTestApp(lessonId: lessonId));
  await tester.pumpAndSettle();
}
