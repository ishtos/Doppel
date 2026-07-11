/// Splits a passage of English text into short shadowing chunks
/// (sentences, further broken into breath groups when too long).
///
/// This is a pure, dependency-free util so it can be unit-tested and
/// computed once per session without touching [LessonModel] or Hive.
library;

/// Sentinel used to temporarily protect a `.` that must NOT be treated
/// as a sentence boundary (abbreviations, initials, decimals).
const _dot = '⫶'; // rarely-used unicode char, safe as a placeholder

/// Known abbreviations whose trailing period should not end a sentence.
const _abbreviations = <String>[
  'Mr', 'Mrs', 'Ms', 'Dr', 'Prof', 'Sr', 'Jr', 'St', 'vs', 'etc',
  'Inc', 'Ltd', 'Co', 'Corp', 'Dept', 'Gov', 'Sen', 'Rep',
  'a.m', 'p.m', 'U.S', 'U.K', 'e.g', 'i.e',
];

/// Split [text] into shadowing chunks.
///
/// - Splits on sentence terminators (`. ! ?`) followed by whitespace and a
///   capital / quote, while protecting abbreviations, initials and decimals.
/// - Any sentence longer than [maxWordsPerChunk] words is further split into
///   natural breath groups at commas, semicolons, colons and coordinating
///   conjunctions.
/// - Always returns at least one chunk for non-empty input.
List<String> splitIntoChunks(String text, {int maxWordsPerChunk = 10}) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return const [];

  final protected = _protectDots(trimmed);

  // Split into sentences.
  final rawSentences = protected
      .split(RegExp(r'''(?<=[.!?])\s+(?=[A-Z"'“‘])'''))
      .map((s) => _restoreDots(s).trim())
      .where((s) => s.isNotEmpty)
      .toList();

  final sentences = rawSentences.isEmpty ? [trimmed] : rawSentences;

  final chunks = <String>[];
  for (final sentence in sentences) {
    if (_wordCount(sentence) <= maxWordsPerChunk) {
      chunks.add(sentence);
    } else {
      chunks.addAll(_splitLongSentence(sentence, maxWordsPerChunk));
    }
  }

  final result = chunks.map((c) => c.trim()).where((c) => c.isNotEmpty).toList();
  return result.isEmpty ? [trimmed] : result;
}

/// Replace abbreviation / initial / decimal periods with a sentinel so they
/// are not treated as sentence boundaries.
String _protectDots(String text) {
  var out = text;

  // Abbreviations (case-insensitive on the word, keep the trailing dot).
  for (final abbr in _abbreviations) {
    // Escape any regex-special chars in the abbreviation (e.g. the `.` in "a.m").
    final escaped = RegExp.escape(abbr);
    out = out.replaceAllMapped(
      RegExp('\\b$escaped\\.', caseSensitive: false),
      (m) => m.group(0)!.replaceAll('.', _dot),
    );
  }

  // Single-capital initials: "J. K. Rowling", "George W. Bush".
  out = out.replaceAllMapped(
    RegExp(r'\b([A-Z])\.'),
    (m) => '${m.group(1)}$_dot',
  );

  // Decimals: "3.8", "twenty.5" (numeric only).
  out = out.replaceAllMapped(
    RegExp(r'(\d)\.(\d)'),
    (m) => '${m.group(1)}$_dot${m.group(2)}',
  );

  return out;
}

String _restoreDots(String text) => text.replaceAll(_dot, '.');

/// Break a long sentence into breath groups at natural boundaries.
List<String> _splitLongSentence(String sentence, int maxWordsPerChunk) {
  // Split points: punctuation (, ; :) and coordinating conjunctions.
  // We keep trailing punctuation with the left-hand group.
  final parts = <String>[];
  final regex = RegExp(
    r'''(?<=[,;:])\s+|\s+(?=\b(?:and|but|or|because|so|which|that|while|when|although|however)\b)''',
    caseSensitive: false,
  );

  final rawParts =
      sentence.split(regex).map((p) => p.trim()).where((p) => p.isNotEmpty);

  // Merge tiny fragments (< 4 words) into the previous group so chunks stay
  // natural to shadow.
  for (final part in rawParts) {
    if (parts.isNotEmpty && _wordCount(part) < 4) {
      parts[parts.length - 1] = '${parts.last} $part';
    } else {
      parts.add(part);
    }
  }

  if (parts.isEmpty) return [sentence];

  // Any group still longer than the limit is hard-wrapped by word count as a
  // last resort so no single chunk is overwhelming.
  final result = <String>[];
  for (final part in parts) {
    if (_wordCount(part) <= maxWordsPerChunk) {
      result.add(part);
    } else {
      result.addAll(_hardWrap(part, maxWordsPerChunk));
    }
  }
  return result;
}

/// Hard-wrap by word count when no natural boundary exists.
List<String> _hardWrap(String text, int maxWordsPerChunk) {
  final words = text.split(RegExp(r'\s+'));
  final out = <String>[];
  for (var i = 0; i < words.length; i += maxWordsPerChunk) {
    final end =
        (i + maxWordsPerChunk < words.length) ? i + maxWordsPerChunk : words.length;
    out.add(words.sublist(i, end).join(' '));
  }
  return out;
}

int _wordCount(String text) =>
    text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
