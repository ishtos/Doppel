import 'package:freezed_annotation/freezed_annotation.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

@freezed
class LessonModel with _$LessonModel {
  const LessonModel._();

  const factory LessonModel({
    required String id,
    required String title,
    required String category,
    required int difficulty,
    required String transcriptText,
    required String audioAssetPath,
    required int durationSeconds,
    required int wordCount,
    @Default(false) bool isBookmarked,
    @Default(false) bool isCompleted,
    DateTime? lastPracticedAt,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}
