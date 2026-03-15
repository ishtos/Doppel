import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/utils/score_utils.dart';

void main() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1A237E),
    secondary: const Color(0xFFFF8F00),
    tertiary: const Color(0xFF00695C),
    error: const Color(0xFFB71C1C),
  );

  group('ScoreUtils.scoreColor', () {
    test('returns tertiary for score >= 80', () {
      expect(ScoreUtils.scoreColor(80, colorScheme), colorScheme.tertiary);
      expect(ScoreUtils.scoreColor(100, colorScheme), colorScheme.tertiary);
      expect(ScoreUtils.scoreColor(90, colorScheme), colorScheme.tertiary);
    });

    test('returns secondary for score 60-79', () {
      expect(ScoreUtils.scoreColor(60, colorScheme), colorScheme.secondary);
      expect(ScoreUtils.scoreColor(79, colorScheme), colorScheme.secondary);
      expect(ScoreUtils.scoreColor(70, colorScheme), colorScheme.secondary);
    });

    test('returns error for score < 60', () {
      expect(ScoreUtils.scoreColor(59, colorScheme), colorScheme.error);
      expect(ScoreUtils.scoreColor(0, colorScheme), colorScheme.error);
      expect(ScoreUtils.scoreColor(30, colorScheme), colorScheme.error);
    });
  });

  group('ScoreUtils.scoreLabel', () {
    test('returns correct labels for score ranges', () {
      expect(ScoreUtils.scoreLabel(95), '素晴らしい！');
      expect(ScoreUtils.scoreLabel(90), '素晴らしい！');
      expect(ScoreUtils.scoreLabel(85), 'とても良い');
      expect(ScoreUtils.scoreLabel(80), 'とても良い');
      expect(ScoreUtils.scoreLabel(75), '良い');
      expect(ScoreUtils.scoreLabel(70), '良い');
      expect(ScoreUtils.scoreLabel(65), 'もう少し');
      expect(ScoreUtils.scoreLabel(60), 'もう少し');
      expect(ScoreUtils.scoreLabel(50), '頑張ろう');
      expect(ScoreUtils.scoreLabel(0), '頑張ろう');
    });
  });
}
