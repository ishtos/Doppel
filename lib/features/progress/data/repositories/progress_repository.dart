import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../feedback/data/models/feedback_model.dart';
import '../../../feedback/data/repositories/feedback_repository.dart';
import '../models/user_progress_model.dart';

class ProgressRepository {
  ProgressRepository({
    required this.progressBox,
    required this.feedbackBox,
  });

  final Box<Map> progressBox;
  final Box<Map> feedbackBox;

  static const _defaultUserId = 'default';

  UserProgressModel getProgress() {
    final raw = progressBox.get(_defaultUserId);
    if (raw == null) {
      return UserProgressModel(
        userId: _defaultUserId,
        currentStreak: 0,
        longestStreak: 0,
        totalPracticeMinutes: 0,
        completedLessons: 0,
        lastPracticeDate: DateTime.now(),
      );
    }
    return UserProgressModel.fromJson(Map<String, dynamic>.from(raw));
  }

  Future<void> saveProgress(UserProgressModel progress) async {
    await progressBox.put(progress.userId, progress.toJson());
  }

  Future<void> recordPractice({required int durationMinutes}) async {
    final current = getProgress();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDate = current.lastPracticeDate;
    final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);

    final daysDiff = today.difference(lastDay).inDays;

    // Same day: keep streak, just update minutes/count
    // Next day: increment streak
    // Gap > 1 day: reset streak to 1
    final int newStreak;
    if (daysDiff == 0) {
      newStreak = current.currentStreak == 0 ? 1 : current.currentStreak;
    } else if (daysDiff == 1) {
      newStreak = current.currentStreak + 1;
    } else {
      newStreak = 1;
    }

    final updated = current.copyWith(
      currentStreak: newStreak,
      longestStreak:
          newStreak > current.longestStreak ? newStreak : current.longestStreak,
      totalPracticeMinutes:
          current.totalPracticeMinutes + durationMinutes,
      completedLessons: current.completedLessons + 1,
      lastPracticeDate: now,
    );

    await saveProgress(updated);
  }

  /// Get score history from feedback data for chart display.
  List<FeedbackModel> getScoreHistory({int days = 7}) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return feedbackBox.values
        .map((e) => FeedbackModel.fromJson(FeedbackRepository.deepCast(e)))
        .where((f) => f.createdAt.isAfter(cutoff))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  /// Analyze weak pronunciation patterns from recent feedback.
  Map<String, double> getWeakPatterns() {
    final feedbacks = feedbackBox.values
        .map((e) => FeedbackModel.fromJson(FeedbackRepository.deepCast(e)))
        .toList();

    final patternCounts = <String, List<double>>{};
    for (final fb in feedbacks) {
      for (final pw in fb.problemWords) {
        patternCounts.putIfAbsent(pw.phoneme, () => []).add(pw.errorRate);
      }
    }

    return patternCounts.map(
      (key, values) =>
          MapEntry(key, values.reduce((a, b) => a + b) / values.length),
    );
  }
}
