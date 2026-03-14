import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _selectedCategory = 'すべて';
  int _selectedDifficulty = 0; // 0 = all

  static const _categories = ['すべて', 'ニュース', 'ビジネス', '日常会話', 'TEDスタイル'];

  // Sample data
  static const _sampleLessons = [
    {'title': 'Morning News Report', 'category': 'ニュース', 'difficulty': 1, 'duration': '2:30', 'words': 85},
    {'title': 'Business Meeting Basics', 'category': 'ビジネス', 'difficulty': 2, 'duration': '3:00', 'words': 110},
    {'title': 'Daily Conversation', 'category': '日常会話', 'difficulty': 1, 'duration': '1:45', 'words': 60},
    {'title': 'TED: The Power of Habit', 'category': 'TEDスタイル', 'difficulty': 3, 'duration': '4:00', 'words': 150},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ライブラリ', style: theme.textTheme.titleLarge),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = cat),
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
              selected: {_selectedDifficulty},
              onSelectionChanged: (v) =>
                  setState(() => _selectedDifficulty = v.first),
            ),
          ),
          const SizedBox(height: 8),

          // Lesson list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _sampleLessons.length,
              itemBuilder: (context, index) {
                final lesson = _sampleLessons[index];
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.headphones,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lesson['title'] as String,
                                  style: theme.textTheme.titleSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${lesson['duration']} • ${lesson['words']}語',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                _DifficultyDots(
                                  level: lesson['difficulty'] as int,
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border),
                            onPressed: () {},
                          ),
                        ],
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
