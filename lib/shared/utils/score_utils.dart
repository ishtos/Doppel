import 'package:flutter/material.dart';

class ScoreUtils {
  ScoreUtils._();

  static Color scoreColor(int score, ColorScheme colorScheme) {
    if (score >= 80) return colorScheme.tertiary;
    if (score >= 60) return colorScheme.secondary;
    return colorScheme.error;
  }

  static String scoreLabel(int score) {
    if (score >= 90) return '素晴らしい！';
    if (score >= 80) return 'とても良い';
    if (score >= 70) return '良い';
    if (score >= 60) return 'もう少し';
    return '頑張ろう';
  }
}
