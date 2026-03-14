import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../features/feedback/data/models/feedback_model.dart';
import 'ai_coach_service.dart';

final speechAnalysisServiceProvider = Provider<SpeechAnalysisService>((ref) {
  return SpeechAnalysisService(ref.watch(aiCoachServiceProvider));
});

/// Analyzes user recordings and generates feedback.
///
/// Current implementation uses simulated scoring.
/// Production version will integrate Google Cloud Speech-to-Text
/// for real pronunciation analysis.
class SpeechAnalysisService {
  SpeechAnalysisService(this._aiCoach);

  final AiCoachService _aiCoach;
  final _random = Random();

  /// Analyze a user recording against the model transcript.
  Future<FeedbackModel> analyze({
    required String lessonId,
    required String modelTranscript,
    required String? userAudioPath,
  }) async {
    // In production: Speech-to-Text → comparison → scoring
    // For MVP: simulate realistic scores with slight variation

    final baseScore = 60 + _random.nextInt(30); // 60-89

    final pronunciationScore = _clamp(baseScore + _random.nextInt(11) - 5);
    final rhythmScore = _clamp(baseScore + _random.nextInt(11) - 5);
    final intonationScore = _clamp(baseScore + _random.nextInt(11) - 5);

    // Extract sample problem words from transcript
    final words = modelTranscript.split(RegExp(r'\s+'));
    final problemWords = _extractProblemWords(words);

    // Generate AI coach message
    final coachMessage = await _aiCoach.generateFeedback(
      pronunciationScore: pronunciationScore,
      rhythmScore: rhythmScore,
      intonationScore: intonationScore,
      problemWords: problemWords.map((pw) => pw.word).toList(),
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
      coachMessage: coachMessage,
      createdAt: DateTime.now(),
    );
  }

  List<ProblemWord> _extractProblemWords(List<String> words) {
    // Simulate finding 2-4 problem words
    // In production, this would compare phonemes from Speech-to-Text
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

    // If no matches, return a generic one
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
