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

// FIXED: prefix/suffix trimming to reduce LCS problem size for typical shadowing results
DiffResult computeWordDiff(String model, String user) {
  final modelWords = _tokenize(model);
  final userWords = _tokenize(user);

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

  // FIXED: trim matching prefix to shrink LCS input
  var prefixLen = 0;
  final minLen =
      modelWords.length < userWords.length ? modelWords.length : userWords.length;
  while (prefixLen < minLen &&
      _eq(modelWords[prefixLen], userWords[prefixLen])) {
    prefixLen++;
  }

  // FIXED: trim matching suffix (from remaining portion after prefix)
  var suffixLen = 0;
  final maxSuffix = minLen - prefixLen;
  while (suffixLen < maxSuffix &&
      _eq(modelWords[modelWords.length - 1 - suffixLen],
          userWords[userWords.length - 1 - suffixLen])) {
    suffixLen++;
  }

  if (prefixLen + suffixLen >= modelWords.length &&
      prefixLen + suffixLen >= userWords.length) {
    return DiffResult(
      modelSpans:
          modelWords.map((w) => DiffSpan(w, DiffType.match)).toList(),
      userSpans:
          userWords.map((w) => DiffSpan(w, DiffType.match)).toList(),
    );
  }

  final modelMiddle =
      modelWords.sublist(prefixLen, modelWords.length - suffixLen);
  final userMiddle =
      userWords.sublist(prefixLen, userWords.length - suffixLen);

  final lcs = _lcs(modelMiddle, userMiddle);

  final modelSpans = <DiffSpan>[];
  final userSpans = <DiffSpan>[];

  for (var i = 0; i < prefixLen; i++) {
    modelSpans.add(DiffSpan(modelWords[i], DiffType.match));
    userSpans.add(DiffSpan(userWords[i], DiffType.match));
  }

  var mi = 0;
  var ui = 0;
  var li = 0;

  while (mi < modelMiddle.length || ui < userMiddle.length) {
    if (li < lcs.length &&
        mi < modelMiddle.length &&
        ui < userMiddle.length &&
        _eq(modelMiddle[mi], lcs[li]) &&
        _eq(userMiddle[ui], lcs[li])) {
      modelSpans.add(DiffSpan(modelMiddle[mi], DiffType.match));
      userSpans.add(DiffSpan(userMiddle[ui], DiffType.match));
      mi++;
      ui++;
      li++;
    } else {
      if (mi < modelMiddle.length &&
          (li >= lcs.length || !_eq(modelMiddle[mi], lcs[li]))) {
        modelSpans.add(DiffSpan(modelMiddle[mi], DiffType.missing));
        mi++;
        continue;
      }
      if (ui < userMiddle.length &&
          (li >= lcs.length || !_eq(userMiddle[ui], lcs[li]))) {
        userSpans.add(DiffSpan(userMiddle[ui], DiffType.extra));
        ui++;
        continue;
      }
    }
  }

  for (var i = modelWords.length - suffixLen; i < modelWords.length; i++) {
    modelSpans.add(DiffSpan(modelWords[i], DiffType.match));
  }
  for (var i = userWords.length - suffixLen; i < userWords.length; i++) {
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

// FIXED: empty string produced [''] instead of [] causing phantom diff spans
List<String> _tokenize(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return [];
  return trimmed.split(RegExp(r'\s+'));
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
