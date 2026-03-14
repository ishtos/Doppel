import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../data/models/lesson_model.dart';

/// All lessons list provider.
final lessonsProvider =
    StateNotifierProvider<LessonsNotifier, AsyncValue<List<LessonModel>>>(
  (ref) => LessonsNotifier(ref),
);

class LessonsNotifier extends StateNotifier<AsyncValue<List<LessonModel>>> {
  LessonsNotifier(this._ref) : super(const AsyncValue.loading()) {
    load();
  }

  final Ref _ref;

  void load() {
    state = const AsyncValue.loading();
    state = AsyncValue.data(_ref.read(lessonRepositoryProvider).findAll());
  }

  Future<void> toggleBookmark(String id) async {
    await _ref.read(lessonRepositoryProvider).toggleBookmark(id);
    load();
  }
}

/// Single lesson provider by ID.
final lessonByIdProvider =
    Provider.family<LessonModel?, String>((ref, id) {
  return ref.watch(lessonRepositoryProvider).findById(id);
});

/// Filtered lessons provider.
final filteredLessonsProvider = Provider<List<LessonModel>>((ref) {
  final lessons = ref.watch(lessonsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final difficulty = ref.watch(selectedDifficultyProvider);
  final query = ref.watch(searchQueryProvider);

  return lessons.maybeWhen(
    data: (list) {
      var filtered = list;
      if (category != 'すべて') {
        filtered = filtered.where((l) => l.category == category).toList();
      }
      if (difficulty > 0) {
        filtered =
            filtered.where((l) => l.difficulty == difficulty).toList();
      }
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        filtered = filtered
            .where((l) =>
                l.title.toLowerCase().contains(q) ||
                l.transcriptText.toLowerCase().contains(q))
            .toList();
      }
      return filtered;
    },
    orElse: () => [],
  );
});

// Filter state providers
final selectedCategoryProvider = StateProvider<String>((ref) => 'すべて');
final selectedDifficultyProvider = StateProvider<int>((ref) => 0);
final searchQueryProvider = StateProvider<String>((ref) => '');
