import 'package:flutter_test/flutter_test.dart';

import 'package:doppel/features/lesson/presentation/providers/shadowing_session_provider.dart';

void main() {
  group('ShadowingSessionState record mode', () {
    test('defaults to whole mode and cannot score yet', () {
      const s = ShadowingSessionState(chunks: ['a', 'b']);
      expect(s.recordMode, RecordMode.whole);
      expect(s.canScore, isFalse);
    });

    test('whole mode: canScore only after a whole recording', () {
      const s = ShadowingSessionState(chunks: ['a', 'b']);
      expect(s.canScore, isFalse);
      final recorded =
          s.copyWith(wholeRecorded: true, wholeRecordingPath: '/tmp/x.m4a');
      expect(recorded.canScore, isTrue);
    });

    test('perChunk mode: canScore after at least one chunk recorded', () {
      final s = const ShadowingSessionState(chunks: ['a', 'b'])
          .copyWith(recordMode: RecordMode.perChunk);
      expect(s.canScore, isFalse);

      final withChunk = s.copyWith(statuses: {0: ChunkStatus.recorded});
      expect(withChunk.canScore, isTrue);

      // A whole recording must NOT enable scoring while in per-chunk mode.
      final wholeOnly = s.copyWith(wholeRecorded: true);
      expect(wholeOnly.canScore, isFalse);
    });

    test('clearWholeRecording resets the path and score eligibility', () {
      final s = const ShadowingSessionState()
          .copyWith(wholeRecordingPath: '/tmp/x.m4a', wholeRecorded: true);
      expect(s.wholeRecordingPath, isNotNull);
      expect(s.canScore, isTrue);

      final cleared =
          s.copyWith(clearWholeRecording: true, wholeRecorded: false);
      expect(cleared.wholeRecordingPath, isNull);
      expect(cleared.canScore, isFalse);
    });
  });

  group('ShadowingSessionState isTextHidden (per-line visibility)', () {
    const chunks = ['a', 'b', 'c'];

    test('default: master off, no overrides → every line shown', () {
      const s = ShadowingSessionState(chunks: chunks);
      expect(s.isTextHidden(0), isFalse);
      expect(s.isTextHidden(1), isFalse);
      expect(s.isTextHidden(2), isFalse);
    });

    test('master on, no overrides → every line hidden', () {
      const s = ShadowingSessionState(chunks: chunks, hideText: true);
      expect(s.isTextHidden(0), isTrue);
      expect(s.isTextHidden(2), isTrue);
    });

    test('master off + override reveals-as-hide: only that line hidden', () {
      const s = ShadowingSessionState(chunks: chunks, hiddenOverrides: {1});
      expect(s.isTextHidden(0), isFalse);
      expect(s.isTextHidden(1), isTrue); // flipped from shown → hidden
      expect(s.isTextHidden(2), isFalse);
    });

    test('master on + override: that line is revealed, rest stay hidden', () {
      const s = ShadowingSessionState(
        chunks: chunks,
        hideText: true,
        hiddenOverrides: {1},
      );
      expect(s.isTextHidden(0), isTrue);
      expect(s.isTextHidden(1), isFalse); // flipped from hidden → shown
      expect(s.isTextHidden(2), isTrue);
    });
  });

  group('readAlongMillis', () {
    test('scales with word count and WPM (10 words @ 100 wpm = 6s)', () {
      expect(readAlongMillis('a b c d e f g h i j', 100), 6000);
    });

    test('clamps very short chunks up to the 700ms minimum', () {
      expect(readAlongMillis('hi', 600), 700); // 1/600*60000 = 100 → 700
    });

    test('clamps very long chunks down to the 20s maximum', () {
      final long = List.filled(500, 'word').join(' ');
      expect(readAlongMillis(long, 10), 20000);
    });

    test('non-positive wpm yields 0 (no auto-advance)', () {
      expect(readAlongMillis('a b c', 0), 0);
    });
  });
}
