import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/data/repositories/feedback_repository.dart';

FeedbackModel _makeFeedback({
  required String id,
  String lessonId = 'lesson-001',
  int overallScore = 75,
  int pronunciationScore = 70,
  int rhythmScore = 80,
  int intonationScore = 75,
  DateTime? createdAt,
  List<ProblemWord>? problemWords,
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
    problemWords: problemWords ?? const [],
    coachMessage: 'Great job!',
    createdAt: createdAt ?? DateTime(2026, 5, 25, 10, 0),
    userTranscript: userTranscript,
    modelTranscript: modelTranscript,
    userAudioPath: userAudioPath,
  );
}

void main() {
  late Box<Map> box;
  late FeedbackRepository repo;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_feedback_repo');
    box = await Hive.openBox<Map>('test_feedbacks');
    repo = FeedbackRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
  });

  group('save and findById', () {
    test('saves and retrieves a feedback', () async {
      final feedback = _makeFeedback(id: 'fb-1');
      await repo.save(feedback);

      final found = repo.findById('fb-1');
      expect(found, isNotNull);
      expect(found!.id, 'fb-1');
      expect(found.lessonId, 'lesson-001');
      expect(found.overallScore, 75);
    });

    test('returns null for non-existent id', () {
      expect(repo.findById('non-existent'), isNull);
    });

    test('overwrites existing feedback on save', () async {
      final fb1 = _makeFeedback(id: 'fb-1', overallScore: 60);
      await repo.save(fb1);

      final fb1Updated = _makeFeedback(id: 'fb-1', overallScore: 90);
      await repo.save(fb1Updated);

      final found = repo.findById('fb-1');
      expect(found!.overallScore, 90);
    });
  });

  group('findAll', () {
    test('returns empty list when no feedbacks', () {
      expect(repo.findAll(), isEmpty);
    });

    test('returns all feedbacks sorted by createdAt descending', () async {
      await repo.save(_makeFeedback(
        id: 'fb-1',
        createdAt: DateTime(2026, 5, 23),
      ));
      await repo.save(_makeFeedback(
        id: 'fb-2',
        createdAt: DateTime(2026, 5, 25),
      ));
      await repo.save(_makeFeedback(
        id: 'fb-3',
        createdAt: DateTime(2026, 5, 24),
      ));

      final all = repo.findAll();
      expect(all.length, 3);
      expect(all[0].id, 'fb-2');
      expect(all[1].id, 'fb-3');
      expect(all[2].id, 'fb-1');
    });
  });

  group('findByLessonId', () {
    test('returns feedbacks for a specific lesson', () async {
      await repo.save(_makeFeedback(id: 'fb-1', lessonId: 'lesson-001'));
      await repo.save(_makeFeedback(id: 'fb-2', lessonId: 'lesson-002'));
      await repo.save(_makeFeedback(id: 'fb-3', lessonId: 'lesson-001'));

      final results = repo.findByLessonId('lesson-001');
      expect(results.length, 2);
      expect(results.every((f) => f.lessonId == 'lesson-001'), true);
    });

    test('returns empty list for lesson with no feedbacks', () {
      expect(repo.findByLessonId('lesson-999'), isEmpty);
    });
  });

  group('findLatestByLessonId', () {
    test('returns most recent feedback for a lesson', () async {
      await repo.save(_makeFeedback(
        id: 'fb-1',
        lessonId: 'lesson-001',
        createdAt: DateTime(2026, 5, 23),
      ));
      await repo.save(_makeFeedback(
        id: 'fb-2',
        lessonId: 'lesson-001',
        createdAt: DateTime(2026, 5, 25),
      ));

      final latest = repo.findLatestByLessonId('lesson-001');
      expect(latest, isNotNull);
      expect(latest!.id, 'fb-2');
    });

    test('returns null for lesson with no feedbacks', () {
      expect(repo.findLatestByLessonId('lesson-999'), isNull);
    });
  });

  group('findRecent', () {
    test('returns feedbacks limited by count', () async {
      for (var i = 0; i < 5; i++) {
        await repo.save(_makeFeedback(
          id: 'fb-$i',
          createdAt: DateTime(2026, 5, 20 + i),
        ));
      }

      final recent = repo.findRecent(limit: 3);
      expect(recent.length, 3);
      expect(recent[0].id, 'fb-4');
      expect(recent[1].id, 'fb-3');
      expect(recent[2].id, 'fb-2');
    });

    test('returns all feedbacks if fewer than limit', () async {
      await repo.save(_makeFeedback(id: 'fb-1'));

      final recent = repo.findRecent(limit: 10);
      expect(recent.length, 1);
    });
  });

  group('delete', () {
    test('removes a feedback by id', () async {
      await repo.save(_makeFeedback(id: 'fb-1'));
      expect(repo.findById('fb-1'), isNotNull);

      await repo.delete('fb-1');
      expect(repo.findById('fb-1'), isNull);
    });

    test('deleting non-existent id does not throw', () async {
      await repo.delete('non-existent');
    });
  });

  group('feedback with problem words', () {
    test('saves and retrieves problem words correctly', () async {
      final feedback = _makeFeedback(
        id: 'fb-pw',
        problemWords: const [
          ProblemWord(word: 'through', phoneme: '/θruː/', errorRate: 0.8),
          ProblemWord(word: 'world', phoneme: '/wɜːrld/', errorRate: 0.6),
        ],
      );
      await repo.save(feedback);

      final found = repo.findById('fb-pw');
      expect(found!.problemWords.length, 2);
      expect(found.problemWords[0].word, 'through');
      expect(found.problemWords[0].phoneme, '/θruː/');
      expect(found.problemWords[0].errorRate, 0.8);
      expect(found.problemWords[1].word, 'world');
    });
  });

  group('feedback with transcripts', () {
    test('saves and retrieves transcript fields', () async {
      final feedback = _makeFeedback(
        id: 'fb-tr',
        modelTranscript: 'Hello world',
        userTranscript: 'Hello word',
        userAudioPath: '/tmp/audio.m4a',
      );
      await repo.save(feedback);

      final found = repo.findById('fb-tr');
      expect(found!.modelTranscript, 'Hello world');
      expect(found.userTranscript, 'Hello word');
      expect(found.userAudioPath, '/tmp/audio.m4a');
    });

    test('nullable fields default to null', () async {
      final feedback = _makeFeedback(id: 'fb-null');
      await repo.save(feedback);

      final found = repo.findById('fb-null');
      expect(found!.modelTranscript, isNull);
      expect(found.userTranscript, isNull);
      expect(found.userAudioPath, isNull);
    });
  });
}
