import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../../shared/utils/score_utils.dart';
import '../../../lesson/presentation/providers/lesson_provider.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  static const _categories = [
    'すべて',
    'ニュース',
    'ビジネス',
    '日常会話',
    'TEDスタイル',
    'スポーツ',
    '時事ネタ',
  ];

  // FIXED: ソート種別のラベルマップを定義
  static const _sortLabels = {
    LessonSortType.defaultOrder: 'デフォルト',
    LessonSortType.difficultyAsc: '難易度順',
    LessonSortType.bestScore: 'スコア順',
    LessonSortType.recentPractice: '最近の練習',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedDifficulty = ref.watch(selectedDifficultyProvider);
    final filteredLessons = ref.watch(filteredLessonsProvider);
    final bookmarkOnly = ref.watch(bookmarkFilterProvider);
    final sortType = ref.watch(lessonSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ライブラリ', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(
              context: context,
              delegate: _LessonSearchDelegate(ref),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final selected = cat == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => ref
                        .read(selectedCategoryProvider.notifier)
                        .state = cat,
                  ),
                );
              }).toList(),
            ),
          ),

          // Difficulty filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('すべて')),
                ButtonSegment(value: 1, label: Text('初級')),
                ButtonSegment(value: 2, label: Text('中級')),
                ButtonSegment(value: 3, label: Text('上級')),
              ],
              selected: {selectedDifficulty},
              onSelectionChanged: (v) => ref
                  .read(selectedDifficultyProvider.notifier)
                  .state = v.first,
            ),
          ),
          const SizedBox(height: 8),

          // FIXED: ソート & ブックマークフィルタ行を追加
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Bookmark toggle
                FilterChip(
                  avatar: Icon(
                    bookmarkOnly ? Icons.bookmark : Icons.bookmark_border,
                    size: 18,
                    color: bookmarkOnly
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  label: const Text('ブックマーク'),
                  selected: bookmarkOnly,
                  onSelected: (_) => ref
                      .read(bookmarkFilterProvider.notifier)
                      .state = !bookmarkOnly,
                ),
                const Spacer(),
                // Sort dropdown
                DropdownButtonHideUnderline(
                  child: DropdownButton<LessonSortType>(
                    value: sortType,
                    icon: const Icon(Icons.sort, size: 20),
                    isDense: true,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    items: LessonSortType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_sortLabels[type]!),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(lessonSortProvider.notifier).state = v;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Lesson list
          Expanded(
            child: filteredLessons.isEmpty
                ? Center(
                    child: Text(
                      bookmarkOnly
                          ? 'ブックマークしたレッスンがありません'
                          : '該当するレッスンがありません',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredLessons.length,
                    itemBuilder: (context, index) {
                      final lesson = filteredLessons[index];
                      final latestFeedback = ref
                          .watch(feedbackRepositoryProvider)
                          .findLatestByLessonId(lesson.id);
                      // FIXED: 練習回数を取得
                      final practiceCount = ref
                          .watch(lessonPracticeCountProvider(lesson.id));
                      return Hero(
                        tag: 'lesson-${lesson.id}',
                        child: Card(
                        elevation: 1,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () =>
                              context.go('/lesson/${lesson.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.headphones,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lesson.title,
                                        style:
                                            theme.textTheme.titleSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_formatDuration(lesson.durationSeconds)} • ${_calcWpm(lesson.wordCount, lesson.durationSeconds)} WPM',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: theme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          _DifficultyDots(
                                            level: lesson.difficulty,
                                            theme: theme,
                                          ),
                                          // FIXED: 練習回数バッジを追加
                                          if (practiceCount > 0) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 1),
                                              decoration: BoxDecoration(
                                                color: theme.colorScheme
                                                    .secondary
                                                    .withValues(alpha: 0.12),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize:
                                                    MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.mic,
                                                    size: 12,
                                                    color: theme.colorScheme
                                                        .secondary,
                                                  ),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    '$practiceCount回',
                                                    style: theme
                                                        .textTheme.labelSmall
                                                        ?.copyWith(
                                                      color: theme
                                                          .colorScheme
                                                          .secondary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                          const Spacer(),
                                          if (latestFeedback != null)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: ScoreUtils.scoreColor(
                                                  latestFeedback
                                                      .overallScore,
                                                  theme.colorScheme,
                                                ).withValues(alpha: 0.15),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                              ),
                                              child: Text(
                                                '${latestFeedback.overallScore}点',
                                                style: theme
                                                    .textTheme.labelSmall
                                                    ?.copyWith(
                                                  color:
                                                      ScoreUtils.scoreColor(
                                                    latestFeedback
                                                        .overallScore,
                                                    theme.colorScheme,
                                                  ),
                                                  fontWeight:
                                                      FontWeight.w700,
                                                ),
                                              ),
                                            )
                                          else if (lesson.isCompleted)
                                            Icon(
                                              Icons.check_circle,
                                              size: 16,
                                              color: theme
                                                  .colorScheme.tertiary,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    lesson.isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                  onPressed: () => ref
                                      .read(lessonsProvider.notifier)
                                      .toggleBookmark(lesson.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  int _calcWpm(int wordCount, int durationSeconds) {
    if (durationSeconds <= 0) return 0;
    return (wordCount / durationSeconds * 60).round();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _DifficultyDots extends StatelessWidget {
  const _DifficultyDots({required this.level, required this.theme});

  final int level;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < level
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

class _LessonSearchDelegate extends SearchDelegate<String> {
  _LessonSearchDelegate(this._ref);

  final WidgetRef _ref;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    _ref.read(searchQueryProvider.notifier).state = query;
    final lessons = _ref.read(filteredLessonsProvider);

    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return ListTile(
          leading: const Icon(Icons.headphones),
          title: Text(lesson.title),
          subtitle: Text(lesson.category),
          onTap: () {
            close(context, lesson.id);
            context.go('/lesson/${lesson.id}');
          },
        );
      },
    );
  }
}
