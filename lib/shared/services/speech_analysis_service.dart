import '../../features/feedback/data/models/feedback_model.dart';

/// Analyzes user recordings and generates feedback.
///
/// Pipeline: Recording -> Speech-to-Text -> Score calculation -> AI coach message.
/// Full implementation in Phase B.
class SpeechAnalysisService {
  Future<FeedbackModel> analyze({
    required String lessonId,
    required String modelTranscript,
    required String userAudioPath,
  }) async {
    // TODO: Implement Speech-to-Text integration
    // TODO: Implement pronunciation scoring
    // TODO: Implement rhythm scoring
    // TODO: Implement intonation scoring
    // TODO: Implement problem word extraction
    throw UnimplementedError('Speech analysis not yet implemented');
  }
}
