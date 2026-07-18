import 'dart:async';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/progress/data/progress_merge.dart';
import '../../features/progress/data/repositories/progress_repository.dart';
import 'ai_backend.dart';
import 'progress_backup_service.dart';
import 'stable_id.dart';

/// Best-effort restore of backed-up progress at launch.
///
/// Fetches the server snapshot for this install and merges it into local state
/// (progress-preferring, so nothing is ever downgraded). Runs before the UI
/// reads progress so a reinstall shows the restored numbers immediately. Never
/// blocks startup for long ([timeout]) and never throws.
Future<void> restoreProgressBackup({
  required Box<Map> progressBox,
  required Box<Map> feedbackBox,
  ProgressBackupService? service,
  Duration timeout = const Duration(seconds: 4),
}) async {
  try {
    final backup = service ?? ProgressBackupService(AiBackendConfig());
    if (!backup.isAvailable) return; // no proxy configured → stay fully local
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(kProgressBackupConsentKey) ?? true)) return; // opted out
    final token = await StableId().resolve(prefs);
    final snapshot =
        await backup.fetch(appAccountToken: token).timeout(timeout);
    if (snapshot == null) return; // nothing stored / unreachable

    final repo =
        ProgressRepository(progressBox: progressBox, feedbackBox: feedbackBox);
    final local = repo.getProgress();
    final merged = mergeProgress(local, snapshot.progress);
    if (merged != local) await repo.saveProgress(merged);
    // Converge the server to the merged max (this device may have had more than
    // the server) so the next device / restore sees the true maximum.
    if (merged != snapshot.progress) {
      unawaited(backup.sync(appAccountToken: token, progress: merged));
    }
  } catch (_) {
    // A restore failure must never block or crash startup.
  }
}
