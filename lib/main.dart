import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'shared/data/seed_data.dart';
import 'shared/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  final lessonsBox = await Hive.openBox<Map>('lessons');
  await Hive.openBox<Map>('feedbacks');
  await Hive.openBox<Map>('progress');

  // Seed lessons: add any missing seed lessons (idempotent)
  for (final lesson in seedLessons) {
    if (!lessonsBox.containsKey(lesson.id)) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }
  }

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
