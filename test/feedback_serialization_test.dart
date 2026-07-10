import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/feedback/data/models/feedback_model.dart';
import 'package:doppel/features/feedback/data/repositories/feedback_repository.dart';

// Regression test for the ProblemWord serialization bug: without
// `explicit_to_json: true` (build.yaml), FeedbackModel.toJson() left
// `problemWords` as ProblemWord objects, and saving to a Box<Map> threw a
// HiveError ("Cannot write, unknown type: ProblemWord"), surfacing to the user
// as "採点中にエラーが発生しました".
void main() {
  late Box<Map> box;

  setUp(() async {
    Hive.init('./test_hive_feedback');
    if (Hive.isBoxOpen('feedbacks_test')) {
      await Hive.box<Map>('feedbacks_test').close();
    }
    box = await Hive.openBox<Map>('feedbacks_test');
    await box.clear();
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
  });

  test('saves and reads back feedback with problem words', () async {
    final repo = FeedbackRepository(box);
    final feedback = FeedbackModel(
      id: 'fb-1',
      lessonId: 'lesson-001',
      overallScore: 75,
      pronunciationScore: 70,
      rhythmScore: 80,
      intonationScore: 75,
      problemWords: const [
        ProblemWord(word: 'through', phoneme: '/θ/', errorRate: 0.6),
        ProblemWord(word: 'world', phoneme: '/r/', errorRate: 0.5),
      ],
      coachMessage: 'Great job!',
      createdAt: DateTime(2026, 7, 10, 10, 0),
      userTranscript: 'hello world',
      modelTranscript: 'hello through world',
    );

    // Must not throw: the scoring flow saves feedback with problem words.
    await repo.save(feedback);

    final loaded = repo.findById('fb-1');
    expect(loaded, isNotNull);
    expect(loaded!.problemWords.length, 2);
    expect(loaded.problemWords.first.word, 'through');
    expect(loaded.problemWords.first.phoneme, '/θ/');
    expect(loaded.problemWords.first.errorRate, closeTo(0.6, 1e-9));
  });

  test('stored problemWords are plain maps (not raw objects)', () async {
    final repo = FeedbackRepository(box);
    await repo.save(
      FeedbackModel(
        id: 'fb-2',
        lessonId: 'lesson-001',
        overallScore: 50,
        pronunciationScore: 50,
        rhythmScore: 50,
        intonationScore: 50,
        problemWords: const [
          ProblemWord(word: 'the', phoneme: '/ð/', errorRate: 0.4),
        ],
        coachMessage: 'Keep going!',
        createdAt: DateTime(2026, 7, 10, 11, 0),
      ),
    );

    final raw = box.get('fb-2')!;
    final stored = (raw['problemWords'] as List).first;
    expect(stored, isA<Map>());
    expect((stored as Map)['word'], 'the');
  });
}
