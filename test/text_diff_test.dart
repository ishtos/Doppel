import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/text_diff.dart';

void main() {
  group('computeWordDiff', () {
    test('identical texts produce all match spans', () {
      final result = computeWordDiff('hello world', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
      expect(result.userSpans.every((s) => s.type == DiffType.match), true);
    });

    test('completely different texts', () {
      final result = computeWordDiff('hello world', 'foo bar');

      expect(
        result.modelSpans.every((s) => s.type == DiffType.missing),
        true,
      );
      expect(
        result.userSpans.every((s) => s.type == DiffType.extra),
        true,
      );
    });

    test('partial match marks missing and extra correctly', () {
      final result = computeWordDiff('the cat sat', 'the dog sat');

      final matchModel =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      final missingModel =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final extraUser =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();

      expect(matchModel.length, 2);
      expect(matchModel.map((s) => s.text), containsAll(['the', 'sat']));
      expect(missingModel.length, 1);
      expect(missingModel.first.text, 'cat');
      expect(extraUser.length, 1);
      expect(extraUser.first.text, 'dog');
    });

    test('case insensitive matching', () {
      final result = computeWordDiff('Hello World', 'hello world');

      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
      expect(result.userSpans.every((s) => s.type == DiffType.match), true);
    });

    test('user has extra words at end', () {
      final result = computeWordDiff('hello', 'hello world');

      expect(result.modelSpans.length, 1);
      expect(result.modelSpans.first.type, DiffType.match);
      expect(result.modelSpans.first.text, 'hello');

      final matchUser =
          result.userSpans.where((s) => s.type == DiffType.match).toList();
      final extraUser =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(matchUser.length, 1);
      expect(extraUser.length, 1);
      expect(extraUser.first.text, 'world');
    });

    test('user missing words', () {
      final result = computeWordDiff('hello world foo', 'hello foo');

      final matchModel =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      final missingModel =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();

      expect(matchModel.length, 2);
      expect(missingModel.length, 1);
      expect(missingModel.first.text, 'world');
    });

    test('longer sentence diff', () {
      const model = 'The quick brown fox jumps over the lazy dog';
      const user = 'The quick red fox runs over a lazy dog';

      final result = computeWordDiff(model, user);

      final matchWords = result.modelSpans
          .where((s) => s.type == DiffType.match)
          .map((s) => s.text.toLowerCase())
          .toList();
      expect(matchWords, containsAll(['the', 'quick', 'fox', 'over', 'lazy', 'dog']));

      final missingWords = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .map((s) => s.text.toLowerCase())
          .toList();
      expect(missingWords, containsAll(['brown', 'jumps', 'the']));

      final extraWords = result.userSpans
          .where((s) => s.type == DiffType.extra)
          .map((s) => s.text.toLowerCase())
          .toList();
      expect(extraWords, containsAll(['red', 'runs', 'a']));
    });

    test('multiple whitespace is normalized', () {
      final result = computeWordDiff('hello   world', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('leading and trailing whitespace is trimmed', () {
      final result = computeWordDiff('  hello world  ', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('single word match', () {
      final result = computeWordDiff('hello', 'hello');

      expect(result.modelSpans.length, 1);
      expect(result.modelSpans.first.type, DiffType.match);
      expect(result.userSpans.length, 1);
      expect(result.userSpans.first.type, DiffType.match);
    });

    test('user empty produces all missing from model', () {
      final result = computeWordDiff('hello world', '');

      final missingModel =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missingModel.length, 2);
    });

    test('model empty produces all extra from user', () {
      final result = computeWordDiff('', 'hello world');

      final extraUser =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extraUser.length, 2);
    });

    test('preserves original word casing in spans', () {
      final result = computeWordDiff('Hello', 'hello');

      expect(result.modelSpans.first.text, 'Hello');
      expect(result.userSpans.first.text, 'hello');
    });

    test('repeated words handled correctly', () {
      final result = computeWordDiff('the the the', 'the the');

      final matchModel =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      expect(matchModel.length, 2);

      final missingModel =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missingModel.length, 1);
    });
  });

  group('buildDiffTextSpan', () {
    const baseStyle = TextStyle(fontSize: 14, color: Colors.black);

    test('returns TextSpan with correct number of children', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
        const DiffSpan('foo', DiffType.match),
      ];

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: baseStyle,
      );

      expect(result.children, isNotNull);
      expect(result.children!.length, 3);
    });

    test('highlighted spans get background color and bold weight', () {
      final spans = [
        const DiffSpan('missing', DiffType.missing),
      ];

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: baseStyle,
      );

      final child = result.children!.first as TextSpan;
      expect(child.style!.backgroundColor, Colors.red);
      expect(child.style!.fontWeight, FontWeight.w600);
    });

    test('non-highlighted spans use base style', () {
      final spans = [
        const DiffSpan('normal', DiffType.match),
      ];

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: baseStyle,
      );

      final child = result.children!.first as TextSpan;
      expect(child.style, baseStyle);
    });

    test('first span has no leading space, subsequent spans have space prefix', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.match),
      ];

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: baseStyle,
      );

      final first = result.children![0] as TextSpan;
      final second = result.children![1] as TextSpan;
      expect(first.text, 'hello');
      expect(second.text, ' world');
    });

    test('empty spans list returns empty TextSpan', () {
      final result = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: baseStyle,
      );

      expect(result.children, isNotNull);
      expect(result.children!.isEmpty, true);
    });
  });

  group('DiffSpan', () {
    test('stores text and type', () {
      const span = DiffSpan('hello', DiffType.match);
      expect(span.text, 'hello');
      expect(span.type, DiffType.match);
    });
  });

  group('DiffType', () {
    test('has three values', () {
      expect(DiffType.values.length, 3);
      expect(DiffType.values, contains(DiffType.match));
      expect(DiffType.values, contains(DiffType.missing));
      expect(DiffType.values, contains(DiffType.extra));
    });
  });
}
