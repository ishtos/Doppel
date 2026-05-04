import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/text_diff.dart';

void main() {
  group('computeWordDiff', () {
    test('identical texts → all match', () {
      final result = computeWordDiff('hello world', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(
        result.modelSpans.every((s) => s.type == DiffType.match),
        isTrue,
      );
      expect(
        result.userSpans.every((s) => s.type == DiffType.match),
        isTrue,
      );
    });

    test('completely different texts → all missing/extra', () {
      final result = computeWordDiff('hello world', 'foo bar');
      expect(
        result.modelSpans.every((s) => s.type == DiffType.missing),
        isTrue,
      );
      expect(
        result.userSpans.every((s) => s.type == DiffType.extra),
        isTrue,
      );
    });

    test('partial match returns correct spans', () {
      final result = computeWordDiff(
        'the quick brown fox',
        'the slow brown cat',
      );
      final matched = result.modelSpans
          .where((s) => s.type == DiffType.match)
          .map((s) => s.text)
          .toList();
      expect(matched, ['the', 'brown']);

      final missing = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .map((s) => s.text)
          .toList();
      expect(missing, ['quick', 'fox']);
    });

    test('case-insensitive matching', () {
      final result = computeWordDiff('Hello World', 'hello world');
      expect(
        result.modelSpans.every((s) => s.type == DiffType.match),
        isTrue,
      );
    });

    test('extra words in user transcript', () {
      final result = computeWordDiff('hello world', 'hello beautiful world');
      final extras = result.userSpans
          .where((s) => s.type == DiffType.extra)
          .toList();
      expect(extras.length, 1);
      expect(extras.first.text, 'beautiful');
    });

    test('missing words from user transcript', () {
      final result = computeWordDiff('hello beautiful world', 'hello world');
      final missing = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .toList();
      expect(missing.length, 1);
      expect(missing.first.text, 'beautiful');
    });

    test('single word match', () {
      final result = computeWordDiff('hello', 'hello');
      expect(result.modelSpans.length, 1);
      expect(result.modelSpans.first.type, DiffType.match);
      expect(result.userSpans.length, 1);
      expect(result.userSpans.first.type, DiffType.match);
    });

    test('user adds words at end', () {
      final result = computeWordDiff('one two', 'one two three');
      final extras = result.userSpans
          .where((s) => s.type == DiffType.extra)
          .toList();
      expect(extras.length, 1);
      expect(extras.first.text, 'three');
    });

    test('longer sentence diff', () {
      final result = computeWordDiff(
        'Good morning and welcome to the news',
        'Good morning and welcome the news report',
      );
      final missing = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .map((s) => s.text)
          .toList();
      expect(missing, contains('to'));

      final extras = result.userSpans
          .where((s) => s.type == DiffType.extra)
          .map((s) => s.text)
          .toList();
      expect(extras, contains('report'));
    });
  });

  group('buildDiffTextSpan', () {
    test('correct children count', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
      ];
      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      expect(textSpan.children?.length, 2);
    });

    test('highlighted span has bold weight and background', () {
      final spans = [const DiffSpan('word', DiffType.missing)];
      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      final child = textSpan.children!.first as TextSpan;
      expect(child.style?.fontWeight, FontWeight.w600);
      expect(child.style?.backgroundColor, const Color(0xFFFF0000));
    });

    test('non-highlighted span keeps base style', () {
      final spans = [const DiffSpan('word', DiffType.match)];
      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      final child = textSpan.children!.first as TextSpan;
      expect(child.style?.fontWeight, isNull);
      expect(child.style?.backgroundColor, isNull);
    });

    test('empty spans returns empty children', () {
      final textSpan = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      expect(textSpan.children, isEmpty);
    });

    test('subsequent spans have space prefix', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.match),
      ];
      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      final first = textSpan.children![0] as TextSpan;
      final second = textSpan.children![1] as TextSpan;
      expect(first.text, 'hello');
      expect(second.text, ' world');
    });
  });
}
