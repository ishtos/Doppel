import '../../features/lesson/data/models/lesson_model.dart';

const seedLessons = [
  LessonModel(
    id: 'lesson-001',
    title: 'Morning News Report',
    category: 'ニュース',
    difficulty: 1,
    transcriptText:
        'Good morning. Today we look at the latest developments in technology. '
        'The world of artificial intelligence continues to grow rapidly. '
        'New breakthroughs are being made every day, changing the way we live and work.',
    audioAssetPath: 'assets/audio/lesson_001.mp3',
    durationSeconds: 150,
    wordCount: 85,
  ),
  LessonModel(
    id: 'lesson-002',
    title: 'Business Meeting Basics',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'Thank you for joining this meeting today. '
        'I would like to go through the agenda quickly. '
        'First, we will review last quarter\'s results. '
        'Then, we will discuss our strategy for the next quarter. '
        'Finally, I\'d like to hear your thoughts on the new project proposal.',
    audioAssetPath: 'assets/audio/lesson_002.mp3',
    durationSeconds: 180,
    wordCount: 110,
  ),
  LessonModel(
    id: 'lesson-003',
    title: 'At the Coffee Shop',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'Hi, could I get a large latte please? '
        'Actually, make that a medium. And could I have it with oat milk? '
        'Sure, that sounds great. Do you have any pastries left?',
    audioAssetPath: 'assets/audio/lesson_003.mp3',
    durationSeconds: 105,
    wordCount: 60,
  ),
  LessonModel(
    id: 'lesson-004',
    title: 'TED: The Power of Habit',
    category: 'TEDスタイル',
    difficulty: 3,
    transcriptText:
        'Every habit has three components: a cue, a routine, and a reward. '
        'Understanding this loop is the key to changing your behavior. '
        'When you identify the cue that triggers a habit, '
        'you can consciously choose a different routine '
        'while still getting the reward your brain craves. '
        'This is really the fundamental principle behind habit formation.',
    audioAssetPath: 'assets/audio/lesson_004.mp3',
    durationSeconds: 240,
    wordCount: 150,
  ),
  LessonModel(
    id: 'lesson-005',
    title: 'Travel Conversations',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'Excuse me, could you tell me how to get to the train station? '
        'Go straight ahead and turn right at the traffic light. '
        'It\'s about a five minute walk from here. '
        'Thank you very much for your help.',
    audioAssetPath: 'assets/audio/lesson_005.mp3',
    durationSeconds: 90,
    wordCount: 55,
  ),
  LessonModel(
    id: 'lesson-006',
    title: 'Product Presentation',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'I\'m very excited to introduce our latest product today. '
        'This solution addresses the key challenges that our customers have been facing. '
        'Let me walk you through the main features and benefits. '
        'As you can see, the interface is intuitive and user-friendly.',
    audioAssetPath: 'assets/audio/lesson_006.mp3',
    durationSeconds: 200,
    wordCount: 95,
  ),
  LessonModel(
    id: 'lesson-007',
    title: 'Breaking News: Economy',
    category: 'ニュース',
    difficulty: 2,
    transcriptText:
        'In economic news today, the central bank announced a change in interest rates. '
        'This decision is expected to have a significant impact on the housing market. '
        'Analysts suggest that consumers should think carefully about their financial plans.',
    audioAssetPath: 'assets/audio/lesson_007.mp3',
    durationSeconds: 160,
    wordCount: 90,
  ),
  LessonModel(
    id: 'lesson-008',
    title: 'TED: Creative Thinking',
    category: 'TEDスタイル',
    difficulty: 3,
    transcriptText:
        'Creativity is not a talent that some people have and others don\'t. '
        'It\'s a skill that can be developed through practice and persistence. '
        'The most innovative thinkers in history shared one common trait: '
        'they were not afraid to fail. They embraced failure as a necessary step '
        'in the creative process and used it to fuel their next breakthrough.',
    audioAssetPath: 'assets/audio/lesson_008.mp3',
    durationSeconds: 260,
    wordCount: 160,
  ),
];
