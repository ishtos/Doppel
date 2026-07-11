import 'dart:io';

import 'package:doppel/shared/utils/recording_cleanup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('referencedRecordingNames', () {
    test('extracts basenames from userAudioPath, ignoring null/empty', () {
      final feedbacks = <Map>[
        {'userAudioPath': '/var/app/docs/recording_a.m4a'},
        {'userAudioPath': ''},
        {'userAudioPath': null},
        {'lessonId': 'no-audio-key'},
      ];
      expect(referencedRecordingNames(feedbacks), {'recording_a.m4a'});
    });
  });

  group('deleteOrphanRecordings', () {
    late Directory dir;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('doppel_rec_test');
    });

    tearDown(() async {
      if (await dir.exists()) await dir.delete(recursive: true);
    });

    File touch(String name) => File('${dir.path}/$name')..writeAsStringSync('x');

    test('deletes old, unreferenced recordings but keeps referenced ones',
        () async {
      final referenced = touch('recording_keep.m4a');
      final orphan = touch('recording_orphan.m4a');
      final unrelated = touch('notes.txt');

      // Pretend "now" is 2h in the future so the just-created files are older
      // than the 1h age guard and thus eligible for deletion.
      final deleted = await deleteOrphanRecordings(
        dir: dir,
        keepNames: {'recording_keep.m4a'},
        now: DateTime.now().add(const Duration(hours: 2)),
      );

      expect(deleted, 1);
      expect(await orphan.exists(), isFalse);
      expect(await referenced.exists(), isTrue); // referenced → kept
      expect(await unrelated.exists(), isTrue); // not a recording → ignored
    });

    test('keeps recordings newer than the age guard', () async {
      final recent = touch('recording_recent.m4a');

      // Real "now": the file was created moments ago, so it is within the 1h
      // guard and must be left alone.
      final deleted = await deleteOrphanRecordings(
        dir: dir,
        keepNames: const {},
        now: DateTime.now(),
      );

      expect(deleted, 0);
      expect(await recent.exists(), isTrue);
    });

    test('ignores non recording_*.m4a files', () async {
      final other = touch('something.m4a'); // wrong prefix
      final txt = touch('recording_x.txt'); // wrong extension

      final deleted = await deleteOrphanRecordings(
        dir: dir,
        keepNames: const {},
        now: DateTime.now().add(const Duration(hours: 2)),
      );

      expect(deleted, 0);
      expect(await other.exists(), isTrue);
      expect(await txt.exists(), isTrue);
    });
  });
}
