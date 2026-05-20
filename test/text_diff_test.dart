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

    test('case-insensitive matching', () {
      final result = computeWordDiff('Hello World', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      for (final span in result.modelSpans) {
        expect(span.type, DiffType.match);
      }
    });

    test('missing words in user transcript are marked as missing', () {
      final result = computeWordDiff('the quick brown fox', 'the fox');

      final missingSpans =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missingSpans.length, 2);
      expect(missingSpans.map((s) => s.text), containsAll(['quick', 'brown']));
    });

    test('extra words in user transcript are marked as extra', () {
      final result = computeWordDiff('hello world', 'hello big world');

      final extraSpans =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extraSpans.length, 1);
      expect(extraSpans.first.text, 'big');
    });

    test('completely different texts', () {
      final result = computeWordDiff('alpha beta', 'gamma delta');

      final missingSpans =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final extraSpans =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(missingSpans.length, 2);
      expect(extraSpans.length, 2);
    });

    test('empty user text marks all model words as missing', () {
      final result = computeWordDiff('hello world', '');

      final missingSpans =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missingSpans.length, 2);
    });

    test('empty model text marks all user words as extra', () {
      final result = computeWordDiff('', 'hello world');

      final extraSpans =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extraSpans.length, 2);
    });

    test('handles multiple spaces between words', () {
      final result = computeWordDiff('hello   world', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      for (final span in result.modelSpans) {
        expect(span.type, DiffType.match);
      }
    });

    test('partial overlap produces mixed spans', () {
      final result =
          computeWordDiff('I love flutter', 'I really love dart');

      final modelMatches =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      final modelMissing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final userMatches =
          result.userSpans.where((s) => s.type == DiffType.match).toList();
      final userExtra =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();

      expect(modelMatches.map((s) => s.text), containsAll(['I', 'love']));
      expect(modelMissing.map((s) => s.text), contains('flutter'));
      expect(userMatches.map((s) => s.text), containsAll(['I', 'love']));
      expect(userExtra.map((s) => s.text), containsAll(['really', 'dart']));
    });
  });

  group('buildDiffTextSpan', () {
    test('produces TextSpan with correct number of children', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
        const DiffSpan('foo', DiffType.match),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      expect(textSpan.children, isNotNull);
      expect(textSpan.children!.length, 3);
    });

    test('highlighted spans have bold fontWeight', () {
      final spans = [
        const DiffSpan('missed', DiffType.missing),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      final child = textSpan.children!.first as TextSpan;
      expect(child.style!.fontWeight, FontWeight.w600);
      expect(child.style!.backgroundColor, Colors.red);
    });

    test('non-highlighted spans keep base style', () {
      final spans = [
        const DiffSpan('normal', DiffType.match),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      final child = textSpan.children!.first as TextSpan;
      expect(child.style!.fontWeight, isNull);
      expect(child.style!.backgroundColor, isNull);
    });

    test('empty spans produce empty children list', () {
      final textSpan = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      expect(textSpan.children, isEmpty);
    });
  });
}
