# Doppel — AI シャドーイングコーチ

## Phase 1: Business Strategy

### App Name

**Doppel** — AI シャドーイングコーチ

### Concept

AIコーチがリアルタイムで発音・リズム・イントネーションを分析し、パーソナライズされたフィードバックで英語シャドーイングの上達を加速するアプリ。

### Target Users

- **Who:** TOEIC 500〜750点レベルの日本人ビジネスパーソン（25〜40歳）。リスニング・スピーキング力を伸ばしたいが、英会話教室に通う時間がない層。
- **Problem:** シャドーイングは効果的と知っているが、自分の発音が正しいのか判断できず、独学では改善ポイントが分からないまま挫折する。
- **Payment motivation:** プロの添削（シャドテン月額約21,780円）は高額。AIによるリアルタイムフィードバックで、1/10以下の価格で同等の改善効果が得られるなら払う。

### Revenue Model

- **Model:** Freemium + Subscription
  - 無料プラン: 1日1レッスン（3分）、基本フィードバック
  - Pro プラン: 無制限レッスン、詳細AI分析、進捗ダッシュボード、オフライン教材
- **Price:** ¥1,480/月（年払い ¥9,800 = ¥817/月）
- **Monthly target:** 有料ユーザー500人 × ¥1,480 = ¥740,000/月（初年度目標）

### Competitive Advantages

1. **リアルタイムAIフィードバック** — 録音→提出→翌日添削のシャドテンと異なり、練習直後にAIが発音・リズム・イントネーションを即時分析。待ち時間ゼロで反復練習のサイクルが圧倒的に速い。
2. **価格破壊** — シャドテン（¥21,780/月）の約1/15の価格。人件費がかからないAIモデルだからこそ実現可能。
3. **適応型レッスン** — AIが弱点パターン（例：/r/と/l/の混同、文末イントネーションの下降不足）を学習し、ユーザーごとにカスタマイズされた教材・練習メニューを自動生成。

### Core Screens (5 screens)

1. **Home（ホーム）** — 今日のレッスン推薦、連続練習日数ストリーク、週間進捗サマリー。ワンタップでレッスン開始。
2. **Lesson（レッスン）** — お手本音声再生 → シャドーイング録音 → 波形比較表示。再生速度調整（0.5x〜1.5x）、区間リピート機能。
3. **Feedback（フィードバック）** — AIによる採点（発音正確度・リズム・イントネーション）、改善すべき単語/フレーズのハイライト、AIコーチからの具体的アドバイスメッセージ。
4. **Library（ライブラリ）** — 教材一覧（ニュース・ビジネス・日常会話・TEDスタイル）、難易度別フィルター、ブックマーク機能、進捗バッジ表示。
5. **Progress（進捗）** — 週次/月次スコア推移グラフ、苦手発音パターン分析、累計練習時間、AIコーチからの週間レビューコメント。

### Design Direction

- **Mood:** Clean & Motivational — 集中力を妨げないミニマルなUIに、達成感を演出する控えめなモーション。
- **Color feel:** Deep Indigo（知的・信頼）をプライマリに、Amber（達成・ポジティブ）をアクセント。ダークモード対応で夜間練習にも最適。
- **Reference apps:** Duolingo（ゲーミフィケーションのストリーク）、ELSA Speak（発音分析UI）、Calm（落ち着いた集中できるデザイン）

---

## Phase 2: UI Design Spec

### Design System

#### Color Palette

```
seedColor: #1A237E  // Deep Indigo — 知的さ・信頼感を表現。学習アプリとしての真剣さを伝える。
```

| Role        | HEX       | Usage                                          |
|-------------|-----------|------------------------------------------------|
| Primary     | `#1A237E` | AppBar、主要ボタン、アクティブ状態のナビゲーション |
| Secondary   | `#FF8F00` | ストリーク炎アイコン、達成バッジ、スコアハイライト  |
| Tertiary    | `#00695C` | 正解/良好スコアのインジケーター、成功状態           |
| Background  | `#F5F5F7` | ライトモードの全画面背景                          |
| Surface     | `#FFFFFF` | カード、ボトムシート、ダイアログ                   |
| Error       | `#B71C1C` | 発音エラーハイライト、バリデーションエラー          |

#### Typography (Google Fonts)

```
DisplayFont: Noto Sans JP (Weight: 700) — 見出し、スクリーンタイトル、スコア表示
BodyFont:    Noto Sans JP (Weight: 400) — 本文、ラベル、AIフィードバックテキスト
MonoFont:    IBM Plex Mono (Weight: 400) — タイマー、波形ラベル、統計数値
```

#### Visual Style

洗練されたミニマルデザインに、学習の達成感を伝えるAmberアクセントを添える。カードベースのレイアウトで情報を整理し、余白を十分に確保して集中力を妨げない。波形表示やスコアグラフには控えめなアニメーションを使い、練習のリズム感とモチベーションを視覚的にサポートする。

---

### Screen-by-Screen Widget Design

#### Screen 1: Home（ホーム）

**Purpose:** 毎日の練習開始点。モチベーション維持のためストリークと進捗を一目で把握させ、ワンタップでレッスンへ導く。

**Widget tree:**
```
Scaffold
  ├── AppBar
  │     ├── Text("Doppel", style: DisplayFont/24)
  │     └── IconButton(Icons.settings)
  └── Body: SafeArea
        └── SingleChildScrollView
              └── Column(crossAxisAlignment: start, padding: 20)
                    ├── _GreetingSection
                    │     ├── Text("おはよう、{name}さん", DisplayFont/20)
                    │     └── Text("Day {streak} 🔥", BodyFont/16, color: Secondary)
                    ├── SizedBox(height: 24)
                    ├── _TodayLessonCard ← Card(elevation: 2, borderRadius: 16)
                    │     └── InkWell(onTap: → LessonScreen)
                    │           └── Padding(16)
                    │                 ├── Row
                    │                 │     ├── Column
                    │                 │     │     ├── Text("今日のレッスン", BodyFont/12, color: onSurfaceVariant)
                    │                 │     │     ├── Text("{lesson_title}", DisplayFont/18)
                    │                 │     │     └── Chip(label: "{difficulty}", color: Primary)
                    │                 │     └── CircleAvatar(radius: 28, child: Icon(Icons.play_arrow))
                    │                 └── LinearProgressIndicator(value: weeklyProgress, color: Primary)
                    ├── SizedBox(height: 24)
                    ├── _WeeklySummaryRow ← Row(mainAxisAlignment: spaceEvenly)
                    │     ├── _StatTile("今週", "{n}回", Icons.mic)
                    │     ├── _StatTile("平均", "{n}点", Icons.trending_up)
                    │     └── _StatTile("時間", "{n}分", Icons.timer)
                    └── SizedBox(height: 24)
                          └── _RecentActivityList ← Column
                                ├── Text("最近の練習", DisplayFont/16)
                                └── ListView.builder(shrinkWrap: true, physics: NeverScrollable)
                                      └── ListTile(leading: Icon, title: lessonName, trailing: score)
```

**Key components:**
- `_TodayLessonCard`: Hero アニメーション付き。タップで Lesson 画面へ遷移。
- `_WeeklySummaryRow`: 3つの `_StatTile` で週間統計を表示。各タイルは `Column` + `Icon` + `Text` × 2。
- `LinearProgressIndicator`: 週間目標（例: 5回/週）に対する達成率。

**Interactions:**
- `InkWell` on `_TodayLessonCard`: `Hero` transition → Lesson 画面
- `AnimatedSwitcher` on streak count: 数値変化時にフェードアニメーション

**Design notes:**
- Card borderRadius: 16, elevation: 2
- セクション間 spacing: 24
- StatTile サイズ: 100 × 80, borderRadius: 12, background: Surface
- ストリーク炎: Secondary (#FF8F00) でアクセント

---

#### Screen 2: Lesson（レッスン）

**Purpose:** シャドーイングの実践画面。お手本再生→録音→波形比較の一連のフローをシームレスに提供。

**Widget tree:**
```
Scaffold
  ├── AppBar
  │     ├── IconButton(Icons.arrow_back)
  │     ├── Text("{lesson_title}", DisplayFont/18)
  │     └── IconButton(Icons.more_vert) → SpeedMenu
  └── Body: Column
        ├── Expanded(flex: 2)
        │     └── _TranscriptView ← SingleChildScrollView
        │           └── RichText
        │                 └── TextSpan[] — 現在再生中の単語をPrimaryでハイライト
        ├── Expanded(flex: 3)
        │     └── _WaveformComparison ← Column
        │           ├── Text("お手本", BodyFont/12)
        │           ├── _WaveformWidget(data: modelAudio, color: Primary.withOpacity(0.6))
        │           ├── SizedBox(height: 8)
        │           ├── Text("あなた", BodyFont/12)
        │           └── _WaveformWidget(data: userAudio, color: Secondary)
        ├── _PlaybackControls ← Padding(horizontal: 20)
        │     ├── Row(mainAxisAlignment: spaceBetween)
        │     │     ├── IconButton(Icons.replay_5) — 5秒巻き戻し
        │     │     ├── Slider(value: speed, min: 0.5, max: 1.5, divisions: 4)
        │     │     └── Text("{speed}x", MonoFont/14)
        │     └── _SegmentRepeatToggle ← ToggleButtons(["全体", "区間リピート"])
        └── _RecordButton ← Padding(bottom: 32)
              └── Center
                    └── GestureDetector(onTap: toggleRecord)
                          └── AnimatedContainer(duration: 300ms)
                                └── CircleAvatar(radius: 36)
                                      └── Icon(recording ? Icons.stop : Icons.mic, size: 32)
```

**Key components:**
- `_TranscriptView`: お手本テキストを表示。再生位置に合わせて現在の単語を `Primary` カラーでハイライト。
- `_WaveformWidget`: `CustomPainter` で波形を描画。お手本（Indigo 半透明）とユーザー音声（Amber）を上下に並べて比較。
- `_RecordButton`: 録音中は `AnimatedContainer` で赤く拡大。録音停止で自動的に Feedback 画面へ遷移。

**Interactions:**
- `Hero` transition: Home の `_TodayLessonCard` → この画面の `AppBar`
- 録音ボタン: `AnimatedContainer` でサイズ・色が変化（48→56 radius、Primary→Error）
- 波形: 再生に合わせてリアルタイム描画（`CustomPainter` + `AnimationController`）
- `Slider`: 再生速度変更時に `AnimatedSwitcher` でラベル更新

**Design notes:**
- 波形エリア背景: Surface, borderRadius: 12, padding: 16
- 録音ボタン: 非録音時 Primary, 録音時 Error, elevation: 8
- Transcript ハイライト: Primary + FontWeight.w700
- 速度 Slider: activeColor: Primary, divisions ラベル: 0.5x / 0.75x / 1.0x / 1.25x / 1.5x

---

#### Screen 3: Feedback（フィードバック）

**Purpose:** AIによる詳細な採点結果とコーチングを表示。改善ポイントを視覚的に分かりやすく提示し、再挑戦を促す。

**Widget tree:**
```
Scaffold
  ├── AppBar
  │     ├── Text("フィードバック", DisplayFont/18)
  │     └── IconButton(Icons.share)
  └── Body: SingleChildScrollView
        └── Column(padding: 20)
              ├── _OverallScoreCard ← Card(elevation: 2, borderRadius: 16)
              │     └── Padding(24)
              │           ├── _CircularScoreIndicator ← Stack
              │           │     ├── SizedBox(120 × 120)
              │           │     │     └── CircularProgressIndicator(value: score/100, strokeWidth: 10, color: _scoreColor)
              │           │     └── Center → Text("{score}", DisplayFont/36)
              │           └── Row(mainAxisAlignment: spaceEvenly)
              │                 ├── _SubScoreTile("発音", pronunciationScore)
              │                 ├── _SubScoreTile("リズム", rhythmScore)
              │                 └── _SubScoreTile("抑揚", intonationScore)
              ├── SizedBox(height: 20)
              ├── _ProblemWordsSection ← Card(borderRadius: 12)
              │     └── Column
              │           ├── Text("改善ポイント", DisplayFont/16)
              │           └── Wrap(spacing: 8)
              │                 └── _ProblemWordChip[] ← InputChip
              │                       ├── label: Text(word)
              │                       ├── avatar: Icon(Icons.volume_up, size: 16)
              │                       └── backgroundColor: Error.withOpacity(0.1)
              ├── SizedBox(height: 20)
              ├── _AICoachMessage ← Card(color: Primary.withOpacity(0.05), borderRadius: 12)
              │     └── Padding(16)
              │           └── Row(crossAxisAlignment: start)
              │                 ├── CircleAvatar(child: Icon(Icons.psychology), radius: 20, bg: Primary)
              │                 └── Expanded → Column
              │                       ├── Text("AIコーチ", DisplayFont/14, color: Primary)
              │                       └── Text(coachMessage, BodyFont/14)
              ├── SizedBox(height: 20)
              ├── _DetailedAnalysis ← ExpansionTile
              │     ├── title: Text("詳細分析", DisplayFont/14)
              │     └── children:
              │           └── _SentenceBreakdown[] ← ListTile
              │                 ├── title: RichText(sentence with color-coded words)
              │                 └── trailing: Text(sentenceScore, MonoFont)
              └── SizedBox(height: 32)
                    └── _ActionButtons ← Row
                          ├── Expanded → OutlinedButton("ライブラリへ", icon: Icons.list)
                          └── SizedBox(width: 12)
                                └── Expanded → FilledButton("もう一度", icon: Icons.replay)
```

**Key components:**
- `_CircularScoreIndicator`: 総合スコアを円グラフで表示。スコアに応じて色変化（80+: Tertiary、60-79: Secondary、0-59: Error）。
- `_ProblemWordChip`: タップでお手本発音を再生。エラー度合いに応じて `Error` の透明度を変化。
- `_AICoachMessage`: AIコーチのアバター付きメッセージカード。具体的な改善アドバイスを表示。

**Interactions:**
- `AnimatedCircularProgressIndicator`: 画面表示時に 0 → score までアニメーション（duration: 800ms, curve: easeOutCubic）
- `_ProblemWordChip` タップ: お手本の該当単語音声を再生
- `ExpansionTile`: 詳細分析の展開/折りたたみ
- 「もう一度」ボタン: `Hero` transition で Lesson 画面へ戻る

**Design notes:**
- スコア円: strokeWidth: 10, size: 120 × 120
- サブスコア `_SubScoreTile`: 60 × 60, 各ラベル BodyFont/12
- AIコーチカード: background Primary 5% opacity, borderRadius: 12
- ProblemWordChip: borderRadius: 20, Error 10% opacity background

---

#### Screen 4: Library（ライブラリ）

**Purpose:** 教材を探索・選択する画面。カテゴリ・難易度でフィルタリングし、ユーザーが最適な教材を見つけられるようにする。

**Widget tree:**
```
Scaffold
  ├── AppBar
  │     ├── Text("ライブラリ", DisplayFont/20)
  │     └── IconButton(Icons.search) → _SearchDelegate
  └── Body: Column
        ├── _CategoryFilter ← SingleChildScrollView(scrollDirection: horizontal)
        │     └── Padding(horizontal: 16, vertical: 8)
        │           └── Row(spacing: 8)
        │                 └── FilterChip[] — ["すべて", "ニュース", "ビジネス", "日常会話", "TEDスタイル"]
        ├── _DifficultyFilter ← Padding(horizontal: 16)
        │     └── SegmentedButton(segments: ["初級", "中級", "上級"])
        ├── SizedBox(height: 8)
        └── Expanded
              └── ListView.builder(padding: horizontal 16)
                    └── _LessonCard[] ← Card(elevation: 1, borderRadius: 12)
                          └── InkWell(onTap: → LessonScreen)
                                └── Padding(12)
                                      └── Row
                                            ├── ClipRRect(borderRadius: 8)
                                            │     └── Container(60 × 60, color: Primary.withOpacity(0.1))
                                            │           └── Icon(Icons.headphones, color: Primary)
                                            ├── SizedBox(width: 12)
                                            ├── Expanded → Column(crossAxisAlignment: start)
                                            │     ├── Text(title, DisplayFont/14)
                                            │     ├── Text(duration + " • " + wordCount, BodyFont/12, color: onSurfaceVariant)
                                            │     └── Row
                                            │           ├── _DifficultyDots(level: difficulty)
                                            │           └── Spacer
                                            │                 └── _CompletionBadge (if completed)
                                            └── IconButton(Icons.bookmark_border / Icons.bookmark)
```

**Key components:**
- `FilterChip[]`: カテゴリ選択。選択時 Primary 背景に変化。複数選択可。
- `SegmentedButton`: 難易度フィルター。単一選択。
- `_LessonCard`: 教材情報カード。完了済みは `_CompletionBadge`（Tertiary チェックアイコン）表示。
- `_DifficultyDots`: 3つのドットで難易度を視覚表示（塗り/空で初級〜上級）。

**Interactions:**
- `FilterChip` タップ: `AnimatedSwitcher` でリスト更新
- `_LessonCard` タップ: Lesson 画面へ `PageTransitionsTheme` でスライド遷移
- ブックマーク `IconButton`: タップでトグル、`AnimatedSwitcher` でアイコン切替
- 検索: `showSearch()` → `SearchDelegate` でインクリメンタルサーチ

**Design notes:**
- FilterChip: selectedColor: Primary, checkmarkColor: onPrimary
- LessonCard: elevation: 1, borderRadius: 12, margin: vertical 4
- サムネイル: 60 × 60, borderRadius: 8
- CompletionBadge: Tertiary background 20% opacity, Icon size: 16

---

#### Screen 5: Progress（進捗）

**Purpose:** 学習の成果を可視化し、長期的なモチベーションを維持する。AIコーチによる週間レビューで継続を後押し。

**Widget tree:**
```
Scaffold
  ├── AppBar
  │     ├── Text("進捗", DisplayFont/20)
  │     └── ToggleButtons(["週", "月"]) — 表示期間切替
  └── Body: SingleChildScrollView
        └── Column(padding: 20)
              ├── _ScoreChart ← Card(elevation: 2, borderRadius: 16)
              │     └── Padding(16)
              │           ├── Text("スコア推移", DisplayFont/16)
              │           └── SizedBox(height: 200)
              │                 └── LineChart (fl_chart)
              │                       ├── xAxis: 日付
              │                       ├── yAxis: 0-100
              │                       ├── line color: Primary
              │                       └── gradient fill: Primary.withOpacity(0.1)
              ├── SizedBox(height: 20)
              ├── _WeakPointsCard ← Card(elevation: 1, borderRadius: 12)
              │     └── Padding(16)
              │           ├── Text("苦手パターン", DisplayFont/16)
              │           └── Column
              │                 └── _WeakPointRow[] ← Row
              │                       ├── Text(pattern, BodyFont/14) — e.g. "/r/ と /l/"
              │                       ├── Expanded → LinearProgressIndicator(value: errorRate, color: Error)
              │                       └── Text(percentage, MonoFont/12)
              ├── SizedBox(height: 20)
              ├── _StatsGrid ← Row
              │     ├── Expanded → _StatCard("累計練習", "{n}時間", Icons.timer)
              │     ├── SizedBox(width: 12)
              │     ├── Expanded → _StatCard("完了レッスン", "{n}回", Icons.check_circle)
              │     ├── SizedBox(width: 12)
              │     └── Expanded → _StatCard("最長連続", "{n}日", Icons.local_fire_department)
              ├── SizedBox(height: 20)
              └── _WeeklyReview ← Card(color: Primary.withOpacity(0.05), borderRadius: 12)
                    └── Padding(16)
                          └── Row(crossAxisAlignment: start)
                                ├── CircleAvatar(child: Icon(Icons.psychology), radius: 20, bg: Primary)
                                └── Expanded → Column
                                      ├── Text("今週のレビュー", DisplayFont/14, color: Primary)
                                      └── Text(weeklyReviewMessage, BodyFont/14)
```

**Key components:**
- `_ScoreChart`: `fl_chart` パッケージの `LineChart` でスコア推移を表示。グラデーション塗りつぶしで視覚的に美しく。
- `_WeakPointsCard`: 苦手発音パターンを `LinearProgressIndicator` のエラー率で可視化。
- `_StatsGrid`: 3カラムの統計カード。累計練習時間・完了数・最長ストリーク。
- `_WeeklyReview`: AIコーチの週間レビューメッセージ。Feedback 画面と同じデザイン言語。

**Interactions:**
- `ToggleButtons` 週/月切替: `AnimatedSwitcher` でチャートデータを切替
- `LineChart`: タッチで該当日のスコア詳細をツールチップ表示
- 画面表示時: チャートが左→右へ `AnimationController`（duration: 600ms）で描画

**Design notes:**
- チャートエリア: height: 200, line strokeWidth: 3, gradient fill Primary 10% opacity
- StatCard: borderRadius: 12, elevation: 1, padding: 16, icon size: 24 (Secondary)
- WeakPointRow: LinearProgressIndicator height: 8, borderRadius: 4
- WeeklyReview: Feedback 画面の `_AICoachMessage` と同一コンポーネント

---

### Navigation

```
BottomNavigationBar (NavigationBar — Material 3)
  ├── NavigationDestination(icon: Icons.home_outlined,        selectedIcon: Icons.home,          label: "ホーム")
  ├── NavigationDestination(icon: Icons.menu_book_outlined,   selectedIcon: Icons.menu_book,     label: "ライブラリ")
  └── NavigationDestination(icon: Icons.insights_outlined,    selectedIcon: Icons.insights,      label: "進捗")
```

- Lesson / Feedback 画面はフルスクリーン遷移（BottomNav 非表示）
- `PageTransitionsTheme`: FadeUpwards（Android）、CupertinoPageRoute（iOS）

---

### Signature Design Details

1. **波形デュアルビュー** — お手本とユーザー音声の波形を上下に並べ、色分け（Indigo / Amber）で直感的に比較。`CustomPainter` によるスムーズなリアルタイム描画。
2. **AIコーチカード** — Deep Indigo 5% 背景 + アバター付きメッセージ。Feedback と Progress 画面で統一されたデザイン言語。コーチの人格を感じさせつつ押しつけがましくない。
3. **スコア円アニメーション** — Feedback 画面進入時に 0 → スコアまで `easeOutCubic` でアニメーション。達成感を演出しつつ、スコアへの注目を自然に誘導。

### Accessibility

- **Contrast ratio:** WCAG AA minimum (4.5:1) confirmed — Primary #1A237E on Background #F5F5F7 = 12.6:1, Error #B71C1C on Surface #FFFFFF = 7.8:1
- **Tap targets:** すべてのインタラクティブ要素は minimum 48 × 48dp
- **録音ボタン:** 72dp radius で視認性・操作性を最大化
- **フォントサイズ:** 最小 12sp（ラベル）、本文 14sp 以上。`MediaQuery.textScaleFactor` 対応
- **スクリーンリーダー:** 全 `Icon` に `semanticLabel` を設定、波形は `Semantics(label: "スコア{n}点")` で代替テキスト提供

---

## Phase 3: Flutter Implementation Plan

### Architecture

```
State management:  Riverpod 2.x (@riverpod annotation)
Architecture:      Feature-first Clean Architecture
Async:             async/await + AsyncValue for error handling
Local DB:          Isar (Flutter-native)
Models:            freezed for immutable data classes
Routing:           go_router
Audio:             just_audio (再生) + record (録音)
AI/Speech:         Google Cloud Speech-to-Text API + Claude API (コーチング)
Charts:            fl_chart
```

### pubspec.yaml

```yaml
name: doppel
description: AI Shadowing Coach - シャドーイングを加速するAIコーチ
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.5.0
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.6.1
  go_router: ^14.3.0
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  google_fonts: ^6.2.1
  path_provider: ^2.1.4

  # Audio
  just_audio: ^0.9.40
  record: ^5.1.2
  audio_waveforms: ^1.2.0

  # AI / Speech
  google_speech: ^2.3.0
  http: ^1.2.2

  # Charts
  fl_chart: ^0.69.0

  # Utilities
  intl: ^0.19.0
  shared_preferences: ^2.3.2
  uuid: ^4.5.1
  permission_handler: ^11.3.1

dev_dependencies:
  riverpod_generator: ^2.6.1
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  build_runner: ^2.4.12
  isar_generator: ^3.1.0
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  mocktail: ^1.0.4
```

### Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── router.dart                    # go_router (5 screens + BottomNav shell)
│   └── theme.dart                     # ThemeData / ColorScheme.fromSeed(#1A237E)
├── features/
│   ├── home/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── home_screen.dart
│   │       ├── widgets/
│   │       │   ├── greeting_section.dart
│   │       │   ├── today_lesson_card.dart
│   │       │   ├── weekly_summary_row.dart
│   │       │   └── recent_activity_list.dart
│   │       └── providers/
│   │           └── home_provider.dart
│   ├── lesson/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── lesson_model.dart          # freezed + Isar
│   │   │   └── repositories/
│   │   │       └── lesson_repository.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── lesson.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── lesson_screen.dart
│   │       ├── widgets/
│   │       │   ├── transcript_view.dart
│   │       │   ├── waveform_widget.dart
│   │       │   ├── waveform_comparison.dart
│   │       │   ├── playback_controls.dart
│   │       │   └── record_button.dart
│   │       └── providers/
│   │           ├── lesson_provider.dart
│   │           ├── audio_player_provider.dart
│   │           └── audio_recorder_provider.dart
│   ├── feedback/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── feedback_model.dart        # freezed + Isar
│   │   │   └── repositories/
│   │   │       └── feedback_repository.dart
│   │   ├── domain/
│   │   │   └── entities/
│   │   │       └── feedback_result.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── feedback_screen.dart
│   │       ├── widgets/
│   │       │   ├── circular_score_indicator.dart
│   │       │   ├── sub_score_tile.dart
│   │       │   ├── problem_words_section.dart
│   │       │   ├── ai_coach_message.dart      # shared widget
│   │       │   └── detailed_analysis.dart
│   │       └── providers/
│   │           ├── feedback_provider.dart
│   │           └── ai_coach_provider.dart
│   ├── library/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── library_repository.dart
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── library_screen.dart
│   │       ├── widgets/
│   │       │   ├── category_filter.dart
│   │       │   ├── difficulty_filter.dart
│   │       │   ├── lesson_card.dart
│   │       │   └── difficulty_dots.dart
│   │       └── providers/
│   │           └── library_provider.dart
│   └── progress/
│       ├── data/
│       │   └── repositories/
│       │       └── progress_repository.dart
│       └── presentation/
│           ├── screens/
│           │   └── progress_screen.dart
│           ├── widgets/
│           │   ├── score_chart.dart
│           │   ├── weak_points_card.dart
│           │   ├── stats_grid.dart
│           │   └── weekly_review.dart
│           └── providers/
│               └── progress_provider.dart
└── shared/
    ├── widgets/
    │   ├── ai_coach_card.dart                 # Feedback & Progress で共有
    │   └── stat_tile.dart                     # Home & Progress で共有
    ├── services/
    │   ├── audio_service.dart                 # 録音・再生の統合サービス
    │   ├── speech_analysis_service.dart        # Speech-to-Text + スコアリング
    │   └── ai_coach_service.dart              # Claude API ラッパー
    └── utils/
        ├── score_utils.dart                   # スコア計算ロジック
        └── date_utils.dart                    # 日付フォーマット
```

### Data Models (Freezed + Isar)

```dart
// lesson_model.dart
@collection
@freezed
class LessonModel with _$LessonModel {
  const LessonModel._();

  const factory LessonModel({
    required String id,
    required String title,
    required String category,       // "news" | "business" | "daily" | "ted"
    required int difficulty,         // 1=初級, 2=中級, 3=上級
    required String transcriptText,
    required String audioAssetPath,
    required int durationSeconds,
    required int wordCount,
    @Default(false) bool isBookmarked,
    @Default(false) bool isCompleted,
    DateTime? lastPracticedAt,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);
}

// feedback_model.dart
@collection
@freezed
class FeedbackModel with _$FeedbackModel {
  const FeedbackModel._();

  const factory FeedbackModel({
    required String id,
    required String lessonId,
    required int overallScore,            // 0-100
    required int pronunciationScore,      // 0-100
    required int rhythmScore,             // 0-100
    required int intonationScore,         // 0-100
    required List<ProblemWord> problemWords,
    required String coachMessage,
    required DateTime createdAt,
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
}

@freezed
class ProblemWord with _$ProblemWord {
  const factory ProblemWord({
    required String word,
    required String phoneme,         // e.g. "/r/", "/l/"
    required double errorRate,       // 0.0 - 1.0
  }) = _ProblemWord;

  factory ProblemWord.fromJson(Map<String, dynamic> json) =>
      _$ProblemWordFromJson(json);
}

// progress_model.dart
@collection
@freezed
class UserProgress with _$UserProgress {
  const UserProgress._();

  const factory UserProgress({
    required String userId,
    required int currentStreak,
    required int longestStreak,
    required int totalPracticeMinutes,
    required int completedLessons,
    required DateTime lastPracticeDate,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}
```

### AppTheme (Phase 2 → Phase 3 連携)

```dart
// app/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _seed = Color(0xFF1A237E); // Deep Indigo from Phase 2
  static const secondary = Color(0xFFFF8F00); // Amber accent
  static const tertiary = Color(0xFF00695C);  // Success green

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      secondary: secondary,
      tertiary: tertiary,
      background: const Color(0xFFF5F5F7),
      surface: Colors.white,
      error: const Color(0xFFB71C1C),
    );

    final notoSans = GoogleFonts.notoSansJpTextTheme();

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: notoSans.copyWith(
        displayLarge: GoogleFonts.notoSansJp(
          fontSize: 36, fontWeight: FontWeight.w700,
        ),
        displayMedium: GoogleFonts.notoSansJp(
          fontSize: 24, fontWeight: FontWeight.w700,
        ),
        titleLarge: GoogleFonts.notoSansJp(
          fontSize: 20, fontWeight: FontWeight.w700,
        ),
        titleMedium: GoogleFonts.notoSansJp(
          fontSize: 18, fontWeight: FontWeight.w700,
        ),
        titleSmall: GoogleFonts.notoSansJp(
          fontSize: 16, fontWeight: FontWeight.w700,
        ),
        bodyLarge: GoogleFonts.notoSansJp(
          fontSize: 16, fontWeight: FontWeight.w400,
        ),
        bodyMedium: GoogleFonts.notoSansJp(
          fontSize: 14, fontWeight: FontWeight.w400,
        ),
        bodySmall: GoogleFonts.notoSansJp(
          fontSize: 12, fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.ibmPlexMono(
          fontSize: 14, fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: colorScheme.primary.withOpacity(0.12),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
      secondary: secondary,
      tertiary: tertiary,
      error: const Color(0xFFB71C1C),
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.notoSansJpTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
```

### Router (go_router + ShellRoute)

```dart
// app/router.dart
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/progress',
            builder: (context, state) => const ProgressScreen(),
          ),
        ],
      ),
      // フルスクリーン遷移（BottomNav 非表示）
      GoRoute(
        path: '/lesson/:lessonId',
        builder: (context, state) => LessonScreen(
          lessonId: state.pathParameters['lessonId']!,
        ),
      ),
      GoRoute(
        path: '/feedback/:feedbackId',
        builder: (context, state) => FeedbackScreen(
          feedbackId: state.pathParameters['feedbackId']!,
        ),
      ),
    ],
  );
});

// MainShell — NavigationBar wrapper
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'ライブラリ',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: '進捗',
          ),
        ],
        // selectedIndex / onDestinationSelected は GoRouter state と連動
      ),
    );
  }
}
```

### Core Service: Speech Analysis

```dart
// shared/services/speech_analysis_service.dart
class SpeechAnalysisService {
  /// ユーザー録音を分析し、FeedbackModel を生成
  Future<FeedbackModel> analyze({
    required String lessonId,
    required String modelTranscript,
    required String userAudioPath,
  }) async {
    // 1. Speech-to-Text でユーザー音声をテキスト化
    final userTranscript = await _speechToText(userAudioPath);

    // 2. 単語レベルの比較で発音スコアを算出
    final pronunciationScore = _calcPronunciationScore(
      model: modelTranscript,
      user: userTranscript,
    );

    // 3. タイミング情報からリズムスコアを算出
    final rhythmScore = _calcRhythmScore(/* timing data */);

    // 4. ピッチ情報からイントネーションスコアを算出
    final intonationScore = _calcIntonationScore(/* pitch data */);

    // 5. 問題のある単語を抽出
    final problemWords = _extractProblemWords(
      model: modelTranscript,
      user: userTranscript,
    );

    // 6. AI コーチメッセージを生成
    final coachMessage = await _generateCoachMessage(
      pronunciationScore: pronunciationScore,
      rhythmScore: rhythmScore,
      intonationScore: intonationScore,
      problemWords: problemWords,
    );

    final overall = ((pronunciationScore + rhythmScore + intonationScore) / 3).round();

    return FeedbackModel(
      id: const Uuid().v4(),
      lessonId: lessonId,
      overallScore: overall,
      pronunciationScore: pronunciationScore,
      rhythmScore: rhythmScore,
      intonationScore: intonationScore,
      problemWords: problemWords,
      coachMessage: coachMessage,
      createdAt: DateTime.now(),
    );
  }
}
```

### Screen Example: FeedbackScreen

```dart
// features/feedback/presentation/screens/feedback_screen.dart
class FeedbackScreen extends ConsumerWidget {
  final String feedbackId;
  const FeedbackScreen({super.key, required this.feedbackId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedbackProvider(feedbackId));

    return Scaffold(
      appBar: AppBar(
        title: Text('フィードバック',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: switch (state) {
        AsyncData(:final value) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircularScoreIndicator(score: value.overallScore),
              const SizedBox(height: 20),
              SubScoreRow(
                pronunciation: value.pronunciationScore,
                rhythm: value.rhythmScore,
                intonation: value.intonationScore,
              ),
              const SizedBox(height: 20),
              ProblemWordsSection(words: value.problemWords),
              const SizedBox(height: 20),
              AiCoachCard(message: value.coachMessage),
              const SizedBox(height: 20),
              DetailedAnalysis(feedbackId: feedbackId),
              const SizedBox(height: 32),
              _ActionButtons(lessonId: value.lessonId),
            ],
          ),
        ),
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
```

### Implementation Phases

#### Phase A — Foundation (Week 1–2) ✅ 完了

- [x] `flutter create doppel` + pubspec.yaml 設定
- [x] `app/theme.dart`: `ColorScheme.fromSeed(seedColor: Color(0xFF1A237E))` + Noto Sans JP + IBM Plex Mono
- [x] `app/router.dart`: go_router ShellRoute + 5 screen routes
- [x] `main.dart`: `ProviderScope` + `MaterialApp.router`
- [x] Hive CE DB 初期化 + freezed モデル定義 (LessonModel, FeedbackModel, UserProgress)
- [x] `build_runner` コード生成確認
- [x] 各画面の空 Scaffold + NavigationBar 遷移確認

> **変更点:** Isar → Hive CE に変更（Flutter 3.41+ 互換性のため）

#### Phase B — Core Features (Week 3–5) ✅ 完了

- [x] **Home 画面**: GreetingSection, TodayLessonCard, WeeklySummaryRow, RecentActivityList
- [x] **Library 画面**: FilterChip カテゴリ、SegmentedButton 難易度、LessonCard リスト、検索
- [x] **Lesson 画面**: flutter_tts でお手本再生、record で録音、波形アニメーション、速度調整 Slider
- [x] **Feedback 画面**: CircularScoreIndicator、ProblemWordChip、AiCoachMessage
- [x] **Progress 画面**: fl_chart LineChart、WeakPointsCard、StatsGrid、WeeklyReview
- [x] **Audio Service**: 録音 → Whisper Speech-to-Text → テキスト比較スコアリング
- [x] **AI Coach Service**: OpenAI API (gpt-4o-mini) 連携、フィードバックメッセージ生成
- [x] Hive CE CRUD repositories + Riverpod providers (manual, not codegen)

> **変更点:**
> - just_audio（お手本再生）→ flutter_tts（TTS でお手本読み上げ）に変更
> - Claude API → OpenAI API (gpt-4o-mini) に変更
> - Google Cloud Speech-to-Text → OpenAI Whisper API に変更
> - API キーは `--dart-define=OPENAI_API_KEY=xxx` でビルド時注入
> - Riverpod codegen → manual providers に変更

#### Phase C — Polish & Release (Week 6–8) ✅ 完了

- [x] Hero transition (Home → Lesson, Library → Lesson)
- [x] CircularScoreIndicator 0→score アニメーション (easeOutCubic, 800ms)
- [x] 波形プレースホルダーアニメーション (AnimationController + sin wave)
- [x] RecordButton AnimatedContainer (Primary→Error, size change)
- [x] ダークモード対応・検証
- [x] ストリーク計算ロジック（日付ベース比較、同日/翌日/リセット）
- [x] Error handling（ErrorView ウィジェット、SnackBar エラー表示）
- [x] Widget tests 22件（Home, Library, Progress, Navigation, ScoreUtils, Streak）
- [x] `flutter analyze` zero issues
- [x] iOS シミュレータビルド確認
- [x] シミュレーター録音フォールバック（tryStartRecording）
- [x] iOS Info.plist マイクロフォン/音声認識パーミッション設定
- [x] record パッケージ ^6.2.0 アップグレード（iOS ビルド修正）
- [x] 未使用ファイル削除 (db_service.dart, ai_coach_card.dart, stat_tile.dart)

#### Phase D — AI 統合 & UX 強化 ✅ 完了

- [x] OpenAI Whisper API による実音声認識（録音 → 文字起こし → テキスト比較）
- [x] フィードバック画面にテキスト比較表示（お手本 vs ユーザー発話）
- [x] フィードバック画面で録音音声の再生機能
- [x] レッスン画面に過去の成績バナー（前回スコア/最高スコア/練習回数）
- [x] レッスン画面に過去成績の詳細ボトムシート
- [x] ライブラリ画面にレッスンごとの最新スコアバッジ表示
- [x] TTS 速度範囲を iOS 向けに最適化（0.25〜0.6 = UI 表示 0.5x〜1.2x）
- [x] WPM（Words Per Minute）表示
- [x] FeedbackModel に userTranscript / modelTranscript / userAudioPath フィールド追加
- [x] FeedbackModel シリアライズバグ修正（problemWords toJson）

### Release Checklist

#### iOS

- [x] Build succeeds via Runner.xcworkspace
- [ ] App icon (1024×1024 PNG) configured
- [ ] Splash screen configured
- [x] Info.plist permissions: `NSMicrophoneUsageDescription`, `NSSpeechRecognitionUsageDescription`
- [ ] Privacy policy URL ready (App Store required)

#### Android

- [ ] versionCode and versionName set in app/build.gradle
- [ ] Adaptive app icon configured
- [ ] AndroidManifest.xml permissions: `RECORD_AUDIO`, `INTERNET`
- [ ] Release keystore created and signing configured

#### Both Platforms

- [x] `flutter analyze` zero issues
- [x] `flutter test` all passing (22 tests)
- [ ] No memory leaks in Flutter DevTools
- [x] Dark mode rendering verified
- [ ] Tested on iOS 16+ and Android API 23+
- [ ] App Store / Google Play メタデータ準備（スクリーンショット 5枚、説明文）

### Performance Targets

| Metric | Target | Tool |
|--------|--------|------|
| Cold start | < 2.5s | `flutter run --profile` |
| Memory (normal) | < 80MB | Flutter DevTools |
| Memory (録音中) | < 120MB | Flutter DevTools |
| Frame rate | 60fps | PerformanceOverlay |
| Build size iOS | < 30MB | Xcode Organizer |
| Build size Android | < 20MB | `flutter build apk --analyze-size` |
| 音声分析レイテンシ | < 3s | Custom timer |
