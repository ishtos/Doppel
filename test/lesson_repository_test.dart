import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/lesson/data/models/lesson_model.dart';
import 'package:doppel/features/lesson/data/repositories/lesson_repository.dart';

LessonModel _makeLesson({
  required String id,
  String title = 'Test Lesson',
  String category = 'ニュース',
  int difficulty = 1,
  bool isBookmarked = false,
  bool isCompleted = false,
}) {
  return LessonModel(
    id: id,
    title: title,
    category: category,
    difficulty: difficulty,
    transcriptText: 'This is a test transcript for $title.',
    audioAssetPath: 'assets/audio/$id.mp3',
    durationSeconds: 120,
    wordCount: 50,
    isBookmarked: isBookmarked,
    isCompleted: isCompleted,
  );
}

void main() {
  late Box<Map> box;
  late LessonRepository repo;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_lesson_repo');
    box = await Hive.openBox<Map>('test_lessons');
    repo = LessonRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
  });

  group('save and findById', () {
    test('saves and retrieves a lesson', () async {
      final lesson = _makeLesson(id: 'l-1', title: 'Morning News');
      await repo.save(lesson);

      final found = repo.findById('l-1');
      expect(found, isNotNull);
      expect(found!.id, 'l-1');
      expect(found.title, 'Morning News');
      expect(found.category, 'ニュース');
      expect(found.difficulty, 1);
    });

    test('returns null for non-existent id', () {
      expect(repo.findById('non-existent'), isNull);
    });

    test('overwrites existing lesson on save', () async {
      await repo.save(_makeLesson(id: 'l-1', title: 'Original'));
      await repo.save(_makeLesson(id: 'l-1', title: 'Updated'));

      final found = repo.findById('l-1');
      expect(found!.title, 'Updated');
    });
  });

  group('findAll', () {
    test('returns empty list when no lessons', () {
      expect(repo.findAll(), isEmpty);
    });

    test('returns all saved lessons', () async {
      await repo.save(_makeLesson(id: 'l-1'));
      await repo.save(_makeLesson(id: 'l-2'));
      await repo.save(_makeLesson(id: 'l-3'));

      expect(repo.findAll().length, 3);
    });
  });

  group('saveAll', () {
    test('saves multiple lessons at once', () async {
      final lessons = [
        _makeLesson(id: 'l-1'),
        _makeLesson(id: 'l-2'),
        _makeLesson(id: 'l-3'),
      ];
      await repo.saveAll(lessons);

      expect(repo.findAll().length, 3);
      expect(repo.findById('l-1'), isNotNull);
      expect(repo.findById('l-2'), isNotNull);
      expect(repo.findById('l-3'), isNotNull);
    });
  });

  group('findByCategory', () {
    test('filters by category', () async {
      await repo.save(_makeLesson(id: 'l-1', category: 'ニュース'));
      await repo.save(_makeLesson(id: 'l-2', category: 'ビジネス'));
      await repo.save(_makeLesson(id: 'l-3', category: 'ニュース'));

      final news = repo.findByCategory('ニュース');
      expect(news.length, 2);
      expect(news.every((l) => l.category == 'ニュース'), true);
    });

    test('returns empty list for non-existent category', () {
      expect(repo.findByCategory('スポーツ'), isEmpty);
    });
  });

  group('findByDifficulty', () {
    test('filters by difficulty level', () async {
      await repo.save(_makeLesson(id: 'l-1', difficulty: 1));
      await repo.save(_makeLesson(id: 'l-2', difficulty: 2));
      await repo.save(_makeLesson(id: 'l-3', difficulty: 1));

      final easy = repo.findByDifficulty(1);
      expect(easy.length, 2);
      expect(easy.every((l) => l.difficulty == 1), true);
    });

    test('returns empty for difficulty with no lessons', () {
      expect(repo.findByDifficulty(3), isEmpty);
    });
  });

  group('search', () {
    test('searches by title', () async {
      await repo.save(_makeLesson(id: 'l-1', title: 'Morning News Report'));
      await repo.save(_makeLesson(id: 'l-2', title: 'Business Meeting'));

      final results = repo.search('morning');
      expect(results.length, 1);
      expect(results.first.title, 'Morning News Report');
    });

    test('searches by transcript text', () async {
      await repo.save(_makeLesson(id: 'l-1', title: 'Lesson A'));
      await repo.save(_makeLesson(id: 'l-2', title: 'Lesson B'));

      final results = repo.search('transcript for Lesson A');
      expect(results.length, 1);
      expect(results.first.id, 'l-1');
    });

    test('search is case insensitive', () async {
      await repo.save(_makeLesson(id: 'l-1', title: 'Breaking News'));

      expect(repo.search('BREAKING').length, 1);
      expect(repo.search('breaking').length, 1);
    });

    test('empty query returns all lessons', () async {
      await repo.save(_makeLesson(id: 'l-1'));
      await repo.save(_makeLesson(id: 'l-2'));

      expect(repo.search('').length, 2);
    });

    test('no match returns empty list', () async {
      await repo.save(_makeLesson(id: 'l-1', title: 'Hello'));

      expect(repo.search('xyz'), isEmpty);
    });
  });

  group('delete', () {
    test('removes a lesson by id', () async {
      await repo.save(_makeLesson(id: 'l-1'));
      expect(repo.findById('l-1'), isNotNull);

      await repo.delete('l-1');
      expect(repo.findById('l-1'), isNull);
    });

    test('deleting non-existent id does not throw', () async {
      await repo.delete('non-existent');
    });
  });

  group('toggleBookmark', () {
    test('toggles bookmark from false to true', () async {
      await repo.save(_makeLesson(id: 'l-1', isBookmarked: false));

      await repo.toggleBookmark('l-1');

      final found = repo.findById('l-1');
      expect(found!.isBookmarked, true);
    });

    test('toggles bookmark from true to false', () async {
      await repo.save(_makeLesson(id: 'l-1', isBookmarked: true));

      await repo.toggleBookmark('l-1');

      final found = repo.findById('l-1');
      expect(found!.isBookmarked, false);
    });

    test('double toggle restores original state', () async {
      await repo.save(_makeLesson(id: 'l-1', isBookmarked: false));

      await repo.toggleBookmark('l-1');
      await repo.toggleBookmark('l-1');

      final found = repo.findById('l-1');
      expect(found!.isBookmarked, false);
    });

    test('toggling non-existent id does not throw', () async {
      await repo.toggleBookmark('non-existent');
    });
  });

  group('model serialization', () {
    test('preserves all fields through save/load cycle', () async {
      final lesson = LessonModel(
        id: 'l-full',
        title: 'Full Test',
        category: '日常会話',
        difficulty: 3,
        transcriptText: 'Hello world test transcript.',
        audioAssetPath: 'assets/audio/test.mp3',
        durationSeconds: 180,
        wordCount: 100,
        isBookmarked: true,
        isCompleted: true,
        lastPracticedAt: DateTime(2026, 5, 25, 14, 30),
      );
      await repo.save(lesson);

      final found = repo.findById('l-full');
      expect(found!.id, 'l-full');
      expect(found.title, 'Full Test');
      expect(found.category, '日常会話');
      expect(found.difficulty, 3);
      expect(found.transcriptText, 'Hello world test transcript.');
      expect(found.audioAssetPath, 'assets/audio/test.mp3');
      expect(found.durationSeconds, 180);
      expect(found.wordCount, 100);
      expect(found.isBookmarked, true);
      expect(found.isCompleted, true);
      expect(found.lastPracticedAt, DateTime(2026, 5, 25, 14, 30));
    });

    test('default values for optional fields', () async {
      final lesson = _makeLesson(id: 'l-defaults');
      await repo.save(lesson);

      final found = repo.findById('l-defaults');
      expect(found!.isBookmarked, false);
      expect(found.isCompleted, false);
      expect(found.lastPracticedAt, isNull);
    });
  });
}
