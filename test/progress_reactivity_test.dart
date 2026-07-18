import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import 'package:doppel/features/home/presentation/providers/home_provider.dart';
import 'package:doppel/features/progress/data/models/user_progress_model.dart';
import 'package:doppel/shared/providers/db_providers.dart';

// Regression for the "streak doesn't update after a lesson until relaunch" bug:
// the home/progress read-providers must recompute when the Hive box changes.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Box<Map> progressBox;
  late Box<Map> feedbackBox;

  UserProgressModel u(int completed) => UserProgressModel(
        userId: 'default',
        currentStreak: 1,
        longestStreak: 1,
        totalPracticeMinutes: completed * 3,
        completedLessons: completed,
        lastPracticeDate: DateTime(2026, 7, 18),
      );

  setUp(() async {
    Hive.init('./test_hive_reactivity');
    progressBox = await Hive.openBox<Map>('progress');
    feedbackBox = await Hive.openBox<Map>('feedbacks');
    await progressBox.clear();
    await feedbackBox.clear();
  });

  tearDown(() async {
    await progressBox.clear();
    await feedbackBox.clear();
    await Hive.close();
  });

  test('homeProgressProvider recomputes when the progress box changes', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final repo = container.read(progressRepositoryProvider);
    await repo.saveProgress(u(1));

    // Keep the provider (and its box-revision dependency) alive and observe it.
    final updated = Completer<int>();
    final sub = container.listen<UserProgressModel>(homeProgressProvider,
        (prev, next) {
      if (next.completedLessons == 2 && !updated.isCompleted) {
        updated.complete(next.completedLessons);
      }
    });
    addTearDown(sub.close);

    expect(container.read(homeProgressProvider).completedLessons, 1);

    // A write to the box must propagate to the provider without a relaunch.
    await repo.saveProgress(u(2));

    final result = await updated.future.timeout(const Duration(seconds: 2));
    expect(result, 2);
    expect(container.read(homeProgressProvider).completedLessons, 2);
  });
}
