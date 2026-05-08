import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/data/repositories/feedback_repository.dart';

void main() {
  late Box<Map> box;
  late FeedbackRepository repo;

  final fb1 = FeedbackModel(
    id: 'fb-1',
    lessonId: 'lesson-001',
    overallScore: 85,
    pronunciationScore: 88,
    rhythmScore: 82,
    intonationScore: 84,
    problemWords: [
      const ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.5),
      const ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.6),
    ],
    coachMessage: 'Great job!',
    createdAt: DateTime(2026, 5, 8, 10, 0),
    userTranscript: 'hello world',
    modelTranscript: 'hello beautiful world',
  );

  final fb2 = FeedbackModel(
    id: 'fb-2',
    lessonId: 'lesson-001',
    overallScore: 72,
    pronunciationScore: 70,
    rhythmScore: 75,
    intonationScore: 71,
    problemWords: [],
    coachMessage: 'Keep practicing!',
    createdAt: DateTime(2026, 5, 7, 15, 0),
  );

  final fb3 = FeedbackModel(
    id: 'fb-3',
    lessonId: 'lesson-002',
    overallScore: 91,
    pronunciationScore: 93,
    rhythmScore: 89,
    intonationScore: 90,
    problemWords: [],
    coachMessage: 'Excellent!',
    createdAt: DateTime(2026, 5, 6, 9, 0),
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_fb_repo');
    if (Hive.isBoxOpen('fb_repo_test')) {
      await Hive.box<Map>('fb_repo_test').close();
    }
    box = await Hive.openBox<Map>('fb_repo_test');
    repo = FeedbackRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
  });

  group('FeedbackRepository', () {
    test('save and findById returns the saved feedback', () async {
      await repo.save(fb1);
      final found = repo.findById('fb-1');
      expect(found, isNotNull);
      expect(found!.id, 'fb-1');
      expect(found.overallScore, 85);
      expect(found.lessonId, 'lesson-001');
      expect(found.userTranscript, 'hello world');
      expect(found.modelTranscript, 'hello beautiful world');
    });

    test('findById returns null for unknown id', () {
      expect(repo.findById('nonexistent'), isNull);
    });

    test('findAll returns all feedbacks sorted by createdAt desc', () async {
      await repo.save(fb1);
      await repo.save(fb2);
      await repo.save(fb3);
      final all = repo.findAll();
      expect(all.length, 3);
      expect(all[0].id, 'fb-1'); // 2026-05-08 newest
      expect(all[1].id, 'fb-2'); // 2026-05-07
      expect(all[2].id, 'fb-3'); // 2026-05-06 oldest
    });

    test('findByLessonId filters by lessonId', () async {
      await repo.save(fb1);
      await repo.save(fb2);
      await repo.save(fb3);
      final results = repo.findByLessonId('lesson-001');
      expect(results.length, 2);
      expect(results.every((f) => f.lessonId == 'lesson-001'), true);
    });

    test('findByLessonId returns empty for unknown lesson', () async {
      await repo.save(fb1);
      expect(repo.findByLessonId('nonexistent'), isEmpty);
    });

    test('findLatestByLessonId returns most recent feedback', () async {
      await repo.save(fb1);
      await repo.save(fb2);
      final latest = repo.findLatestByLessonId('lesson-001');
      expect(latest, isNotNull);
      expect(latest!.id, 'fb-1');
    });

    test('findLatestByLessonId returns null when no feedbacks', () {
      expect(repo.findLatestByLessonId('nonexistent'), isNull);
    });

    test('findRecent respects limit parameter', () async {
      await repo.save(fb1);
      await repo.save(fb2);
      await repo.save(fb3);
      final recent = repo.findRecent(limit: 2);
      expect(recent.length, 2);
      expect(recent[0].id, 'fb-1');
      expect(recent[1].id, 'fb-2');
    });

    test('delete removes feedback from storage', () async {
      await repo.save(fb1);
      expect(repo.findById('fb-1'), isNotNull);
      await repo.delete('fb-1');
      expect(repo.findById('fb-1'), isNull);
    });

    test('save overwrites existing feedback with same id', () async {
      await repo.save(fb1);
      final updated = fb1.copyWith(overallScore: 99);
      await repo.save(updated);
      final found = repo.findById('fb-1');
      expect(found!.overallScore, 99);
      expect(repo.findAll().length, 1);
    });

    test('problemWords are preserved through serialization', () async {
      await repo.save(fb1);
      final found = repo.findById('fb-1');
      expect(found!.problemWords.length, 2);
      expect(found.problemWords[0].word, 'through');
      expect(found.problemWords[0].phoneme, '/θ/');
      expect(found.problemWords[0].errorRate, 0.5);
      expect(found.problemWords[1].word, 'world');
    });

    test('nullable fields are preserved through serialization', () async {
      await repo.save(fb2); // fb2 has no userTranscript, modelTranscript, userAudioPath
      final found = repo.findById('fb-2');
      expect(found!.userTranscript, isNull);
      expect(found.modelTranscript, isNull);
      expect(found.userAudioPath, isNull);
    });
  });
}
