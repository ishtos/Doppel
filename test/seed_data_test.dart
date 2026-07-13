import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/lesson/data/models/lesson_model.dart';
import 'package:doppel/shared/data/seed_data.dart';

void main() {
  group('seedLessons', () {
    test('contains 100 lessons', () {
      expect(seedLessons.length, 100);
    });

    test('ids are unique and non-empty', () {
      final ids = seedLessons.map((l) => l.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'duplicate lesson ids');
      expect(ids.every((id) => id.trim().isNotEmpty), isTrue);
    });

    test('every lesson has valid required fields', () {
      for (final l in seedLessons) {
        expect(l.title.trim(), isNotEmpty, reason: l.id);
        expect(l.category.trim(), isNotEmpty, reason: l.id);
        expect(l.difficulty, inInclusiveRange(1, 3), reason: l.id);
        expect(l.transcriptText.trim(), isNotEmpty, reason: l.id);
        expect(l.wordCount, greaterThan(0), reason: l.id);
        expect(l.durationSeconds, greaterThan(0), reason: l.id);
      }
    });

    test('covers a diverse set of categories', () {
      final categories = seedLessons.map((l) => l.category).toSet();
      expect(categories.length, greaterThanOrEqualTo(10),
          reason: 'expected diverse themes');
    });

    test('wordCount matches the transcript token count', () {
      // Same tokenization the scoring path uses (text_diff.dart): split on
      // whitespace runs. Keeps the badge/WPM/read-along pacing honest.
      for (final l in seedLessons) {
        final actual =
            l.transcriptText.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        expect(l.wordCount, actual,
            reason: '${l.id}: wordCount ${l.wordCount} != actual $actual');
      }
    });

    test('lesson length stays within the per-difficulty cap', () {
      // Shadowing works best on short, repeatable passages. Caps keep each
      // lesson practicable in one or two takes and bound AI cost per session.
      const cap = {1: 80, 2: 130, 3: 200};
      for (final l in seedLessons) {
        expect(l.wordCount, lessThanOrEqualTo(cap[l.difficulty]!),
            reason: '${l.id} (diff ${l.difficulty}) is ${l.wordCount} words');
        expect(l.wordCount, greaterThanOrEqualTo(40),
            reason: '${l.id} looks truncated (${l.wordCount} words)');
      }
    });

    test('every lesson JSON round-trips (Hive storage contract)', () {
      for (final l in seedLessons) {
        final restored = LessonModel.fromJson(l.toJson());
        expect(restored.id, l.id);
        expect(restored.category, l.category);
        expect(restored.wordCount, l.wordCount);
      }
    });
  });
}
