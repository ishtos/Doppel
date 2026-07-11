import 'dart:io';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Cleanup for orphaned user-recording files.
///
/// Recordings are written to the app documents directory as
/// `recording_<uuid>.m4a` and are only referenced afterwards when a scored
/// feedback keeps one as its `userAudioPath` (for replay). Everything else —
/// abandoned sessions, and the non-representative chunks of a per-chunk take —
/// is dead weight that would otherwise accumulate forever. This prunes it.

/// Filenames of recordings still referenced by a saved feedback, so they are
/// kept. Matches on basename (not full path) because a mobile app's documents
/// directory can move between launches while the file name is stable.
Set<String> referencedRecordingNames(Iterable<Map> feedbacks) {
  final names = <String>{};
  for (final raw in feedbacks) {
    final path = raw['userAudioPath'];
    if (path is String && path.isNotEmpty) {
      names.add(path.split('/').last);
    }
  }
  return names;
}

/// Delete `recording_*.m4a` files in [dir] whose name is not in [keepNames] and
/// that are older than [minAge] (the age guard avoids removing a file from a
/// session that may still be in progress). Best-effort: never throws; returns
/// how many files were deleted.
Future<int> deleteOrphanRecordings({
  required Directory dir,
  required Set<String> keepNames,
  Duration minAge = const Duration(hours: 1),
  DateTime? now,
}) async {
  var deleted = 0;
  try {
    final cutoff = (now ?? DateTime.now()).subtract(minAge);
    await for (final entity in dir.list()) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      if (!name.startsWith('recording_') || !name.endsWith('.m4a')) continue;
      if (keepNames.contains(name)) continue;
      try {
        final stat = await entity.stat();
        if (stat.modified.isAfter(cutoff)) continue; // too new — leave it
        await entity.delete();
        deleted++;
      } catch (_) {
        // Skip files we can't stat/delete.
      }
    }
  } catch (_) {
    // Never let cleanup interfere with app startup.
  }
  return deleted;
}

/// App-startup convenience: prune orphan recordings using the feedback box and
/// the real documents directory.
Future<void> cleanupOrphanRecordings(Box<Map> feedbackBox) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    await deleteOrphanRecordings(
      dir: dir,
      keepNames: referencedRecordingNames(feedbackBox.values),
    );
  } catch (_) {
    // Best-effort.
  }
}
