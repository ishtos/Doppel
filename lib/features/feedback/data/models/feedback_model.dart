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
