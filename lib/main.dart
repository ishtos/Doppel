import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'shared/data/lesson_seeder.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/progress_backup_startup.dart';
import 'shared/services/purchase_service.dart';
import 'shared/utils/recording_cleanup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  final lessonsBox = await Hive.openBox<Map>('lessons');
  final feedbacksBox = await Hive.openBox<Map>('feedbacks');
  final progressBox = await Hive.openBox<Map>('progress');

  // Remove orphaned recording files (abandoned sessions / non-representative
  // chunks) so they don't accumulate. Best-effort; never blocks startup.
  await cleanupOrphanRecordings(feedbacksBox);

  // Seed new lessons and refresh changed content from the bundle, preserving
  // user state (bookmarks / completion). Lets content updates reach existing
  // installs without a reinstall. See syncSeedLessons for details.
  await syncSeedLessons(lessonsBox);

  // Restore backed-up progress (best-effort) before the UI reads it, so a
  // reinstall / new device shows the user's real progress from the start.
  await restoreProgressBackup(progressBox: progressBox, feedbackBox: feedbacksBox);

  // Initialize notification service
  await NotificationService.instance.initialize();

  runApp(const ProviderScope(child: DoppelApp()));
}

class DoppelApp extends ConsumerWidget {
  const DoppelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    // Keep the purchase controller alive for the whole app so store
    // transactions (e.g. an interrupted or restored purchase) are handled at
    // launch, not only when the paywall is open.
    ref.watch(purchaseControllerProvider);

    return MaterialApp.router(
      title: 'Doppel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
