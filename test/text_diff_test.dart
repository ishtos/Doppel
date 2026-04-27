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

    test('case-insensitive matching', () {
      final result = computeWordDiff('Hello World', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('missing word from user marked as missing in model', () {
      final result = computeWordDiff('the quick fox', 'the fox');

      final missingSpans =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missingSpans.length, 1);
      expect(missingSpans.first.text, 'quick');

      final matchSpans =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      expect(matchSpans.length, 2);
    });

    test('extra word from user marked as extra in user spans', () {
      final result = computeWordDiff('the fox', 'the quick fox');

      final extraSpans =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extraSpans.length, 1);
      expect(extraSpans.first.text, 'quick');
    });

    test('completely different texts', () {
      final result = computeWordDiff('hello world', 'goodbye earth');

      final missingSpans =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final extraSpans =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();

      expect(missingSpans.length, 2);
      expect(extraSpans.length, 2);
    });

    test('empty model text produces all extra user spans', () {
      final result = computeWordDiff('', 'hello world');

      expect(result.modelSpans, isEmpty);
      expect(result.userSpans.length, 2);
      expect(result.userSpans.every((s) => s.type == DiffType.extra), true);
    });

    test('empty user text produces all missing model spans', () {
      final result = computeWordDiff('hello world', '');

      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.missing), true);
      expect(result.userSpans, isEmpty);
    });

    test('both texts empty produces no spans', () {
      final result = computeWordDiff('', '');

      expect(result.modelSpans, isEmpty);
      expect(result.userSpans, isEmpty);
    });

    test('substitution produces missing and extra', () {
      final result = computeWordDiff('I like cats', 'I like dogs');

      final modelMatch =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      final modelMissing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      final userExtra =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();

      expect(modelMatch.length, 2);
      expect(modelMissing.length, 1);
      expect(modelMissing.first.text, 'cats');
      expect(userExtra.length, 1);
      expect(userExtra.first.text, 'dogs');
    });

    test('handles multiple whitespace between words', () {
      final result = computeWordDiff('hello   world', 'hello world');

      expect(result.modelSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('longer text with partial match', () {
      final result = computeWordDiff(
        'the cat sat on the mat',
        'the cat on a mat',
      );

      final modelMatches =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      expect(modelMatches.length, greaterThanOrEqualTo(4));

      final totalModelSpans = result.modelSpans.length;
      expect(totalModelSpans, 6);
    });

    test('preserves original word casing in spans', () {
      final result = computeWordDiff('Hello World', 'hello world');

      expect(result.modelSpans.first.text, 'Hello');
      expect(result.userSpans.first.text, 'hello');
    });
  });

  group('buildDiffTextSpan', () {
    test('returns TextSpan with correct number of children', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      expect(textSpan.children!.length, 2);
    });

    test('highlighted spans have background color and bold weight', () {
      final spans = [
        const DiffSpan('missing', DiffType.missing),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      final child = textSpan.children!.first as TextSpan;
      expect(child.style!.backgroundColor, Colors.red);
      expect(child.style!.fontWeight, FontWeight.w600);
    });

    test('non-highlighted spans use base style without background', () {
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
      expect(child.style!.backgroundColor, isNull);
      expect(child.style!.fontWeight, isNull);
    });

    test('empty spans list produces TextSpan with no children', () {
      final textSpan = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      expect(textSpan.children, isEmpty);
    });

    test('space prefix added between words except first', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.match),
      ];

      final textSpan = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      final first = textSpan.children![0] as TextSpan;
      final second = textSpan.children![1] as TextSpan;
      expect(first.text, 'hello');
      expect(second.text, ' world');
    });
  });
}
