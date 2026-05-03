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

    test('missing words are marked as DiffType.missing in model spans', () {
      final result = computeWordDiff('the quick brown fox', 'the brown fox');

      final missingSpans =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missingSpans.length, 1);
      expect(missingSpans.first.text.toLowerCase(), 'quick');
    });

    test('extra words are marked as DiffType.extra in user spans', () {
      final result = computeWordDiff('the brown fox', 'the quick brown fox');

      final extraSpans =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extraSpans.length, 1);
      expect(extraSpans.first.text.toLowerCase(), 'quick');
    });

    test('case-insensitive comparison', () {
      final result = computeWordDiff('Hello World', 'hello world');

      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
      expect(result.userSpans.every((s) => s.type == DiffType.match), true);
    });

    test('completely different texts', () {
      final result = computeWordDiff('alpha beta', 'gamma delta');

      final modelMissing =
          result.modelSpans.where((s) => s.type == DiffType.missing).length;
      final userExtra =
          result.userSpans.where((s) => s.type == DiffType.extra).length;
      expect(modelMissing, 2);
      expect(userExtra, 2);
    });

    test('empty model text', () {
      final result = computeWordDiff('', 'hello world');

      expect(result.modelSpans, isEmpty);
      final userExtra =
          result.userSpans.where((s) => s.type == DiffType.extra).length;
      expect(userExtra, 2);
    });

    test('empty user text', () {
      final result = computeWordDiff('hello world', '');

      expect(result.userSpans, isEmpty);
      final modelMissing =
          result.modelSpans.where((s) => s.type == DiffType.missing).length;
      expect(modelMissing, 2);
    });
  });

  group('buildDiffTextSpan', () {
    test('highlights spans matching the specified DiffType', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
      ];

      const baseStyle = TextStyle(fontSize: 14);
      const highlightColor = Color(0x40FF0000);

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: highlightColor,
        baseStyle: baseStyle,
      );

      expect(textSpan.children, hasLength(2));

      final matchChild = textSpan.children![0] as TextSpan;
      expect(matchChild.style?.backgroundColor, isNull);

      final missingChild = textSpan.children![1] as TextSpan;
      expect(missingChild.style?.backgroundColor, highlightColor);
      expect(missingChild.style?.fontWeight, FontWeight.w600);
    });

    test('produces correct text content', () {
      final spans = [
        const DiffSpan('a', DiffType.match),
        const DiffSpan('b', DiffType.match),
        const DiffSpan('c', DiffType.extra),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.extra,
        highlightColor: const Color(0x4000FF00),
        baseStyle: const TextStyle(),
      );

      final texts =
          textSpan.children!.map((c) => (c as TextSpan).text).toList();
      expect(texts[0], 'a');
      expect(texts[1], ' b');
      expect(texts[2], ' c');
    });

    test('empty spans produce empty children', () {
      final textSpan = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: const Color(0x40FF0000),
        baseStyle: const TextStyle(),
      );

      expect(textSpan.children, isEmpty);
    });
  });
}
