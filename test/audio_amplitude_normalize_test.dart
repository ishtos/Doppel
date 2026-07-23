import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/shared/services/audio_service.dart';

void main() {
  group('normalizeAmplitude', () {
    test('silence floor (-50 dB) and below maps to 0', () {
      expect(normalizeAmplitude(-50), 0.0);
      expect(normalizeAmplitude(-80), 0.0);
      expect(normalizeAmplitude(-160), 0.0);
    });

    test('0 dBFS (max) maps to 1 and clamps above', () {
      expect(normalizeAmplitude(0), 1.0);
      expect(normalizeAmplitude(5), 1.0);
    });

    test('midpoint (-25 dB) maps to ~0.5', () {
      expect(normalizeAmplitude(-25), closeTo(0.5, 1e-9));
    });

    test('non-finite inputs map to 0 (no NaN leaking into the UI)', () {
      expect(normalizeAmplitude(double.nan), 0.0);
      expect(normalizeAmplitude(double.infinity), 0.0);
      expect(normalizeAmplitude(double.negativeInfinity), 0.0);
    });
  });
}
