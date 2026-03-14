import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'shared/data/seed_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  final lessonsBox = await Hive.openBox<Map>('lessons');
  await Hive.openBox<Map>('feedbacks');
  await Hive.openBox<Map>('progress');

  // Seed lessons if empty
  if (lessonsBox.isEmpty) {
    for (final lesson in seedLessons) {
      await lessonsBox.put(lesson.id, lesson.toJson());
    }
  }

  runApp(const ProviderScope(child: DoppelApp()));
}

class DoppelApp extends ConsumerWidget {
  const DoppelApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Doppel',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
