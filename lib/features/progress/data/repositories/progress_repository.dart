import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../feedback/data/models/feedback_model.dart';
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
    final lastDate = current.lastPracticeDate;

    final isConsecutiveDay = now.difference(lastDate).inDays == 1 ||
        (now.day != lastDate.day && now.difference(lastDate).inHours < 48);

    final newStreak = isConsecutiveDay ? current.currentStreak + 1 : 1;

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
        .map((e) => FeedbackModel.fromJson(Map<String, dynamic>.from(e)))
        .where((f) => f.createdAt.isAfter(cutoff))
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  /// Analyze weak pronunciation patterns from recent feedback.
  Map<String, double> getWeakPatterns() {
    final feedbacks = feedbackBox.values
        .map((e) => FeedbackModel.fromJson(Map<String, dynamic>.from(e)))
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
