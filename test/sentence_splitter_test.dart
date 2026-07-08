import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/sentence_splitter.dart';

void main() {
  group('splitIntoChunks', () {
    test('returns empty list for empty / whitespace input', () {
      expect(splitIntoChunks(''), isEmpty);
      expect(splitIntoChunks('   '), isEmpty);
    });

    test('returns single chunk for a single short sentence', () {
      final chunks = splitIntoChunks('Hello world.');
      expect(chunks, ['Hello world.']);
    });

    test('splits multiple sentences on terminators', () {
      final chunks = splitIntoChunks(
        'Good morning. Welcome to the news. How are you today?',
      );
      expect(chunks, [
        'Good morning.',
        'Welcome to the news.',
        'How are you today?',
      ]);
    });

    test('does not split on abbreviation periods', () {
      final chunks = splitIntoChunks('Dr. Smith met Mr. Lee at the U.S. base.');
      expect(chunks, ['Dr. Smith met Mr. Lee at the U.S. base.']);
    });

    test('does not split on decimal points', () {
      final chunks = splitIntoChunks(
        'The rate fell to 3.8 percent. That is a record.',
      );
      expect(chunks, [
        'The rate fell to 3.8 percent.',
        'That is a record.',
      ]);
    });

    test('does not split on single-capital initials', () {
      final chunks = splitIntoChunks('J. K. Rowling wrote the book. It sold well.');
      expect(chunks, ['J. K. Rowling wrote the book.', 'It sold well.']);
    });

    test('handles a sentence ending before a quote', () {
      final chunks = splitIntoChunks('He said hello. "Nice to meet you," she replied.');
      expect(chunks.length, 2);
      expect(chunks.first, 'He said hello.');
    });

    test('breaks a long sentence into breath groups', () {
      const long =
          'The world of artificial intelligence continues to grow at a rapid pace, '
          'and new breakthroughs are being made every single day, '
          'because researchers keep pushing the limits of what is possible.';
      final chunks = splitIntoChunks(long, maxWordsPerChunk: 12);
      expect(chunks.length, greaterThan(1));
      for (final c in chunks) {
        final words = c.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        // Breath groups should never be a single stray word.
        expect(words, greaterThanOrEqualTo(3));
      }
      // Reassembled content preserves all original words.
      expect(
        chunks.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim(),
        long.replaceAll(RegExp(r'\s+'), ' ').trim(),
      );
    });

    test('always returns at least one chunk for text with no terminator', () {
      final chunks = splitIntoChunks('just a fragment without punctuation');
      expect(chunks, ['just a fragment without punctuation']);
    });

    test('every chunk is non-empty and trimmed', () {
      final chunks = splitIntoChunks(
        '  First.   Second sentence here.   Third one?  ',
      );
      for (final c in chunks) {
        expect(c, isNotEmpty);
        expect(c, c.trim());
      }
    });
  });
}
