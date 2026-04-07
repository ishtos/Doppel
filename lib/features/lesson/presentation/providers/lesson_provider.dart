import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../data/models/lesson_model.dart';

// FIXED: ソート種別を enum で明示的に定義
enum LessonSortType {
  defaultOrder,
  difficultyAsc,
  bestScore,
  recentPractice,
}

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

/// Practice count per lesson (number of feedback records).
final lessonPracticeCountProvider =
    Provider.family<int, String>((ref, lessonId) {
  final feedbackRepo = ref.watch(feedbackRepositoryProvider);
  return feedbackRepo.findByLessonId(lessonId).length;
});

/// Filtered lessons provider.
final filteredLessonsProvider = Provider<List<LessonModel>>((ref) {
  final lessons = ref.watch(lessonsProvider);
  final category = ref.watch(selectedCategoryProvider);
  final difficulty = ref.watch(selectedDifficultyProvider);
  final query = ref.watch(searchQueryProvider);
  // FIXED: ブックマークフィルタとソートを追加
  final bookmarkOnly = ref.watch(bookmarkFilterProvider);
  final sortType = ref.watch(lessonSortProvider);

  return lessons.maybeWhen(
    data: (list) {
      var filtered = list;
      if (bookmarkOnly) {
        filtered = filtered.where((l) => l.isBookmarked).toList();
      }
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

      // FIXED: ソートロジック
      switch (sortType) {
        case LessonSortType.defaultOrder:
          break;
        case LessonSortType.difficultyAsc:
          filtered = [...filtered]
            ..sort((a, b) => a.difficulty.compareTo(b.difficulty));
        case LessonSortType.bestScore:
          final feedbackRepo = ref.read(feedbackRepositoryProvider);
          filtered = [...filtered]..sort((a, b) {
              final aFb = feedbackRepo.findLatestByLessonId(a.id);
              final bFb = feedbackRepo.findLatestByLessonId(b.id);
              final aScore = aFb?.overallScore ?? -1;
              final bScore = bFb?.overallScore ?? -1;
              return bScore.compareTo(aScore);
            });
        case LessonSortType.recentPractice:
          filtered = [...filtered]..sort((a, b) {
              final aTime = a.lastPracticedAt ?? DateTime(2000);
              final bTime = b.lastPracticedAt ?? DateTime(2000);
              return bTime.compareTo(aTime);
            });
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
final bookmarkFilterProvider = StateProvider<bool>((ref) => false);
final lessonSortProvider =
    StateProvider<LessonSortType>((ref) => LessonSortType.defaultOrder);
