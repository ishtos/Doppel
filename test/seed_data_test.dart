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
