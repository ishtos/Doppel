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

  // ── スポーツ ──

  LessonModel(
    id: 'lesson-009',
    title: 'World Cup Match Report',
    category: 'スポーツ',
    difficulty: 1,
    transcriptText:
        'Welcome to our sports coverage. Last night\'s World Cup match was absolutely incredible. '
        'The underdog team shocked the world by defeating the reigning champions three to one. '
        'The first goal came from a stunning free kick that sailed over the wall and into the top corner. '
        'The goalkeeper had no chance. Just ten minutes later, a quick counterattack led to the second goal. '
        'Despite a strong comeback effort in the second half, the champions could only manage one consolation goal. '
        'The winning team celebrated wildly as fans across the nation took to the streets.',
    audioAssetPath: 'assets/audio/lesson_009.mp3',
    durationSeconds: 55,
    wordCount: 99,
  ),
  LessonModel(
    id: 'lesson-010',
    title: 'Olympic Sprint Finals',
    category: 'スポーツ',
    difficulty: 2,
    transcriptText:
        'The crowd roared as the eight finalists took their positions on the starting blocks. '
        'The tension was palpable in the stadium. The gun fired and the athletes exploded forward with tremendous power. '
        'Within the first thirty meters, it was clear this would be a historic race. '
        'The defending champion surged ahead, but the young challenger from Jamaica was right on her heels. '
        'As they approached the finish line, the gap narrowed to almost nothing. '
        'In a photo finish that left everyone breathless, the newcomer crossed the line first by just three thousandths of a second. '
        'The stadium erupted in disbelief. A new world record had been set, shattering the previous mark. '
        'The young athlete fell to her knees in tears of joy, unable to believe what she had just accomplished on the world\'s biggest stage.',
    audioAssetPath: 'assets/audio/lesson_010.mp3',
    durationSeconds: 60,
    wordCount: 140,
  ),
  LessonModel(
    id: 'lesson-011',
    title: 'Tennis Grand Slam Commentary',
    category: 'スポーツ',
    difficulty: 3,
    transcriptText:
        'And we are into the fifth set of this absolutely extraordinary Grand Slam final. '
        'Both players have been pushing each other to the absolute limit for nearly four hours now. '
        'The number one seed fires a blistering serve down the center line at two hundred and twenty kilometers per hour. '
        'His opponent somehow gets the racket on it and sends back a deep return. '
        'What follows is a breathtaking thirty-shot rally that has the entire crowd on their feet. '
        'The ball flies back and forth across the net with incredible speed and precision. '
        'Finally, a perfectly placed drop shot catches the defender off guard, and the point is won. '
        'This is tennis at the very highest level. The atmosphere here at Centre Court is absolutely electric. '
        'Every single point feels like a match point, and neither player is willing to give an inch.',
    audioAssetPath: 'assets/audio/lesson_011.mp3',
    durationSeconds: 60,
    wordCount: 153,
  ),

  // ── 時事ネタ ──

  LessonModel(
    id: 'lesson-012',
    title: 'Climate Change Summit',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText:
        'World leaders gathered in Geneva this week for the annual climate summit. '
        'The latest scientific report paints a concerning picture. Global temperatures have risen significantly since pre-industrial times, '
        'and extreme weather events are becoming more frequent and severe. '
        'The summit\'s host called for an immediate fifty percent reduction in carbon emissions by twenty thirty. '
        'Several developing nations pushed back, arguing that wealthier countries should bear a greater share of the burden. '
        'By the end of the week, delegates reached a landmark agreement that includes binding targets for renewable energy adoption.',
    audioAssetPath: 'assets/audio/lesson_012.mp3',
    durationSeconds: 55,
    wordCount: 95,
  ),
  LessonModel(
    id: 'lesson-013',
    title: 'AI and the Future of Work',
    category: '時事ネタ',
    difficulty: 2,
    transcriptText:
        'Artificial intelligence is transforming the workplace at an unprecedented pace. '
        'A new report released this week estimates that forty percent of all jobs worldwide will be affected by AI within the next five years. '
        'However, experts are quick to point out that this doesn\'t necessarily mean mass unemployment. '
        'While some roles will certainly be automated, many new positions are emerging in fields like AI safety, prompt engineering, and data curation. '
        'The real challenge lies in retraining the existing workforce quickly enough to keep up with the pace of change. '
        'Governments around the world are now racing to develop education policies that prepare workers for this new reality. '
        'The consensus among economists is clear: those who adapt will thrive, and those who resist will be left behind.',
    audioAssetPath: 'assets/audio/lesson_013.mp3',
    durationSeconds: 60,
    wordCount: 131,
  ),
  LessonModel(
    id: 'lesson-014',
    title: 'Space Exploration Breakthrough',
    category: '時事ネタ',
    difficulty: 3,
    transcriptText:
        'In a historic achievement that marks a new chapter in human space exploration, the international crew of six astronauts '
        'has successfully completed the first manned mission to Mars orbit. The spacecraft, which departed Earth eleven months ago, '
        'entered a stable orbit around the red planet early this morning. Mission control in Houston erupted in celebration as telemetry data '
        'confirmed the successful orbital insertion. The crew will spend the next thirty days conducting observations and deploying satellites '
        'before beginning the long journey home. The mission commander described the view of Mars from orbit as beyond anything she had imagined. '
        'This achievement represents decades of international cooperation, technological innovation, and the relentless human drive to explore the unknown. '
        'Scientists believe this mission will pave the way for the first human landing on Mars within the next decade, fundamentally changing our understanding '
        'of the solar system and our place within it.',
    audioAssetPath: 'assets/audio/lesson_014.mp3',
    durationSeconds: 60,
    wordCount: 155,
  ),

  // ── 高速ニュース & ビジネス ──

  LessonModel(
    id: 'lesson-015',
    title: 'Rapid News Broadcast',
    category: 'ニュース',
    difficulty: 3,
    transcriptText:
        'Good evening. Here are tonight\'s top stories. The government has announced a major infrastructure spending package worth two hundred billion dollars, '
        'focusing on bridges, highways, and public transit systems across the country. The plan is expected to create three million jobs over the next five years. '
        'In international news, peace talks between the two nations have resumed after a three-month pause, with diplomats expressing cautious optimism. '
        'On the technology front, the world\'s largest smartphone manufacturer reported record quarterly earnings, driven by strong demand for its latest AI-powered devices. '
        'Meanwhile, a powerful earthquake measuring six point eight on the Richter scale struck the Pacific coast early this morning. '
        'Fortunately, no casualties have been reported, though some coastal areas experienced minor flooding. '
        'In sports, the national team secured a dramatic victory in the championship semifinals. We\'ll have full coverage after the break.',
    audioAssetPath: 'assets/audio/lesson_015.mp3',
    durationSeconds: 60,
    wordCount: 150,
  ),
  LessonModel(
    id: 'lesson-016',
    title: 'Startup Investor Pitch',
    category: 'ビジネス',
    difficulty: 3,
    transcriptText:
        'Thank you for the opportunity to present today. We are building the next generation of healthcare technology. '
        'Our platform uses artificial intelligence to analyze medical images with ninety-eight percent accuracy, helping doctors detect diseases earlier than ever before. '
        'The healthcare AI market is projected to reach fifty billion dollars by twenty twenty-eight, and we are uniquely positioned to capture a significant share. '
        'Our team includes former researchers from Stanford and MIT, and we hold twelve patents in medical imaging technology. '
        'We already have partnerships with three major hospital networks, serving over two million patients. '
        'Our revenue grew three hundred percent last year, and we are on track to achieve profitability by the end of next quarter. '
        'We are raising thirty million dollars in Series B funding to expand into international markets and accelerate our product development. '
        'This is your chance to invest in a company that is literally saving lives while delivering exceptional returns.',
    audioAssetPath: 'assets/audio/lesson_016.mp3',
    durationSeconds: 60,
    wordCount: 153,
  ),
];
