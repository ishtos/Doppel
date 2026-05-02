import '../../features/lesson/data/models/lesson_model.dart';

const seedLessons = [
  // ── ニュース ──

  LessonModel(
    id: 'lesson-001',
    title: 'Morning News Report',
    category: 'ニュース',
    difficulty: 1,
    transcriptText:
        'Good morning and welcome to the morning news report. '
        'Today we begin with the latest developments in technology. '
        'The world of artificial intelligence continues to grow at a rapid pace. '
        'New breakthroughs are being made every single day, changing the way we live and work. '
        'Researchers at several leading universities have announced exciting new findings this week. '
        'Their work focuses on making computers better at understanding human language. '
        'This could lead to improvements in everything from customer service to medical care. '
        'In other news, the weather forecast for today shows clear skies across most of the country. '
        'Temperatures will be mild, reaching about twenty degrees in the afternoon. '
        'However, there is a chance of light rain later in the evening, so you may want to carry an umbrella just in case. '
        'Moving on to business news, the stock market had a strong day yesterday. '
        'Technology companies led the gains, with several major firms reporting better than expected results for the quarter. '
        'Economists say this is a positive sign for the economy as a whole. '
        'Looking at sports, the national soccer team won their match last night with a score of two to one. '
        'The winning goal came in the final minutes of the game, sending fans into celebration. '
        'The team will play again next week in the semifinal round. '
        'Finally, in local news, a new community center will open its doors this weekend. '
        'The center will offer free classes in art, music, and language for people of all ages. '
        'City officials say they hope the center will bring the community closer together. '
        'That is all for this morning. Thank you for watching, and we hope you have a wonderful day ahead.',
    audioAssetPath: 'assets/audio/lesson_001.mp3',
    durationSeconds: 169,
    wordCount: 281,
  ),
  LessonModel(
    id: 'lesson-007',
    title: 'Breaking News: Economy',
    category: 'ニュース',
    difficulty: 2,
    transcriptText:
        'In economic news today, the central bank announced a significant change in interest rates, '
        'cutting the benchmark rate by a quarter of a percentage point. '
        'This decision is expected to have a major impact on the housing market, '
        'as lower rates make it cheaper for people to borrow money for homes. '
        'Analysts suggest that consumers should think carefully about their financial plans in light of this change. '
        'The stock market reacted positively to the news, with major indexes rising sharply in afternoon trading. '
        'Banking stocks were among the biggest movers, as investors assessed how the rate cut would affect profits. '
        'Meanwhile, the national unemployment rate fell to three point eight percent, '
        'its lowest level in over a decade. Economists point to strong job creation in the technology and healthcare sectors '
        'as the main drivers of this improvement. However, some experts warn that wages have not kept pace with the rising cost of living. '
        'Housing prices in major cities continue to climb, making it difficult for young professionals to enter the market. '
        'A government spokesperson said new housing initiatives would be announced in the coming weeks. '
        'In international trade news, negotiations between the two largest economies appear to be making progress. '
        'Both sides have agreed to reduce certain tariffs, which could boost global trade volumes significantly. '
        'Business leaders have welcomed the development, saying it would create new opportunities for growth and investment. '
        'The currency markets also responded to these developments, with the dollar strengthening against most major currencies. '
        'Financial advisors recommend that individuals review their investment portfolios and consider diversifying their holdings. '
        'Looking ahead, the next major economic report is due out on Friday, and markets will be watching closely for any surprises. '
        'That wraps up our economic coverage for today. Stay tuned for more updates throughout the evening.',
    audioAssetPath: 'assets/audio/lesson_007.mp3',
    durationSeconds: 138,
    wordCount: 298,
  ),
  LessonModel(
    id: 'lesson-015',
    title: 'Rapid News Broadcast',
    category: 'ニュース',
    difficulty: 3,
    transcriptText:
        'Good evening. Here are tonight\'s top stories. '
        'The government has announced a major infrastructure spending package worth two hundred billion dollars, '
        'focusing on bridges, highways, and public transit systems across the country. '
        'The plan is expected to create three million jobs over the next five years '
        'and represents the largest investment in public infrastructure in more than a generation. '
        'Critics argue the spending is excessive and could increase the national debt to dangerous levels. '
        'In international news, peace talks between the two nations have resumed after a three-month pause, '
        'with diplomats expressing cautious optimism about reaching a comprehensive agreement before the end of the year. '
        'The lead negotiator told reporters that significant progress was made during today\'s session. '
        'On the technology front, the world\'s largest smartphone manufacturer reported record quarterly earnings, '
        'driven by strong demand for its latest AI-powered devices. '
        'Revenue surged thirty-two percent compared to the same period last year, exceeding analyst expectations by a wide margin. '
        'The company also announced plans to open three new research centers focused on next-generation semiconductor design. '
        'Meanwhile, a powerful earthquake measuring six point eight on the Richter scale struck the Pacific coast early this morning. '
        'Fortunately, no casualties have been reported, though some coastal areas experienced minor flooding and structural damage. '
        'Emergency response teams have been deployed to the affected regions and officials urge residents to remain vigilant for aftershocks. '
        'In sports, the national team secured a dramatic last-minute victory in the championship semifinals, '
        'with the captain scoring the decisive goal in stoppage time to send the stadium into a frenzy. '
        'The team will face the defending champions in next Saturday\'s final. We\'ll have full coverage after the break.',
    audioAssetPath: 'assets/audio/lesson_015.mp3',
    durationSeconds: 111,
    wordCount: 277,
  ),

  // ── ビジネス ──

  // FIXED: 初級ビジネスレッスンを追加（難易度ギャップを解消）
  LessonModel(
    id: 'lesson-017',
    title: 'First Day at Work',
    category: 'ビジネス',
    difficulty: 1,
    transcriptText:
        'Good morning and welcome to the team. My name is Sarah, and I will be helping you get started on your first day. '
        'Let me begin by showing you around the office. This is the main work area where most of our team sits. '
        'Over there is the break room where you can find coffee, tea, and water anytime you need a drink. '
        'The meeting rooms are on the second floor. You can book them through our online calendar system. '
        'Now let me explain a few important things about how we work here. '
        'Our office hours are from nine in the morning until five in the afternoon, Monday through Friday. '
        'Most people arrive a little early to get settled in before the day starts. '
        'We have a team meeting every Monday at ten o\'clock. It usually lasts about thirty minutes. '
        'During the meeting, each person shares what they are working on and whether they need any help. '
        'Your manager will meet with you every two weeks to discuss your progress and answer your questions. '
        'We use email for most of our communication, but for quick questions you can use our messaging app. '
        'Please check your email at least twice a day so you do not miss anything important. '
        'For lunch, there are several restaurants and cafes within walking distance of the office. '
        'Many people also bring their own lunch and eat together in the break room. '
        'It is a great way to get to know your colleagues and feel at home. '
        'If you ever have a problem or need help with anything, please do not hesitate to ask. '
        'Everyone here is very friendly and always happy to help new team members. '
        'I hope you enjoy your first day with us. Let me now take you to meet your team.',
    audioAssetPath: 'assets/audio/lesson_017.mp3',
    durationSeconds: 179,
    wordCount: 299,
  ),

  LessonModel(
    id: 'lesson-002',
    title: 'Business Meeting Basics',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'Thank you for joining this meeting today. I would like to go through the agenda quickly before we begin. '
        'First, we will review last quarter\'s results. Then, we will discuss our strategy for the next quarter. '
        'Finally, I\'d like to hear your thoughts on the new project proposal. '
        'So let\'s start with the numbers. Our revenue for the third quarter came in at twelve point five million dollars, '
        'which is an increase of eight percent compared to the same period last year. '
        'This is largely thanks to strong performance in our digital products division. '
        'Customer satisfaction scores also improved, reaching an all-time high of ninety-two percent. '
        'Our support team deserves a lot of credit for that achievement. '
        'However, I should note that our operating costs increased by about five percent. '
        'We need to find ways to improve efficiency without sacrificing quality. '
        'Now, looking ahead to the next quarter, I believe we have a real opportunity to accelerate our growth. '
        'The market research team has identified several promising segments that we have not yet explored. '
        'I would like to propose that we allocate additional resources to our marketing efforts in these areas. '
        'We also need to invest in training for our sales team to help them adapt to the new product line. '
        'Before I move on, does anyone have questions about the quarterly results? '
        'Great. Let me now introduce the new project proposal. '
        'This initiative would involve building a mobile application for our enterprise clients. '
        'The estimated development timeline is six months, and the projected return on investment is significant. '
        'I\'d like each department head to review the proposal document and send me feedback by Friday. '
        'Thank you all for your time today. Let\'s make the next quarter our best one yet.',
    audioAssetPath: 'assets/audio/lesson_002.mp3',
    durationSeconds: 134,
    wordCount: 291,
  ),
  LessonModel(
    id: 'lesson-006',
    title: 'Product Presentation',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText:
        'I\'m very excited to introduce our latest product today. '
        'This solution addresses the key challenges that our customers have been facing for years. '
        'Let me walk you through the main features and benefits. '
        'As you can see on the screen, the interface is intuitive and user-friendly. '
        'We designed it with the end user in mind, conducting extensive research and testing over the past twelve months. '
        'The first feature I want to highlight is the smart dashboard. '
        'It gives users a complete overview of their data in real time, with customizable widgets and filters. '
        'Our beta testers reported saving an average of two hours per day just by using this one feature alone. '
        'The second key feature is our advanced analytics engine. '
        'It uses machine learning to identify trends and patterns that would be impossible to spot manually. '
        'This means your team can make faster, better-informed decisions based on actual data rather than guesswork. '
        'We also built in powerful collaboration tools. '
        'Team members can share reports, leave comments, and set up automated alerts for important changes. '
        'Everything stays in one place, so there is no need to switch between different applications. '
        'Now let me talk about security. We know this is a top priority for enterprise customers. '
        'Our platform uses end-to-end encryption and complies with all major international data protection standards. '
        'Your data is stored in secure, redundant data centers with ninety-nine point nine percent uptime. '
        'In terms of pricing, we offer flexible plans to fit organizations of any size. '
        'We are confident that once you see the product in action, you will understand why our early customers call it a game changer. '
        'I\'d be happy to answer any questions and schedule a personalized demo for your team.',
    audioAssetPath: 'assets/audio/lesson_006.mp3',
    durationSeconds: 132,
    wordCount: 287,
  ),
  LessonModel(
    id: 'lesson-016',
    title: 'Startup Investor Pitch',
    category: 'ビジネス',
    difficulty: 3,
    transcriptText:
        'Thank you for the opportunity to present today. We are building the next generation of healthcare technology. '
        'Our platform uses artificial intelligence to analyze medical images with ninety-eight percent accuracy, '
        'helping doctors detect diseases earlier and more reliably than ever before. '
        'Let me give you some context on the market. '
        'The healthcare AI market is projected to reach fifty billion dollars by twenty twenty-eight, '
        'and we are uniquely positioned to capture a significant share of that opportunity. '
        'Our team includes former researchers from Stanford and MIT, and we hold twelve patents in medical imaging technology. '
        'What sets us apart from competitors is our proprietary training methodology. '
        'While other companies rely on publicly available datasets, '
        'we have exclusive partnerships with three major hospital networks, giving us access to over ten million anonymized scans. '
        'This data advantage translates directly into superior diagnostic accuracy. '
        'We already serve over two million patients across forty-seven hospitals in twelve countries. '
        'Our net promoter score among physicians is eighty-five, the highest in the industry. '
        'Now let me share our financial performance. Revenue grew three hundred percent last year, '
        'reaching eighteen million dollars in annual recurring revenue. '
        'Our gross margins are seventy-eight percent and improving as we scale. '
        'We are on track to achieve profitability by the end of next quarter. '
        'We are raising thirty million dollars in Series B funding to expand into international markets, '
        'double our engineering team, and accelerate our product development roadmap. '
        'With this funding, we project revenue of sixty million dollars within twenty-four months. '
        'This is your chance to invest in a company that is literally saving lives while delivering exceptional returns to shareholders. '
        'I look forward to your questions.',
    audioAssetPath: 'assets/audio/lesson_016.mp3',
    durationSeconds: 111,
    wordCount: 277,
  ),

  // ── 日常会話 ──

  LessonModel(
    id: 'lesson-003',
    title: 'At the Coffee Shop',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'Hi, could I get a large latte please? '
        'Actually, make that a medium. And could I have it with oat milk? '
        'Sure, that sounds great. Do you have any pastries left? '
        'Oh, the chocolate croissant looks amazing. I\'ll take one of those as well. '
        'Could I also get a glass of water on the side? Thank you so much. '
        'By the way, do you have wi-fi here? I need to get some work done while I wait. '
        'The password is on the board over there? Perfect, thanks. '
        'Actually, excuse me, I just realized I forgot to ask. Is the latte with regular or decaf? '
        'Could you make it decaf, please? I\'ve already had too much coffee this morning. '
        'Oh, and is there an extra charge for the oat milk? Just fifty cents? That\'s fine, no problem at all. '
        'Thank you. This is a really nice place. I\'ve walked past it many times, but this is my first time coming in. '
        'It\'s so cozy and the music is lovely. Do you know what playlist this is? '
        'I love discovering new cafes in the neighborhood. My friend told me about this one. '
        'She said the pastries here are the best in the area, and looking at that croissant, I can already tell she was right. '
        'Oh, my order is ready already? That was fast. '
        'Wow, this looks wonderful. Could I get some sugar please? It\'s just over there by the napkins? Great. '
        'Thank you for your help. I\'ll definitely be coming back. Have a lovely day!',
    audioAssetPath: 'assets/audio/lesson_003.mp3',
    durationSeconds: 152,
    wordCount: 254,
  ),
  LessonModel(
    id: 'lesson-005',
    title: 'Travel Conversations',
    category: '日常会話',
    difficulty: 1,
    transcriptText:
        'Excuse me, could you tell me how to get to the train station? '
        'Go straight ahead and turn right at the traffic light. '
        'It\'s about a five minute walk from here. Thank you very much for your help. '
        'Oh wait, one more question. Do you know which platform the train to the city center leaves from? '
        'Platform three? And how often do the trains run? Every fifteen minutes? That\'s very convenient. '
        'I\'m visiting this city for the first time. It\'s really beautiful. '
        'Could you recommend a good restaurant near the station? '
        'There\'s a nice Italian place just around the corner? That sounds perfect. I love Italian food. '
        'Do I need a reservation, or can I just walk in? Usually it\'s fine for lunch? Great, that\'s good to know. '
        'Also, is there a tourist information center nearby? '
        'I\'d like to get a map of the city and find out about any interesting events happening this week. '
        'It\'s right next to the station? Wonderful, I\'ll stop by before I catch my train. '
        'One last thing. I need to buy a bus pass for tomorrow. Can I get that at the station as well? '
        'There are machines in the main hall where I can buy one? And they accept credit cards? Perfect. '
        'Thank you so much for all your help. You\'ve been incredibly kind. '
        'I hope you enjoy the rest of your day. '
        'Oh, I almost forgot to ask. What time does the last train back to the hotel area leave? '
        'Eleven thirty? That gives me plenty of time. Thanks again and goodbye!',
    audioAssetPath: 'assets/audio/lesson_005.mp3',
    durationSeconds: 156,
    wordCount: 260,
  ),

  // FIXED: 日常会話の中級・上級レッスンを追加（難易度ギャップを解消）
  LessonModel(
    id: 'lesson-018',
    title: 'Weekend Plans with Friends',
    category: '日常会話',
    difficulty: 2,
    transcriptText:
        'Hey, have you made any plans for this weekend yet? I was thinking we could do something fun together. '
        'There is a new Italian restaurant that just opened on Oak Street. I have heard the food is really good. '
        'A friend of mine went there last week and she said the pasta was incredible. '
        'Would you be interested in trying it out on Saturday evening? '
        'We could meet up around six thirty and grab a table before it gets too crowded. '
        'Actually, now that I think about it, we should probably make a reservation. '
        'Popular restaurants tend to fill up quickly on weekends, especially new ones that everyone is talking about. '
        'I will call them this afternoon and see if I can get us a table for four. '
        'Do you think James and Lisa would want to come along? It has been ages since we all got together. '
        'Last time we met up was at that barbecue in July, and that was months ago. '
        'Speaking of which, there is also a food festival happening in the park on Sunday. '
        'They are supposed to have stalls from all different countries, with live music and cooking demonstrations. '
        'It starts at eleven in the morning and goes until nine at night, so we could go anytime. '
        'I was thinking we could head over after lunch, walk around, and try a few things. '
        'The weather forecast says it should be sunny and warm, which would be perfect for an outdoor event. '
        'If it does rain though, we could always go to the cinema instead. '
        'There is that new science fiction movie that just came out. The reviews have been really positive. '
        'Either way, it would be nice to spend some time together outside of work. '
        'Let me know what you think and I will start making arrangements.',
    audioAssetPath: 'assets/audio/lesson_018.mp3',
    durationSeconds: 140,
    wordCount: 303,
  ),
  LessonModel(
    id: 'lesson-019',
    title: 'Apartment Hunting',
    category: '日常会話',
    difficulty: 3,
    transcriptText:
        'I have been looking at apartments for the past three weeks, and honestly, the whole experience has been quite exhausting. '
        'The rental market right now is incredibly competitive, and anything decent gets snapped up within days of being listed. '
        'Last Tuesday, I visited a place in the city center that looked absolutely perfect in the photos. '
        'Two bedrooms, a modern kitchen, plenty of natural light, and a small balcony overlooking the park. '
        'The rent was within my budget, and the location was ideal for my commute to work. '
        'But when I arrived for the viewing, there were already twelve other people waiting to see the same apartment. '
        'The landlord told me she had received over forty applications in the first twenty-four hours. '
        'I submitted my application anyway, but I never heard back, which was incredibly frustrating. '
        'Then on Thursday, I saw another listing that seemed promising. It was slightly further from the center, '
        'but the neighborhood had a reputation for being quiet and family-friendly, with excellent cafes and restaurants nearby. '
        'The apartment itself was spacious, with hardwood floors and high ceilings that gave it a really elegant feel. '
        'The only downside was that the building did not have an elevator, and the unit was on the fifth floor. '
        'I could probably manage the stairs for a while, but carrying groceries up five flights would get old pretty fast. '
        'The real estate agent suggested I should widen my search radius and consider neighborhoods I had not previously thought about. '
        'She mentioned that areas on the east side of the city are undergoing rapid development, '
        'with new shops, restaurants, and transit connections being added all the time. '
        'The prices there are still relatively affordable, though they are expected to rise significantly over the next few years. '
        'I have a few more viewings scheduled for this weekend, so hopefully I will find something soon.',
    audioAssetPath: 'assets/audio/lesson_019.mp3',
    durationSeconds: 124,
    wordCount: 311,
  ),

  // ── TEDスタイル ──

  // FIXED: TEDスタイルの初級・中級レッスンを追加（難易度ギャップを解消）
  LessonModel(
    id: 'lesson-020',
    title: 'TED: The Magic of Reading',
    category: 'TEDスタイル',
    difficulty: 1,
    transcriptText:
        'I want to talk to you today about something very simple but incredibly powerful. Reading. '
        'When was the last time you sat down and read a book from beginning to end? '
        'For many of us, the answer might be a long time ago. '
        'Our lives are so busy that we forget how much a good book can change the way we think. '
        'Reading does something amazing to our brains. When we read a story, our brain acts as if we are actually living it. '
        'If a character in a book is running, the part of our brain that controls movement lights up. '
        'If they are eating a delicious meal, we can almost taste the food ourselves. '
        'This is why reading builds something called empathy, the ability to understand how other people feel. '
        'Studies show that people who read fiction regularly are better at understanding emotions and connecting with others. '
        'They become better listeners, better friends, and better leaders. '
        'But reading is not just about stories. Reading anything at all helps your brain stay sharp and healthy. '
        'Just like your body needs exercise, your brain needs to be challenged and stimulated. '
        'People who read every day have better memory, stronger focus, and clearer thinking. '
        'Some research even suggests that reading can slow down the effects of aging on the brain. '
        'And here is the best part. You do not need to read for hours to see these benefits. '
        'Just fifteen to twenty minutes a day is enough to make a real difference. '
        'That could be on the train to work, during your lunch break, or before you go to sleep at night. '
        'So my challenge to you is simple. Pick up a book this week. Any book. '
        'Give your brain the workout it deserves, and I promise you will not regret it.',
    audioAssetPath: 'assets/audio/lesson_020.mp3',
    durationSeconds: 181,
    wordCount: 301,
  ),
  LessonModel(
    id: 'lesson-021',
    title: 'TED: Sleep and Health',
    category: 'TEDスタイル',
    difficulty: 2,
    transcriptText:
        'How many hours of sleep did you get last night? If your answer is less than seven, you are not alone. '
        'Nearly a third of adults around the world are chronically sleep-deprived, '
        'and the consequences are far more serious than just feeling tired during the day. '
        'Let me share some of the science with you, because the research is genuinely alarming. '
        'When you sleep fewer than six hours a night, your risk of developing heart disease increases by forty-eight percent. '
        'Your immune system weakens significantly, making you more vulnerable to infections. '
        'And your ability to form new memories drops by nearly forty percent compared to when you are well rested. '
        'But perhaps the most surprising finding is how sleep affects our decision-making. '
        'Sleep-deprived individuals consistently make riskier choices and are worse at reading social situations. '
        'In fact, studies have shown that being awake for seventeen hours straight impairs your cognitive performance '
        'as much as having a blood alcohol level of point zero five percent. '
        'So why are so many of us not getting enough sleep? The answer lies partly in our modern lifestyle. '
        'We work longer hours than any previous generation. We stare at screens that emit blue light, '
        'which suppresses the production of melatonin, the hormone that tells our body it is time to sleep. '
        'And we live in a culture that often treats sleep as a luxury rather than a biological necessity. '
        'But there are practical steps you can take to improve your sleep starting tonight. '
        'First, establish a consistent bedtime and wake-up time, even on weekends. '
        'Second, avoid caffeine after two in the afternoon. Third, make your bedroom as dark and cool as possible. '
        'And finally, put away your phone at least thirty minutes before bed. '
        'These changes might seem small, but the impact on your health, your mood, and your productivity can be transformative.',
    audioAssetPath: 'assets/audio/lesson_021.mp3',
    durationSeconds: 142,
    wordCount: 308,
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
        'you can consciously choose a different routine while still getting the reward your brain craves. '
        'This is really the fundamental principle behind habit formation. '
        'But let me go deeper into why this matters so much for your daily life. '
        'Think about your morning routine for a moment. You probably do the same things in roughly the same order every single day. '
        'You wake up, check your phone, brush your teeth, make coffee, and head out the door. '
        'Most of these actions happen on autopilot. Your brain has learned these patterns so well '
        'that it barely uses any energy to execute them. This is incredibly efficient, '
        'but it also means that bad habits can run on autopilot too. '
        'Here is the good news. Once you understand the habit loop, you can begin to take control of it. '
        'Let me give you a real example. Suppose you have a habit of snacking on junk food every afternoon at three o\'clock. '
        'The cue is the time of day. The routine is walking to the vending machine. '
        'But the reward is not actually the food itself. Research shows that what most people are really seeking is a break from work '
        'and a moment of social interaction. So what if you replaced the routine? '
        'Instead of going to the vending machine, you could take a short walk outside or chat with a colleague. '
        'You still get the reward, a pleasant break, but without the unhealthy snack. '
        'The key insight is this: you cannot simply eliminate a habit. You have to replace it with something better. '
        'And the more you practice the new routine, the stronger it becomes. '
        'Over time, the new habit will feel just as automatic as the old one.',
    audioAssetPath: 'assets/audio/lesson_004.mp3',
    durationSeconds: 127,
    wordCount: 317,
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
        'they were not afraid to fail. They embraced failure as a necessary step in the creative process '
        'and used it to fuel their next breakthrough. '
        'Consider the story of Thomas Edison. He famously tested thousands of materials before finding one that worked for the light bulb. '
        'When asked about his failures, he replied that he had not failed, '
        'he had simply found ten thousand ways that did not work. This mindset is what separates creative people from everyone else. '
        'They do not see failure as an ending. They see it as information. '
        'Now, there is a second important element of creative thinking that often gets overlooked, and that is boredom. '
        'We live in a world that constantly fills every moment with stimulation. '
        'We check our phones, scroll through social media, and listen to podcasts during every spare second. '
        'But research shows that some of our best ideas come during moments of quiet reflection. '
        'When your mind is free to wander, it makes unexpected connections between ideas that seem completely unrelated. '
        'This is why people so often report having their best ideas in the shower or while taking a walk. '
        'So here is my challenge to you. This week, try setting aside fifteen minutes each day '
        'with absolutely nothing to do. No phone, no music, no distractions. '
        'Just sit quietly and let your mind wander. You might be surprised at what emerges. '
        'The creative mind needs space to breathe, and in our busy modern world, '
        'giving yourself that space is perhaps the most radical and productive thing you can do.',
    audioAssetPath: 'assets/audio/lesson_008.mp3',
    durationSeconds: 117,
    wordCount: 292,
  ),

  // ── スポーツ ──

  // FIXED: スポーツの追加レッスン
  LessonModel(
    id: 'lesson-023',
    title: 'City Marathon Report',
    category: 'スポーツ',
    difficulty: 2,
    transcriptText:
        'What an extraordinary day it has been here at the city marathon, '
        'with over thirty thousand runners taking part in what many are calling the most exciting race in the event\'s twenty-year history. '
        'The men\'s race was won by Kenya\'s David Kimani, who crossed the finish line in a time of two hours, four minutes, and thirty-seven seconds. '
        'This sets a new course record, beating the previous best by almost a full minute. '
        'Kimani took control of the race at the halfway mark and gradually pulled away from the leading pack. '
        'By the thirty-kilometer mark, his advantage had grown to nearly forty-five seconds, and he never looked back. '
        'The women\'s race produced an equally thrilling result. Ethiopia\'s Marta Bekele ran a masterful tactical race, '
        'staying with the leaders until the final three kilometers before unleashing a devastating finishing kick. '
        'She crossed the line in two hours, nineteen minutes, and twelve seconds, a personal best by over two minutes. '
        'Beyond the elite athletes, today was really about the thousands of ordinary runners who took on this incredible challenge. '
        'From first-time marathon runners to dedicated charity fundraisers, each one of them has their own inspiring story. '
        'One runner who caught everyone\'s attention was seventy-eight-year-old Margaret Chen, '
        'who completed her fiftieth marathon to raise money for children\'s hospitals. '
        'She finished in just under five hours and received a standing ovation as she crossed the line. '
        'The event organizers reported that participants raised over twelve million dollars for various charitable causes this year, '
        'setting a new record for the event. Weather conditions were nearly perfect for running, '
        'with clear skies and temperatures hovering around fifteen degrees. '
        'Next year\'s race is already generating excitement, with registration expected to open in September.',
    audioAssetPath: 'assets/audio/lesson_023.mp3',
    durationSeconds: 132,
    wordCount: 286,
  ),

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
        'The winning team celebrated wildly as fans across the nation took to the streets. '
        'Let\'s take a closer look at how the match played out. '
        'The first half was dominated by the underdog team, who came out with incredible energy from the very first whistle. '
        'Their coach had clearly prepared a brilliant game plan. '
        'The midfield controlled the ball beautifully, keeping possession for long stretches and waiting patiently for openings. '
        'The champions looked nervous and made several unusual mistakes in defense. '
        'After going two goals down, they tried to change their approach, but it was too late. '
        'In the second half, the champions pushed forward with everything they had. '
        'They brought on two fresh strikers and switched to a more attacking formation. '
        'This led to their only goal, a powerful header from a corner kick in the sixty-fifth minute. '
        'For a brief moment, it seemed like they might find an equalizer. '
        'But the underdog team held firm, defending with passion and discipline until the final whistle. '
        'The result sends shockwaves through the tournament. '
        'Nobody predicted this outcome, and it completely changes the picture for the remaining matches.',
    audioAssetPath: 'assets/audio/lesson_009.mp3',
    durationSeconds: 160,
    wordCount: 267,
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
        'The stadium erupted in disbelief. A new world record had been set, shattering the previous mark by two hundredths of a second. '
        'The young athlete fell to her knees in tears of joy, unable to believe what she had just accomplished on the world\'s biggest stage. '
        'The electronic scoreboard confirmed what the crowd had witnessed, a time of ten point forty-nine seconds. '
        'It was the fastest hundred meters ever recorded in women\'s athletics. '
        'The defeated champion walked over and embraced the winner in a touching display of sportsmanship. '
        'She later told reporters that she had given her absolute best, '
        'and that losing to such an extraordinary performance was nothing to be ashamed of. '
        'The new champion\'s journey to this moment has been remarkable. '
        'Born in a small rural village, she was discovered by a local coach at the age of fourteen. '
        'Within three years, she was competing at the national level, and within five, she was on the world stage. '
        'Her coach described her as the most naturally talented sprinter he had ever worked with, '
        'combined with an unmatched dedication to training.',
    audioAssetPath: 'assets/audio/lesson_010.mp3',
    durationSeconds: 128,
    wordCount: 277,
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
        'Every single point feels like a match point, and neither player is willing to give an inch. '
        'The challenger has been the story of this tournament, defeating three seeded players on his way to the final. '
        'Nobody gave him a chance coming into today\'s match, but here he is, pushing the greatest player of his generation to the brink. '
        'The number one seed steps up to serve again. Another powerful delivery, this time out wide. '
        'The return clips the net cord and drops just over. What luck for the challenger! '
        'The crowd gasps, and the server can only shake his head. '
        'At deuce now, the tension is almost unbearable. Both players towel off and take deep breaths. '
        'You can see the fatigue in their movements, but the quality of tennis has not dropped one bit. '
        'This match will be remembered for years to come, regardless of who emerges victorious. '
        'We are witnessing something truly special here today, and the whole world is watching.',
    audioAssetPath: 'assets/audio/lesson_011.mp3',
    durationSeconds: 116,
    wordCount: 289,
  ),

  // ── 時事ネタ ──

  // FIXED: ニュースの追加中級レッスン
  LessonModel(
    id: 'lesson-022',
    title: 'Technology News Update',
    category: 'ニュース',
    difficulty: 2,
    transcriptText:
        'Good evening and welcome to tonight\'s technology news update. '
        'Our top story tonight concerns the rapid advancement of quantum computing. '
        'Researchers at a leading European university have announced a breakthrough that could revolutionize the field. '
        'Their new processor can perform calculations in minutes that would take traditional computers thousands of years. '
        'While practical applications are still several years away, experts say this development brings us significantly closer '
        'to solving some of humanity\'s most complex problems, from drug discovery to climate modeling. '
        'In other tech news, a major social media company has introduced new features designed to protect younger users. '
        'The updated platform will automatically limit screen time for users under sixteen years old '
        'and restrict the types of content that appear in their feeds. '
        'Parents will also be able to monitor their children\'s activity through a new dashboard. '
        'Privacy advocates have praised the move, though some critics say the measures do not go far enough. '
        'Turning to the world of electric vehicles, the latest industry report shows sales are continuing to surge. '
        'Global sales rose twenty-five percent in the first quarter compared to the same period last year. '
        'Battery technology improvements have led to longer driving ranges and shorter charging times, '
        'making electric cars a more practical option for everyday use. '
        'Several major automakers have announced plans to phase out traditional gasoline engines entirely within the next decade. '
        'Finally, in the world of consumer technology, a new generation of smart home devices was unveiled at this week\'s trade show. '
        'The products use advanced artificial intelligence to learn household routines and adjust settings automatically. '
        'Industry analysts predict that the smart home market will double in size over the next three years. '
        'That is all for tonight\'s tech update. Join us again tomorrow for the latest developments.',
    audioAssetPath: 'assets/audio/lesson_022.mp3',
    durationSeconds: 136,
    wordCount: 295,
  ),

  // FIXED: 時事ネタの追加初級レッスン
  LessonModel(
    id: 'lesson-024',
    title: 'Renewable Energy Revolution',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText:
        'A quiet revolution is happening in the world of energy, and it is changing the way we power our homes and cities. '
        'Solar and wind energy are now cheaper than coal and natural gas in most parts of the world. '
        'This is a huge shift that seemed impossible just ten years ago. '
        'Last year, renewable energy sources provided thirty percent of the world\'s electricity for the first time ever. '
        'In some countries, that number is even higher. '
        'Denmark gets more than half of its power from wind turbines, '
        'and Portugal ran entirely on renewable energy for six straight days last summer. '
        'So what is driving this change? The biggest reason is the falling cost of solar panels. '
        'The price of solar energy has dropped by ninety percent over the past decade. '
        'Today, building a new solar farm is often cheaper than running an existing coal plant. '
        'Many countries are taking advantage of these lower costs by investing heavily in clean energy projects. '
        'China installed more solar panels last year than the rest of the world combined. '
        'The United States added enough wind power to supply electricity to five million homes. '
        'And in Africa, small solar systems are bringing power to villages that have never had electricity before. '
        'Of course, there are still challenges to overcome. '
        'The sun does not always shine, and the wind does not always blow. '
        'This means we need better ways to store energy for use at night and on calm days. '
        'Battery technology is improving rapidly, but we still have a long way to go. '
        'Experts believe that by twenty fifty, renewable energy could provide eighty percent of the world\'s power. '
        'To reach that goal, governments, businesses, and individuals all need to work together. '
        'The good news is that the transition has already begun, and there is no turning back.',
    audioAssetPath: 'assets/audio/lesson_024.mp3',
    durationSeconds: 182,
    wordCount: 304,
  ),

  LessonModel(
    id: 'lesson-012',
    title: 'Climate Change Summit',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText:
        'World leaders gathered in Geneva this week for the annual climate summit. '
        'The latest scientific report paints a concerning picture. '
        'Global temperatures have risen significantly since pre-industrial times, '
        'and extreme weather events are becoming more frequent and severe. '
        'The summit\'s host called for an immediate fifty percent reduction in carbon emissions by twenty thirty. '
        'Several developing nations pushed back, arguing that wealthier countries should bear a greater share of the burden. '
        'By the end of the week, delegates reached a landmark agreement that includes binding targets for renewable energy adoption. '
        'The agreement calls on all countries to invest heavily in solar, wind, and other clean energy sources. '
        'It also includes a fund of one hundred billion dollars per year to help poorer nations make the transition. '
        'Environmental groups have welcomed the agreement, but many say it does not go far enough. '
        'They argue that the targets should be more ambitious and that enforcement measures need to be stronger. '
        'Without real consequences for countries that fail to meet their goals, the agreement could end up being meaningless. '
        'On the positive side, several major corporations announced new climate commitments during the summit. '
        'Some of the world\'s biggest technology companies pledged to reach net zero emissions within the next ten years. '
        'They also promised to work with their supply chains to reduce pollution at every level. '
        'Experts say that the private sector has a crucial role to play in fighting climate change. '
        'Government action is important, but businesses can often move faster and more flexibly. '
        'The next summit is scheduled for December, and delegates have agreed to provide progress reports before then. '
        'The eyes of the world will be watching to see if promises are turned into real action.',
    audioAssetPath: 'assets/audio/lesson_012.mp3',
    durationSeconds: 172,
    wordCount: 286,
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
        'The consensus among economists is clear: those who adapt will thrive, and those who resist will be left behind. '
        'But what does this actually look like in practice? '
        'Consider the legal profession, where AI tools can now review contracts in seconds that would take a human lawyer hours to analyze. '
        'This does not eliminate the need for lawyers. Instead, it frees them to focus on higher-value tasks like strategy and negotiation. '
        'The same pattern is appearing across industries, from healthcare to finance to manufacturing. '
        'AI handles the repetitive, data-heavy work while humans focus on creativity, judgment, and interpersonal skills. '
        'Companies that embrace this partnership between humans and AI are already seeing dramatic productivity gains. '
        'One major consulting firm reported that teams using AI assistants completed projects thirty percent faster with higher quality outcomes. '
        'The key takeaway is that AI is not replacing workers wholesale. '
        'It is changing the nature of work itself, and the workers who learn to collaborate effectively with AI tools '
        'will have a significant advantage in the job market of tomorrow.',
    audioAssetPath: 'assets/audio/lesson_013.mp3',
    durationSeconds: 130,
    wordCount: 281,
  ),
  LessonModel(
    id: 'lesson-014',
    title: 'Space Exploration Breakthrough',
    category: '時事ネタ',
    difficulty: 3,
    transcriptText:
        'In a historic achievement that marks a new chapter in human space exploration, '
        'the international crew of six astronauts has successfully completed the first manned mission to Mars orbit. '
        'The spacecraft, which departed Earth eleven months ago, '
        'entered a stable orbit around the red planet early this morning. '
        'Mission control in Houston erupted in celebration as telemetry data confirmed the successful orbital insertion. '
        'The crew will spend the next thirty days conducting observations and deploying satellites '
        'before beginning the long journey home. '
        'The mission commander described the view of Mars from orbit as beyond anything she had imagined. '
        'In a live broadcast that was watched by an estimated two billion people worldwide, '
        'she described the planet\'s rust-colored surface stretching endlessly beneath them, '
        'with massive dust storms visible swirling across the southern hemisphere. '
        'This achievement represents decades of international cooperation, technological innovation, '
        'and the relentless human drive to explore the unknown. '
        'The spacecraft itself is a marvel of engineering, incorporating breakthroughs in propulsion, '
        'radiation shielding, and life support systems that were considered impossible just twenty years ago. '
        'The crew has maintained remarkable physical and psychological health throughout the voyage, '
        'thanks in part to an advanced exercise program and regular virtual reality sessions '
        'designed to combat the isolation of deep space travel. '
        'Scientists believe this mission will pave the way for the first human landing on Mars within the next decade, '
        'fundamentally changing our understanding of the solar system and our place within it. '
        'The data collected during the orbital phase alone is expected to keep researchers busy for years, '
        'with implications for fields ranging from geology to astrobiology to atmospheric science.',
    audioAssetPath: 'assets/audio/lesson_014.mp3',
    durationSeconds: 108,
    wordCount: 270,
  ),
];
