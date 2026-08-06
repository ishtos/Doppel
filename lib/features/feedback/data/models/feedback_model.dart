import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

@freezed
class FeedbackModel with _$FeedbackModel {
  const FeedbackModel._();

  const factory FeedbackModel({
    required String id,
    required String lessonId,
    required int overallScore,
    required int pronunciationScore,
    required int rhythmScore,
    required int intonationScore,
    required List<ProblemWord> problemWords,
    required String coachMessage,
    required DateTime createdAt,
    String? userTranscript,
    String? modelTranscript,
    String? userAudioPath,
    // True when the coach message is a local fallback because a cloud call was
    // attempted and failed (not the by-design offline case).
    @Default(false) bool coachIsFallback,
    // Non-null only when cloud transcription was attempted but failed (so scores
    // are simulated). Carries the cause (e.g. `http_401`, `network`) so the
    // fallback is diagnosable instead of a silent degrade. Null for the
    // by-design offline / consent-off case and for successful cloud scoring.
    String? analysisError,
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
}

@freezed
class ProblemWord with _$ProblemWord {
  const factory ProblemWord({
    required String word,
    required String phoneme,
    required double errorRate,
  }) = _ProblemWord;

  factory ProblemWord.fromJson(Map<String, dynamic> json) =>
      _$ProblemWordFromJson(json);
}
