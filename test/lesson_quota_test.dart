import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/settings/presentation/providers/settings_provider.dart';

void main() {
  group('daily lesson quota', () {
    const today = '2026-07-11';

    test('premium user always has access', () {
      expect(
        SettingsNotifier.computeCanAccess(
          isPremium: true,
          quotaDate: today,
          quotaLessonId: 'lesson-002',
          today: today,
          lessonId: 'lesson-050',
        ),
        isTrue,
      );
    });

    test('free user with no usage today can access', () {
      expect(
        SettingsNotifier.computeCanAccess(
          isPremium: false,
          quotaDate: '2026-07-10',
          quotaLessonId: 'lesson-001',
          today: today,
          lessonId: 'lesson-002',
        ),
        isTrue,
      );
    });

    test('free user can re-enter the same lesson used today', () {
      expect(
        SettingsNotifier.computeCanAccess(
          isPremium: false,
          quotaDate: today,
          quotaLessonId: 'lesson-005',
          today: today,
          lessonId: 'lesson-005',
        ),
        isTrue,
      );
    });

    test('free user is blocked from a different lesson after using quota', () {
      expect(
        SettingsNotifier.computeCanAccess(
          isPremium: false,
          quotaDate: today,
          quotaLessonId: 'lesson-005',
          today: today,
          lessonId: 'lesson-006',
        ),
        isFalse,
      );
    });

    test('free user with empty quota can access', () {
      expect(
        SettingsNotifier.computeCanAccess(
          isPremium: false,
          quotaDate: '',
          quotaLessonId: null,
          today: today,
          lessonId: 'lesson-001',
        ),
        isTrue,
      );
    });

    test('todayString is zero-padded yyyy-MM-dd', () {
      expect(SettingsNotifier.todayString(DateTime(2026, 3, 5)), '2026-03-05');
      expect(SettingsNotifier.todayString(DateTime(2026, 12, 25)), '2026-12-25');
    });
  });
}
