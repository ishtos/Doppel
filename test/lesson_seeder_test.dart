import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/lesson/data/models/lesson_model.dart';
import 'package:doppel/shared/data/lesson_seeder.dart';
import 'package:doppel/shared/data/seed_data.dart';

// syncSeedLessons must deliver bundled content updates to existing installs
// (the reason old, long passages otherwise "stick" after an app update) while
// never clobbering the user's own bookmark / completion / last-practiced state.
void main() {
  late Box<Map> box;

  setUp(() async {
    Hive.init('./test_hive_lesson_seeder');
    if (Hive.isBoxOpen('lessons_test')) {
      await Hive.box<Map>('lessons_test').close();
    }
    box = await Hive.openBox<Map>('lessons_test');
    await box.clear();
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
  });

  test('first launch seeds every bundled lesson', () async {
    await syncSeedLessons(box);
    expect(box.length, seedLessons.length);
    for (final lesson in seedLessons) {
      final raw = box.get(lesson.id);
      expect(raw, isNotNull, reason: lesson.id);
      final stored = LessonModel.fromJson(Map<String, dynamic>.from(raw!));
      expect(stored.transcriptText, lesson.transcriptText, reason: lesson.id);
      expect(stored.wordCount, lesson.wordCount, reason: lesson.id);
    }
  });

  test('refreshes changed content while preserving user state', () async {
    final seed = seedLessons.first;
    final lastPracticed = DateTime(2026, 7, 1, 8, 30);
    // Simulate an existing install: same id, stale content, user state set.
    final stale = seed.copyWith(
      transcriptText: 'This is the old, much longer passage that should be '
          'replaced by the bundled content on the next launch.',
      wordCount: 999,
      durationSeconds: 999,
      isBookmarked: true,
      isCompleted: true,
      lastPracticedAt: lastPracticed,
    );
    await box.put(seed.id, stale.toJson());

    await syncSeedLessons(box);

    final stored =
        LessonModel.fromJson(Map<String, dynamic>.from(box.get(seed.id)!));
    // Content refreshed from the bundle.
    expect(stored.transcriptText, seed.transcriptText);
    expect(stored.wordCount, seed.wordCount);
    expect(stored.durationSeconds, seed.durationSeconds);
    // User state preserved.
    expect(stored.isBookmarked, isTrue);
    expect(stored.isCompleted, isTrue);
    expect(stored.lastPracticedAt, lastPracticed);
  });

  test('removes lessons no longer in the bundle (orphan cleanup)', () async {
    await box.put('retired-lesson', {
      'id': 'retired-lesson',
      'title': 'Old',
      'category': 'x',
      'difficulty': 1,
      'transcriptText': 'gone',
      'audioAssetPath': 'a',
      'durationSeconds': 1,
      'wordCount': 1,
    });

    await syncSeedLessons(box);

    expect(box.containsKey('retired-lesson'), isFalse);
    expect(box.length, seedLessons.length);
  });

  test('is idempotent and keeps a user bookmark across a second sync', () async {
    await syncSeedLessons(box);
    final id = seedLessons.first.id;

    // User bookmarks a lesson after the first seed.
    final current = LessonModel.fromJson(Map<String, dynamic>.from(box.get(id)!));
    await box.put(id, current.copyWith(isBookmarked: true).toJson());

    // A later launch runs the sync again.
    await syncSeedLessons(box);

    expect(box.length, seedLessons.length);
    final after = LessonModel.fromJson(Map<String, dynamic>.from(box.get(id)!));
    expect(after.isBookmarked, isTrue, reason: 'bookmark must survive re-sync');
    expect(after.transcriptText, seedLessons.first.transcriptText);
  });
}
