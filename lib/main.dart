import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'shared/data/seed_data.dart';
import 'shared/services/notification_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Hive.initFlutter();
  final lessonsBox = await Hive.openBox<Map>('lessons');
  await Hive.openBox<Map>('feedbacks');
  await Hive.openBox<Map>('progress');

  if (lessonsBox.isEmpty) {
    for (final lesson in seedLessons) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }
  }

  await NotificationService.instance.initialize();

  FlutterNativeSplash.remove();
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
