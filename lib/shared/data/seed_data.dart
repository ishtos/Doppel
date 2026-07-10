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

  // ── TEDスタイル ──

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

  // ── 追加コンテンツ (自動生成) ──
  LessonModel(
    id: 'lesson-017',
    title: 'Packing Smart for Travel',
    category: '旅行',
    difficulty: 1,
    transcriptText: 'Packing for a trip does not have to be stressful. Start by making a short list of the things you really need. Bring clothes you can mix and match, so you always have something to wear. Roll your shirts and pants to save space in your bag. Keep your passport, phone, and money in a safe place that is easy to reach. Do not forget a charger and a small bag for snacks. If you pack light, it is easier to walk and move around. A little planning makes your journey much more relaxing.',
    audioAssetPath: 'assets/audio/lesson_017.mp3',
    durationSeconds: 56,
    wordCount: 94,
  ),
  LessonModel(
    id: 'lesson-018',
    title: 'A Day at the Airport',
    category: '旅行',
    difficulty: 1,
    transcriptText: 'Arriving at the airport early is always a good idea. First, you check in and give your bags to the airline. Then you go through security, where you show your passport and boarding pass. Take off your belt and put your bag on the belt for the machine to scan. After that, you can find your gate and wait for your flight. Many airports have shops, cafes, and comfortable seats. Listen carefully for announcements about your plane. When the staff call your group, walk to the gate and get ready to board. Soon you will be up in the sky.',
    audioAssetPath: 'assets/audio/lesson_018.mp3',
    durationSeconds: 60,
    wordCount: 100,
  ),
  LessonModel(
    id: 'lesson-019',
    title: 'Tasting Local Cuisine',
    category: '旅行',
    difficulty: 2,
    transcriptText: 'One of the best parts of traveling is tasting the local food. Every region has its own flavors, ingredients, and cooking traditions that tell a story about the people who live there. When you visit a new place, try to eat where the locals eat rather than at tourist restaurants. Small family-run shops and busy street markets often serve the most authentic dishes at fair prices. Do not be afraid to point at something that looks interesting, even if you cannot read the menu. Ask friendly questions about how a dish is made, and you may learn something surprising. Some flavors will feel strange at first, but keeping an open mind is part of the adventure. Sharing a meal is also a wonderful way to connect with strangers and understand a culture more deeply than any guidebook can explain.',
    audioAssetPath: 'assets/audio/lesson_019.mp3',
    durationSeconds: 64,
    wordCount: 139,
  ),
  LessonModel(
    id: 'lesson-020',
    title: 'Budget Travel Tips',
    category: '旅行',
    difficulty: 2,
    transcriptText: 'Traveling on a budget does not mean missing out on great experiences. With a little planning, you can see the world without spending a fortune. Booking your flights and rooms well in advance usually saves money, especially if you avoid busy holiday seasons. Consider staying in hostels or small guesthouses, where you can meet other travelers and share tips. Public buses and trains are cheaper than taxis and often show you more of daily life. Cooking a few of your own meals or buying food from a local market can cut your costs in half. Free walking tours, public parks, and museums with no entry fee let you enjoy a city for very little. The goal is to spend wisely on what matters most to you, whether that is food, adventure, or simply time to relax and explore.',
    audioAssetPath: 'assets/audio/lesson_020.mp3',
    durationSeconds: 64,
    wordCount: 138,
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
    transcriptText: 'A smartphone can do many helpful things once you learn the basics. To turn it on, press and hold the power button for a few seconds. The screen you touch is how you control the phone, so tap gently with your finger. You can make calls, send messages, take photos, and search the internet. Small pictures called apps open different tools when you tap them. Remember to charge the battery every day so your phone does not turn off. If you are not sure what to do, ask a friend or look for simple guides online. With a little practice, using a smartphone soon feels easy and natural.',
    audioAssetPath: 'assets/audio/lesson_022.mp3',
    durationSeconds: 65,
    wordCount: 108,
  ),
  LessonModel(
    id: 'lesson-023',
    title: 'Working from Home',
    category: 'テクノロジー',
    difficulty: 2,
    transcriptText: 'Working from home has become common for millions of people, thanks to fast internet and modern software. Video calls let coworkers meet face to face even when they live in different cities or countries. Shared documents allow a whole team to write and edit the same file at the same time. While working remotely offers freedom and saves time on commuting, it also brings new challenges. Without a clear routine, it is easy to work too much or to feel distracted by chores at home. Experts suggest setting up a quiet corner just for work and taking regular short breaks to rest your eyes. Turning off notifications during focused tasks can help you concentrate. It is also important to stay connected with colleagues through chats and calls, so you do not feel isolated. With good habits and the right tools, working from home can be both productive and enjoyable.',
    audioAssetPath: 'assets/audio/lesson_023.mp3',
    durationSeconds: 69,
    wordCount: 149,
  ),
  LessonModel(
    id: 'lesson-024',
    title: 'How the Internet Connects Us',
    category: 'テクノロジー',
    difficulty: 2,
    transcriptText: 'The internet is a giant network that links billions of computers and phones around the world. When you open a website, your device sends a request that travels through cables, routers, and sometimes satellites. In less than a second, the information you asked for comes back to your screen. Much of this data moves through undersea cables that stretch across entire oceans. Every device connected to the network has a unique address, a bit like a home address, so information reaches the correct place. Wireless signals let us connect without wires, using radio waves from routers and phone towers. Because the system is shared, engineers work constantly to keep it fast, safe, and reliable. Understanding these basics helps us appreciate how a simple search, message, or video call is actually a remarkable journey of tiny signals traveling enormous distances in the blink of an eye.',
    audioAssetPath: 'assets/audio/lesson_024.mp3',
    durationSeconds: 67,
    wordCount: 145,
  ),
  LessonModel(
    id: 'lesson-025',
    title: 'Living with Smart Devices',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText: 'Many homes now use smart devices that make daily life easier. A smart speaker can play music, answer questions, and set timers when you speak to it. Smart lights let you turn them on or off using your phone, even from another room. Some people use smart plugs to control fans or lamps without getting up. These devices connect to your home internet and follow simple voice commands. They can be very helpful, but it is wise to protect them with strong passwords. Remember that these tools are meant to help you, not to replace your skills. Used carefully, smart devices can save time and add comfort to your day.',
    audioAssetPath: 'assets/audio/lesson_025.mp3',
    durationSeconds: 66,
    wordCount: 110,
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
    transcriptText: 'The water cycle is the journey water takes around our planet. When the sun heats lakes, rivers, and oceans, some water turns into a gas and rises into the sky. This is called evaporation. High in the air, the gas cools and forms tiny drops that gather into clouds. When the clouds become heavy, the water falls back down as rain or snow. This falling water is called precipitation. Some of it flows into rivers and returns to the sea, while some soaks into the ground. Then the sun warms the water again, and the whole cycle starts over. This process gives us the fresh water we need to live.',
    audioAssetPath: 'assets/audio/lesson_027.mp3',
    durationSeconds: 66,
    wordCount: 110,
  ),
  LessonModel(
    id: 'lesson-028',
    title: 'Why We Need Sleep',
    category: '科学',
    difficulty: 2,
    transcriptText: 'Sleep is one of the most important things we do for our health, yet many people do not get enough of it. While we rest, our bodies repair muscles, fight illness, and store energy for the day ahead. The brain is especially busy during sleep, sorting through memories and clearing away waste that builds up while we are awake. This is why a good night of sleep helps us think clearly, learn new skills, and manage our emotions. Scientists recommend that most adults get between seven and nine hours each night. To sleep well, it helps to keep a regular schedule, avoid bright screens before bed, and keep the bedroom cool and dark. Skipping sleep for too long can weaken the immune system and make it harder to focus. By treating rest as a priority rather than a luxury, we give our minds and bodies the care they truly need.',
    audioAssetPath: 'assets/audio/lesson_028.mp3',
    durationSeconds: 69,
    wordCount: 150,
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
    transcriptText: 'Going for a walk in the morning is a simple way to feel better. You do not need special shoes or a gym. Just step outside and start moving. A short walk can wake up your body and clear your mind. Try to walk for ten or fifteen minutes at first. Later, you can walk a little longer each day. Fresh air and sunlight are good for you. Walking with a friend makes it more fun. Soon, a morning walk will feel like a happy part of your day.',
    audioAssetPath: 'assets/audio/lesson_031.mp3',
    durationSeconds: 53,
    wordCount: 89,
  ),
  LessonModel(
    id: 'lesson-032',
    title: 'Drinking Enough Water',
    category: '健康・フィットネス',
    difficulty: 1,
    transcriptText: 'Water is very important for your body. Every day, you lose water when you move, breathe, and sweat. That is why you must drink water often. Many people carry a bottle so they can drink all day long. When you feel tired or have a headache, you might just need more water. Try to drink a glass in the morning and more with your meals. Cold water is nice on a hot day. Your body will thank you when you drink enough. Water keeps you fresh, happy, and healthy.',
    audioAssetPath: 'assets/audio/lesson_032.mp3',
    durationSeconds: 53,
    wordCount: 89,
  ),
  LessonModel(
    id: 'lesson-033',
    title: 'Building Better Sleep Habits',
    category: '健康・フィットネス',
    difficulty: 2,
    transcriptText: 'Getting good sleep is one of the best things you can do for your health, yet many people struggle to rest well at night. The quality of your sleep often depends on your habits during the evening. Try to go to bed and wake up at the same time every day, even on weekends. This helps your body build a steady rhythm. Avoid looking at bright screens for an hour before bed, because the light can trick your brain into staying awake. A cool, dark, and quiet room also makes a big difference. Some people find that a warm bath or a few pages of a book help them relax. Cutting back on coffee in the afternoon is another smart choice. With a little patience, these small changes can lead to deeper, more restful nights.',
    audioAssetPath: 'assets/audio/lesson_033.mp3',
    durationSeconds: 62,
    wordCount: 135,
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
    transcriptText: 'Recycling at home is an easy way to help the planet. Many things you throw away can be used again. Paper, glass, plastic, and metal can all be recycled. First, rinse bottles and cans so they are clean. Then put them in the right bin. Every town has its own rules, so check what your area accepts. When you recycle, less trash goes to the landfill. It also saves energy and natural resources. Even small actions matter when many people join in. Teach your family to sort waste, and soon it will become a simple daily habit.',
    audioAssetPath: 'assets/audio/lesson_036.mp3',
    durationSeconds: 58,
    wordCount: 97,
  ),
  LessonModel(
    id: 'lesson-037',
    title: 'Saving Energy Every Day',
    category: '環境',
    difficulty: 1,
    transcriptText: 'Saving energy at home is good for the earth and your wallet. There are many simple things you can do. Turn off the lights when you leave a room. Unplug devices that you are not using. In winter, wear a warm sweater instead of turning up the heat. In summer, open a window to catch a cool breeze. Wash your clothes in cold water when you can. Using less energy means burning less fuel and making less pollution. These little habits are easy to learn. When your whole family helps, you can save a lot of energy together.',
    audioAssetPath: 'assets/audio/lesson_037.mp3',
    durationSeconds: 59,
    wordCount: 98,
  ),
  LessonModel(
    id: 'lesson-038',
    title: 'The Importance Of Bees',
    category: '環境',
    difficulty: 2,
    transcriptText: 'Bees may be small, but they play a huge role in the health of our planet. As they fly from flower to flower to collect nectar, they carry pollen with them. This process, called pollination, helps plants produce fruits, vegetables, and seeds. In fact, a large share of the food we eat depends on bees and other pollinators. Without them, our meals would be far less colorful and varied. Sadly, bee populations have been shrinking in many parts of the world. Loss of habitat, harmful chemicals, and disease all threaten these hardworking insects. There are ways we can help, however. Planting flowers, avoiding strong pesticides, and leaving wild corners in the garden all give bees a place to thrive. By protecting bees, we protect the food supply and the natural world we all share.',
    audioAssetPath: 'assets/audio/lesson_038.mp3',
    durationSeconds: 62,
    wordCount: 134,
  ),
  LessonModel(
    id: 'lesson-039',
    title: 'Ocean Plastic Pollution',
    category: '環境',
    difficulty: 2,
    transcriptText: 'Every year, millions of tons of plastic end up in our oceans, creating one of the biggest environmental problems of our time. This waste comes from many sources, including bottles, bags, and tiny pieces that break off larger items. Ocean currents gather much of this trash into enormous floating patches far from any coast. Sea animals often mistake the plastic for food, which can make them sick or even kill them. Over time, plastic breaks down into tiny fragments called microplastics, which then enter the food chain and may eventually reach our own plates. The good news is that individuals and companies are taking action. People are using fewer single-use products, choosing reusable bags and bottles, and joining beach cleanups. Governments are passing laws to reduce plastic waste as well. Small choices, repeated by millions, can help keep our oceans clean and full of life.',
    audioAssetPath: 'assets/audio/lesson_039.mp3',
    durationSeconds: 67,
    wordCount: 145,
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
    transcriptText: 'Visiting an art museum is a calm and interesting way to spend a day. Inside, you can see paintings, statues, and other beautiful works from many countries. Some art is very old, while other pieces are new and modern. Walk slowly and take your time with each one. You do not have to like everything you see. Just notice the colors, shapes, and feelings the art gives you. Many museums are quiet, so people can think and enjoy. Some have a small café where you can rest. A trip to a museum can open your mind to new ideas.',
    audioAssetPath: 'assets/audio/lesson_041.mp3',
    durationSeconds: 59,
    wordCount: 99,
  ),
  LessonModel(
    id: 'lesson-042',
    title: 'Learning To Paint',
    category: '文化・芸術',
    difficulty: 2,
    transcriptText: 'Learning to paint is a wonderful hobby that anyone can enjoy, no matter their age or skill. You do not need expensive supplies to begin. A few brushes, some basic colors, and a sheet of thick paper are enough for your first steps. Many beginners start with watercolors because they are easy to clean and forgiving of mistakes. At first, try painting simple things around you, such as a piece of fruit or a flower in a vase. Do not worry about making your work look perfect. The goal is to practice mixing colors and to see how light and shadow fall on objects. With each painting, your eye and your hand grow stronger together. Over time, you may discover your own style. Above all, painting should feel relaxing and fun, a quiet escape from a busy world.',
    audioAssetPath: 'assets/audio/lesson_042.mp3',
    durationSeconds: 64,
    wordCount: 138,
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
    transcriptText: 'The pyramids of Egypt are among the oldest buildings in the world. People built them thousands of years ago to hold the bodies of kings called pharaohs. The largest one is the Great Pyramid of Giza. Workers moved huge blocks of stone by hand and with simple tools. Each block was very heavy, and there were more than two million of them. It took many years to finish just one pyramid. Today, visitors from all over the world come to see these amazing structures. They remind us how clever and hard-working ancient people really were.',
    audioAssetPath: 'assets/audio/lesson_045.mp3',
    durationSeconds: 57,
    wordCount: 95,
  ),
  LessonModel(
    id: 'lesson-046',
    title: 'The Great Wall Of China',
    category: '歴史',
    difficulty: 1,
    transcriptText: 'The Great Wall of China is one of the most famous structures in the world. It was built long ago to protect the country from invaders in the north. The wall is very long and stretches over mountains and valleys for thousands of miles. Many different rulers added new parts to it over the centuries. Workers used stone, brick, and earth to build the strong walls and tall towers. Guards once stood on the towers to watch for enemies and to send warning signals with smoke and fire. Today, millions of people visit the wall each year to walk along it and enjoy the views.',
    audioAssetPath: 'assets/audio/lesson_046.mp3',
    durationSeconds: 63,
    wordCount: 105,
  ),
  LessonModel(
    id: 'lesson-047',
    title: 'The Silk Road Trade Routes',
    category: '歴史',
    difficulty: 2,
    transcriptText: 'The Silk Road was not a single road but a network of trade routes that connected the East and the West for many centuries. Merchants traveled across deserts, mountains, and wide grasslands to carry goods between China, India, Persia, and Europe. Silk was one of the most famous products, but traders also carried spices, tea, precious stones, and paper. These journeys were long and dangerous, so people traveled together in large groups called caravans. Along the way, they stopped at busy market towns to rest and to exchange their goods. The Silk Road did more than move products, however. It also spread ideas, religions, languages, and new technologies from one culture to another. Because of this exchange, distant civilizations learned about each other and grew richer in knowledge. The routes slowly declined when sailors discovered faster and cheaper ways to travel by sea.',
    audioAssetPath: 'assets/audio/lesson_047.mp3',
    durationSeconds: 66,
    wordCount: 143,
  ),
  LessonModel(
    id: 'lesson-048',
    title: 'Gutenberg And The Printing Press',
    category: '歴史',
    difficulty: 2,
    transcriptText: 'Before the printing press was invented, books were copied slowly by hand, usually by monks who spent months on a single volume. Because the work took so long, books were rare and very expensive, and only wealthy people or churches could afford them. In the middle of the fifteenth century, a German craftsman named Johannes Gutenberg changed everything. He created a machine that used small metal letters, which could be arranged, inked, and pressed onto paper again and again. Suddenly, printers could produce hundreds of identical pages in the time it once took to copy a single one. Books became cheaper, and more ordinary people learned to read. New ideas about science, religion, and politics spread across Europe faster than ever before. Many historians believe that this single invention helped launch the modern age, because knowledge was no longer locked away in a few precious handwritten copies.',
    audioAssetPath: 'assets/audio/lesson_048.mp3',
    durationSeconds: 68,
    wordCount: 147,
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
    transcriptText: 'Pizza is one of the most popular foods in the world. It began in Italy, in the city of Naples, many years ago. A basic pizza has a round base made of dough, a layer of tomato sauce, and cheese on top. People also add other toppings, such as vegetables, mushrooms, or meat. The pizza is baked in a very hot oven until the cheese melts and the edges turn golden brown. Families often share a pizza together, cutting it into slices with their hands. Today you can find pizza in almost every country, and each place has its own favorite style and toppings.',
    audioAssetPath: 'assets/audio/lesson_050.mp3',
    durationSeconds: 62,
    wordCount: 104,
  ),
  LessonModel(
    id: 'lesson-051',
    title: 'A Warm Cup Of Coffee',
    category: '料理・グルメ',
    difficulty: 1,
    transcriptText: 'Coffee is a warm drink that millions of people enjoy every day. It is made from beans that grow on small trees in warm countries. First, the beans are dried and then roasted until they turn dark brown. After that, they are ground into a fine powder. Hot water is poured over the powder to make the drink. Many people like to have a cup of coffee in the morning because it helps them feel awake and ready for the day. Some drink it black, while others add milk or sugar. Coffee shops are popular places where friends meet, talk, and relax together.',
    audioAssetPath: 'assets/audio/lesson_051.mp3',
    durationSeconds: 62,
    wordCount: 103,
  ),
  LessonModel(
    id: 'lesson-052',
    title: 'The Art Of Japanese Sushi',
    category: '料理・グルメ',
    difficulty: 2,
    transcriptText: 'Sushi is a traditional Japanese dish that has become popular all around the world. Although many people think sushi is simply raw fish, the word actually refers to the seasoned rice that forms the base of the dish. This rice is gently mixed with vinegar, sugar, and salt to give it a delicate flavor. Chefs then top the rice with fresh fish, seafood, or vegetables, or they roll everything together with a sheet of dried seaweed. Making good sushi takes years of practice and great skill. A master chef must learn how to choose the freshest ingredients, how to slice the fish perfectly, and how to shape the rice with just the right pressure. In Japan, sushi is often enjoyed with soy sauce, wasabi, and pickled ginger. Whether eaten at a fancy restaurant or a small counter, sushi is admired for its beauty, freshness, and simple elegance.',
    audioAssetPath: 'assets/audio/lesson_052.mp3',
    durationSeconds: 68,
    wordCount: 147,
  ),
  LessonModel(
    id: 'lesson-053',
    title: 'The Spices Of Indian Cooking',
    category: '料理・グルメ',
    difficulty: 2,
    transcriptText: 'Indian cooking is famous around the world for its bold and colorful use of spices. In a typical Indian kitchen, you might find turmeric, cumin, coriander, cardamom, and many others, each with its own aroma and flavor. Cooks often mix several spices together to create a blend, and every family may have its own secret recipe passed down through the generations. One of the most well-known dishes is curry, a rich and flavorful sauce that can be made with vegetables, beans, chicken, or fish. Spices are not just added for taste; many of them are also believed to be good for health. Before cooking, some spices are gently heated in oil to release their full flavor and fragrance. The result is a meal that fills the whole house with a wonderful smell. Served with rice or warm flatbread, Indian food offers an unforgettable experience for anyone who loves to eat.',
    audioAssetPath: 'assets/audio/lesson_053.mp3',
    durationSeconds: 69,
    wordCount: 150,
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
    transcriptText: 'Penguins are birds that cannot fly, but they are excellent swimmers. Most penguins live in the cold parts of the world, far to the south. Their black and white feathers help keep them warm in the icy water. Penguins use their short wings like paddles to move quickly through the sea, where they catch fish to eat. On land, they walk with a funny waddle and sometimes slide on their bellies across the snow. Many penguins live together in large groups to stay safe and warm. Parents take good care of their eggs and feed their young chicks until they are big enough to swim and hunt on their own.',
    audioAssetPath: 'assets/audio/lesson_055.mp3',
    durationSeconds: 66,
    wordCount: 110,
  ),
  LessonModel(
    id: 'lesson-056',
    title: 'The Great Journey Of Birds',
    category: '自然・動物',
    difficulty: 2,
    transcriptText: 'Every year, millions of birds make incredible journeys across the world in a process known as migration. As the seasons change and the weather grows colder, many birds fly long distances to find warmer places with more food. Some travel only a short way, while others cross entire oceans and continents without stopping for days. One small bird, the Arctic tern, travels from the top of the world to the bottom and back again, covering an enormous distance each year. Scientists are still learning how birds find their way over such great distances. It seems they use the sun, the stars, and even the Earth\'s magnetic field to guide themselves. Many birds return to the very same nesting spot year after year. These amazing journeys require huge amounts of energy, so before they leave, birds eat as much as they can to store fat for the trip ahead.',
    audioAssetPath: 'assets/audio/lesson_056.mp3',
    durationSeconds: 68,
    wordCount: 148,
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
    transcriptText: 'Film festivals are exciting events where new movies are shown for the very first time. People travel from many countries to watch films and meet the directors. Some festivals are very famous, and winning a prize there can make a movie popular around the world. At a festival, you can see small independent films that are hard to find in normal cinemas. Actors walk on the red carpet while photographers take pictures. Fans wait outside, hoping to see their favorite stars. For film lovers, a festival is a wonderful place to discover new stories and enjoy the art of cinema together.',
    audioAssetPath: 'assets/audio/lesson_059.mp3',
    durationSeconds: 61,
    wordCount: 101,
  ),
  LessonModel(
    id: 'lesson-060',
    title: 'Behind the Special Effects',
    category: '映画・エンタメ',
    difficulty: 2,
    transcriptText: 'Have you ever wondered how filmmakers create giant monsters, exploding buildings, or entire alien worlds? Most of these amazing scenes are made using special effects. In the past, artists built small models and used clever camera tricks to make them look real. Today, computers do much of the work. Teams of digital artists design creatures and landscapes that never actually existed, then add them to the footage frame by frame. Actors often perform in front of a green screen, imagining explosions and dragons that will appear later. Sound designers also play an important role, recording and mixing noises to make each moment feel believable. Creating these effects can take months of careful work, but the result is a world that pulls audiences completely into the story. The next time you watch an action film, remember the hidden artists behind the magic.',
    audioAssetPath: 'assets/audio/lesson_060.mp3',
    durationSeconds: 65,
    wordCount: 141,
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
    transcriptText: 'Streaming services have changed the way we watch movies and shows. In the past, people went to a store to rent films or waited for them on television. Now we can watch almost anything at home with just a few clicks. These services offer thousands of titles, from old classics to brand new series. You can pause, rewind, or continue watching on your phone, tablet, or big screen. Many companies also create their own original shows, which are only available to their members. Because there is so much choice, sometimes it is hard to decide what to watch tonight.',
    audioAssetPath: 'assets/audio/lesson_062.mp3',
    durationSeconds: 59,
    wordCount: 99,
  ),
  LessonModel(
    id: 'lesson-063',
    title: 'The Magic of Musical Theater',
    category: '映画・エンタメ',
    difficulty: 2,
    transcriptText: 'Musical theater combines acting, singing, and dancing to tell powerful stories on stage. Unlike a film, every performance happens live, so no two shows are ever exactly the same. The actors must sing while moving across the stage, expressing deep emotions through both their voices and their bodies. Behind the scenes, a live orchestra usually plays the music, following the singers closely so that everything stays perfectly in time. Building a musical takes an enormous amount of teamwork. Writers create the songs and dialogue, choreographers design the dances, and set designers build colorful worlds that transport the audience to another place. Costumes, lighting, and sound all work together to create a magical atmosphere. When the final song ends and the curtain falls, audiences often rise to their feet, applauding the incredible energy and talent they have just witnessed. For many people, a night at the theater is truly unforgettable.',
    audioAssetPath: 'assets/audio/lesson_063.mp3',
    durationSeconds: 69,
    wordCount: 149,
  ),
  LessonModel(
    id: 'lesson-064',
    title: 'Learning a New Language',
    category: '教育・学習',
    difficulty: 1,
    transcriptText: 'Learning a new language is a fun and useful skill. At first, it may feel difficult to remember new words and sounds. But with a little practice every day, you will slowly improve. Try to listen to songs, watch simple videos, and repeat short sentences out loud. Speaking with other people is one of the best ways to learn. Do not worry about making mistakes, because mistakes help you grow. Learning a language also lets you meet new friends and understand other cultures. Step by step, you will feel more confident. The most important thing is to keep going and enjoy the journey along the way.',
    audioAssetPath: 'assets/audio/lesson_064.mp3',
    durationSeconds: 64,
    wordCount: 106,
  ),
  LessonModel(
    id: 'lesson-065',
    title: 'Smarter Ways to Study',
    category: '教育・学習',
    difficulty: 2,
    transcriptText: 'Many students study for hours yet still struggle to remember what they learned. The problem is often not the amount of time, but the method they use. Research shows that simply rereading notes is one of the least effective ways to learn. A far better approach is to test yourself regularly, trying to recall information from memory before checking the answer. This effort strengthens the connections in your brain. Spreading your study sessions across several days, rather than cramming everything the night before, also helps knowledge stick for much longer. Another useful trick is to explain a topic in your own words, as if teaching it to someone else. If you can do that clearly, you truly understand it. Getting enough sleep matters too, because your brain organizes and stores memories while you rest. By using these simple techniques, anyone can learn more efficiently and remember information for years to come.',
    audioAssetPath: 'assets/audio/lesson_065.mp3',
    durationSeconds: 70,
    wordCount: 151,
  ),
  LessonModel(
    id: 'lesson-066',
    title: 'The Rise of Online Learning',
    category: '教育・学習',
    difficulty: 3,
    transcriptText: 'Over the past two decades, online education has quietly revolutionized the way people acquire knowledge and skills. Where learning was once confined to physical classrooms accessible to a privileged few, ambitious individuals can now enroll in courses taught by distinguished professors from renowned universities without ever leaving their homes. This democratization of education carries profound implications, particularly for those in remote regions or challenging financial circumstances who previously had no realistic path to advanced study. A learner in a small village can now examine the same lectures, complete the same assignments, and earn credentials comparable to those of students on prestigious campuses. Nevertheless, this transformation is not without its difficulties. Online courses demand considerable self-discipline, since the structure and accountability of a traditional classroom are largely absent, and completion rates remain stubbornly low. Furthermore, subjects requiring hands-on practice or intimate mentorship are difficult to replicate through a screen. Educators continue to experiment with interactive tools, discussion forums, and peer-review systems in an effort to recreate the collaborative spirit of physical institutions. Despite these obstacles, the trajectory is unmistakable: as technology advances and connectivity spreads, online learning will increasingly complement, and in some cases replace, the conventional educational experiences of previous generations.',
    audioAssetPath: 'assets/audio/lesson_066.mp3',
    durationSeconds: 80,
    wordCount: 201,
  ),
  LessonModel(
    id: 'lesson-067',
    title: 'Why Reading Matters',
    category: '教育・学習',
    difficulty: 1,
    transcriptText: 'Reading is one of the best habits you can build. When you read, you learn new words and discover new ideas. Books can take you to faraway places and different times without leaving your chair. Reading a little every day can make you a better writer and a clearer thinker. It also helps you relax after a busy day. You do not need to read fast; what matters is that you enjoy the story. Try to keep a book near your bed and read a few pages before you sleep. Over time, this small and simple habit will bring you great rewards.',
    audioAssetPath: 'assets/audio/lesson_067.mp3',
    durationSeconds: 61,
    wordCount: 102,
  ),
  LessonModel(
    id: 'lesson-068',
    title: 'Exploring STEM Education',
    category: '教育・学習',
    difficulty: 2,
    transcriptText: 'STEM education focuses on science, technology, engineering, and mathematics. These subjects are becoming more important as our world depends more and more on technology. In a good STEM class, students do not just memorize facts from a book. Instead, they build robots, run experiments, and solve real problems using their own ideas. This hands-on approach helps young people develop curiosity and creativity. It also teaches them how to think logically and work well in teams, skills that are valuable in almost any career. Many schools now encourage girls to take part in STEM, since these fields have long needed more diverse voices. Learning to code, design, or analyze data opens the door to exciting jobs in the future. Perhaps more importantly, STEM education helps students understand the technology all around them, turning them from passive users into confident creators who can shape the world of tomorrow.',
    audioAssetPath: 'assets/audio/lesson_068.mp3',
    durationSeconds: 67,
    wordCount: 146,
  ),
  LessonModel(
    id: 'lesson-069',
    title: 'Today\'s Weather Report',
    category: 'ニュース',
    difficulty: 1,
    transcriptText: 'Good morning, and here is today\'s weather report. This morning will be cool and cloudy across most of the region, with temperatures near ten degrees. By the afternoon, the clouds will slowly clear, and the sun will bring warmer weather. There is a small chance of light rain in the evening, so you may want to carry an umbrella. Winds will be gentle, coming from the west. Tomorrow looks bright and sunny, perfect for spending time outside. Remember to wear a light jacket in the morning. That is all for now. Stay safe, and have a wonderful day.',
    audioAssetPath: 'assets/audio/lesson_069.mp3',
    durationSeconds: 59,
    wordCount: 98,
  ),
  LessonModel(
    id: 'lesson-070',
    title: 'News From Our Community',
    category: 'ニュース',
    difficulty: 2,
    transcriptText: 'In local news tonight, our city is celebrating the reopening of the historic downtown library after two years of careful renovation. The building, which first opened its doors nearly a century ago, now features a modern children\'s section, faster internet, and a bright new community meeting room. Hundreds of residents gathered this morning for the opening ceremony, where the mayor thanked the volunteers and donors who made the project possible. Many families said they were thrilled to have their favorite gathering place back. In other news, the city council announced plans to add several new bicycle lanes along the main road, aiming to make travel safer and reduce traffic during busy hours. Construction is expected to begin next month and finish before the winter. Finally, the annual food festival will return to the central park this weekend, promising live music, local vendors, and plenty of delicious dishes for everyone to enjoy.',
    audioAssetPath: 'assets/audio/lesson_070.mp3',
    durationSeconds: 70,
    wordCount: 151,
  ),
  LessonModel(
    id: 'lesson-071',
    title: 'A New Mission to a Distant Moon',
    category: 'ニュース',
    difficulty: 3,
    transcriptText: 'Scientists around the world are celebrating tonight following the successful launch of an ambitious mission aimed at exploring one of the distant moons of the outer solar system. The spacecraft, developed over more than a decade by an international team of engineers, carries a sophisticated array of instruments designed to search for the chemical ingredients that could, in theory, support primitive life. According to mission directors, the probe will travel for several years before reaching its destination, where it will gather detailed measurements of the moon\'s icy surface and the vast ocean believed to lie hidden beneath it. Researchers are particularly intrigued by evidence suggesting that this subsurface sea may contain more water than all of Earth\'s oceans combined. While no one expects to discover advanced civilizations, even the detection of simple microbes would profoundly reshape our understanding of where life can arise. The mission also represents a remarkable example of global cooperation, uniting agencies from multiple continents behind a shared scientific goal. Officials emphasized that the knowledge gained will benefit not only astronomers but also fields ranging from climate science to engineering. As the spacecraft begins its long and lonely voyage, millions of curious observers on Earth will be watching, eager for the discoveries that lie ahead.',
    audioAssetPath: 'assets/audio/lesson_071.mp3',
    durationSeconds: 83,
    wordCount: 208,
  ),
  LessonModel(
    id: 'lesson-072',
    title: 'Renewable Energy Reaches a Milestone',
    category: 'ニュース',
    difficulty: 3,
    transcriptText: 'Energy analysts released a landmark report this week revealing that renewable sources now generate a record share of the world\'s electricity, marking a significant milestone in the global effort to combat climate change. According to the study, wind and solar power expanded more rapidly than any other energy source over the past year, driven by falling costs and increasingly supportive government policies. In several countries, electricity generated from sunlight and wind has become cheaper than that produced by burning coal or gas, a shift that would have seemed unimaginable just a generation ago. Experts caution, however, that considerable challenges remain. Because the sun does not always shine and the wind does not always blow, nations must invest heavily in large batteries and modernized power grids capable of storing and distributing energy reliably. The report also highlights the importance of retraining workers from traditional industries so that no community is left behind during the transition. Environmental groups welcomed the findings as encouraging evidence that a cleaner future is within reach, while urging leaders to accelerate their commitments. Although the road ahead is long and complex, the authors conclude that the momentum behind renewable energy is now unstoppable, offering genuine hope for reducing the harmful emissions warming our planet.',
    audioAssetPath: 'assets/audio/lesson_072.mp3',
    durationSeconds: 83,
    wordCount: 207,
  ),
  LessonModel(
    id: 'lesson-073',
    title: 'First Day Introduction',
    category: 'ビジネス',
    difficulty: 1,
    transcriptText: 'Good morning, everyone. My name is Daniel, and today is my first day on the team. I am really happy to be here. In my last job, I worked in customer support for three years. I enjoy helping people and solving small problems. In my free time, I like to read and go running. I still have a lot to learn about this company, so please be patient with me. If I ask many questions, it is because I want to do good work. Thank you for the warm welcome. I look forward to working with all of you.',
    audioAssetPath: 'assets/audio/lesson_073.mp3',
    durationSeconds: 59,
    wordCount: 99,
  ),
  LessonModel(
    id: 'lesson-074',
    title: 'Project Update Meeting',
    category: 'ビジネス',
    difficulty: 2,
    transcriptText: 'Thank you all for joining this project update. Over the past two weeks, our team has made solid progress on the new mobile app. The design phase is now complete, and the engineering team has started building the main features. We are currently on schedule, but I want to highlight one risk. The payment system depends on a third-party service, and their documentation has been unclear. To avoid delays, I have scheduled a call with their support team this Friday. On the budget side, we are spending slightly less than planned, which gives us some room for testing. Before we launch, I would like to run a small trial with ten real users. Their feedback will help us fix problems early. If everyone agrees, I will send a detailed timeline by tomorrow afternoon. Please review it carefully and share any concerns before the weekend.',
    audioAssetPath: 'assets/audio/lesson_074.mp3',
    durationSeconds: 66,
    wordCount: 144,
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
    transcriptText: 'Hello, and thank you for your time. I would like to briefly introduce our new scheduling tool for small businesses. Many owners tell us that managing appointments by phone wastes hours every week. Our software lets customers book online, receive automatic reminders, and reschedule without a single phone call. On average, our clients reduce missed appointments by about thirty percent. Setup takes less than ten minutes, and no technical skills are required. We also offer a free trial for two weeks, so you can test everything before you decide. If you have a question during the trial, our support team replies within one business day. I truly believe this tool can save you time and help your business grow. Would you be open to a short demo next week? I can walk you through the main features and answer anything you want to know.',
    audioAssetPath: 'assets/audio/lesson_076.mp3',
    durationSeconds: 66,
    wordCount: 144,
  ),
  LessonModel(
    id: 'lesson-077',
    title: 'Rescheduling A Meeting',
    category: 'ビジネス',
    difficulty: 1,
    transcriptText: 'Hi Sarah, this is Tom from the sales team. I am calling about the meeting on Thursday. I am sorry, but I need to change the time. Something came up in the morning, so can we meet at two o\'clock instead? Please let me know if that works for you. I also want to talk about the new report before we send it to the client. If you have ten minutes today, please call me back. My number is on the company list. Thank you very much, and have a good day. I will wait to hear from you soon.',
    audioAssetPath: 'assets/audio/lesson_077.mp3',
    durationSeconds: 60,
    wordCount: 100,
  ),
  LessonModel(
    id: 'lesson-078',
    title: 'My Quiet Morning Routine',
    category: '日常会話',
    difficulty: 1,
    transcriptText: 'Every morning, I wake up at six thirty. The first thing I do is open the window to let in fresh air. Then I make a cup of coffee and sit at the kitchen table. I like the quiet before the day begins. While I drink my coffee, I check the weather and plan my day. After that, I take a short walk around the block. The streets are calm, and I often see the same friendly dog. When I come back, I feel ready for work. This simple routine makes me happy. It gives me a calm start, and I think it helps me all day long.',
    audioAssetPath: 'assets/audio/lesson_078.mp3',
    durationSeconds: 65,
    wordCount: 108,
  ),
  LessonModel(
    id: 'lesson-079',
    title: 'A Trip To The Market',
    category: '日常会話',
    difficulty: 2,
    transcriptText: 'Last Saturday, I decided to visit the farmers market for the first time in months. I usually shop at the big supermarket, but I wanted something different. The market was busier than I expected, full of colorful stalls and the smell of fresh bread. I bought tomatoes, some local honey, and a small bunch of flowers for my kitchen table. One of the farmers explained how he grows his vegetables without chemicals, and I found it really interesting. Later, I stopped at a little stand selling homemade soup and had a warm bowl in the sunshine. On my way home, I felt relaxed and grateful. It reminded me that slowing down can be surprisingly enjoyable. Now I plan to go every weekend, not just to buy food, but to enjoy the friendly atmosphere and meet the people who grow it.',
    audioAssetPath: 'assets/audio/lesson_079.mp3',
    durationSeconds: 65,
    wordCount: 140,
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
    transcriptText: 'I have a small orange cat named Milo. He is three years old, and he loves to sleep in the sun. Every afternoon, he finds a warm spot by the window and stays there for hours. When I come home, he runs to the door and meows loudly. I think he is happy to see me, but maybe he just wants food. In the evening, he sits on my lap while I watch television. His soft purring makes me feel calm after a long day. Milo is a little lazy, but he is my best friend. I cannot imagine my home without him now.',
    audioAssetPath: 'assets/audio/lesson_081.mp3',
    durationSeconds: 62,
    wordCount: 104,
  ),
  LessonModel(
    id: 'lesson-082',
    title: 'Learning To Play Guitar',
    category: '日常会話',
    difficulty: 2,
    transcriptText: 'A few months ago, I finally decided to learn the guitar. I had wanted to play since I was a teenager, but I always found an excuse not to start. The first weeks were honestly frustrating. My fingers hurt, the chords sounded terrible, and I could barely switch between two notes without stopping. There were evenings when I thought about giving up completely. But I set a small goal: just ten minutes of practice every day, no matter how tired I felt. Slowly, something changed. My fingers grew stronger, and one afternoon I played a simple song from beginning to end without a single mistake. That small victory felt amazing. Now, playing the guitar has become my favorite way to relax after work. It taught me an important lesson too. Progress does not come from big bursts of effort, but from showing up again and again, even when you are not in the mood.',
    audioAssetPath: 'assets/audio/lesson_082.mp3',
    durationSeconds: 71,
    wordCount: 154,
  ),
  LessonModel(
    id: 'lesson-083',
    title: 'Why Sleep Matters',
    category: 'TEDスタイル',
    difficulty: 3,
    transcriptText: 'We live in a culture that treats sleep as a luxury, or worse, as a sign of laziness. We brag about how little we slept, as if exhaustion were a badge of honor. But science tells a very different story. While you sleep, your brain is anything but idle. It is busy consolidating memories, clearing away toxic waste products, and rebalancing the chemistry that regulates your mood. A single night of poor sleep measurably impairs your attention, your judgment, and even your ability to read other people\'s emotions. Chronic sleep deprivation has been linked to heart disease, weakened immunity, and a significantly higher risk of dementia later in life. Yet we continue to sacrifice sleep for one more episode, one more email, one more scroll through our phones. I want to challenge you to reconsider that trade. Imagine treating your eight hours not as wasted time, but as the foundation on which everything else depends: your creativity, your relationships, your health. Protecting your sleep is not self-indulgence. It may be one of the most rational, most productive decisions you can make. So tonight, when the screen glows and one more click beckons, choose rest instead.',
    audioAssetPath: 'assets/audio/lesson_083.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),
  LessonModel(
    id: 'lesson-084',
    title: 'Rethinking Failure',
    category: 'TEDスタイル',
    difficulty: 2,
    transcriptText: 'Most of us are taught to fear failure, to see it as the opposite of success. But what if failure is actually a necessary part of the path? Think about how a child learns to walk. They fall, again and again, dozens of times a day. Nobody calls that failing. We simply call it learning. Somewhere along the way, though, we begin to treat every mistake as evidence that we are not good enough. That fear makes us cautious, and caution quietly stops us from trying new things. I am not asking you to enjoy failure. Nobody enjoys it. But I am asking you to change your relationship with it. The next time something goes wrong, resist the urge to feel ashamed. Instead, ask one simple question: what is this trying to teach me? The people we admire most are rarely those who never failed. They are the ones who kept going anyway.',
    audioAssetPath: 'assets/audio/lesson_084.mp3',
    durationSeconds: 71,
    wordCount: 153,
  ),
  LessonModel(
    id: 'lesson-085',
    title: 'The Value Of Boredom',
    category: 'TEDスタイル',
    difficulty: 3,
    transcriptText: 'I want to make an unusual argument today: that boredom might be one of the most undervalued experiences in modern life. A generation ago, boredom was simply part of being human. We waited in lines, stared out of train windows, and let our minds wander with nowhere in particular to go. Today, that empty space has all but vanished. The moment a flicker of boredom appears, we reach instinctively for our phones, filling every gap with notifications, videos, and endless streams of content. But here is what we are quietly losing. Boredom is not merely the absence of stimulation. It is the fertile ground from which reflection, creativity, and self-understanding grow. Some of our best ideas arrive precisely when the mind is left unoccupied, free to make unexpected connections. When we eliminate every dull moment, we also eliminate the space where imagination breathes. I am not suggesting we abandon technology. I am suggesting we reclaim a little discomfort. Try sitting quietly, without a screen, and simply letting your thoughts drift. It may feel strange at first, even unbearable. But within that emptiness, you may rediscover a part of your mind you had almost forgotten existed.',
    audioAssetPath: 'assets/audio/lesson_085.mp3',
    durationSeconds: 78,
    wordCount: 195,
  ),
  LessonModel(
    id: 'lesson-086',
    title: 'Small Acts Of Kindness',
    category: 'TEDスタイル',
    difficulty: 1,
    transcriptText: 'Today I want to talk about small acts of kindness. We often think we need to do something big to change the world. But that is not true. A simple smile can brighten someone\'s whole day. Saying thank you can make a tired worker feel seen. Holding a door, sharing a kind word, or just listening can mean more than we know. These little actions cost us nothing, yet they spread from person to person. When someone is kind to you, you often want to be kind to others. So today, try one small act of kindness. You may never see the result, but it matters more than you think.',
    audioAssetPath: 'assets/audio/lesson_086.mp3',
    durationSeconds: 66,
    wordCount: 110,
  ),
  LessonModel(
    id: 'lesson-087',
    title: 'Learning To Swim',
    category: 'スポーツ',
    difficulty: 1,
    transcriptText: 'Swimming is a great sport for people of all ages. When I was young, I was afraid of the water. My coach was very kind and patient. First, I learned how to float on my back. Then I practiced kicking my legs slowly. After many lessons, I could swim across the pool. Now I go to the pool twice a week. Swimming makes me feel strong and calm. It is also good for my heart and my whole body. If you want to try it, do not give up. Everyone can learn to swim with time and practice.',
    audioAssetPath: 'assets/audio/lesson_087.mp3',
    durationSeconds: 59,
    wordCount: 98,
  ),
  LessonModel(
    id: 'lesson-088',
    title: 'A Morning Run In The Park',
    category: 'スポーツ',
    difficulty: 1,
    transcriptText: 'Every morning I go for a run in the park near my house. I wake up early, put on my shoes, and step outside. The air is cool and fresh. I start with a slow walk to warm up my body. Then I begin to run along the path under the trees. Sometimes I see other runners and we say hello. Birds sing in the branches above me. After thirty minutes, I feel tired but happy. Running helps me feel awake and ready for the day. It is a simple way to stay healthy and enjoy nature.',
    audioAssetPath: 'assets/audio/lesson_088.mp3',
    durationSeconds: 58,
    wordCount: 97,
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
    transcriptText: 'Rugby is often described as a game played by rough people but governed by remarkable discipline and respect. What fascinates me most is the balance between raw physical power and intricate teamwork. Fifteen players on each side must coordinate their movements, communicating constantly to break through the opposing defense while protecting their own line. Unlike many sports, rugby demands that every player contribute to both attack and defense, blurring the traditional boundaries between offensive and defensive roles. The scrum, in particular, is a fascinating display of collective strength, where eight forwards bind together and drive forward as a single unit. Beyond the physical intensity, rugby cultivates a culture of humility and camaraderie. Opponents who collide fiercely on the field will often share meals and stories afterward, a tradition that reflects the sport\'s deep-rooted values of sportsmanship and mutual respect that endure long after the final whistle.',
    audioAssetPath: 'assets/audio/lesson_090.mp3',
    durationSeconds: 58,
    wordCount: 146,
  ),
  LessonModel(
    id: 'lesson-091',
    title: 'My Favorite Cooking App',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText: 'I love to cook, but I never know what to make for dinner. Last month, I downloaded a cooking app on my phone. Now it is very easy to find new recipes. I just type in the food I have at home, and the app shows me many ideas. Each recipe has clear steps and nice photos. Some even have short videos to help me. I can also save my favorite meals for later. The app tells me how long each dish will take to cook. Thanks to this simple tool, I now enjoy cooking much more, and my meals taste better than before.',
    audioAssetPath: 'assets/audio/lesson_091.mp3',
    durationSeconds: 62,
    wordCount: 104,
  ),
  LessonModel(
    id: 'lesson-092',
    title: 'How Robots Help At Home',
    category: 'テクノロジー',
    difficulty: 1,
    transcriptText: 'Robots are no longer just in movies. Today, many people use small robots at home. My family has a robot that cleans the floor. It moves around by itself and picks up dust. We turn it on before we leave for work. When we come home, the floor is clean. Some robots can help in the kitchen or answer simple questions. Others can water plants or feed pets. These machines save us time and make life easier. I think robots will become even more common in the future. They are helpful friends that do the boring jobs, so we have more time to relax and enjoy our day.',
    audioAssetPath: 'assets/audio/lesson_092.mp3',
    durationSeconds: 65,
    wordCount: 108,
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
    transcriptText: 'A new public library opened in our town last week. Many people came to see it on the first day. The building is bright and modern, with large windows and comfortable chairs. Children have their own reading room full of colorful books. There is also a quiet area for students who want to study. The library offers free internet and computers for everyone to use. On weekends, staff will hold story time for young kids. The mayor said the library will help the whole community learn and grow. I visited yesterday and borrowed three books. I am very happy that our town now has such a wonderful place to read.',
    audioAssetPath: 'assets/audio/lesson_096.mp3',
    durationSeconds: 66,
    wordCount: 110,
  ),
  LessonModel(
    id: 'lesson-097',
    title: 'Recycling Rules Change This Month',
    category: '時事ネタ',
    difficulty: 1,
    transcriptText: 'Our city has new recycling rules that start this month. The government wants to reduce waste and protect the environment. Now we must separate our trash into more groups. Paper, glass, and plastic all go into different bins. Food waste has its own special bag too. At first, some people found the new system confusing. The city sent a simple guide to every home to help. There are also new signs at the collection points. If we follow the rules, less garbage will go to landfills. Many neighbors say they are happy to help the planet. Small changes like these can make a big difference for our future and our children.',
    audioAssetPath: 'assets/audio/lesson_097.mp3',
    durationSeconds: 67,
    wordCount: 111,
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
    transcriptText: 'Running a marathon is about far more than simply being fast. The real challenge lies in managing your energy over a distance of more than forty kilometers. Experienced runners learn to control their pace from the very beginning, resisting the temptation to sprint ahead when they feel fresh and excited. Instead, they aim for a steady rhythm that they can maintain for hours. Nutrition and hydration also play a crucial role, so many athletes drink water and eat small snacks along the route to avoid running out of fuel. Training for a marathon takes months of preparation, gradually increasing the distance each week. Mental strength matters just as much as physical fitness, because there are moments when the body wants to stop. Crossing the finish line brings a powerful sense of achievement that makes all the effort worthwhile.',
    audioAssetPath: 'assets/audio/lesson_100.mp3',
    durationSeconds: 64,
    wordCount: 138,
  ),
];
