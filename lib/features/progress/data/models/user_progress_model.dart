import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_progress_model.freezed.dart';
part 'user_progress_model.g.dart';

@freezed
class UserProgressModel with _$UserProgressModel {
  const UserProgressModel._();

  const factory UserProgressModel({
    required String userId,
    required int currentStreak,
    required int longestStreak,
    required int totalPracticeMinutes,
    required int completedLessons,
    required DateTime lastPracticeDate,
  }) = _UserProgressModel;

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserProgressModelFromJson(json);
}
