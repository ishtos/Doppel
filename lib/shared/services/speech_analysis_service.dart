import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../features/feedback/data/models/feedback_model.dart';
import '../analytics/analytics_events.dart';
import '../analytics/analytics_provider.dart';
import '../analytics/analytics_service.dart';
import 'ai_backend.dart';
import 'ai_coach_service.dart';

final speechAnalysisServiceProvider = Provider<SpeechAnalysisService>((ref) {
  return SpeechAnalysisService(
    ref.watch(aiCoachServiceProvider),
    analytics: ref.watch(analyticsProvider),
  );
});

class SpeechAnalysisService {
  SpeechAnalysisService(
    this._aiCoach, {
    AiBackendConfig? backend,
    AnalyticsService? analytics,
  })  : _backend = backend ?? AiBackendConfig(),
        _analytics = analytics;

  final AiCoachService _aiCoach;
  final AiBackendConfig _backend;

  /// Optional — when present, cloud transcription failures are reported so a
  /// silent fall-back to simulated scoring becomes diagnosable.
  final AnalyticsService? _analytics;

  final _random = Random();

  /// Analyze a user recording against the model transcript.
  Future<FeedbackModel> analyze({
    required String lessonId,
    required String modelTranscript,
    required String? userAudioPath,
    bool cloudEnabled = false,
  }) async {
    // Transcribe user audio via Whisper API only when available AND the user
    // has consented to cloud analysis. Otherwise no audio leaves the device.
    String? userTranscript;
    String? transcriptionError;
    if (userAudioPath != null && _backend.isAvailable && cloudEnabled) {
      final (text, error) = await _transcribe(userAudioPath);
      userTranscript = text;
      transcriptionError = error;
    }

    // Score only up to where the user actually read (they read sequentially).
    // Unread trailing text is trimmed so it does not lower the score.
    final scoredModel = userTranscript == null
        ? modelTranscript
        : coveredModelSpan(modelTranscript, userTranscript);

    return _buildFeedback(
      lessonId: lessonId,
      modelTranscript: scoredModel,
      userTranscript: userTranscript,
      userAudioPath: userAudioPath,
      cloudEnabled: cloudEnabled,
      transcriptionError: transcriptionError,
    );
  }

  /// Trim [model] to the portion the user actually read, assuming sequential
  /// reading from the start. Returns the model up to the furthest model word
  /// the user reached; if they reached (near) the end, the whole model is kept
  /// so a complete read is scored in full. Prevents unread trailing text from
  /// lowering the score.
  static String coveredModelSpan(String model, String user) {
    final modelWords = model
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    String norm(String w) => w.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
    final modelNorm = modelWords.map(norm).toList();
    final userNorm = user
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map(norm)
        .where((w) => w.isNotEmpty)
        .toList();
    if (modelWords.isEmpty || userNorm.isEmpty) return model;

    // Greedily walk the user's words forward through the model, tracking the
    // furthest model index reached.
    var mi = 0;
    var lastMatched = -1;
    for (final uw in userNorm) {
      for (var j = mi; j < modelNorm.length; j++) {
        if (modelNorm[j] == uw) {
          lastMatched = j;
          mi = j + 1;
          break;
        }
      }
    }
    if (lastMatched < 0) return model; // no alignment → score the whole thing
    if (lastMatched >= modelWords.length - 2) return model; // (near) the end
    return modelWords.sublist(0, lastMatched + 1).join(' ');
  }

  /// Build a [FeedbackModel] from a (possibly null) user transcript, applying
  /// real transcript-comparison scoring when available and falling back to
  /// simulated scores otherwise. Shared by [analyze] and [analyzeChunks].
  Future<FeedbackModel> _buildFeedback({
    required String lessonId,
    required String modelTranscript,
    required String? userTranscript,
    required String? userAudioPath,
    required bool cloudEnabled,
    String? transcriptionError,
  }) async {
    // A cloud transcription was attempted but failed (distinct from the
    // by-design offline / consent-off case, where no attempt is made). Report
    // it so a silent degrade to simulated scoring becomes diagnosable.
    if (transcriptionError != null) {
      _analytics?.capture(
        AnalyticsEvents.aiTranscriptionFailed,
        properties: {'reason': transcriptionError},
      );
    }
    // Score by comparing transcripts
    final int pronunciationScore;
    final int rhythmScore;
    final int intonationScore;
    final List<ProblemWord> problemWords;

    if (userTranscript != null) {
      // Real scoring based on transcript comparison
      final scores = _compareTranscripts(modelTranscript, userTranscript);
      pronunciationScore = scores.pronunciation;
      rhythmScore = scores.rhythm;
      intonationScore = scores.intonation;
      problemWords = scores.problemWords;
    } else {
      // Fallback: simulated scores
      final baseScore = 60 + _random.nextInt(30);
      pronunciationScore = _clamp(baseScore + _random.nextInt(11) - 5);
      rhythmScore = _clamp(baseScore + _random.nextInt(11) - 5);
      intonationScore = _clamp(baseScore + _random.nextInt(11) - 5);
      problemWords =
          _extractProblemWordsFallback(modelTranscript.split(RegExp(r'\s+')));
    }

    // Generate AI coach message
    final coach = await _aiCoach.generateFeedback(
      pronunciationScore: pronunciationScore,
      rhythmScore: rhythmScore,
      intonationScore: intonationScore,
      problemWords: problemWords.map((pw) => pw.word).toList(),
      cloudEnabled: cloudEnabled,
    );

    final overall =
        ((pronunciationScore + rhythmScore + intonationScore) / 3).round();

    return FeedbackModel(
      id: const Uuid().v4(),
      lessonId: lessonId,
      overallScore: overall,
      pronunciationScore: pronunciationScore,
      rhythmScore: rhythmScore,
      intonationScore: intonationScore,
      problemWords: problemWords,
      coachMessage: coach.text,
      coachIsFallback: coach.isFallback,
      createdAt: DateTime.now(),
      userTranscript: userTranscript,
      modelTranscript: modelTranscript,
      userAudioPath: userAudioPath,
      analysisError: transcriptionError,
    );
  }

  /// Analyze a chunk-by-chunk shadowing session.
  ///
  /// Each recorded chunk is transcribed independently (in parallel) via
  /// Whisper, then the transcripts are concatenated and scored against the
  /// joined model chunks using the exact same logic as [analyze], producing a
  /// single whole-passage [FeedbackModel]. When no API key / no audio is
  /// available it falls through to the same simulated-score path as [analyze],
  /// so the effortless offline loop is preserved.
  ///
  /// [chunkAudioPaths] is index-aligned with [modelChunks]; a null entry means
  /// that chunk was not recorded (e.g. skipped or simulator with no mic).
  Future<FeedbackModel> analyzeChunks({
    required String lessonId,
    required List<String> modelChunks,
    required List<String?> chunkAudioPaths,
    bool cloudEnabled = false,
  }) async {
    // Score only the chunks that were actually recorded (read). Excluding
    // unrecorded chunks means the part the user did not read does not lower
    // their score.
    final recordedModelChunks = <String>[];
    final recordedPaths = <String>[];
    for (var i = 0; i < modelChunks.length; i++) {
      final path = i < chunkAudioPaths.length ? chunkAudioPaths[i] : null;
      if (path != null) {
        recordedModelChunks.add(modelChunks[i]);
        recordedPaths.add(path);
      }
    }

    // Fallback: nothing recorded with audio (e.g. simulator without a mic) →
    // score against the whole passage via the simulated-score path.
    final scoredChunks =
        recordedModelChunks.isEmpty ? modelChunks : recordedModelChunks;
    final modelTranscript = scoredChunks.join(' ');

    // Transcribe the recorded chunks in parallel, preserving order.
    String? userTranscript;
    String? transcriptionError;
    if (_backend.isAvailable && recordedPaths.isNotEmpty && cloudEnabled) {
      final results = await Future.wait(recordedPaths.map(_transcribe));
      final joined = results
          .map((r) => r.$1)
          .whereType<String>()
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .join(' ')
          .trim();
      if (joined.isNotEmpty) {
        userTranscript = joined;
      } else {
        // Every recorded chunk failed to transcribe — surface the first cause.
        final errors = results.map((r) => r.$2).whereType<String>();
        transcriptionError = errors.isEmpty ? 'unknown' : errors.first;
      }
    }

    // Representative audio path (feedback screen replays a single file).
    final firstAudioPath =
        recordedPaths.isNotEmpty ? recordedPaths.first : null;

    return _buildFeedback(
      lessonId: lessonId,
      modelTranscript: modelTranscript,
      userTranscript: userTranscript,
      userAudioPath: firstAudioPath,
      cloudEnabled: cloudEnabled,
      transcriptionError: transcriptionError,
    );
  }

  /// Transcribe audio file using OpenAI Whisper API.
  ///
  /// Returns `(text, error)`: on success `text` is the transcript and `error`
  /// is null; on failure `text` is null and `error` carries a short cause code
  /// (`http_<status>` for a non-200 response, `network` for an exception) so
  /// callers can report *why* scoring fell back to simulated. No PII is
  /// included — only the status/kind.
  Future<(String?, String?)> _transcribe(String audioPath) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse(_backend.transcriptionUrl));
      _backend.authHeaders().forEach((k, v) => request.headers[k] = v);
      request.fields['model'] = 'whisper-1';
      request.fields['language'] = 'en';
      request.files
          .add(await http.MultipartFile.fromPath('file', audioPath));

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return (data['text'] as String?, null);
      }
      return (null, 'http_${response.statusCode}');
    } catch (_) {
      return (null, 'network');
    }
  }

  /// Compare model transcript with user transcript to generate scores.
  _ScoreResult _compareTranscripts(String model, String user) {
    final modelWords = _normalizeWords(model);
    final userWords = _normalizeWords(user);

    // Word-level accuracy (pronunciation proxy)
    final matchCount = _countMatches(modelWords, userWords);
    final accuracy = modelWords.isEmpty ? 0.0 : matchCount / modelWords.length;
    final pronunciationScore = _clamp((accuracy * 100).round());

    // Word count ratio (rhythm proxy)
    final countRatio = modelWords.isEmpty
        ? 0.0
        : (userWords.length / modelWords.length).clamp(0.0, 1.0);
    // Penalize both too few and too many words. Scale straight to 0–100 with
    // no random noise so the same recording always yields the same score.
    final rhythmRaw = 1.0 - (1.0 - countRatio).abs();
    final rhythmScore = _clamp((rhythmRaw * 100).round());

    // Sequence similarity (intonation proxy)
    final seqSimilarity = _sequenceSimilarity(modelWords, userWords);
    final intonationScore = _clamp((seqSimilarity * 100).round());

    // Identify problem words (in model but not in user transcript)
    final userWordSet = userWords.toSet();
    final missed = <ProblemWord>[];
    final seen = <String>{};
    for (final word in modelWords) {
      if (!userWordSet.contains(word) && !seen.contains(word) && word.length > 2) {
        seen.add(word);
        final phoneme = _guessPhoneme(word);
        missed.add(ProblemWord(
          word: word,
          phoneme: phoneme,
          // Deterministic estimate from the phoneme's known difficulty for
          // Japanese learners (was a random 0.5–0.9).
          errorRate: _errorRateFor(phoneme),
        ));
        if (missed.length >= 4) break;
      }
    }

    return _ScoreResult(
      pronunciation: pronunciationScore,
      rhythm: rhythmScore,
      intonation: intonationScore,
      problemWords: missed,
    );
  }

  List<String> _normalizeWords(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  int _countMatches(List<String> model, List<String> user) {
    final userBag = <String, int>{};
    for (final w in user) {
      userBag[w] = (userBag[w] ?? 0) + 1;
    }
    var count = 0;
    for (final w in model) {
      if ((userBag[w] ?? 0) > 0) {
        userBag[w] = userBag[w]! - 1;
        count++;
      }
    }
    return count;
  }

  /// Longest common subsequence ratio as sequence similarity.
  double _sequenceSimilarity(List<String> a, List<String> b) {
    if (a.isEmpty || b.isEmpty) return 0.0;
    // Use shorter lengths for efficiency
    final m = a.length;
    final n = b.length;
    final prev = List.filled(n + 1, 0);
    final curr = List.filled(n + 1, 0);
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          curr[j] = prev[j - 1] + 1;
        } else {
          curr[j] = max(prev[j], curr[j - 1]);
        }
      }
      for (var j = 0; j <= n; j++) {
        prev[j] = curr[j];
        curr[j] = 0;
      }
    }
    return prev[n] / max(m, n);
  }

  String _guessPhoneme(String word) {
    final w = word.toLowerCase();
    if (w.contains('th')) return '/θ/';
    if (w.contains('r')) return '/r/';
    if (w.contains('l')) return '/l/';
    if (w.contains('v')) return '/v/';
    if (w.contains('f')) return '/f/';
    if (w.contains('sh') || w.contains('ch')) return '/ʃ/';
    return '/ə/';
  }

  /// Deterministic per-phoneme error-rate estimate (0–1), ordered by how hard
  /// each sound is for Japanese learners of English. Replaces the former random
  /// errorRate so results are reproducible and the weak-pattern breakdown
  /// reflects real difficulty rather than noise.
  static const _phonemeDifficulty = <String, double>{
    '/θ/': 0.9, // "th" — think, through
    '/ð/': 0.85, // voiced "th" — the
    '/r/': 0.8,
    '/l/': 0.8,
    '/v/': 0.7,
    '/f/': 0.6,
    '/ʃ/': 0.6,
    '/ə/': 0.5, // schwa / default
  };

  double _errorRateFor(String phoneme) => _phonemeDifficulty[phoneme] ?? 0.6;

  // ── Fallback (no audio / no API key) ──

  List<ProblemWord> _extractProblemWordsFallback(List<String> words) {
    final commonProblems = <MapEntry<String, String>>[
      const MapEntry('through', '/θ/'),
      const MapEntry('the', '/ð/'),
      const MapEntry('world', '/r/'),
      const MapEntry('really', '/r/ vs /l/'),
      const MapEntry('think', '/θ/'),
      const MapEntry('light', '/l/'),
      const MapEntry('right', '/r/'),
      const MapEntry('very', '/v/'),
    ];

    final found = <ProblemWord>[];
    for (final entry in commonProblems) {
      if (words.any((w) => w.toLowerCase().contains(entry.key)) &&
          found.length < 3) {
        found.add(ProblemWord(
          word: entry.key,
          phoneme: entry.value,
          errorRate: 0.3 + _random.nextDouble() * 0.5,
        ));
      }
    }

    if (found.isEmpty && words.length > 3) {
      found.add(ProblemWord(
        word: words[_random.nextInt(words.length)],
        phoneme: '/r/',
        errorRate: 0.4,
      ));
    }

    return found;
  }

  int _clamp(int score) => score.clamp(0, 100);
}

class _ScoreResult {
  const _ScoreResult({
    required this.pronunciation,
    required this.rhythm,
    required this.intonation,
    required this.problemWords,
  });

  final int pronunciation;
  final int rhythm;
  final int intonation;
  final List<ProblemWord> problemWords;
}
