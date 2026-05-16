import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/text_diff.dart';

void main() {
  group('computeWordDiff', () {
    group('empty inputs', () {
      test('both empty strings', () {
        final result = computeWordDiff('', '');
        expect(result.modelSpans, isEmpty);
        expect(result.userSpans, isEmpty);
      });

      test('both whitespace-only strings', () {
        final result = computeWordDiff('   ', '  \t  ');
        expect(result.modelSpans, isEmpty);
        expect(result.userSpans, isEmpty);
      });

      test('empty model, non-empty user', () {
        final result = computeWordDiff('', 'hello world');
        expect(result.modelSpans, isEmpty);
        expect(result.userSpans, hasLength(2));
        expect(result.userSpans[0].text, 'hello');
        expect(result.userSpans[0].type, DiffType.extra);
        expect(result.userSpans[1].text, 'world');
        expect(result.userSpans[1].type, DiffType.extra);
      });

      test('non-empty model, empty user', () {
        final result = computeWordDiff('hello world', '');
        expect(result.modelSpans, hasLength(2));
        expect(result.modelSpans[0].text, 'hello');
        expect(result.modelSpans[0].type, DiffType.missing);
        expect(result.modelSpans[1].text, 'world');
        expect(result.modelSpans[1].type, DiffType.missing);
        expect(result.userSpans, isEmpty);
      });
    });

    group('identical texts', () {
      test('single word', () {
        final result = computeWordDiff('hello', 'hello');
        expect(result.modelSpans, hasLength(1));
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.userSpans, hasLength(1));
        expect(result.userSpans[0].type, DiffType.match);
      });

      test('multiple words', () {
        final result = computeWordDiff('the quick brown fox', 'the quick brown fox');
        expect(result.modelSpans, hasLength(4));
        expect(result.userSpans, hasLength(4));
        for (final span in result.modelSpans) {
          expect(span.type, DiffType.match);
        }
        for (final span in result.userSpans) {
          expect(span.type, DiffType.match);
        }
      });

      test('identical except for extra whitespace', () {
        final result = computeWordDiff('hello  world', 'hello world');
        expect(result.modelSpans, hasLength(2));
        expect(result.userSpans, hasLength(2));
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[1].type, DiffType.match);
      });
    });

    group('case insensitivity', () {
      test('different case matches', () {
        final result = computeWordDiff('Hello World', 'hello world');
        expect(result.modelSpans, hasLength(2));
        expect(result.userSpans, hasLength(2));
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[0].text, 'Hello');
        expect(result.userSpans[0].type, DiffType.match);
        expect(result.userSpans[0].text, 'hello');
      });

      test('mixed case matches', () {
        final result = computeWordDiff('THE Quick BROWN', 'the QUICK brown');
        for (final span in result.modelSpans) {
          expect(span.type, DiffType.match);
        }
        for (final span in result.userSpans) {
          expect(span.type, DiffType.match);
        }
      });
    });

    group('missing words (user omits words)', () {
      test('user omits first word', () {
        final result = computeWordDiff('hello world', 'world');
        expect(result.modelSpans, hasLength(2));
        expect(result.modelSpans[0].text, 'hello');
        expect(result.modelSpans[0].type, DiffType.missing);
        expect(result.modelSpans[1].text, 'world');
        expect(result.modelSpans[1].type, DiffType.match);
      });

      test('user omits last word', () {
        final result = computeWordDiff('hello world', 'hello');
        expect(result.modelSpans, hasLength(2));
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[1].type, DiffType.missing);
      });

      test('user omits middle word', () {
        final result = computeWordDiff('a b c', 'a c');
        expect(result.modelSpans, hasLength(3));
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[1].type, DiffType.missing);
        expect(result.modelSpans[2].type, DiffType.match);
      });
    });

    group('extra words (user adds words)', () {
      test('user adds word at beginning', () {
        final result = computeWordDiff('world', 'hello world');
        expect(result.userSpans, hasLength(2));
        expect(result.userSpans[0].text, 'hello');
        expect(result.userSpans[0].type, DiffType.extra);
        expect(result.userSpans[1].text, 'world');
        expect(result.userSpans[1].type, DiffType.match);
      });

      test('user adds word at end', () {
        final result = computeWordDiff('hello', 'hello world');
        expect(result.userSpans, hasLength(2));
        expect(result.userSpans[0].type, DiffType.match);
        expect(result.userSpans[1].type, DiffType.extra);
      });

      test('user adds word in middle', () {
        final result = computeWordDiff('a c', 'a b c');
        expect(result.userSpans, hasLength(3));
        expect(result.userSpans[0].type, DiffType.match);
        expect(result.userSpans[1].type, DiffType.extra);
        expect(result.userSpans[2].type, DiffType.match);
      });
    });

    group('completely different texts', () {
      test('no common words', () {
        final result = computeWordDiff('alpha beta', 'gamma delta');
        expect(
          result.modelSpans.every((s) => s.type == DiffType.missing),
          isTrue,
        );
        expect(
          result.userSpans.every((s) => s.type == DiffType.extra),
          isTrue,
        );
      });
    });

    group('mixed differences', () {
      test('substitution in middle', () {
        final result =
            computeWordDiff('the quick brown fox', 'the quick red fox');
        expect(result.modelSpans, hasLength(4));
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[1].type, DiffType.match);
        expect(result.modelSpans[2].text, 'brown');
        expect(result.modelSpans[2].type, DiffType.missing);
        expect(result.modelSpans[3].type, DiffType.match);

        expect(result.userSpans, hasLength(4));
        expect(result.userSpans[0].type, DiffType.match);
        expect(result.userSpans[1].type, DiffType.match);
        expect(result.userSpans[2].text, 'red');
        expect(result.userSpans[2].type, DiffType.extra);
        expect(result.userSpans[3].type, DiffType.match);
      });

      test('realistic shadowing scenario', () {
        const model = 'The weather forecast predicts rain tomorrow';
        const user = 'The weather predicts rain';
        final result = computeWordDiff(model, user);

        final matchedModel =
            result.modelSpans.where((s) => s.type == DiffType.match).length;
        final missingModel =
            result.modelSpans.where((s) => s.type == DiffType.missing).length;

        expect(matchedModel, 4);
        expect(missingModel, 2);
      });
    });

    group('prefix/suffix optimization correctness', () {
      test('common prefix only', () {
        final result = computeWordDiff('a b c d', 'a b x y');
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[1].type, DiffType.match);
      });

      test('common suffix only', () {
        final result = computeWordDiff('x y c d', 'a b c d');
        expect(result.modelSpans[2].type, DiffType.match);
        expect(result.modelSpans[3].type, DiffType.match);
      });

      test('common prefix and suffix', () {
        final result = computeWordDiff('a b c d e', 'a b x d e');
        expect(result.modelSpans[0].type, DiffType.match);
        expect(result.modelSpans[1].type, DiffType.match);
        expect(result.modelSpans[2].type, DiffType.missing);
        expect(result.modelSpans[3].type, DiffType.match);
        expect(result.modelSpans[4].type, DiffType.match);
      });

      test('entire text is common prefix', () {
        final result = computeWordDiff('a b c', 'a b c d e');
        for (var i = 0; i < 3; i++) {
          expect(result.modelSpans[i].type, DiffType.match);
        }
        expect(result.userSpans[3].type, DiffType.extra);
        expect(result.userSpans[4].type, DiffType.extra);
      });
    });

    group('single word inputs', () {
      test('single matching word', () {
        final result = computeWordDiff('hello', 'hello');
        expect(result.modelSpans, hasLength(1));
        expect(result.modelSpans[0].type, DiffType.match);
      });

      test('single non-matching word', () {
        final result = computeWordDiff('hello', 'world');
        expect(result.modelSpans[0].type, DiffType.missing);
        expect(result.userSpans[0].type, DiffType.extra);
      });
    });
  });

  group('buildDiffTextSpan', () {
    test('empty spans list', () {
      final result = buildDiffTextSpan(
        spans: [],
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(),
      );
      expect(result.children, isEmpty);
    });

    test('highlights spans matching highlightType', () {
      final spans = [
        const DiffSpan('hello', DiffType.match),
        const DiffSpan('world', DiffType.missing),
      ];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(fontSize: 14),
      );

      final children = result.children! as List<InlineSpan>;
      expect(children, hasLength(2));

      final normalSpan = children[0] as TextSpan;
      expect(normalSpan.text, 'hello');
      expect(normalSpan.style?.backgroundColor, isNull);

      final highlightedSpan = children[1] as TextSpan;
      expect(highlightedSpan.text, ' world');
      expect(highlightedSpan.style?.backgroundColor, Colors.red);
      expect(highlightedSpan.style?.fontWeight, FontWeight.w600);
    });

    test('first span has no space prefix', () {
      final spans = [const DiffSpan('first', DiffType.match)];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(),
      );
      final children = result.children! as List<InlineSpan>;
      final span = children[0] as TextSpan;
      expect(span.text, 'first');
    });

    test('subsequent spans have space prefix', () {
      final spans = [
        const DiffSpan('a', DiffType.match),
        const DiffSpan('b', DiffType.match),
        const DiffSpan('c', DiffType.match),
      ];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: const TextStyle(),
      );
      final children = result.children! as List<InlineSpan>;
      expect((children[0] as TextSpan).text, 'a');
      expect((children[1] as TextSpan).text, ' b');
      expect((children[2] as TextSpan).text, ' c');
    });

    test('works with null baseStyle', () {
      final spans = [const DiffSpan('hello', DiffType.missing)];
      final result = buildDiffTextSpan(
        spans: spans,
        highlightType: DiffType.missing,
        highlightColor: Colors.red,
        baseStyle: null,
      );
      final children = result.children! as List<InlineSpan>;
      expect(children, hasLength(1));
    });
  });
}
