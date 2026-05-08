import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/text_diff.dart';

void main() {
  group('computeWordDiff', () {
    test('identical texts produce all-match spans', () {
      final result = computeWordDiff('hello world', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
      expect(result.userSpans.every((s) => s.type == DiffType.match), true);
    });

    test('missing word in user text marks model span as missing', () {
      final result =
          computeWordDiff('good morning and welcome', 'good morning welcome');
      final missing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(missing.length, 1);
      expect(missing.first.text, 'and');
    });

    test('extra word in user text marks user span as extra', () {
      final result = computeWordDiff('good morning', 'good very morning');
      final extra =
          result.userSpans.where((s) => s.type == DiffType.extra).toList();
      expect(extra.length, 1);
      expect(extra.first.text, 'very');
    });

    test('case insensitive matching treats Hello and hello as equal', () {
      final result = computeWordDiff('Hello World', 'hello world');
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
      expect(result.userSpans.every((s) => s.type == DiffType.match), true);
    });

    test('completely different texts produce all missing and extra', () {
      final result = computeWordDiff('alpha beta', 'gamma delta');
      expect(result.modelSpans.every((s) => s.type == DiffType.missing), true);
      expect(result.userSpans.every((s) => s.type == DiffType.extra), true);
    });

    test('single word match surrounded by extras', () {
      final result = computeWordDiff('hello', 'hey hello there');
      final userMatches =
          result.userSpans.where((s) => s.type == DiffType.match);
      final userExtra =
          result.userSpans.where((s) => s.type == DiffType.extra);
      expect(userMatches.length, 1);
      expect(userExtra.length, 2);
    });

    test('multiple whitespace is normalized during tokenization', () {
      final result = computeWordDiff('hello   world', 'hello world');
      expect(result.modelSpans.length, 2);
      expect(result.userSpans.length, 2);
      expect(result.modelSpans.every((s) => s.type == DiffType.match), true);
    });

    test('partial overlap preserves LCS order', () {
      final result = computeWordDiff('a b c d e', 'a c e');
      final modelMatches =
          result.modelSpans.where((s) => s.type == DiffType.match).toList();
      final modelMissing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(modelMatches.length, 3);
      expect(modelMatches.map((s) => s.text).toList(), ['a', 'c', 'e']);
      expect(modelMissing.length, 2);
      expect(modelMissing.map((s) => s.text).toList(), ['b', 'd']);
    });

    test('duplicate words are matched correctly', () {
      final result =
          computeWordDiff('the cat and the dog', 'the cat the dog');
      final modelMissing =
          result.modelSpans.where((s) => s.type == DiffType.missing).toList();
      expect(modelMissing.length, 1);
      expect(modelMissing.first.text, 'and');
    });

    test('long texts produce correct match count', () {
      const model = 'the quick brown fox jumps over the lazy dog';
      const user = 'the quick fox jumps the lazy dog';
      final result = computeWordDiff(model, user);
      final matches =
          result.modelSpans.where((s) => s.type == DiffType.match).length;
      final missing =
          result.modelSpans.where((s) => s.type == DiffType.missing).length;
      expect(matches, 7);
      expect(missing, 2); // 'brown' and 'over'
    });

    test('swapped words produce missing and extra spans', () {
      final result = computeWordDiff('hello world', 'world hello');
      // LCS is either 'hello' or 'world' (length 1)
      final modelMatches =
          result.modelSpans.where((s) => s.type == DiffType.match).length;
      expect(modelMatches, 1);
    });
  });

  group('buildDiffTextSpan', () {
    test('highlights spans matching the specified DiffType', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
      ];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: const Color(0xFFFF0000),
        baseStyle: const TextStyle(fontSize: 14),
      );
      final children = result.children!;
      expect(children.length, 2);
      expect(
          (children[0] as TextSpan).style?.backgroundColor, isNull);
      expect((children[1] as TextSpan).style?.backgroundColor,
          const Color(0xFFFF0000));
    });

    test('first span has no prefix space, subsequent spans do', () {
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
      expect((result.children![0] as TextSpan).text, 'hello');
      expect((result.children![1] as TextSpan).text, ' world');
    });

    test('empty spans produce empty children list', () {
      final result = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(),
      );
      expect(result.children, isEmpty);
    });

    test('highlighted spans have FontWeight.w600', () {
      final spans = [const DiffSpan('test', DiffType.extra)];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.extra,
        highlightColor: Colors.blue,
        baseStyle: const TextStyle(),
      );
      expect((result.children![0] as TextSpan).style?.fontWeight,
          FontWeight.w600);
    });

    test('non-target DiffType spans use baseStyle without highlight', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.extra),
      ];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 16),
      );
      // Neither span should be highlighted (looking for 'missing')
      for (final child in result.children!) {
        expect((child as TextSpan).style?.backgroundColor, isNull);
      }
    });
  });
}
