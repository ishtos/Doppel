import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/text_diff.dart';

void main() {
  group('computeWordDiff', () {
    test('identical texts return all matches', () {
      final result = computeWordDiff('hello world', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
      expect(result.userSpans.every((s) => s.type == DiffType.match), true);
    });

    test('case-insensitive matching', () {
      final result = computeWordDiff('Hello World', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('missing word in user text', () {
      final result = computeWordDiff('the quick brown fox', 'the brown fox');
      final missing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missing.length, 1);
      expect(missing.first.text, 'quick');
    });

    test('extra word in user text', () {
      final result = computeWordDiff('the fox', 'the brown fox');
      final extra =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extra.length, 1);
      expect(extra.first.text, 'brown');
    });

    test('completely different texts', () {
      final result = computeWordDiff('hello world', 'foo bar');
      final missingCount =
          result.modelSpans.where((s) => s.type == DiffType.missing).length;
      final extraCount =
          result.userSpans.where((s) => s.type == DiffType.extra).length;
      expect(missingCount, 2);
      expect(extraCount, 2);
    });

    test('empty model text', () {
      final result = computeWordDiff('', 'hello world');
      expect(result.modelSpans, isEmpty);
      expect(result.userSpans.length, 2);
      expect(result.userSpans.every((s) => s.type == DiffType.extra), true);
    });

    test('empty user text', () {
      final result = computeWordDiff('hello world', '');
      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.missing), true);
      expect(result.userSpans, isEmpty);
    });

    test('both empty texts', () {
      final result = computeWordDiff('', '');
      expect(result.modelSpans, isEmpty);
      expect(result.userSpans, isEmpty);
    });

    test('single word match', () {
      final result = computeWordDiff('hello', 'hello');
      expect(result.modelSpans.length, 1);
      expect(result.modelSpans.first.type, DiffType.match);
      expect(result.userSpans.length, 1);
      expect(result.userSpans.first.type, DiffType.match);
    });

    test('single word mismatch', () {
      final result = computeWordDiff('hello', 'world');
      expect(result.modelSpans.length, 1);
      expect(result.modelSpans.first.type, DiffType.missing);
      expect(result.userSpans.length, 1);
      expect(result.userSpans.first.type, DiffType.extra);
    });

    test('common prefix and suffix with different middle', () {
      final result = computeWordDiff(
        'the quick brown fox jumps over',
        'the quick red fox jumps over',
      );
      final missing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final extra =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(missing.length, 1);
      expect(missing.first.text, 'brown');
      expect(extra.length, 1);
      expect(extra.first.text, 'red');
    });

    test('only common prefix', () {
      final result = computeWordDiff(
        'the quick brown fox',
        'the quick red cat',
      );
      final matched =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      expect(matched.length, greaterThanOrEqualTo(2));
      expect(matched[0].text, 'the');
      expect(matched[1].text, 'quick');
    });

    test('only common suffix', () {
      final result = computeWordDiff(
        'brown fox jumps over',
        'red cat jumps over',
      );
      final matched =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      expect(matched.length, greaterThanOrEqualTo(2));
    });

    test('handles multiple whitespace between words', () {
      final result = computeWordDiff('hello   world', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('leading and trailing whitespace is trimmed', () {
      final result = computeWordDiff('  hello world  ', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('preserves original word casing in spans', () {
      final result = computeWordDiff('Hello', 'hello');
      expect(result.modelSpans.first.text, 'Hello');
      expect(result.userSpans.first.text, 'hello');
    });

    test('long text with single word difference', () {
      final model =
          'this is a very long sentence with many words in it to test performance';
      final user =
          'this is a very long sentence with several words in it to test performance';
      final result = computeWordDiff(model, user);
      final missing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final extra =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(missing.length, 1);
      expect(missing.first.text, 'many');
      expect(extra.length, 1);
      expect(extra.first.text, 'several');
    });

    test('user text is entirely a subset of model', () {
      final result = computeWordDiff('a b c d e', 'b d');
      final matched =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      final missing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(matched.length, 2);
      expect(missing.length, 3);
    });

    test('repeated words are handled correctly', () {
      final result = computeWordDiff('the the the', 'the the');
      final modelMatch =
          result.modelSpans.where((s) => s.type == DiffType.match).length;
      expect(modelMatch, 2);
    });
  });

  group('buildDiffTextSpan', () {
    test('creates spans with correct highlight styling', () {
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
      expect(textSpan.children!.length, 2);

      final highlighted = textSpan.children![1] as TextSpan;
      expect(highlighted.style!.backgroundColor, const Color(0xFFFF0000));
      expect(highlighted.style!.fontWeight, FontWeight.w600);
    });

    test('match spans use base style without highlight', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
      ];
      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      final child = textSpan.children![0] as TextSpan;
      expect(child.style!.backgroundColor, isNull);
    });

    test('first span has no leading space prefix', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.match),
      ];
      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(),
      );
      final first = textSpan.children![0] as TextSpan;
      final second = textSpan.children![1] as TextSpan;
      expect(first.text, 'hello');
      expect(second.text, ' world');
    });

    test('empty spans list returns empty TextSpan', () {
      final textSpan = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(),
      );
      expect(textSpan.children, isEmpty);
    });
  });

  group('DiffSpan', () {
    test('DiffType enum has three values', () {
      expect(DiffType.values.length, 3);
      expect(DiffType.values, contains(DiffType.match));
      expect(DiffType.values, contains(DiffType.missing));
      expect(DiffType.values, contains(DiffType.extra));
    });
  });
}
