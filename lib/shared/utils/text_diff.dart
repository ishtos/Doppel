import 'package:flutter/material.dart';

/// Result of word-level diff between two texts.
class DiffResult {
  const DiffResult({required this.modelSpans, required this.userSpans});

  final List<DiffSpan> modelSpans;
  final List<DiffSpan> userSpans;
}

/// A span of text with a diff type.
class DiffSpan {
  const DiffSpan(this.text, this.type);

  final String text;
  final DiffType type;
}

enum DiffType { match, missing, extra }

/// Compute word-level diff using Longest Common Subsequence (LCS).
DiffResult computeWordDiff(String model, String user) {
  final modelWords = _tokenize(model);
  final userWords = _tokenize(user);

  final lcs = _lcs(modelWords, userWords);

  final modelSpans = <DiffSpan>[];
  final userSpans = <DiffSpan>[];

  var mi = 0;
  var ui = 0;
  var li = 0;

  while (mi < modelWords.length || ui < userWords.length) {
    if (li < lcs.length &&
        mi < modelWords.length &&
        ui < userWords.length &&
        _eq(modelWords[mi], lcs[li]) &&
        _eq(userWords[ui], lcs[li])) {
      // Matched word
      modelSpans.add(DiffSpan(modelWords[mi], DiffType.match));
      userSpans.add(DiffSpan(userWords[ui], DiffType.match));
      mi++;
      ui++;
      li++;
    } else {
      // Consume non-matching model words (missing from user)
      if (mi < modelWords.length &&
          (li >= lcs.length || !_eq(modelWords[mi], lcs[li]))) {
        modelSpans.add(DiffSpan(modelWords[mi], DiffType.missing));
        mi++;
        continue;
      }
      // Consume non-matching user words (extra from user)
      if (ui < userWords.length &&
          (li >= lcs.length || !_eq(userWords[ui], lcs[li]))) {
        userSpans.add(DiffSpan(userWords[ui], DiffType.extra));
        ui++;
        continue;
      }
    }
  }

  return DiffResult(modelSpans: modelSpans, userSpans: userSpans);
}

/// Build a RichText widget from diff spans.
TextSpan buildDiffTextSpan({
  required List<DiffSpan> spans,
  required DiffType highlightType,
  required Color highlightColor,
  required TextStyle? baseStyle,
}) {
  final children = <TextSpan>[];

  for (var i = 0; i < spans.length; i++) {
    final span = spans[i];
    final prefix = i > 0 ? ' ' : '';

    if (span.type == highlightType) {
      children.add(TextSpan(
        text: '$prefix${span.text}',
        style: baseStyle?.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.w600,
        ),
      ));
    } else {
      children.add(TextSpan(
        text: '$prefix${span.text}',
        style: baseStyle,
      ));
    }
  }

  return TextSpan(children: children);
}

// ── Helpers ──

List<String> _tokenize(String text) {
  return text.trim().split(RegExp(r'\s+'));
}

bool _eq(String a, String b) => a.toLowerCase() == b.toLowerCase();

/// Longest Common Subsequence of two word lists (case-insensitive).
List<String> _lcs(List<String> a, List<String> b) {
  final m = a.length;
  final n = b.length;
  final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (_eq(a[i - 1], b[j - 1])) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] = dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
      }
    }
  }

  // Backtrack to find the LCS.
  final result = <String>[];
  var i = m;
  var j = n;
  while (i > 0 && j > 0) {
    if (_eq(a[i - 1], b[j - 1])) {
      result.add(a[i - 1]);
      i--;
      j--;
    } else if (dp[i - 1][j] > dp[i][j - 1]) {
      i--;
    } else {
      j--;
    }
  }

  return result.reversed.toList();
}
