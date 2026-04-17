import 'package:flutter/material.dart';

enum AchievementCategory { practice, streak, score, explore }

class AchievementDef {
  const AchievementDef({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.target,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final AchievementCategory category;
  final int target;
}

const kAchievements = <AchievementDef>[
  // Practice milestones
  AchievementDef(
    id: 'practice_1',
    title: '初めの一歩',
    description: '最初の練習を完了する',
    icon: Icons.emoji_events,
    category: AchievementCategory.practice,
    target: 1,
  ),
  AchievementDef(
    id: 'practice_5',
    title: '練習生',
    description: '5回練習を完了する',
    icon: Icons.fitness_center,
    category: AchievementCategory.practice,
    target: 5,
  ),
  AchievementDef(
    id: 'practice_10',
    title: '努力家',
    description: '10回練習を完了する',
    icon: Icons.military_tech,
    category: AchievementCategory.practice,
    target: 10,
  ),
  AchievementDef(
    id: 'practice_25',
    title: 'ベテラン',
    description: '25回練習を完了する',
    icon: Icons.workspace_premium,
    category: AchievementCategory.practice,
    target: 25,
  ),
  AchievementDef(
    id: 'practice_50',
    title: 'マスター',
    description: '50回練習を完了する',
    icon: Icons.diamond,
    category: AchievementCategory.practice,
    target: 50,
  ),

  // Streak milestones
  AchievementDef(
    id: 'streak_3',
    title: '3日坊主じゃない',
    description: '3日連続で練習する',
    icon: Icons.local_fire_department,
    category: AchievementCategory.streak,
    target: 3,
  ),
  AchievementDef(
    id: 'streak_7',
    title: '1週間の習慣',
    description: '7日連続で練習する',
    icon: Icons.whatshot,
    category: AchievementCategory.streak,
    target: 7,
  ),
  AchievementDef(
    id: 'streak_14',
    title: '2週間の継続',
    description: '14日連続で練習する',
    icon: Icons.bolt,
    category: AchievementCategory.streak,
    target: 14,
  ),
  AchievementDef(
    id: 'streak_30',
    title: '1ヶ月の達人',
    description: '30日連続で練習する',
    icon: Icons.auto_awesome,
    category: AchievementCategory.streak,
    target: 30,
  ),

  // Score milestones
  AchievementDef(
    id: 'score_80',
    title: '好スコア',
    description: 'スコア80点以上を獲得する',
    icon: Icons.star,
    category: AchievementCategory.score,
    target: 80,
  ),
  AchievementDef(
    id: 'score_95',
    title: '完璧主義者',
    description: 'スコア95点以上を獲得する',
    icon: Icons.stars,
    category: AchievementCategory.score,
    target: 95,
  ),

  // Explore milestones
  AchievementDef(
    id: 'all_categories',
    title: '全カテゴリ制覇',
    description: '全6カテゴリのレッスンで練習する',
    icon: Icons.explore,
    category: AchievementCategory.explore,
    target: 6,
  ),
  AchievementDef(
    id: 'bookmark_first',
    title: 'お気に入り発見',
    description: 'レッスンをブックマークする',
    icon: Icons.bookmark,
    category: AchievementCategory.explore,
    target: 1,
  ),
];

String achievementCategoryLabel(AchievementCategory category) {
  switch (category) {
    case AchievementCategory.practice:
      return '練習回数';
    case AchievementCategory.streak:
      return '連続記録';
    case AchievementCategory.score:
      return 'スコア';
    case AchievementCategory.explore:
      return '探索';
  }
}
