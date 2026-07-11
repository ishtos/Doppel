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

/// Split [text] into shadowing chunks, one chunk per sentence (period-based).
///
/// Splits on sentence terminators (`. ! ?`) followed by whitespace and a
/// capital / opening quote, while protecting abbreviations, initials and
/// decimals so their periods are not treated as sentence boundaries. Each
/// sentence becomes a single chunk (long sentences are kept whole for clear,
/// predictable boundaries). Always returns at least one chunk for non-empty
/// input.
List<String> splitIntoChunks(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return const [];

  final protected = _protectDots(trimmed);

  final sentences = protected
      .split(RegExp(r'''(?<=[.!?])\s+(?=[A-Z"'“‘])'''))
      .map((s) => _restoreDots(s).trim())
      .where((s) => s.isNotEmpty)
      .toList();

  return sentences.isEmpty ? [trimmed] : sentences;
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
