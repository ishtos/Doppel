/// AI coaching service using Claude API.
///
/// Generates personalized feedback messages based on analysis results.
/// Full implementation in Phase B.
class AiCoachService {
  Future<String> generateFeedback({
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<String> problemWords,
  }) async {
    // TODO: Implement Claude API integration
    throw UnimplementedError('AI coach service not yet implemented');
  }

  Future<String> generateWeeklyReview({
    required int averageScore,
    required int practiceCount,
    required List<String> weakPatterns,
  }) async {
    // TODO: Implement weekly review generation
    throw UnimplementedError('Weekly review not yet implemented');
  }
}
