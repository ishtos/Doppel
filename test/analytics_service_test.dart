import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/analytics/analytics_service.dart';

void main() {
  group('ConsentGatedAnalytics', () {
    test('forwards captures only when enabled', () {
      final sink = InMemoryAnalytics();
      var enabled = false;
      final gated = ConsentGatedAnalytics(sink, () => enabled);

      gated.capture('lesson_started', properties: {'id': 'lesson-001'});
      expect(sink.calls, isEmpty, reason: 'opt-out must drop events');

      enabled = true;
      gated.capture('lesson_started', properties: {'id': 'lesson-001'});
      expect(sink.events, ['lesson_started']);
      expect(sink.calls.single.properties, {'id': 'lesson-001'});
    });

    test('gates identify and flush too', () async {
      final sink = InMemoryAnalytics();
      var enabled = false;
      final gated = ConsentGatedAnalytics(sink, () => enabled);

      gated.identify('token-123');
      expect(sink.distinctId, isNull);

      enabled = true;
      gated.identify('token-123');
      expect(sink.distinctId, 'token-123');

      await gated.flush(); // must not throw
    });

    test('re-evaluates consent on every call', () {
      final sink = InMemoryAnalytics();
      var enabled = true;
      final gated = ConsentGatedAnalytics(sink, () => enabled);

      gated.capture('a');
      enabled = false;
      gated.capture('b');
      enabled = true;
      gated.capture('c');

      expect(sink.events, ['a', 'c'], reason: 'consent is checked per call');
    });
  });

  group('NoopAnalytics', () {
    test('never throws and records nothing observable', () async {
      const noop = NoopAnalytics();
      noop.capture('x', properties: {'k': 1});
      noop.identify('id');
      await noop.flush();
    });
  });
}
