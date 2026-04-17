import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/data/achievements.dart';
import '../../../../shared/providers/db_providers.dart';

class AchievementStatus {
  const AchievementStatus({
    required this.definition,
    required this.isUnlocked,
    required this.current,
  });

  final AchievementDef definition;
  final bool isUnlocked;
  final int current;

  int get target => definition.target;

  String get progressLabel {
    if (isUnlocked) return '達成！';
    // FIXED: ${target} に中括弧を使い、日本語文字が識別子に含まれるのを防止
    switch (definition.category) {
      case AchievementCategory.practice:
        return '$current/${target}回';
      case AchievementCategory.streak:
        return '$current/${target}日';
      case AchievementCategory.score:
        return '最高${current}点';
      case AchievementCategory.explore:
        if (definition.id == 'bookmark_first') {
          return current > 0 ? '達成！' : '未達成';
        }
        return '$current/${target}カテゴリ';
    }
  }
}

final achievementsProvider = Provider<List<AchievementStatus>>((ref) {
  final progress = ref.watch(progressRepositoryProvider).getProgress();
  final feedbacks = ref.watch(feedbackRepositoryProvider).findAll();
  final lessons = ref.watch(lessonRepositoryProvider).findAll();

  final maxScore = feedbacks.isEmpty
      ? 0
      : feedbacks.map((f) => f.overallScore).reduce((a, b) => a > b ? a : b);

  final practicedLessonIds = feedbacks.map((f) => f.lessonId).toSet();
  final practicedCategories = <String>{};
  for (final lessonId in practicedLessonIds) {
    final lesson = lessons.where((l) => l.id == lessonId).firstOrNull;
    if (lesson != null) {
      practicedCategories.add(lesson.category);
    }
  }

  final bookmarkedCount = lessons.where((l) => l.isBookmarked).length;

  return kAchievements.map((def) {
    final (current, unlocked) = _evaluate(
      def,
      completedLessons: progress.completedLessons,
      longestStreak: progress.longestStreak,
      maxScore: maxScore,
      practicedCategoryCount: practicedCategories.length,
      bookmarkedCount: bookmarkedCount,
    );
    return AchievementStatus(
      definition: def,
      isUnlocked: unlocked,
      current: current,
    );
  }).toList();
});

final unlockedCountProvider = Provider<int>((ref) {
  return ref.watch(achievementsProvider).where((a) => a.isUnlocked).length;
});

(int, bool) _evaluate(
  AchievementDef def, {
  required int completedLessons,
  required int longestStreak,
  required int maxScore,
  required int practicedCategoryCount,
  required int bookmarkedCount,
}) {
  switch (def.id) {
    case 'practice_1':
    case 'practice_5':
    case 'practice_10':
    case 'practice_25':
    case 'practice_50':
      return (completedLessons, completedLessons >= def.target);

    case 'streak_3':
    case 'streak_7':
    case 'streak_14':
    case 'streak_30':
      return (longestStreak, longestStreak >= def.target);

    case 'score_80':
    case 'score_95':
      return (maxScore, maxScore >= def.target);

    case 'all_categories':
      return (practicedCategoryCount, practicedCategoryCount >= def.target);

    case 'bookmark_first':
      return (bookmarkedCount, bookmarkedCount >= def.target);

    default:
      return (0, false);
  }
}
