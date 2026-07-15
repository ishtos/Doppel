import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/analytics/day2_tracker.dart';

void main() {
  group('calendarDaysBetween', () {
    test('same calendar day is 0 regardless of time', () {
      expect(
        calendarDaysBetween(DateTime(2026, 7, 16, 23, 59), DateTime(2026, 7, 16, 0, 1)),
        0,
      );
    });

    test('crossing midnight is 1', () {
      expect(
        calendarDaysBetween(DateTime(2026, 7, 15, 23, 0), DateTime(2026, 7, 16, 1, 0)),
        1,
      );
    });

    test('multi-day gap', () {
      expect(calendarDaysBetween(DateTime(2026, 7, 10), DateTime(2026, 7, 16)), 6);
    });
  });

  group('day2ReturnGap', () {
    test('null on the same day (not a return)', () {
      expect(day2ReturnGap(DateTime(2026, 7, 16, 8), DateTime(2026, 7, 16, 20)), isNull);
    });

    test('reports the gap when returning on a later day', () {
      expect(day2ReturnGap(DateTime(2026, 7, 14), DateTime(2026, 7, 16)), 2);
    });

    test('null when last practice is in the future (clock skew)', () {
      expect(day2ReturnGap(DateTime(2026, 7, 17), DateTime(2026, 7, 16)), isNull);
    });
  });
}
