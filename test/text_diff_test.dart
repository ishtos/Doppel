import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/text_diff.dart';

void main() {
  group('computeWordDiff', () {
    test('identical texts produce all match spans', () {
      final result = computeWordDiff('hello world', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      for (final span in result.modelSpans) {
        expect(span.type, DiffType.match);
      }
      for (final span in result.userSpans) {
        expect(span.type, DiffType.match);
      }
    });

    test('preserves original word casing in spans', () {
      final result = computeWordDiff('Hello World', 'hello world');

      expect(result.modelSpans[0].text, 'Hello');
      expect(result.modelSpans[1].text, 'World');
      expect(result.userSpans[0].text, 'hello');
      expect(result.userSpans[1].text, 'world');
    });

    test('case insensitive matching marks as match', () {
      final result = computeWordDiff('HELLO', 'hello');

      expect(result.modelSpans.length, 1);
      expect(result.modelSpans[0].type, DiffType.match);
      expect(result.userSpans.length, 1);
      expect(result.userSpans[0].type, DiffType.match);
    });

    test('completely different texts produce missing and extra', () {
      final result = computeWordDiff('alpha beta', 'gamma delta');

      for (final span in result.modelSpans) {
        expect(span.type, DiffType.missing);
      }
      for (final span in result.userSpans) {
        expect(span.type, DiffType.extra);
      }
    });

    test('partial overlap produces correct diff types', () {
      final result = computeWordDiff(
        'the quick brown fox',
        'the slow brown cat',
      );

      final modelTypes = result.modelSpans.map((s) => s.type).toList();
      expect(modelTypes, [
        DiffType.match,
        DiffType.missing,
        DiffType.match,
        DiffType.missing,
      ]);

      final userTypes = result.userSpans.map((s) => s.type).toList();
      expect(userTypes, [
        DiffType.match,
        DiffType.extra,
        DiffType.match,
        DiffType.extra,
      ]);
    });

    test('extra words in user transcript', () {
      final result = computeWordDiff('hello', 'hello beautiful world');

      expect(result.modelSpans.length, 1);
      expect(result.modelSpans[0].type, DiffType.match);

      expect(result.userSpans.length, 3);
      expect(result.userSpans[0].type, DiffType.match);
      expect(result.userSpans[1].type, DiffType.extra);
      expect(result.userSpans[2].type, DiffType.extra);
    });

    test('missing words from user transcript', () {
      final result = computeWordDiff('hello beautiful world', 'hello');

      expect(result.modelSpans.length, 3);
      expect(result.modelSpans[0].type, DiffType.match);
      expect(result.modelSpans[1].type, DiffType.missing);
      expect(result.modelSpans[2].type, DiffType.missing);

      expect(result.userSpans.length, 1);
      expect(result.userSpans[0].type, DiffType.match);
    });

    test('handles trailing missing word in model', () {
      final result = computeWordDiff(
        'Good morning and welcome to the news report',
        'Good morning and welcome to the news',
      );

      final missingWords = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .map((s) => s.text)
          .toList();
      expect(missingWords, ['report']);

      final extraWords = result.userSpans
          .where((s) => s.type == DiffType.extra)
          .toList();
      expect(extraWords, isEmpty);
    });

    test('handles word substitution in middle', () {
      final result = computeWordDiff(
        'I like apples very much',
        'I like oranges very much',
      );

      final modelMissing = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .map((s) => s.text)
          .toList();
      expect(modelMissing, ['apples']);

      final userExtra = result.userSpans
          .where((s) => s.type == DiffType.extra)
          .map((s) => s.text)
          .toList();
      expect(userExtra, ['oranges']);
    });

    test('single word texts - same', () {
      final result = computeWordDiff('hello', 'hello');
      expect(result.modelSpans.length, 1);
      expect(result.modelSpans[0].type, DiffType.match);
      expect(result.userSpans.length, 1);
      expect(result.userSpans[0].type, DiffType.match);
    });

    test('single word texts - different', () {
      final result = computeWordDiff('hello', 'world');
      expect(result.modelSpans.length, 1);
      expect(result.modelSpans[0].type, DiffType.missing);
      expect(result.userSpans.length, 1);
      expect(result.userSpans[0].type, DiffType.extra);
    });

    test('multiple substitutions in sequence', () {
      final result = computeWordDiff(
        'red blue green yellow',
        'red purple green orange',
      );

      final modelMatches = result.modelSpans
          .where((s) => s.type == DiffType.match)
          .map((s) => s.text.toLowerCase())
          .toList();
      expect(modelMatches, contains('red'));
      expect(modelMatches, contains('green'));

      final modelMissing = result.modelSpans
          .where((s) => s.type == DiffType.missing)
          .map((s) => s.text.toLowerCase())
          .toList();
      expect(modelMissing, contains('blue'));
      expect(modelMissing, contains('yellow'));
    });
  });

  group('buildDiffTextSpan', () {
    test('highlights spans of the specified type', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
        const DiffSpan('again', DiffType.match),
      ];

      const baseStyle = TextStyle(fontSize: 14);
      const highlightColor = Colors.red;

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: highlightColor,
        baseStyle: baseStyle,
      );

      expect(result.children!.length, 3);

      final first = result.children![0] as TextSpan;
      expect(first.text, 'hello');
      expect(first.style?.backgroundColor, isNull);

      final second = result.children![1] as TextSpan;
      expect(second.text, ' world');
      expect(second.style?.backgroundColor, highlightColor);
      expect(second.style?.fontWeight, FontWeight.w600);

      final third = result.children![2] as TextSpan;
      expect(third.text, ' again');
      expect(third.style?.backgroundColor, isNull);
    });

    test('first span has no leading space', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.match),
      ];

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(),
      );

      final first = result.children![0] as TextSpan;
      expect(first.text, 'hello');

      final second = result.children![1] as TextSpan;
      expect(second.text, ' world');
    });

    test('empty spans list produces empty children', () {
      final result = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(),
      );

      expect(result.children, isEmpty);
    });

    test('highlights extra type correctly', () {
      final spans = [
        const DiffSpan('hello', DiffType.extra),
      ];

      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.extra,
        highlightColor: Colors.green,
        baseStyle: const TextStyle(),
      );

      final child = result.children![0] as TextSpan;
      expect(child.style?.backgroundColor, Colors.green);
      expect(child.style?.fontWeight, FontWeight.w600);
    });
  });
}
