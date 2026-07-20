import '../../features/lesson/data/models/lesson_model.dart';

const seedLessons = [
  // ── ニュース ──

  LessonModel(
    id: 'lesson-001',
    title: 'Morning News Report',
    category: 'ニュース',
    difficulty: 1,
    transcriptText:
        'Good morning and welcome to the news report. '
        'Today, artificial intelligence continues to grow quickly. '
        'Researchers at leading universities announced exciting new findings this week that help computers understand human language better. '
        'The weather today will be clear and mild, with a chance of light rain in the evening. '
        'In business news, the stock market had a strong day. '
        'In sports, the national soccer team won their match two to one. '
        'Thank you for watching, and have a wonderful day.',
    audioAssetPath: 'assets/audio/lesson_001.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-007',
    title: 'Breaking News: Economy',
    category: 'ニュース',
    difficulty: 2,
    transcriptText:
        'In economic news today, the central bank announced a significant change in interest rates, cutting the benchmark rate by a quarter of a percentage point. '
        'Lower rates make it cheaper for people to borrow money for homes, so this decision should have a major impact on the housing market. '
        'The stock market reacted positively, with major indexes rising sharply in afternoon trading. '
        'Meanwhile, the national unemployment rate fell to three point eight percent, its lowest level in over a decade. '
        'Economists point to strong job creation in technology and healthcare. '
        'However, some experts warn that wages have not kept pace with the rising cost of living. '
        'In trade news, the two largest economies agreed to reduce certain tariffs, which could boost global trade. '
        'That wraps up our economic coverage.',
    audioAssetPath: 'assets/audio/lesson_007.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-015',
    title: 'Rapid News Broadcast',
    category: 'ニュース',
    difficulty: 3,
    transcriptText:
        'Good evening. '
        'Here are tonight\'s top stories. '
        'The government has announced a major infrastructure package worth two hundred billion dollars, focusing on bridges, highways, and public transit systems nationwide. '
        'The plan is expected to create three million jobs over the next five years, representing the largest investment in public infrastructure in a generation. '
        'Critics argue the spending is excessive and could push the national debt to dangerous levels. '
        'In international news, peace talks between the two nations have resumed after a three-month pause, with diplomats expressing cautious optimism about reaching a comprehensive agreement before year\'s end. '
        'On the technology front, the world\'s largest smartphone manufacturer reported record quarterly earnings, driven by strong demand for its latest AI-powered devices. '
        'Revenue surged thirty-two percent compared with the same period last year, exceeding analyst expectations. '
        'Meanwhile, a powerful earthquake measuring six point eight struck the Pacific coast early this morning. '
        'Fortunately, no casualties have been reported, though some coastal areas experienced minor flooding. '
        'Emergency teams have been deployed, and officials urge residents to remain vigilant for aftershocks. '
        'In sports, the national team secured a dramatic last-minute victory in the championship semifinals. '
        'We\'ll have full coverage after the break.',
    audioAssetPath: 'assets/audio/lesson_015.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),

  // ── ビジネス ──

  LessonModel(
    id: 'lesson-002',
    title: 'Business Meeting Basics',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'Thank you for joining this meeting today. '
        'Let me go through the agenda before we begin. '
        'First, we will review last quarter\'s results. '
        'Then we will discuss our strategy for the next quarter. '
        'Finally, I\'d like your thoughts on the new project proposal. '
        'Our revenue for the third quarter came in at twelve point five million dollars, an increase of eight percent over last year. '
        'Customer satisfaction scores reached an all-time high of ninety-two percent. '
        'However, operating costs rose about five percent, so we must improve efficiency without sacrificing quality. '
        'Looking ahead, the research team has identified several promising segments we have not yet explored. '
        'Please review the proposal document and send me feedback by Friday. '
        'Thank you all for your time.',
    audioAssetPath: 'assets/audio/lesson_002.mp3',
    durationSeconds: 56,
    wordCount: 122,
  ),
  LessonModel(
    id: 'lesson-006',
    title: 'Product Presentation',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'I\'m very excited to introduce our latest product today. '
        'This solution addresses the key challenges our customers have faced for years. '
        'As you can see on the screen, the interface is intuitive and user-friendly. '
        'The first feature I want to highlight is the smart dashboard, which gives users a complete overview of their data in real time. '
        'Our beta testers reported saving an average of two hours per day using it. '
        'The second key feature is our advanced analytics engine, which uses machine learning to identify trends that would be impossible to spot manually. '
        'For security, the platform uses end-to-end encryption and meets all major international standards. '
        'Once you see it in action, you will understand why early customers call it a game changer.',
    audioAssetPath: 'assets/audio/lesson_006.mp3',
    durationSeconds: 57,
    wordCount: 124,
  ),
  LessonModel(
    id: 'lesson-016',
    title: 'Startup Investor Pitch',
    category: 'ビジネス',
    difficulty: 3,
    transcriptText:
        'Thank you for the opportunity to present today. '
        'We are building the next generation of healthcare technology. '
        'Our platform uses artificial intelligence to analyze medical images with ninety-eight percent accuracy, helping doctors detect diseases earlier and more reliably than ever before. '
        'The healthcare AI market is projected to reach fifty billion dollars by twenty twenty-eight, and we are uniquely positioned to capture a significant share. '
        'Our team includes former researchers from Stanford and MIT, and we hold twelve patents in medical imaging. '
        'What sets us apart is our proprietary training methodology. '
        'While competitors rely on public datasets, we have exclusive partnerships with three major hospital networks, giving us access to over ten million anonymized scans. '
        'This advantage translates directly into superior diagnostic accuracy. '
        'We already serve over two million patients across forty-seven hospitals in twelve countries. '
        'Revenue grew three hundred percent last year, reaching eighteen million dollars in annual recurring revenue. '
        'We are raising thirty million dollars in Series B funding to expand internationally, double our engineering team, and accelerate our product roadmap. '
        'This is your chance to invest in a company that saves lives while delivering exceptional returns. '
        'I look forward to your questions.',
    audioAssetPath: 'assets/audio/lesson_016.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),

  // ── 日常会話 ──

  LessonModel(
    id: 'lesson-003',
    title: 'At the Coffee Shop',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'Hi, could I get a medium latte, please? '
        'And could I have it with oat milk? '
        'Do you have any pastries left? '
        'The chocolate croissant looks amazing, so I\'ll take one too. '
        'Could I also get a glass of water? '
        'Do you have wi-fi here? '
        'I need to get some work done while I wait. '
        'This is a really nice place. '
        'It\'s so cozy, and the music is lovely. '
        'Oh, my order is ready? '
        'Thank you so much!',
    audioAssetPath: 'assets/audio/lesson_003.mp3',
    durationSeconds: 47,
    wordCount: 78,
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
        'Thank you very much. '
        'Which platform does the train to the city center leave from? '
        'And how often do the trains run? '
        'Every fifteen minutes? '
        'That\'s very convenient. '
        'I\'m visiting this city for the first time, and it\'s really beautiful. '
        'Thank you so much for all your help. '
        'Goodbye!',
    audioAssetPath: 'assets/audio/lesson_005.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),

  // ── プレゼン ──

  LessonModel(
    id: 'lesson-004',
    title: 'How Habits Work',
    category: 'プレゼン',
    difficulty: 3,
    transcriptText:
        'Building better habits takes patience and a bit of clever planning. Many people believe that change depends on having strong willpower, but willpower comes and goes throughout the day. A more reliable approach is to make good choices easier and bad choices harder. If you want to drink more water, keep a full bottle on your desk where you can see it. If you want to spend less time on your phone, leave it in another room while you work. Small changes to your surroundings can quietly guide your behavior without any struggle. It also helps to begin with something almost too easy. Reading a single page, stretching for two minutes, or writing one sentence may seem pointless, but these small starts remove the pressure and help you get going. Once you begin, continuing feels natural. Above all, aim for consistency rather than perfection. Practicing a little every day is far more powerful than doing a lot once in a while. Give yourself time, repeat the routine, and gradually it will start to feel like a normal part of who you are.',
    audioAssetPath: 'assets/audio/lesson_004.mp3',
    durationSeconds: 73,
    wordCount: 182,
  ),
  LessonModel(
    id: 'lesson-008',
    title: 'Creative Thinking',
    category: 'プレゼン',
    difficulty: 3,
    transcriptText:
        'Creativity is not a talent that some people have and others lack. '
        'It is a skill developed through practice and persistence. '
        'The most innovative thinkers in history shared one common trait: they were not afraid to fail. '
        'They embraced failure as a necessary step in the creative process and used it to fuel their next breakthrough. '
        'Consider Thomas Edison, who famously tested thousands of materials before finding one that worked for the light bulb. '
        'When asked about his failures, he replied that he had not failed; he had simply found ten thousand ways that did not work. '
        'Creative people do not see failure as an ending; they see it as information. '
        'There is a second element of creative thinking that often gets overlooked, and that is boredom. '
        'We constantly fill every moment with stimulation, yet some of our best ideas emerge during quiet reflection, when the mind is free to wander and make unexpected connections. '
        'So here is my challenge: this week, set aside fifteen minutes each day with nothing to do, and simply let your mind wander. '
        'The creative mind needs space to breathe, and giving yourself that space may be the most productive thing you can do.',
    audioAssetPath: 'assets/audio/lesson_008.mp3',
    durationSeconds: 80,
    wordCount: 199,
  ),

  // ── スポーツ ──

  LessonModel(
    id: 'lesson-009',
    title: 'World Cup Match Report',
    category: 'スポーツ',
    difficulty: 1,
    transcriptText:
        'Welcome to our sports coverage. '
        'Last night\'s World Cup match was incredible. '
        'The underdog team shocked the world by defeating the champions three to one. '
        'The first goal came from a stunning free kick over the wall. '
        'Just ten minutes later, a quick counterattack led to the second goal. '
        'The champions pushed forward in the second half and scored one goal from a corner kick. '
        'But the underdog team defended with passion until the final whistle. '
        'Nobody predicted this result.',
    audioAssetPath: 'assets/audio/lesson_009.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-010',
    title: 'Olympic Sprint Finals',
    category: 'スポーツ',
    difficulty: 2,
    transcriptText:
        'The crowd roared as the eight finalists took their positions on the starting blocks. '
        'The gun fired and the athletes exploded forward with tremendous power. '
        'Within the first thirty meters, it was clear this would be a historic race. '
        'The defending champion surged ahead, but the young challenger from Jamaica was right on her heels. '
        'As they approached the finish line, the gap narrowed to almost nothing. '
        'In a photo finish that left everyone breathless, the newcomer crossed the line first by just three thousandths of a second, setting a new world record. '
        'She fell to her knees in tears of joy, unable to believe what she had accomplished. '
        'The defeated champion walked over and embraced the winner in a touching display of sportsmanship.',
    audioAssetPath: 'assets/audio/lesson_010.mp3',
    durationSeconds: 57,
    wordCount: 124,
  ),
  LessonModel(
    id: 'lesson-011',
    title: 'Tennis Grand Slam Commentary',
    category: 'スポーツ',
    difficulty: 3,
    transcriptText:
        'We are into the fifth set of this extraordinary Grand Slam final. '
        'Both players have been pushing each other to the limit for nearly four hours. '
        'The number one seed fires a blistering serve down the center line at two hundred and twenty kilometers per hour. '
        'His opponent somehow gets a racket on it and sends back a deep return. '
        'What follows is a breathtaking thirty-shot rally that has the entire crowd on their feet. '
        'Finally, a perfectly placed drop shot catches the defender off guard, and the point is won. '
        'The atmosphere here at Centre Court is absolutely electric. '
        'Every point feels like a match point, and neither player is willing to give an inch. '
        'The challenger has been the story of this tournament, defeating three seeded players on his way to the final. '
        'Nobody gave him a chance today, yet here he is, pushing the greatest player of his generation to the brink. '
        'The number one seed serves again, out wide. '
        'The return clips the net cord and drops just over. '
        'What luck for the challenger! '
        'At deuce now, the tension is almost unbearable. '
        'We are witnessing something truly special, and the whole world is watching.',
    audioAssetPath: 'assets/audio/lesson_011.mp3',
    durationSeconds: 79,
    wordCount: 198,
  ),

  // ── 時事ネタ ──

  LessonModel(
    id: 'lesson-012',
    title: 'Climate Change Summit',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText:
        'World leaders gathered in Geneva this week for the climate summit. '
        'A new report warns that global temperatures have risen sharply, and extreme weather is becoming more common. '
        'Delegates reached an agreement with binding targets for renewable energy. '
        'The deal asks all countries to invest in solar, wind, and clean energy. '
        'It also creates a fund to help poorer nations. '
        'Environmental groups welcomed the agreement, but many say it does not go far enough. '
        'The next summit is in December.',
    audioAssetPath: 'assets/audio/lesson_012.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-013',
    title: 'AI and the Future of Work',
    category: '時事ネタ',
    difficulty: 2,
    transcriptText:
        'Artificial intelligence is transforming the workplace at an unprecedented pace. '
        'A new report estimates that forty percent of all jobs worldwide will be affected by AI within five years. '
        'However, experts point out that this does not necessarily mean mass unemployment. '
        'While some roles will be automated, many new positions are emerging in fields like AI safety and data curation. '
        'The real challenge is retraining the existing workforce quickly enough to keep up. '
        'Consider the legal profession, where AI can now review contracts in seconds, freeing lawyers to focus on strategy and negotiation instead. '
        'AI is not replacing workers wholesale. '
        'It is changing the nature of work itself, and those who learn to collaborate with these tools will have a real advantage in tomorrow\'s job market.',
    audioAssetPath: 'assets/audio/lesson_013.mp3',
    durationSeconds: 58,
    wordCount: 126,
  ),
  LessonModel(
    id: 'lesson-014',
    title: 'Space Exploration Breakthrough',
    category: '時事ネタ',
    difficulty: 3,
    transcriptText:
        'In a historic achievement that marks a new chapter in human space exploration, an international crew of six astronauts has successfully completed the first manned mission to Mars orbit. '
        'The spacecraft, which departed Earth eleven months ago, entered a stable orbit around the red planet early this morning. '
        'Mission control in Houston erupted in celebration as telemetry data confirmed the successful orbital insertion. '
        'The crew will spend the next thirty days conducting observations and deploying satellites before beginning the long journey home. '
        'In a live broadcast watched by an estimated two billion people worldwide, the commander described the planet\'s rust-colored surface stretching endlessly beneath them, with massive dust storms swirling across the southern hemisphere. '
        'This achievement represents decades of international cooperation, technological innovation, and the relentless human drive to explore the unknown. '
        'The spacecraft is a marvel of engineering, incorporating breakthroughs in propulsion, radiation shielding, and life support that were considered impossible twenty years ago. '
        'The crew has maintained remarkable physical and psychological health throughout the voyage. '
        'Scientists believe this mission will pave the way for the first human landing on Mars within the next decade, fundamentally changing our understanding of the solar system and our place within it.',
    audioAssetPath: 'assets/audio/lesson_014.mp3',
    durationSeconds: 80,
    wordCount: 199,
  ),

  // ── 追加コンテンツ (自動生成) ──
  LessonModel(
    id: 'lesson-017',
    title: 'Packing Smart for Travel',
    category: '旅行',
    difficulty: 1,
    transcriptText:
        'Packing for a trip does not have to be stressful. '
        'Start by making a short list of the things you need. '
        'Bring clothes you can mix and match, so you always have something to wear. '
        'Roll your shirts and pants to save space in your bag. '
        'Keep your passport, phone, and money in a safe place that is easy to reach. '
        'If you pack light, it is easier to walk and move around. '
        'A little planning makes your journey relaxing.',
    audioAssetPath: 'assets/audio/lesson_017.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-018',
    title: 'A Day at the Airport',
    category: '旅行',
    difficulty: 1,
    transcriptText:
        'Arriving at the airport early is a good idea. '
        'First, you check in and give your bags to the airline. '
        'Then you go through security, where you show your passport and boarding pass. '
        'Put your bag on the belt to be scanned. '
        'After that, you can find your gate and wait for your flight. '
        'Many airports have shops, cafes, and comfortable seats. '
        'Listen for announcements. '
        'When the staff call your group, walk to the gate and get ready to board.',
    audioAssetPath: 'assets/audio/lesson_018.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-019',
    title: 'Tasting Local Cuisine',
    category: '旅行',
    difficulty: 2,
    transcriptText:
        'One of the best parts of traveling is tasting the local food. '
        'Every region has its own flavors, ingredients, and cooking traditions that tell a story about the people who live there. '
        'When you visit a new place, try to eat where the locals eat rather than at tourist restaurants. '
        'Small family-run shops and busy street markets often serve the most authentic dishes. '
        'Do not be afraid to point at something that looks interesting, even if you cannot read the menu. '
        'Ask friendly questions about how a dish is made, and you may learn something surprising. '
        'Some flavors will feel strange at first, but keeping an open mind is part of the adventure. '
        'Sharing a meal is a wonderful way to connect with strangers and understand a culture deeply.',
    audioAssetPath: 'assets/audio/lesson_019.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-020',
    title: 'Budget Travel Tips',
    category: '旅行',
    difficulty: 2,
    transcriptText:
        'Traveling on a budget does not mean missing out on great experiences. '
        'With a little planning, you can see the world without spending a fortune. '
        'Booking your flights and rooms well in advance usually saves money, especially if you avoid holiday seasons. '
        'Consider staying in hostels or small guesthouses, where you can meet other travelers and share tips. '
        'Public buses and trains are cheaper than taxis and show you more of daily life. '
        'Cooking a few of your own meals or shopping at a local market can cut your costs in half. '
        'Free walking tours, public parks, and museums with no entry fee let you enjoy a city for very little. '
        'The goal is to spend wisely on what matters most to you, whether that is food, adventure, or relaxation.',
    audioAssetPath: 'assets/audio/lesson_020.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-021',
    title: 'Wonders of National Parks',
    category: '旅行',
    difficulty: 3,
    transcriptText: 'National parks offer some of the most breathtaking landscapes our planet has to offer, and visiting them can be a truly humbling experience. From towering granite cliffs and thundering waterfalls to silent deserts and ancient forests, these protected areas preserve natural beauty for future generations. Careful planning greatly enhances any visit, since popular parks can become crowded during the summer months, and permits are sometimes required for camping or hiking demanding trails. Experienced visitors recommend arriving early in the morning, when the light is soft, wildlife is active, and the trails are peaceful. Respecting the environment is essential; travelers should stay on marked paths, carry out all their trash, and observe animals from a safe distance rather than feeding them. Beyond the scenery, national parks provide a rare opportunity to disconnect from screens and reconnect with the rhythms of the natural world. Whether you are watching a sunrise over a canyon or listening to a river in the distance, these landscapes remind us why conservation matters so profoundly.',
    audioAssetPath: 'assets/audio/lesson_021.mp3',
    durationSeconds: 67,
    wordCount: 168,
  ),
  LessonModel(
    id: 'lesson-022',
    title: 'Using Your First Smartphone',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText:
        'A smartphone can do many things once you learn the basics. '
        'To turn it on, press and hold the power button. '
        'The screen is how you control the phone, so tap gently with your finger. '
        'You can make calls, send messages, take photos, and search the internet. '
        'Small pictures called apps open tools when you tap them. '
        'Remember to charge the battery every day so your phone does not turn off. '
        'With a little practice, a smartphone soon feels easy.',
    audioAssetPath: 'assets/audio/lesson_022.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-023',
    title: 'Working from Home',
    category: 'テクノロジー',
    difficulty: 2,
    transcriptText:
        'Working from home has become common for millions of people, thanks to fast internet and modern software. '
        'Video calls let coworkers meet face to face even when they live in different cities. '
        'Shared documents allow a whole team to edit the same file at the same time. '
        'While remote work offers freedom and saves time on commuting, it also brings new challenges. '
        'Without a clear routine, it is easy to work too much or to feel distracted by chores at home. '
        'Experts suggest setting up a quiet corner for work and taking breaks to rest your eyes. '
        'It is important to stay connected with colleagues through chats and calls, so you do not feel isolated. '
        'With good habits and the right tools, working from home can be productive and enjoyable.',
    audioAssetPath: 'assets/audio/lesson_023.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-024',
    title: 'How the Internet Connects Us',
    category: 'テクノロジー',
    difficulty: 2,
    transcriptText:
        'The internet is a giant network that links billions of computers and phones worldwide. '
        'When you open a website, your device sends a request that travels through cables, routers, and sometimes satellites. '
        'In less than a second, the information you asked for comes back to your screen. '
        'Much of this data moves through undersea cables. '
        'Every device on the network has a unique address, a bit like a home address, so information reaches the correct place. '
        'Wireless signals let us connect without wires, using radio waves from routers and phone towers. '
        'Because the system is shared, engineers work constantly to keep it fast, safe, and reliable. '
        'Understanding these basics helps us appreciate how a simple search or video call is a remarkable journey of tiny signals traveling enormous distances.',
    audioAssetPath: 'assets/audio/lesson_024.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-025',
    title: 'Living with Smart Devices',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText:
        'Many homes now use smart devices that make daily life easier. '
        'A smart speaker can play music, answer questions, and set timers when you speak to it. '
        'Smart lights let you turn them on or off using your phone, even from another room. '
        'These devices connect to your home internet and follow simple voice commands. '
        'They can be very helpful, but it is wise to protect them with strong passwords. '
        'Used carefully, smart devices add comfort to your day.',
    audioAssetPath: 'assets/audio/lesson_025.mp3',
    durationSeconds: 47,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-026',
    title: 'The Future of Artificial Intelligence',
    category: 'テクノロジー',
    difficulty: 3,
    transcriptText: 'Artificial intelligence has advanced remarkably in recent years, transforming the way we work, communicate, and solve difficult problems. Systems that once struggled to recognize a simple image can now translate languages, compose music, and assist doctors in diagnosing illnesses. This progress is driven by powerful computers and enormous amounts of data, which allow machines to detect patterns that humans might overlook. Yet these capabilities raise important questions that society must address thoughtfully. How do we ensure that automated decisions are fair and free from hidden bias? What happens to jobs when machines can perform tasks more quickly and cheaply than people? Experts emphasize that artificial intelligence should support human judgment rather than replace it entirely, especially in sensitive fields like medicine and law. Transparency, careful regulation, and ongoing education will be crucial as this technology becomes woven into everyday life. If we guide its development responsibly, artificial intelligence could help us tackle enormous challenges, from curing diseases to fighting climate change, while still preserving the values we care about most.',
    audioAssetPath: 'assets/audio/lesson_026.mp3',
    durationSeconds: 68,
    wordCount: 170,
  ),
  LessonModel(
    id: 'lesson-027',
    title: 'The Water Cycle',
    category: '科学',
    difficulty: 1,
    transcriptText:
        'The water cycle is the journey water takes around our planet. '
        'When the sun heats lakes, rivers, and oceans, some water turns into a gas and rises into the sky. '
        'This is called evaporation. '
        'High in the air, the gas cools and forms tiny drops that gather into clouds. '
        'When the clouds become heavy, the water falls as rain or snow. '
        'This is called precipitation. '
        'Then the sun warms the water again, and the whole cycle starts over.',
    audioAssetPath: 'assets/audio/lesson_027.mp3',
    durationSeconds: 47,
    wordCount: 78,
  ),
  LessonModel(
    id: 'lesson-028',
    title: 'Why We Need Sleep',
    category: '科学',
    difficulty: 2,
    transcriptText:
        'Sleep is one of the most important things we do for our health, yet many people do not get enough of it. '
        'While we rest, our bodies repair muscles, fight illness, and store energy for the day ahead. '
        'The brain is especially busy during sleep, sorting through memories and clearing away waste that builds up while we are awake. '
        'This is why a good night of sleep helps us think clearly, learn new skills, and manage our emotions. '
        'Scientists recommend that most adults get between seven and nine hours each night. '
        'To sleep well, keep a regular schedule, avoid bright screens before bed, and keep the bedroom cool and dark. '
        'By treating rest as a priority rather than a luxury, we give our minds and bodies the care they need.',
    audioAssetPath: 'assets/audio/lesson_028.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-029',
    title: 'Exploring the Deep Ocean',
    category: '科学',
    difficulty: 3,
    transcriptText: 'The deep ocean remains one of the least explored regions on Earth, a vast and mysterious world hidden beneath thousands of meters of water. Sunlight cannot reach these depths, so the environment is permanently dark, intensely cold, and crushed by enormous pressure that would flatten most machines. Despite these harsh conditions, life thrives in surprising forms. Strange creatures glow with their own light, a phenomenon known as bioluminescence, using it to attract prey or confuse predators. Around volcanic vents on the seafloor, entire communities survive without sunlight, feeding on chemicals that escape from cracks in the Earth\'s crust. Scientists explore this hidden realm using robotic submarines equipped with cameras, lights, and mechanical arms that can collect samples. Each expedition reveals new species and deepens our understanding of how life can adapt to extreme places. Studying the deep sea may even offer clues about how life could exist on distant moons and planets. Protecting these fragile ecosystems is vital, because much of this remarkable world could disappear before we ever fully understand it.',
    audioAssetPath: 'assets/audio/lesson_029.mp3',
    durationSeconds: 69,
    wordCount: 172,
  ),
  LessonModel(
    id: 'lesson-030',
    title: 'The Life of Stars',
    category: '科学',
    difficulty: 3,
    transcriptText: 'Stars may look like tiny, unchanging points of light, but they are enormous balls of gas that live through dramatic cycles of birth, growth, and death. A star begins its life inside a vast cloud of dust and gas, where gravity slowly pulls material together until the center becomes hot and dense enough for nuclear reactions to ignite. These reactions release tremendous energy, which is why stars shine for millions or even billions of years. Our own Sun is a middle-aged star, steadily burning hydrogen and providing the warmth and light that make life on Earth possible. When a star finally exhausts its fuel, its fate depends on its size. Smaller stars swell, cool, and gently fade away, while the most massive ones collapse and explode in a brilliant burst called a supernova. Remarkably, these explosions scatter heavy elements across space, the very materials that later form new planets and living things. In a real sense, the atoms in our bodies were forged long ago inside ancient stars.',
    audioAssetPath: 'assets/audio/lesson_030.mp3',
    durationSeconds: 67,
    wordCount: 168,
  ),
  LessonModel(
    id: 'lesson-031',
    title: 'Morning Walks For Beginners',
    category: '健康・フィットネス',
    difficulty: 1,
    transcriptText:
        'Going for a walk in the morning is a simple way to feel better. '
        'You do not need special shoes or a gym. '
        'Just step outside and start moving. '
        'A short walk can wake up your body and clear your mind. '
        'Try to walk for ten or fifteen minutes at first. '
        'Later, you can walk a little longer each day. '
        'Walking with a friend makes it fun. '
        'Soon, a morning walk will feel like a happy part of your day.',
    audioAssetPath: 'assets/audio/lesson_031.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-032',
    title: 'Drinking Enough Water',
    category: '健康・フィットネス',
    difficulty: 1,
    transcriptText:
        'Water is important for your body. '
        'Every day, you lose water when you move, breathe, and sweat. '
        'That is why you must drink water often. '
        'Many people carry a bottle so they can drink all day. '
        'When you feel tired or have a headache, you might just need more water. '
        'Try to drink a glass in the morning and more with your meals. '
        'Cold water is nice on a hot day. '
        'Your body will thank you when you drink enough.',
    audioAssetPath: 'assets/audio/lesson_032.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-033',
    title: 'Building Better Sleep Habits',
    category: '健康・フィットネス',
    difficulty: 2,
    transcriptText:
        'Getting good sleep is one of the best things you can do for your health, yet many people struggle to rest well at night. '
        'The quality of your sleep often depends on your evening habits. '
        'Try to go to bed and wake up at the same time every day, even on weekends. '
        'This helps your body build a steady rhythm. '
        'Avoid bright screens for an hour before bed, because the light can trick your brain into staying awake. '
        'A cool, dark, and quiet room also makes a big difference. '
        'Some people find that a warm bath or a few pages of a book help them relax. '
        'Cutting back on coffee in the afternoon is another smart choice. '
        'With patience, these small changes can lead to deeper, more restful nights.',
    audioAssetPath: 'assets/audio/lesson_033.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-034',
    title: 'Strength Training Basics',
    category: '健康・フィットネス',
    difficulty: 2,
    transcriptText: 'Strength training is not only for athletes or bodybuilders; it is useful for almost everyone. As we grow older, our muscles naturally become weaker, and regular exercise can slow this process. You do not need a fancy gym to begin. Simple movements like squats, push-ups, and lunges use your own body weight and can be done at home. When you first start, focus on doing each movement correctly rather than lifting something heavy. Good form protects you from injury and helps you build real strength. Give your muscles a day of rest between hard sessions so they can recover and grow. Over time, you will notice that daily tasks, such as carrying groceries or climbing stairs, feel much easier.',
    audioAssetPath: 'assets/audio/lesson_034.mp3',
    durationSeconds: 55,
    wordCount: 119,
  ),
  LessonModel(
    id: 'lesson-035',
    title: 'Understanding Mental Health',
    category: '健康・フィットネス',
    difficulty: 3,
    transcriptText: 'Mental health is just as important as physical health, though it often receives far less attention in our busy daily lives. It refers to our emotional, psychological, and social well-being, shaping how we think, feel, and handle the challenges that come our way. Everyone experiences moments of stress, sadness, or worry, but persistent feelings of this kind can gradually interfere with work, relationships, and overall happiness. Fortunately, there are many practical ways to care for your mind. Regular exercise, balanced meals, and enough sleep all provide a strong foundation. Staying connected with supportive friends and family can ease feelings of loneliness, while activities like journaling or spending time in nature help calm a racing mind. Perhaps most importantly, we must learn to recognize when we need help and to seek it without shame. Speaking with a trusted counselor or doctor is a sign of strength, not weakness. As societies slowly become more open about these topics, more people feel comfortable sharing their struggles. By treating mental health with the same seriousness we give to a broken bone or a fever, we build kinder communities where everyone has the chance to thrive.',
    audioAssetPath: 'assets/audio/lesson_035.mp3',
    durationSeconds: 76,
    wordCount: 191,
  ),
  LessonModel(
    id: 'lesson-036',
    title: 'Recycling At Home',
    category: '環境',
    difficulty: 1,
    transcriptText:
        'Recycling at home is an easy way to help the planet. '
        'Many things you throw away can be used again. '
        'Paper, glass, plastic, and metal can all be recycled. '
        'First, rinse bottles and cans so they are clean. '
        'Then put them in the right bin. '
        'When you recycle, less trash goes to the landfill. '
        'It also saves energy and natural resources. '
        'Teach your family to sort waste, and soon it will become a simple daily habit.',
    audioAssetPath: 'assets/audio/lesson_036.mp3',
    durationSeconds: 45,
    wordCount: 76,
  ),
  LessonModel(
    id: 'lesson-037',
    title: 'Saving Energy Every Day',
    category: '環境',
    difficulty: 1,
    transcriptText:
        'Saving energy at home is good for the earth and your wallet. '
        'There are many simple things you can do. '
        'Turn off the lights when you leave a room. '
        'Unplug devices that you are not using. '
        'In winter, wear a warm sweater instead of turning up the heat. '
        'Wash your clothes in cold water when you can. '
        'Using less energy means burning less fuel and making less pollution. '
        'When your whole family helps, you can save a lot together.',
    audioAssetPath: 'assets/audio/lesson_037.mp3',
    durationSeconds: 48,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-038',
    title: 'The Importance Of Bees',
    category: '環境',
    difficulty: 2,
    transcriptText:
        'Bees may be small, but they play a huge role in the health of our planet. '
        'As they fly from flower to flower to collect nectar, they carry pollen with them. '
        'This process, called pollination, helps plants produce fruits, vegetables, and seeds. '
        'In fact, a large share of the food we eat depends on bees and other pollinators. '
        'Without them, our meals would be less colorful and varied. '
        'Sadly, bee populations have been shrinking in many parts of the world. '
        'Loss of habitat, harmful chemicals, and disease all threaten these insects. '
        'There are ways we can help, however. '
        'Planting flowers, avoiding strong pesticides, and leaving wild corners in the garden all give bees a place to thrive. '
        'By protecting bees, we protect our food and our shared natural world.',
    audioAssetPath: 'assets/audio/lesson_038.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-039',
    title: 'Ocean Plastic Pollution',
    category: '環境',
    difficulty: 2,
    transcriptText:
        'Every year, millions of tons of plastic end up in our oceans, creating one of today\'s biggest environmental problems. '
        'This waste comes from many sources, including bottles, bags, and tiny pieces that break off larger items. '
        'Ocean currents gather much of this trash into enormous floating patches. '
        'Sea animals often mistake the plastic for food, which can make them sick or even kill them. '
        'Over time, plastic breaks into tiny fragments called microplastics, which enter the food chain and may reach our own plates. '
        'The good news is that people and companies are taking action. '
        'Many now use fewer single-use products, choose reusable bags and bottles, and join beach cleanups. '
        'Governments are passing laws too. '
        'Small choices, repeated by millions, can keep our oceans clean and full of life.',
    audioAssetPath: 'assets/audio/lesson_039.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-040',
    title: 'Renewable Energy Sources',
    category: '環境',
    difficulty: 3,
    transcriptText: 'As the world searches for cleaner ways to power its homes, factories, and vehicles, renewable energy has moved to the center of the conversation. Unlike coal, oil, and gas, which release large amounts of carbon dioxide and will eventually run out, renewable sources draw on forces that nature replenishes continuously. Sunlight, wind, flowing water, and heat from deep within the earth can all be captured and turned into electricity. Solar panels on rooftops and vast wind farms on open plains have become increasingly common and affordable in recent years. One challenge, however, is that the sun does not always shine and the wind does not always blow, so engineers are developing better batteries to store energy for later use. Governments around the world are investing heavily in these technologies, hoping to reduce pollution and slow the pace of climate change. The transition will not happen overnight, and it requires cooperation among nations, businesses, and ordinary citizens. Yet the progress already made offers real reason for hope. By embracing renewable energy, we can build an economy that meets our needs today without robbing future generations of a healthy planet.',
    audioAssetPath: 'assets/audio/lesson_040.mp3',
    durationSeconds: 75,
    wordCount: 188,
  ),
  LessonModel(
    id: 'lesson-041',
    title: 'Visiting An Art Museum',
    category: '文化・芸術',
    difficulty: 1,
    transcriptText:
        'Visiting an art museum is a calm and interesting way to spend a day. '
        'Inside, you can see paintings, statues, and other beautiful works from many countries. '
        'Some art is old, while other pieces are new and modern. '
        'Walk slowly and take your time with each one. '
        'You do not have to like everything you see. '
        'Just notice the colors, shapes, and feelings the art gives you. '
        'A trip to a museum can open your mind to new ideas.',
    audioAssetPath: 'assets/audio/lesson_041.mp3',
    durationSeconds: 47,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-042',
    title: 'Learning To Paint',
    category: '文化・芸術',
    difficulty: 2,
    transcriptText:
        'Learning to paint is a wonderful hobby that anyone can enjoy, no matter their age or skill. '
        'You do not need expensive supplies to begin. '
        'A few brushes, some basic colors, and a sheet of thick paper are enough for your first steps. '
        'Many beginners start with watercolors because they are easy to clean and forgiving of mistakes. '
        'At first, try painting simple things around you, such as a piece of fruit or a flower in a vase. '
        'Do not worry about making your work look perfect. '
        'The goal is to practice mixing colors and to see how light and shadow fall on objects. '
        'With each painting, your eye and hand grow stronger. '
        'Over time, you may discover your own style. '
        'Above all, painting should feel relaxing and fun.',
    audioAssetPath: 'assets/audio/lesson_042.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-043',
    title: 'The History Of Jazz',
    category: '文化・芸術',
    difficulty: 3,
    transcriptText: 'Jazz is one of the most influential musical styles ever created, and its roots reach deep into American history. It was born in the early twentieth century in New Orleans, a lively port city where many cultures met and mingled. Musicians blended African rhythms, blues, and European harmonies to create something entirely new and full of energy. What made jazz so remarkable was its spirit of improvisation, meaning that performers often invented melodies on the spot rather than reading every note from a page. As the music spread north to cities like Chicago and New York, it grew and changed with each new generation of players. Legendary artists such as Louis Armstrong and Duke Ellington pushed the form in bold directions, while later musicians experimented with faster tempos and unusual harmonies. Jazz also carried a deeper meaning, giving voice to communities that had long been silenced and helping to break down barriers between people. Today, its influence can be heard in pop, rock, and film music around the globe. More than a century after its birth, jazz continues to inspire listeners and remind us that great art often grows from the meeting of different traditions.',
    audioAssetPath: 'assets/audio/lesson_043.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),
  LessonModel(
    id: 'lesson-044',
    title: 'Traditional Japanese Theater',
    category: '文化・芸術',
    difficulty: 3,
    transcriptText: 'Japan is home to several forms of traditional theater that have been performed for hundreds of years and remain treasured today. Two of the most famous are Noh and Kabuki, each with its own distinct character. Noh is the older of the two, a slow and solemn art form in which actors wear carved wooden masks and move with careful, deliberate grace. Its stories often explore ghosts, gods, and deep human emotions, accompanied by chanting and the haunting sound of flutes and drums. Kabuki, by contrast, is bold and dramatic, filled with colorful costumes, striking makeup, and exaggerated gestures that thrill the audience. Both forms pass their techniques down from teacher to student across many generations, preserving skills that might otherwise be lost. For centuries, certain roles have even been performed only by men, who train for years to portray a wide range of characters convincingly. Watching these performances offers more than entertainment; it opens a window into Japanese history, values, and beauty. Although modern movies and television now compete for attention, these ancient arts continue to draw devoted audiences who appreciate their timeless power and craftsmanship.',
    audioAssetPath: 'assets/audio/lesson_044.mp3',
    durationSeconds: 75,
    wordCount: 187,
  ),
  LessonModel(
    id: 'lesson-045',
    title: 'The Pyramids Of Egypt',
    category: '歴史',
    difficulty: 1,
    transcriptText:
        'The pyramids of Egypt are among the oldest buildings in the world. '
        'People built them thousands of years ago to hold the bodies of kings called pharaohs. '
        'The largest one is the Great Pyramid of Giza. '
        'Workers moved huge blocks of stone by hand and with simple tools. '
        'Each block was very heavy, and there were more than two million of them. '
        'Today, visitors from all over the world come to see these amazing structures.',
    audioAssetPath: 'assets/audio/lesson_045.mp3',
    durationSeconds: 45,
    wordCount: 75,
  ),
  LessonModel(
    id: 'lesson-046',
    title: 'The Great Wall Of China',
    category: '歴史',
    difficulty: 1,
    transcriptText:
        'The Great Wall of China is one of the most famous structures in the world. '
        'It was built long ago to protect the country from invaders in the north. '
        'The wall stretches over mountains and valleys for thousands of miles. '
        'Workers used stone, brick, and earth to build the strong walls and tall towers. '
        'Guards once stood on the towers to watch for enemies. '
        'Today, millions of people visit the wall each year.',
    audioAssetPath: 'assets/audio/lesson_046.mp3',
    durationSeconds: 44,
    wordCount: 73,
  ),
  LessonModel(
    id: 'lesson-047',
    title: 'The Silk Road Trade Routes',
    category: '歴史',
    difficulty: 2,
    transcriptText:
        'The Silk Road was not a single road but a network of trade routes that connected the East and the West for many centuries. '
        'Merchants traveled across deserts, mountains, and grasslands to carry goods between China, India, Persia, and Europe. '
        'Silk was the most famous product, but traders carried spices, tea, precious stones, and paper. '
        'These journeys were long and dangerous, so people traveled together in groups called caravans. '
        'Along the way, they stopped at market towns to rest and exchange goods. '
        'The Silk Road did more than move products. '
        'It also spread ideas, religions, languages, and new technologies from one culture to another. '
        'Because of this exchange, distant civilizations learned about each other and grew richer. '
        'The routes declined when sailors found faster ways to travel by sea.',
    audioAssetPath: 'assets/audio/lesson_047.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-048',
    title: 'Gutenberg And The Printing Press',
    category: '歴史',
    difficulty: 2,
    transcriptText:
        'Before the printing press was invented, books were copied slowly by hand, by monks who spent months on one volume. '
        'Because the work took so long, books were rare and expensive, and only wealthy people or churches could afford them. '
        'In the fifteenth century, a German craftsman named Johannes Gutenberg changed everything. '
        'He created a machine that used metal letters, which could be inked and pressed onto paper again and again. '
        'Suddenly, printers could produce hundreds of pages in the time it once took to copy one. '
        'Books became cheaper, and more people learned to read. '
        'New ideas about science, religion, and politics spread across Europe quickly. '
        'Many historians believe this invention helped launch the modern age, because knowledge was no longer locked away in a few handwritten copies.',
    audioAssetPath: 'assets/audio/lesson_048.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-049',
    title: 'The Rise And Fall Of Rome',
    category: '歴史',
    difficulty: 3,
    transcriptText: 'At its height, the Roman Empire stretched across three continents and governed tens of millions of people who spoke dozens of different languages. What made this vast territory possible was not only a powerful army but also a remarkable talent for organization. The Romans built an extensive system of paved roads, allowing soldiers, messengers, and merchants to travel with unprecedented speed. They engineered aqueducts that carried fresh water into crowded cities, and they developed a legal framework whose principles still influence modern courts today. Roman culture absorbed ideas from the peoples it conquered, particularly the Greeks, blending art, philosophy, and religion into something distinctly its own. Yet the empire\'s very size eventually became a burden. Defending its enormous borders demanded ever more resources, while political corruption, economic instability, and repeated invasions gradually weakened the state. In the fifth century, the western half finally collapsed, though its eastern counterpart endured for another thousand years. Even after its fall, Rome\'s legacy persisted in language, architecture, government, and law, shaping the foundations of Western civilization for centuries to come.',
    audioAssetPath: 'assets/audio/lesson_049.mp3',
    durationSeconds: 70,
    wordCount: 176,
  ),
  LessonModel(
    id: 'lesson-050',
    title: 'How Pizza Is Made',
    category: '料理・グルメ',
    difficulty: 1,
    transcriptText:
        'Pizza is one of the most popular foods in the world. '
        'It began in Italy, in the city of Naples, many years ago. '
        'A basic pizza has a round base made of dough, a layer of tomato sauce, and cheese on top. '
        'People also add other toppings, such as vegetables, mushrooms, or meat. '
        'The pizza is baked in a very hot oven until the cheese melts. '
        'Today you can find pizza in almost every country.',
    audioAssetPath: 'assets/audio/lesson_050.mp3',
    durationSeconds: 45,
    wordCount: 75,
  ),
  LessonModel(
    id: 'lesson-051',
    title: 'A Warm Cup Of Coffee',
    category: '料理・グルメ',
    difficulty: 1,
    transcriptText:
        'Coffee is a warm drink that millions of people enjoy every day. '
        'It is made from beans that grow on small trees in warm countries. '
        'First, the beans are dried and then roasted until they turn dark brown. '
        'After that, they are ground into a fine powder. '
        'Hot water is poured over the powder to make the drink. '
        'Many people like a cup in the morning because it helps them feel awake. '
        'Coffee shops are places where friends meet.',
    audioAssetPath: 'assets/audio/lesson_051.mp3',
    durationSeconds: 48,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-052',
    title: 'The Art Of Japanese Sushi',
    category: '料理・グルメ',
    difficulty: 2,
    transcriptText:
        'Sushi is a traditional Japanese dish that has become popular around the world. '
        'Although many people think sushi is raw fish, the word actually refers to the seasoned rice at the base of the dish. '
        'The rice is mixed with vinegar, sugar, and salt for a delicate flavor. '
        'Chefs top the rice with fresh fish, seafood, or vegetables, or roll it in a sheet of dried seaweed. '
        'Making good sushi takes years of practice and skill. '
        'A master chef must learn to choose the freshest ingredients, slice the fish perfectly, and shape the rice with the right pressure. '
        'In Japan, it is enjoyed with soy sauce, wasabi, and pickled ginger. '
        'Whether eaten at a fancy restaurant or a small counter, it is admired for its beauty, freshness, and elegance.',
    audioAssetPath: 'assets/audio/lesson_052.mp3',
    durationSeconds: 60,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-053',
    title: 'The Spices Of Indian Cooking',
    category: '料理・グルメ',
    difficulty: 2,
    transcriptText:
        'Indian cooking is famous worldwide for its bold, colorful use of spices. '
        'In an Indian kitchen, you might find turmeric, cumin, coriander, cardamom, and many others, each with its own aroma and flavor. '
        'Cooks often mix several spices to create a blend, and every family may have its own secret recipe passed down through generations. '
        'One well-known dish is curry, a rich sauce that can be made with vegetables, beans, chicken, or fish. '
        'Spices are added not just for taste; many are believed good for health. '
        'Before cooking, some spices are heated in oil to release their full flavor. '
        'The result is a meal that fills the house with a wonderful smell. '
        'Served with rice or flatbread, Indian food is an unforgettable experience for anyone who loves to eat.',
    audioAssetPath: 'assets/audio/lesson_053.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-054',
    title: 'The World Of French Cheese',
    category: '料理・グルメ',
    difficulty: 3,
    transcriptText: 'France is often celebrated as one of the great homes of cheese, producing hundreds of distinct varieties, each shaped by the region, climate, and traditions from which it comes. From the soft, creamy rounds of Brie to the sharp, blue-veined intensity of Roquefort, French cheeses reflect an extraordinary diversity of flavors, textures, and aromas. The process of making them is both an ancient craft and a careful science. Cheesemakers begin with fresh milk, which may come from cows, goats, or sheep, and they add cultures and rennet to encourage it to thicken and separate. The resulting curds are then pressed, salted, and left to age in cool, damp cellars, sometimes for many months or even years. During this patient maturing, subtle chemical changes develop the complex characters that connoisseurs prize so highly. In France, cheese is far more than an ingredient; it occupies a respected place at the table, traditionally served after the main course and before dessert. A well-chosen selection, paired thoughtfully with bread and wine, is considered a small work of art. For many families, sharing such a board remains one of the simplest and most enduring pleasures of daily life.',
    audioAssetPath: 'assets/audio/lesson_054.mp3',
    durationSeconds: 77,
    wordCount: 193,
  ),
  LessonModel(
    id: 'lesson-055',
    title: 'Penguins Of The Cold South',
    category: '自然・動物',
    difficulty: 1,
    transcriptText:
        'Penguins are birds that cannot fly, but they are excellent swimmers. '
        'Most penguins live in the cold parts of the world, far to the south. '
        'Their black and white feathers keep them warm in the icy water. '
        'Penguins use their short wings like paddles to move quickly through the sea and catch fish. '
        'On land, they walk with a funny waddle and sometimes slide on their bellies. '
        'Parents take care of their eggs and young chicks.',
    audioAssetPath: 'assets/audio/lesson_055.mp3',
    durationSeconds: 46,
    wordCount: 76,
  ),
  LessonModel(
    id: 'lesson-056',
    title: 'The Great Journey Of Birds',
    category: '自然・動物',
    difficulty: 2,
    transcriptText:
        'Every year, millions of birds make incredible journeys in a process known as migration. '
        'As the weather grows colder, many birds fly long distances to find warmer places with more food. '
        'Some travel only a short way, while others cross oceans and continents without stopping for days. '
        'One small bird, the Arctic tern, travels from the top of the world to the bottom and back each year. '
        'Scientists are still learning how birds find their way over such distances. '
        'It seems they use the sun, stars, and even the Earth\'s magnetic field to guide themselves. '
        'Many birds return to the same nesting spot year after year. '
        'These journeys require enormous energy, so before they leave, birds eat as much as they can to store fat for the trip ahead.',
    audioAssetPath: 'assets/audio/lesson_056.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-057',
    title: 'Life Within Coral Reefs',
    category: '自然・動物',
    difficulty: 3,
    transcriptText: 'Coral reefs are among the most colorful and diverse ecosystems on the planet, often described as the rainforests of the sea. Although a reef may look like a lifeless rock formation, it is actually built by tiny living animals called coral polyps, which slowly construct hard skeletons of limestone over thousands of years. Within these intricate structures live an astonishing variety of creatures, from brilliantly patterned fish and darting shrimp to sea turtles, octopuses, and countless smaller organisms. What makes coral so remarkable is a delicate partnership with microscopic algae that live inside the polyps. These algae capture sunlight and provide the coral with food, while the coral offers them shelter and essential nutrients in return. Unfortunately, this balance is fragile. When ocean waters grow too warm, the coral expels its algae and loses its vivid color, a stressful event known as bleaching. If the warmth continues, the coral may eventually die. Pollution, overfishing, and rising sea temperatures now threaten reefs across the globe. Scientists and conservationists are working hard to protect these underwater treasures, because reefs shelter roughly a quarter of all marine species and support the livelihoods of millions of people.',
    audioAssetPath: 'assets/audio/lesson_057.mp3',
    durationSeconds: 77,
    wordCount: 193,
  ),
  LessonModel(
    id: 'lesson-058',
    title: 'Secrets Of The Amazon Rainforest',
    category: '自然・動物',
    difficulty: 3,
    transcriptText: 'The Amazon rainforest, stretching across much of South America, is the largest tropical forest on Earth and one of its most vital natural treasures. Beneath its dense green canopy lives an almost unimaginable variety of life, including millions of species of insects, thousands of kinds of birds and fish, and countless plants that exist nowhere else in the world. Scientists believe that many of these species have not yet even been discovered or named. The forest plays a crucial role in regulating the planet\'s climate, absorbing vast quantities of carbon dioxide and releasing the oxygen that living things depend upon. Its towering trees also influence rainfall patterns far beyond the region itself. For thousands of years, indigenous peoples have lived within the forest, developing a deep knowledge of its plants and animals and using them for food and medicine. Today, however, the Amazon faces serious dangers. Large areas are cleared each year for farming, mining, and logging, threatening both wildlife and the communities who call the forest home. Protecting this extraordinary place has become one of the most urgent environmental challenges of our time, for its health is closely linked to the well-being of the entire planet.',
    audioAssetPath: 'assets/audio/lesson_058.mp3',
    durationSeconds: 79,
    wordCount: 197,
  ),
  LessonModel(
    id: 'lesson-059',
    title: 'The Magic of Film Festivals',
    category: '映画・エンタメ',
    difficulty: 1,
    transcriptText:
        'Film festivals are exciting events where new movies are shown for the first time. '
        'People travel from many countries to watch films and meet the directors. '
        'Some festivals are very famous, and winning a prize there can make a movie popular around the world. '
        'At a festival, you can see small films that are hard to find in normal cinemas. '
        'Actors walk on the red carpet while photographers take pictures. '
        'For film lovers, a festival is a wonderful place.',
    audioAssetPath: 'assets/audio/lesson_059.mp3',
    durationSeconds: 48,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-060',
    title: 'Behind the Special Effects',
    category: '映画・エンタメ',
    difficulty: 2,
    transcriptText:
        'Have you ever wondered how filmmakers create giant monsters, exploding buildings, or alien worlds? '
        'Most of these scenes are made using special effects. '
        'In the past, artists built models and used camera tricks to make them look real. '
        'Today, computers do much of the work. '
        'Teams of digital artists design creatures and landscapes that never existed, then add them to the footage frame by frame. '
        'Actors often perform in front of a green screen, imagining explosions and dragons added later. '
        'Sound designers also matter, recording and mixing noises to make each moment feel believable. '
        'Creating these effects can take months of work, but the result is a world that pulls audiences into the story. '
        'The next time you watch an action film, remember the hidden artists behind the magic.',
    audioAssetPath: 'assets/audio/lesson_060.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-061',
    title: 'The Long History of Animation',
    category: '映画・エンタメ',
    difficulty: 3,
    transcriptText: 'The history of animation is a remarkable journey of imagination and technical invention. Long before computers existed, pioneers painstakingly drew thousands of individual pictures, each slightly different from the last, so that when shown in rapid succession they appeared to move. Early studios employed vast teams of artists who painted every frame by hand onto transparent sheets, a laborious process that could consume years for a single feature. As decades passed, innovators experimented with clay figures, cut-out puppets, and elaborate mechanical rigs, constantly expanding what the medium could express. The arrival of digital technology transformed everything, allowing filmmakers to construct dazzling three-dimensional worlds and subtle character expressions that once seemed impossible. Yet despite these advances, the fundamental principle has never changed: animation breathes life into inanimate drawings by exploiting the way our eyes perceive continuous motion. What makes the art form so enduring is its boundless freedom, for animators are limited only by their creativity rather than the constraints of physical reality. From whimsical comedies to profound dramas, animated films continue to captivate audiences of every age, proving that stories drawn frame by frame can move us just as deeply as those performed by living actors.',
    audioAssetPath: 'assets/audio/lesson_061.mp3',
    durationSeconds: 78,
    wordCount: 196,
  ),
  LessonModel(
    id: 'lesson-062',
    title: 'Watching Movies at Home',
    category: '映画・エンタメ',
    difficulty: 1,
    transcriptText:
        'Streaming services have changed the way we watch movies and shows. '
        'In the past, people rented films at a store or waited for them on television. '
        'Now we can watch almost anything at home with a few clicks. '
        'These services offer thousands of titles, from old classics to new series. '
        'You can pause, rewind, or continue watching on your phone, tablet, or screen. '
        'Because there is so much choice, sometimes it is hard to decide what to watch tonight.',
    audioAssetPath: 'assets/audio/lesson_062.mp3',
    durationSeconds: 47,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-063',
    title: 'The Magic of Musical Theater',
    category: '映画・エンタメ',
    difficulty: 2,
    transcriptText:
        'Musical theater combines acting, singing, and dancing to tell powerful stories on stage. '
        'Unlike a film, every performance happens live, so no two shows are ever exactly the same. '
        'The actors must sing while moving across the stage, expressing deep emotions through both their voices and their bodies. '
        'Behind the scenes, a live orchestra usually follows the singers closely so that everything stays in time. '
        'Building a musical takes enormous teamwork. '
        'Writers create the songs and dialogue, choreographers design the dances, and set designers build colorful worlds that transport the audience. '
        'Costumes, lighting, and sound all work together to create a magical atmosphere. '
        'When the final song ends and the curtain falls, audiences often rise to their feet, applauding the energy and talent they have just witnessed.',
    audioAssetPath: 'assets/audio/lesson_063.mp3',
    durationSeconds: 59,
    wordCount: 127,
  ),
  LessonModel(
    id: 'lesson-064',
    title: 'Learning a New Language',
    category: '教育・学習',
    difficulty: 1,
    transcriptText:
        'Learning a new language is a fun and useful skill. '
        'At first, it may feel difficult to remember new words and sounds. '
        'But with a little practice every day, you will slowly improve. '
        'Try to listen to songs, watch simple videos, and repeat short sentences out loud. '
        'Speaking with other people is one of the best ways to learn. '
        'Do not worry about making mistakes, because mistakes help you grow. '
        'Step by step, you will feel more confident.',
    audioAssetPath: 'assets/audio/lesson_064.mp3',
    durationSeconds: 47,
    wordCount: 78,
  ),
  LessonModel(
    id: 'lesson-065',
    title: 'Smarter Ways to Study',
    category: '教育・学習',
    difficulty: 2,
    transcriptText:
        'Many students study for hours yet still struggle to remember what they learned. '
        'The problem is often not the amount of time, but the method they use. '
        'Research shows that simply rereading notes is one of the least effective ways to learn. '
        'A far better approach is to test yourself regularly, trying to recall information from memory before checking the answer. '
        'This effort strengthens the connections in your brain. '
        'Spreading your study sessions across several days, rather than cramming the night before, also helps knowledge stick for longer. '
        'Another useful trick is to explain a topic in your own words, as if teaching someone else. '
        'If you can do that clearly, you truly understand it. '
        'Getting enough sleep matters too, because your brain organizes memories while you rest.',
    audioAssetPath: 'assets/audio/lesson_065.mp3',
    durationSeconds: 59,
    wordCount: 128,
  ),
  LessonModel(
    id: 'lesson-066',
    title: 'The Rise of Online Learning',
    category: '教育・学習',
    difficulty: 3,
    transcriptText:
        'Over the past two decades, online education has quietly revolutionized the way people acquire knowledge and skills. '
        'Where learning was once confined to physical classrooms accessible to a privileged few, ambitious individuals can now enroll in courses taught by distinguished professors from renowned universities without leaving their homes. '
        'This democratization carries profound implications, particularly for those in remote regions or difficult financial circumstances who previously had no realistic path to advanced study. '
        'A learner in a small village can now watch the same lectures, complete the same assignments, and earn credentials comparable to those of students on prestigious campuses. '
        'Nevertheless, this transformation is not without difficulties. '
        'Online courses demand considerable self-discipline, since the structure and accountability of a traditional classroom are largely absent, and completion rates remain stubbornly low. '
        'Furthermore, subjects requiring hands-on practice or intimate mentorship are difficult to replicate through a screen. '
        'Educators continue to experiment with interactive tools, discussion forums, and peer-review systems to recreate the collaborative spirit of physical institutions. '
        'Despite these obstacles, the trajectory is unmistakable: as technology advances and connectivity spreads, online learning will increasingly complement, and in some cases replace, the conventional education of previous generations.',
    audioAssetPath: 'assets/audio/lesson_066.mp3',
    durationSeconds: 77,
    wordCount: 193,
  ),
  LessonModel(
    id: 'lesson-067',
    title: 'Why Reading Matters',
    category: '教育・学習',
    difficulty: 1,
    transcriptText:
        'Reading is one of the best habits you can build. '
        'When you read, you learn new words and discover new ideas. '
        'Books can take you to faraway places and different times without leaving your chair. '
        'Reading a little every day can make you a better writer. '
        'It also helps you relax after a busy day. '
        'You do not need to read fast; what matters is that you enjoy the story. '
        'Over time, this habit will bring great rewards.',
    audioAssetPath: 'assets/audio/lesson_067.mp3',
    durationSeconds: 47,
    wordCount: 78,
  ),
  LessonModel(
    id: 'lesson-068',
    title: 'Exploring STEM Education',
    category: '教育・学習',
    difficulty: 2,
    transcriptText:
        'STEM education focuses on science, technology, engineering, and mathematics. '
        'These subjects are becoming more important as our world depends more and more on technology. '
        'In a good STEM class, students do not just memorize facts from a book. '
        'Instead, they build robots, run experiments, and solve real problems using their own ideas. '
        'This hands-on approach helps young people develop curiosity and creativity. '
        'It also teaches them to think logically and work well in teams, skills that are valuable in almost any career. '
        'Many schools now encourage girls to take part, since these fields have long needed more diverse voices. '
        'Learning to code, design, or analyze data opens the door to exciting jobs. '
        'More importantly, STEM education turns students from passive users into confident creators who can shape the future.',
    audioAssetPath: 'assets/audio/lesson_068.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-069',
    title: 'Today\'s Weather Report',
    category: 'ニュース',
    difficulty: 1,
    transcriptText:
        'Good morning, and here is today\'s weather report. '
        'This morning will be cool and cloudy, with temperatures near ten degrees. '
        'By the afternoon, the clouds will clear, and the sun will bring warmer weather. '
        'There is a small chance of light rain in the evening, so you may want an umbrella. '
        'Tomorrow looks bright and sunny, perfect for time outside. '
        'Remember to wear a light jacket in the morning. '
        'That is all for now. '
        'Have a wonderful day.',
    audioAssetPath: 'assets/audio/lesson_069.mp3',
    durationSeconds: 47,
    wordCount: 78,
  ),
  LessonModel(
    id: 'lesson-070',
    title: 'News From Our Community',
    category: 'ニュース',
    difficulty: 2,
    transcriptText:
        'In local news tonight, our city is celebrating the reopening of the historic downtown library after two years of renovation. '
        'The building, which first opened nearly a century ago, now features a modern children\'s section, faster internet, and a bright community meeting room. '
        'Hundreds of residents gathered this morning for the opening ceremony, where the mayor thanked the volunteers and donors who made the project possible. '
        'Many families said they were thrilled to have their favorite gathering place back. '
        'In other news, the city council announced plans to add new bicycle lanes along the main road, aiming to make travel safer and reduce traffic. '
        'Finally, the annual food festival returns to the central park this weekend, promising live music, local vendors, and plenty of delicious dishes for everyone to enjoy.',
    audioAssetPath: 'assets/audio/lesson_070.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-071',
    title: 'A New Mission to a Distant Moon',
    category: 'ニュース',
    difficulty: 3,
    transcriptText:
        'Scientists around the world are celebrating tonight following the successful launch of an ambitious mission aimed at exploring one of the distant moons of the outer solar system. '
        'The spacecraft, developed over more than a decade by an international team of engineers, carries a sophisticated array of instruments designed to search for the chemical ingredients that could, in theory, support primitive life. '
        'According to mission directors, the probe will travel for several years before reaching its destination, where it will gather detailed measurements of the moon\'s icy surface and the vast ocean believed to lie hidden beneath it. '
        'Researchers are particularly intrigued by evidence suggesting that this subsurface sea may contain more water than all of Earth\'s oceans combined. '
        'While no one expects to discover advanced civilizations, even the detection of simple microbes would profoundly reshape our understanding of where life can arise. '
        'The mission also represents a remarkable example of global cooperation, uniting agencies from multiple continents behind a shared scientific goal. '
        'As the spacecraft begins its long and lonely voyage, millions of curious observers on Earth will be watching, eager for the discoveries that lie ahead.',
    audioAssetPath: 'assets/audio/lesson_071.mp3',
    durationSeconds: 75,
    wordCount: 188,
  ),
  LessonModel(
    id: 'lesson-072',
    title: 'Renewable Energy Reaches a Milestone',
    category: 'ニュース',
    difficulty: 3,
    transcriptText:
        'Energy analysts released a landmark report this week revealing that renewable sources now generate a record share of the world\'s electricity, marking a significant milestone in the global effort to combat climate change. '
        'According to the study, wind and solar power expanded more rapidly than any other energy source over the past year, driven by falling costs and increasingly supportive government policies. '
        'In several countries, electricity generated from sunlight and wind has become cheaper than that produced by burning coal or gas, a shift that would have seemed unimaginable a generation ago. '
        'Experts caution, however, that challenges remain. '
        'Because the sun does not always shine and the wind does not always blow, nations must invest heavily in large batteries and modernized power grids. '
        'The report also highlights the importance of retraining workers from traditional industries so that no community is left behind during the transition. '
        'Environmental groups welcomed the findings as encouraging evidence that a cleaner future is within reach, while urging leaders to accelerate their commitments. '
        'Although the road ahead is long and complex, the authors conclude that the momentum behind renewable energy is now unstoppable, offering genuine hope for reducing the emissions warming our planet.',
    audioAssetPath: 'assets/audio/lesson_072.mp3',
    durationSeconds: 79,
    wordCount: 197,
  ),
  LessonModel(
    id: 'lesson-073',
    title: 'First Day Introduction',
    category: 'ビジネス',
    difficulty: 1,
    transcriptText:
        'Good morning, everyone. '
        'My name is Daniel, and today is my first day on the team. '
        'I am happy to be here. '
        'In my last job, I worked in customer support for three years. '
        'I enjoy helping people and solving problems. '
        'In my free time, I like to read and go running. '
        'I still have a lot to learn, so please be patient with me. '
        'Thank you for the warm welcome. '
        'I look forward to working with all of you.',
    audioAssetPath: 'assets/audio/lesson_073.mp3',
    durationSeconds: 48,
    wordCount: 80,
  ),
  LessonModel(
    id: 'lesson-074',
    title: 'Project Update Meeting',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'Thank you all for joining this project update. '
        'Over the past two weeks, our team has made solid progress on the new mobile app. '
        'The design phase is now complete, and the engineering team has started building the main features. '
        'We are on schedule, but I want to highlight one risk. '
        'The payment system depends on a third-party service, and their documentation has been unclear. '
        'To avoid delays, I have scheduled a call with their support team this Friday. '
        'On the budget side, we are spending slightly less than planned, which gives us room for testing. '
        'Before we launch, I would like to run a small trial with ten real users. '
        'Their feedback will help us fix problems early. '
        'If everyone agrees, I will send a detailed timeline by tomorrow.',
    audioAssetPath: 'assets/audio/lesson_074.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-075',
    title: 'Leading Through Change',
    category: 'ビジネス',
    difficulty: 3,
    transcriptText: 'Leading a company through significant change is one of the most demanding responsibilities a manager can face. When we announced the restructuring last quarter, many employees understandably felt anxious about their roles and their future. My first priority was transparency. Rather than hiding behind vague statements, I chose to explain exactly why the decisions were necessary, even when the answers were uncomfortable. People can tolerate difficult news far better than they can tolerate uncertainty. Throughout the transition, we held weekly sessions where anyone could ask questions directly, and we committed to answering honestly, without corporate jargon. We also invested heavily in retraining, because letting talented people go is both expensive and demoralizing. Interestingly, productivity did not collapse as some had predicted. Instead, teams that felt respected became remarkably resilient. The lesson I have carried forward is deceptively simple: employees do not resist change itself, they resist being treated as passive objects of change. When you invite people into the reasoning behind a decision, you transform potential resistance into genuine ownership. That single shift in approach has shaped how I lead every project since.',
    audioAssetPath: 'assets/audio/lesson_075.mp3',
    durationSeconds: 73,
    wordCount: 183,
  ),
  LessonModel(
    id: 'lesson-076',
    title: 'Product Pitch For Owners',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'Hello, and thank you for your time. '
        'I would like to briefly introduce our new scheduling tool for small businesses. '
        'Many owners tell us that managing appointments by phone wastes hours every week. '
        'Our software lets customers book online, receive automatic reminders, and reschedule without a single phone call. '
        'On average, our clients reduce missed appointments by about thirty percent. '
        'Setup takes less than ten minutes, and no technical skills are required. '
        'We also offer a free trial for two weeks, so you can test everything before you decide. '
        'If you have a question during the trial, our support team replies within one business day. '
        'I truly believe this tool can save you time and help your business grow. '
        'Would you be open to a short demo next week?',
    audioAssetPath: 'assets/audio/lesson_076.mp3',
    durationSeconds: 59,
    wordCount: 129,
  ),
  LessonModel(
    id: 'lesson-077',
    title: 'Rescheduling A Meeting',
    category: 'ビジネス',
    difficulty: 1,
    transcriptText:
        'Hi Sarah, this is Tom from the sales team. '
        'I am calling about the meeting on Thursday. '
        'I am sorry, but I need to change the time. '
        'Something came up, so can we meet at two o\'clock instead? '
        'Please let me know if that works for you. '
        'I also want to talk about the new report before we send it to the client. '
        'If you have ten minutes today, please call me back. '
        'Thank you very much.',
    audioAssetPath: 'assets/audio/lesson_077.mp3',
    durationSeconds: 46,
    wordCount: 77,
  ),
  LessonModel(
    id: 'lesson-078',
    title: 'My Quiet Morning Routine',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'Every morning, I wake up at six thirty. '
        'First, I open the window to let in fresh air. '
        'Then I make a cup of coffee and sit at the kitchen table. '
        'I like the quiet before the day begins. '
        'After that, I take a short walk around the block. '
        'The streets are calm, and I often see the same friendly dog. '
        'When I come back, I feel ready for work. '
        'This simple routine makes me happy.',
    audioAssetPath: 'assets/audio/lesson_078.mp3',
    durationSeconds: 46,
    wordCount: 76,
  ),
  LessonModel(
    id: 'lesson-079',
    title: 'A Trip To The Market',
    category: '日常会話',
    difficulty: 2,
    transcriptText:
        'Last Saturday, I decided to visit the farmers market for the first time in months. '
        'I usually shop at the supermarket, but I wanted something different. '
        'The market was busier than I expected, full of colorful stalls and the smell of fresh bread. '
        'I bought tomatoes, some local honey, and a bunch of flowers for my kitchen table. '
        'One of the farmers explained how he grows his vegetables without chemicals, and I found it interesting. '
        'Later, I stopped at a little stand selling homemade soup and had a warm bowl in the sunshine. '
        'On my way home, I felt relaxed and grateful. '
        'It reminded me that slowing down can be surprisingly enjoyable. '
        'Now I plan to go every weekend, not just to buy food, but to enjoy the friendly atmosphere.',
    audioAssetPath: 'assets/audio/lesson_079.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-080',
    title: 'Settling Into A New City',
    category: '日常会話',
    difficulty: 3,
    transcriptText: 'When I first moved to a new city for work, I underestimated how disorienting it would feel to be completely surrounded by strangers. For the first few weeks, everything seemed slightly off: the buses ran on unfamiliar routes, the local shops closed at odd hours, and even ordering coffee felt like a small performance I hadn\'t rehearsed. I remember evenings when the silence in my apartment felt almost heavy, and I questioned whether the move had been a mistake. Gradually, though, the city began to reveal its quieter charms. I discovered a tiny bookshop tucked between two cafes, where the owner remembered my name after only two visits. I learned which park bench caught the morning sun, and where to find the best noodles at midnight. What surprised me most was how loneliness slowly transformed into a kind of comfortable independence. I stopped waiting for the city to welcome me and started building my own small routines within it. Looking back now, that difficult adjustment taught me something valuable: belonging is not something you are given, it is something you patiently create, one ordinary habit at a time.',
    audioAssetPath: 'assets/audio/lesson_080.mp3',
    durationSeconds: 75,
    wordCount: 188,
  ),
  LessonModel(
    id: 'lesson-081',
    title: 'My Lazy Orange Cat',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'I have a small orange cat named Milo. '
        'He is three years old, and he loves to sleep in the sun. '
        'Every afternoon, he finds a warm spot by the window and stays there for hours. '
        'When I come home, he runs to the door and meows loudly. '
        'I think he is happy to see me, but maybe he just wants food. '
        'Milo is a little lazy, but he is my best friend.',
    audioAssetPath: 'assets/audio/lesson_081.mp3',
    durationSeconds: 44,
    wordCount: 73,
  ),
  LessonModel(
    id: 'lesson-082',
    title: 'Learning To Play Guitar',
    category: '日常会話',
    difficulty: 2,
    transcriptText:
        'A few months ago, I finally decided to learn the guitar. '
        'I had wanted to play since I was a teenager, but I always found an excuse not to start. '
        'The first weeks were frustrating. '
        'My fingers hurt, the chords sounded terrible, and I could barely switch between two notes without stopping. '
        'There were evenings when I thought about giving up. '
        'But I set a goal: just ten minutes of practice every day, no matter how tired I felt. '
        'Slowly, something changed. '
        'My fingers grew stronger, and one afternoon I played a simple song from beginning to end without a single mistake. '
        'That small victory felt amazing. '
        'It taught me an important lesson too. '
        'Progress does not come from big bursts of effort, but from showing up again and again.',
    audioAssetPath: 'assets/audio/lesson_082.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-083',
    title: 'Why Sleep Matters',
    category: 'プレゼン',
    difficulty: 3,
    transcriptText: 'We live in a culture that treats sleep as a luxury, or worse, as a sign of laziness. We brag about how little we slept, as if exhaustion were a badge of honor. But science tells a very different story. While you sleep, your brain is anything but idle. It is busy consolidating memories, clearing away toxic waste products, and rebalancing the chemistry that regulates your mood. A single night of poor sleep measurably impairs your attention, your judgment, and even your ability to read other people\'s emotions. Chronic sleep deprivation has been linked to heart disease, weakened immunity, and a significantly higher risk of dementia later in life. Yet we continue to sacrifice sleep for one more episode, one more email, one more scroll through our phones. I want to challenge you to reconsider that trade. Imagine treating your eight hours not as wasted time, but as the foundation on which everything else depends: your creativity, your relationships, your health. Protecting your sleep is not self-indulgence. It may be one of the most rational, most productive decisions you can make. So tonight, when the screen glows and one more click beckons, choose rest instead.',
    audioAssetPath: 'assets/audio/lesson_083.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),
  LessonModel(
    id: 'lesson-084',
    title: 'Rethinking Failure',
    category: 'プレゼン',
    difficulty: 2,
    transcriptText:
        'Most of us are taught to fear failure, to see it as the opposite of success. '
        'But what if failure is a necessary part of the path? '
        'Think about how a child learns to walk. '
        'They fall, again and again, dozens of times a day. '
        'Nobody calls that failing. '
        'We call it learning. '
        'Somewhere along the way, though, we begin to treat every mistake as evidence that we are not good enough. '
        'That fear makes us cautious, and caution stops us from trying new things. '
        'I am not asking you to enjoy failure. '
        'Nobody enjoys it. '
        'But I am asking you to change your relationship with it. '
        'Next time something goes wrong, resist the urge to feel ashamed. '
        'Instead, ask one simple question: what is this trying to teach me?',
    audioAssetPath: 'assets/audio/lesson_084.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-085',
    title: 'The Value Of Boredom',
    category: 'プレゼン',
    difficulty: 3,
    transcriptText: 'I want to make an unusual argument today: that boredom might be one of the most undervalued experiences in modern life. A generation ago, boredom was simply part of being human. We waited in lines, stared out of train windows, and let our minds wander with nowhere in particular to go. Today, that empty space has all but vanished. The moment a flicker of boredom appears, we reach instinctively for our phones, filling every gap with notifications, videos, and endless streams of content. But here is what we are quietly losing. Boredom is not merely the absence of stimulation. It is the fertile ground from which reflection, creativity, and self-understanding grow. Some of our best ideas arrive precisely when the mind is left unoccupied, free to make unexpected connections. When we eliminate every dull moment, we also eliminate the space where imagination breathes. I am not suggesting we abandon technology. I am suggesting we reclaim a little discomfort. Try sitting quietly, without a screen, and simply letting your thoughts drift. It may feel strange at first, even unbearable. But within that emptiness, you may rediscover a part of your mind you had almost forgotten existed.',
    audioAssetPath: 'assets/audio/lesson_085.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),
  LessonModel(
    id: 'lesson-086',
    title: 'Small Acts Of Kindness',
    category: 'プレゼン',
    difficulty: 1,
    transcriptText:
        'Today I want to talk about small acts of kindness. '
        'We often think we need to do something big to change the world. '
        'But that is not true. '
        'A simple smile can brighten someone\'s day. '
        'Saying thank you can make a tired worker feel seen. '
        'Holding a door or listening can mean more than we know. '
        'These actions cost us nothing, yet they spread quickly. '
        'So today, try one small act of kindness. '
        'It matters more than you think.',
    audioAssetPath: 'assets/audio/lesson_086.mp3',
    durationSeconds: 47,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-087',
    title: 'Learning To Swim',
    category: 'スポーツ',
    difficulty: 1,
    transcriptText:
        'Swimming is a great sport for people of all ages. '
        'When I was young, I was afraid of the water. '
        'My coach was kind and patient. '
        'First, I learned to float on my back. '
        'Then I practiced kicking my legs. '
        'After many lessons, I could swim across the pool. '
        'Now I go twice a week. '
        'Swimming makes me feel strong and calm, and it is good for my body. '
        'If you want to try it, do not give up.',
    audioAssetPath: 'assets/audio/lesson_087.mp3',
    durationSeconds: 48,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-088',
    title: 'A Morning Run In The Park',
    category: 'スポーツ',
    difficulty: 1,
    transcriptText:
        'Every morning I go for a run in the park near my house. '
        'I wake up early, put on my shoes, and step outside. '
        'The air is cool and fresh. '
        'I start with a slow walk to warm up. '
        'Then I run along the path under the trees. '
        'Sometimes I see other runners and we say hello. '
        'Birds sing in the branches above me. '
        'After thirty minutes, I feel tired but happy. '
        'Running helps me feel awake and ready.',
    audioAssetPath: 'assets/audio/lesson_088.mp3',
    durationSeconds: 47,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-089',
    title: 'The Excitement Of Rock Climbing',
    category: 'スポーツ',
    difficulty: 2,
    transcriptText: 'Rock climbing has become one of my favorite weekend activities. At first, I was nervous about reaching for holds high above the ground, but a good harness and rope kept me safe. My instructor taught me to trust my legs instead of pulling too hard with my arms. Climbing is like solving a puzzle with your whole body. You must decide where to place each hand and foot before you move. Indoor gyms are perfect for beginners because the walls have colorful holds and soft mats below. As I improved, I started climbing real cliffs outdoors. The feeling of reaching the top and looking out at the view is truly unforgettable, and it builds both confidence and patience.',
    audioAssetPath: 'assets/audio/lesson_089.mp3',
    durationSeconds: 54,
    wordCount: 118,
  ),
  LessonModel(
    id: 'lesson-090',
    title: 'The Team Spirit Of Rugby',
    category: 'スポーツ',
    difficulty: 3,
    transcriptText: 'Rugby is often described as a rough sport played with remarkable discipline and respect. What fascinates me most is the balance between raw physical power and intricate teamwork. Fifteen players on each side must coordinate their movements, communicating constantly to break through the opposing defense while protecting their own line. Unlike many sports, rugby demands that every player contribute to both attack and defense, blurring the traditional boundaries between offensive and defensive roles. The scrum, in particular, is a fascinating display of collective strength, where eight forwards bind together and drive forward as a single unit. Beyond the physical intensity, rugby cultivates a culture of humility and camaraderie. Opponents who collide fiercely on the field will often share meals and stories afterward, a tradition that reflects the sport\'s deep-rooted values of sportsmanship and mutual respect that endure long after the final whistle.',
    audioAssetPath: 'assets/audio/lesson_090.mp3',
    durationSeconds: 58,
    wordCount: 142,
  ),
  LessonModel(
    id: 'lesson-091',
    title: 'My Favorite Cooking App',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText:
        'I love to cook, but I never know what to make for dinner. '
        'Last month, I downloaded a cooking app on my phone. '
        'Now it is easy to find new recipes. '
        'I just type in the food I have at home, and the app shows me many ideas. '
        'Each recipe has clear steps and nice photos. '
        'I can also save my favorite meals for later. '
        'Thanks to this simple tool, I now enjoy cooking much more.',
    audioAssetPath: 'assets/audio/lesson_091.mp3',
    durationSeconds: 45,
    wordCount: 76,
  ),
  LessonModel(
    id: 'lesson-092',
    title: 'How Robots Help At Home',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText:
        'Robots are no longer in movies. '
        'Today, many people use robots at home. '
        'My family has a robot that cleans the floor. '
        'It moves around by itself and picks up dust. '
        'We turn it on before we leave for work. '
        'When we come home, the floor is clean. '
        'Some robots help in the kitchen, and others water plants or feed pets. '
        'These machines save us time and make life easier. '
        'Robots will become more common in the future.',
    audioAssetPath: 'assets/audio/lesson_092.mp3',
    durationSeconds: 47,
    wordCount: 78,
  ),
  LessonModel(
    id: 'lesson-093',
    title: 'The Rise Of Electric Cars',
    category: 'テクノロジー',
    difficulty: 2,
    transcriptText: 'Electric cars are changing the way we think about driving. Instead of using gasoline, they run on batteries that you charge at home or at special stations. Many people choose electric cars because they are quiet and do not produce smoke from the exhaust. This helps keep the air cleaner in our cities. At first, drivers worried that the batteries would not last long enough for long trips. However, modern cars can now travel hundreds of kilometers on a single charge. Charging stations are also appearing in more places, from shopping centers to highway rest stops. Although electric cars can be expensive to buy, they often cost less to run over time. As technology improves, these vehicles are becoming a practical choice for everyday families.',
    audioAssetPath: 'assets/audio/lesson_093.mp3',
    durationSeconds: 58,
    wordCount: 125,
  ),
  LessonModel(
    id: 'lesson-094',
    title: 'Understanding Cloud Computing',
    category: 'テクノロジー',
    difficulty: 2,
    transcriptText: 'Have you ever wondered where your photos go when you save them online? The answer is often the cloud. Cloud computing means storing and using data on powerful computers far away instead of on your own device. These computers, called servers, sit in huge buildings known as data centers. When you upload a picture or send an email, it travels across the internet to one of these servers. The main benefit is convenience, because you can reach your files from any device with a connection. Businesses also use the cloud to run websites and applications without buying expensive equipment. This saves money and allows them to grow quickly. However, it is important to protect your accounts with strong passwords, since your information is stored somewhere you cannot see.',
    audioAssetPath: 'assets/audio/lesson_094.mp3',
    durationSeconds: 59,
    wordCount: 128,
  ),
  LessonModel(
    id: 'lesson-095',
    title: 'The Promise Of Quantum Computing',
    category: 'テクノロジー',
    difficulty: 3,
    transcriptText: 'Quantum computing represents one of the most ambitious frontiers in modern science, promising to solve problems that would overwhelm even the fastest traditional computers. Ordinary machines store information as bits, which are either zero or one. Quantum computers, by contrast, use quantum bits, or qubits, which can exist in multiple states simultaneously thanks to a strange property called superposition. This allows them to explore many possible solutions at once rather than checking them one by one. Another remarkable phenomenon, known as entanglement, links qubits together so that changing one instantly affects another. Scientists believe these machines could revolutionize fields such as medicine, cryptography, and climate modeling by simulating complex molecules and systems. Yet the technology remains fragile and enormously difficult to control, since qubits are easily disturbed by heat and noise. Researchers around the world are racing to build stable machines, and their progress may reshape the boundaries of what computers can achieve.',
    audioAssetPath: 'assets/audio/lesson_095.mp3',
    durationSeconds: 61,
    wordCount: 153,
  ),
  LessonModel(
    id: 'lesson-096',
    title: 'A New Library Opens Downtown',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText:
        'A new library opened in our town last week. '
        'Many people came to see it on the first day. '
        'The building is bright and modern, with large windows and comfortable chairs. '
        'Children have their own reading room full of colorful books. '
        'The library offers free internet and computers for everyone. '
        'On weekends, staff will hold story time for kids. '
        'I visited yesterday and borrowed three books. '
        'I am happy that our town now has a wonderful place to read.',
    audioAssetPath: 'assets/audio/lesson_096.mp3',
    durationSeconds: 47,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-097',
    title: 'Recycling Rules Change This Month',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText:
        'Our city has new recycling rules that start this month. '
        'The government wants to reduce waste and protect the environment. '
        'Now we must separate our trash into more groups. '
        'Paper, glass, and plastic all go into different bins. '
        'Food waste has its own special bag. '
        'The city sent a simple guide to every home to help. '
        'If we follow the rules, less garbage will go to landfills. '
        'Small changes like these can make a big difference for our future.',
    audioAssetPath: 'assets/audio/lesson_097.mp3',
    durationSeconds: 48,
    wordCount: 79,
  ),
  LessonModel(
    id: 'lesson-098',
    title: 'Cities Respond To Rising Heat',
    category: '時事ネタ',
    difficulty: 2,
    transcriptText: 'This summer, many cities around the world have experienced record-breaking temperatures. In response, local governments are taking new steps to keep their residents safe. Some towns have opened cooling centers where people can rest in air-conditioned rooms during the hottest hours. Others are planting more trees along streets to provide shade and lower the temperature naturally. Officials are also warning people to drink plenty of water and to check on elderly neighbors who live alone. Schools in certain areas have changed their schedules so that children are not outside during the afternoon heat. Experts say that these extreme conditions may become more common in the years ahead. As a result, communities are learning to prepare better and to share information quickly, hoping to protect the most vulnerable members of society.',
    audioAssetPath: 'assets/audio/lesson_098.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
  LessonModel(
    id: 'lesson-099',
    title: 'The Global Push For Clean Energy',
    category: '時事ネタ',
    difficulty: 3,
    transcriptText: 'Across the globe, nations are accelerating their efforts to transition toward cleaner sources of energy, driven by both environmental concerns and economic opportunity. Governments that once relied heavily on coal and oil are now investing billions in solar farms, wind turbines, and hydroelectric projects. This shift is reshaping entire industries and creating new kinds of jobs, from installing panels to maintaining vast networks of batteries that store surplus power. International agreements have set ambitious targets, urging countries to reduce their emissions within the coming decades. Yet the path forward is far from simple. Developing nations argue that they should not bear the same burden as wealthier countries that industrialized long ago. Meanwhile, questions remain about how to build reliable systems that function even when the sun does not shine and the wind does not blow. Despite these challenges, the momentum behind renewable energy appears unstoppable, signaling a profound transformation in how humanity powers its future.',
    audioAssetPath: 'assets/audio/lesson_099.mp3',
    durationSeconds: 62,
    wordCount: 155,
  ),
  LessonModel(
    id: 'lesson-100',
    title: 'The Strategy Behind Marathon Running',
    category: 'スポーツ',
    difficulty: 2,
    transcriptText:
        'Running a marathon is about far more than being fast. '
        'The real challenge lies in managing your energy over a distance of more than forty kilometers. '
        'Experienced runners learn to control their pace from the beginning, resisting the temptation to sprint ahead when they feel fresh. '
        'Instead, they aim for a steady rhythm that they can maintain for hours. '
        'Nutrition and hydration also play a crucial role, so many athletes drink water and eat snacks along the route to avoid running out of fuel. '
        'Training takes months of preparation, gradually increasing the distance each week. '
        'Mental strength matters just as much as physical fitness, because there are moments when the body wants to stop. '
        'Crossing the finish line brings a powerful sense of achievement that makes all the effort worthwhile.',
    audioAssetPath: 'assets/audio/lesson_100.mp3',
    durationSeconds: 60,
    wordCount: 130,
  ),
];
