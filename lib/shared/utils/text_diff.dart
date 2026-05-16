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

  // FIXED: Early return for empty inputs
  if (modelWords.isEmpty && userWords.isEmpty) {
    return const DiffResult(modelSpans: [], userSpans: []);
  }
  if (modelWords.isEmpty) {
    return DiffResult(
      modelSpans: const [],
      userSpans: userWords.map((w) => DiffSpan(w, DiffType.extra)).toList(),
    );
  }
  if (userWords.isEmpty) {
    return DiffResult(
      modelSpans:
          modelWords.map((w) => DiffSpan(w, DiffType.missing)).toList(),
      userSpans: const [],
    );
  }

  // FIXED: Strip common prefix/suffix to shrink LCS subproblem
  final minLen = modelWords.length < userWords.length
      ? modelWords.length
      : userWords.length;

  var prefixLen = 0;
  while (prefixLen < minLen &&
      _eq(modelWords[prefixLen], userWords[prefixLen])) {
    prefixLen++;
  }

  var suffixLen = 0;
  while (suffixLen < minLen - prefixLen &&
      _eq(
        modelWords[modelWords.length - 1 - suffixLen],
        userWords[userWords.length - 1 - suffixLen],
      )) {
    suffixLen++;
  }

  final modelSpans = <DiffSpan>[];
  final userSpans = <DiffSpan>[];

  for (var i = 0; i < prefixLen; i++) {
    modelSpans.add(DiffSpan(modelWords[i], DiffType.match));
    userSpans.add(DiffSpan(userWords[i], DiffType.match));
  }

  final mEnd = modelWords.length - suffixLen;
  final uEnd = userWords.length - suffixLen;
  final modelMiddle = modelWords.sublist(prefixLen, mEnd);
  final userMiddle = userWords.sublist(prefixLen, uEnd);

  if (modelMiddle.isNotEmpty || userMiddle.isNotEmpty) {
    if (modelMiddle.isEmpty) {
      userSpans.addAll(userMiddle.map((w) => DiffSpan(w, DiffType.extra)));
    } else if (userMiddle.isEmpty) {
      modelSpans
          .addAll(modelMiddle.map((w) => DiffSpan(w, DiffType.missing)));
    } else {
      final lcs = _lcs(modelMiddle, userMiddle);
      _buildSpans(modelMiddle, userMiddle, lcs, modelSpans, userSpans);
    }
  }

  for (var i = mEnd; i < modelWords.length; i++) {
    modelSpans.add(DiffSpan(modelWords[i], DiffType.match));
  }
  for (var i = uEnd; i < userWords.length; i++) {
    userSpans.add(DiffSpan(userWords[i], DiffType.match));
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

// FIXED: Return empty list for empty/whitespace-only input
List<String> _tokenize(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return [];
  return trimmed.split(RegExp(r'\s+'));
}

bool _eq(String a, String b) => a.toLowerCase() == b.toLowerCase();

void _buildSpans(
  List<String> modelWords,
  List<String> userWords,
  List<String> lcs,
  List<DiffSpan> modelSpans,
  List<DiffSpan> userSpans,
) {
  var mi = 0;
  var ui = 0;
  var li = 0;

  while (mi < modelWords.length || ui < userWords.length) {
    if (li < lcs.length &&
        mi < modelWords.length &&
        ui < userWords.length &&
        _eq(modelWords[mi], lcs[li]) &&
        _eq(userWords[ui], lcs[li])) {
      modelSpans.add(DiffSpan(modelWords[mi], DiffType.match));
      userSpans.add(DiffSpan(userWords[ui], DiffType.match));
      mi++;
      ui++;
      li++;
    } else {
      if (mi < modelWords.length &&
          (li >= lcs.length || !_eq(modelWords[mi], lcs[li]))) {
        modelSpans.add(DiffSpan(modelWords[mi], DiffType.missing));
        mi++;
        continue;
      }
      if (ui < userWords.length &&
          (li >= lcs.length || !_eq(userWords[ui], lcs[li]))) {
        userSpans.add(DiffSpan(userWords[ui], DiffType.extra));
        ui++;
        continue;
      }
    }
  }
}

/// Longest Common Subsequence of two word lists (case-insensitive).
// FIXED: Use shorter list as columns to minimize per-row allocation
List<String> _lcs(List<String> a, List<String> b) {
  final bool swapped = a.length < b.length;
  final List<String> rows = swapped ? b : a;
  final List<String> cols = swapped ? a : b;
  final m = rows.length;
  final n = cols.length;

  final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

  for (var i = 1; i <= m; i++) {
    for (var j = 1; j <= n; j++) {
      if (_eq(rows[i - 1], cols[j - 1])) {
        dp[i][j] = dp[i - 1][j - 1] + 1;
      } else {
        dp[i][j] =
            dp[i - 1][j] > dp[i][j - 1] ? dp[i - 1][j] : dp[i][j - 1];
      }
    }
  }

  final result = <String>[];
  var i = m;
  var j = n;
  while (i > 0 && j > 0) {
    if (_eq(rows[i - 1], cols[j - 1])) {
      result.add(rows[i - 1]);
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
