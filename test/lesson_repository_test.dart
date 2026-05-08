import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/lesson/data/models/lesson_model.dart';
import 'package:doppel/features/lesson/data/repositories/lesson_repository.dart';

void main() {
  late Box<Map> box;
  late LessonRepository repo;

  const lesson1 = LessonModel(
    id: 'test-l-1',
    title: 'Morning News Report',
    category: 'ニュース',
    difficulty: 1,
    transcriptText: 'Good morning and welcome to the news report.',
    audioAssetPath: 'assets/audio/test1.mp3',
    durationSeconds: 60,
    wordCount: 8,
  );

  const lesson2 = LessonModel(
    id: 'test-l-2',
    title: 'Business Meeting Basics',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText: 'Let us begin the quarterly review meeting.',
    audioAssetPath: 'assets/audio/test2.mp3',
    durationSeconds: 90,
    wordCount: 7,
  );

  const lesson3 = LessonModel(
    id: 'test-l-3',
    title: 'Daily Conversation Practice',
    category: '日常会話',
    difficulty: 1,
    transcriptText: 'How are you doing today? Fine thanks.',
    audioAssetPath: 'assets/audio/test3.mp3',
    durationSeconds: 30,
    wordCount: 8,
    isBookmarked: true,
  );

  const lesson4 = LessonModel(
    id: 'test-l-4',
    title: 'Advanced TED Talk',
    category: 'TEDスタイル',
    difficulty: 3,
    transcriptText:
        'The future of technology lies in artificial intelligence.',
    audioAssetPath: 'assets/audio/test4.mp3',
    durationSeconds: 120,
    wordCount: 8,
  );

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('./test_hive_lesson_repo');
    if (Hive.isBoxOpen('lesson_repo_test')) {
      await Hive.box<Map>('lesson_repo_test').close();
    }
    box = await Hive.openBox<Map>('lesson_repo_test');
    repo = LessonRepository(box);
  });

  tearDown(() async {
    await box.clear();
    await Hive.close();
  });

  group('LessonRepository', () {
    test('save and findById returns saved lesson', () async {
      await repo.save(lesson1);
      final found = repo.findById('test-l-1');
      expect(found, isNotNull);
      expect(found!.title, 'Morning News Report');
      expect(found.category, 'ニュース');
      expect(found.difficulty, 1);
      expect(found.wordCount, 8);
    });

    test('findById returns null for unknown id', () {
      expect(repo.findById('nonexistent'), isNull);
    });

    test('findAll returns all saved lessons', () async {
      await repo.saveAll([lesson1, lesson2, lesson3, lesson4]);
      final all = repo.findAll();
      expect(all.length, 4);
    });

    test('findByCategory filters correctly', () async {
      await repo.saveAll([lesson1, lesson2, lesson3, lesson4]);
      final news = repo.findByCategory('ニュース');
      expect(news.length, 1);
      expect(news.first.title, 'Morning News Report');
    });

    test('findByCategory returns empty for unknown category', () async {
      await repo.saveAll([lesson1, lesson2]);
      expect(repo.findByCategory('スポーツ'), isEmpty);
    });

    test('findByDifficulty filters by level', () async {
      await repo.saveAll([lesson1, lesson2, lesson3, lesson4]);
      final easy = repo.findByDifficulty(1);
      expect(easy.length, 2);
      expect(easy.every((l) => l.difficulty == 1), true);

      final hard = repo.findByDifficulty(3);
      expect(hard.length, 1);
      expect(hard.first.id, 'test-l-4');
    });

    test('search matches title case-insensitively', () async {
      await repo.saveAll([lesson1, lesson2, lesson3]);
      final results = repo.search('business');
      expect(results.length, 1);
      expect(results.first.id, 'test-l-2');
    });

    test('search matches transcript content', () async {
      await repo.saveAll([lesson1, lesson2, lesson3]);
      final results = repo.search('quarterly');
      expect(results.length, 1);
      expect(results.first.id, 'test-l-2');
    });

    test('search returns empty for no matches', () async {
      await repo.saveAll([lesson1, lesson2]);
      expect(repo.search('xyz nonexistent'), isEmpty);
    });

    test('toggleBookmark flips isBookmarked state', () async {
      await repo.save(lesson1);
      expect(repo.findById('test-l-1')!.isBookmarked, false);

      await repo.toggleBookmark('test-l-1');
      expect(repo.findById('test-l-1')!.isBookmarked, true);

      await repo.toggleBookmark('test-l-1');
      expect(repo.findById('test-l-1')!.isBookmarked, false);
    });

    test('delete removes lesson from storage', () async {
      await repo.save(lesson1);
      expect(repo.findById('test-l-1'), isNotNull);
      await repo.delete('test-l-1');
      expect(repo.findById('test-l-1'), isNull);
    });

    test('saveAll stores multiple lessons atomically', () async {
      await repo.saveAll([lesson1, lesson2, lesson3]);
      expect(repo.findAll().length, 3);
    });

    test('save preserves isBookmarked through serialization', () async {
      await repo.save(lesson3); // lesson3 has isBookmarked: true
      final found = repo.findById('test-l-3');
      expect(found!.isBookmarked, true);
    });

    test('save preserves lastPracticedAt through serialization', () async {
      final practiced = lesson1.copyWith(
        lastPracticedAt: DateTime(2026, 5, 8, 14, 30),
      );
      await repo.save(practiced);
      final found = repo.findById('test-l-1');
      expect(found!.lastPracticedAt, DateTime(2026, 5, 8, 14, 30));
    });
  });
}
