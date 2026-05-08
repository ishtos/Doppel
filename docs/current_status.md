# Project Status: Doppel

## 1. Goal
AIを活用した英語シャドーイングコーチアプリ。TTS によるお手本再生、ユーザー録音、Whisper 音声認識、テキスト比較スコアリング、AI コーチフィードバックを統合し、効率的な発音練習を実現する。

## 2. Technical Stack
- **Framework:** Flutter 3.41+ (Dart ^3.11.0)
- **State Management:** Riverpod (manual providers, not codegen)
- **Navigation:** GoRouter (ShellRoute + 5 screen routes)
- **Database:** Hive CE (ローカルストレージ)
- **Design Pattern:** Feature-first architecture
- **AI/Speech:** OpenAI API (Whisper STT + GPT-5-mini Coach)
- **Audio:** flutter_tts (TTS再生) + record (録音) + just_audio (音声再生)
- **Charts:** fl_chart
- **Data Models:** Freezed + json_serializable
- **Notifications:** flutter_local_notifications + timezone
- **API Key 管理:** `--dart-define=OPENAI_API_KEY=xxx` (ビルド時注入)

## 3. Current Milestones
- [x] Phase A: Foundation (プロジェクト初期設定、ルーティング、DB、テーマ)
- [x] Phase B: Core Features (5画面実装、録音パイプライン、AI連携)
- [x] Phase C: Polish (アニメーション、ダークモード、テスト22件、iOS ビルド)
- [x] Phase D: AI統合 & UX強化 (Whisper STT、テキスト比較、過去成績表示)
- [x] Phase E: UX改善 (録音キャンセル、波形UI統合、レッスン拡張、WPM修正)
- [x] Phase F: 改善ポイント & Diff (ホーム画面に改善ポイント、テキスト比較ハイライト)
- [x] Phase G: オンボーディング画面 (初回起動時の3ページガイド)
- [x] Phase H: AI Coach リトライUI (フィードバック画面でのAIコーチメッセージ再生成)
- [x] Phase I: Release準備 - About画面 & Settings強化
- [x] Phase J: デイリー練習目標 (目標設定 & ホーム画面に進捗表示)
- [x] Phase K: ライブラリ画面強化 (ソート・ブックマークフィルタ・練習回数バッジ) & Home画面お気に入りセクション
- [x] Phase L: ローカル通知リマインダー (毎日の練習リマインダー通知、設定画面からの有効/無効・時刻設定)
- [x] Phase M: テスト拡充 (Feedback/Lesson テスト 22件→55件超、text_diff・Repository・統合テスト)
- [ ] Release準備 (アイコン、スプラッシュ、ストア申請) ← **Next**

## 4. Feature Backlog (Prioritized)
1. App icon (1024x1024 PNG) & Splash screen 設定
2. Android ビルド確認 & リリース署名設定
3. ~~Privacy policy URL 作成~~ → About画面内にプライバシーポリシー表示を実装済み
4. App Store / Google Play メタデータ準備
5. Flutter DevTools でメモリリーク検証
6. iOS 16+ / Android API 23+ 実機テスト
7. ~~ローカル通知によるリマインダー機能~~ → Phase L で実装済み
8. 追加レッスンコンテンツ拡充

## 5. Technical Debt & Issues
- `text_diff.dart` の LCS アルゴリズムはO(n*m)であり、非常に長いテキストではパフォーマンス懸念あり
- シミュレーターでは録音が不可のためフォールバック処理で分析をスキップしている（実機テストが必要）
- ~~Widget tests は 22件だが、Feedback / Lesson 画面のテストが不足~~ → Phase M で 55件超に拡充済み
- 既存 widget_test.dart に SharedPreferences mock 未設定の問題あり → Phase M で修正済み

## 6. Screens & Architecture

| 画面 | ルート | 主な機能 |
|------|--------|----------|
| Onboarding | `/onboarding` | 初回起動ガイド (3ページ) |
| Home | `/home` | 挨拶、デイリー目標進捗、お気に入りレッスン、今日のレッスン、週間統計、改善ポイント、最近の練習 |
| Library | `/library` | カテゴリ/難易度フィルタ、**ソート(4種)、ブックマークフィルタ、練習回数バッジ**、検索、WPMバッジ、スコアバッジ |
| Lesson | `/lesson/:id` | TTS再生、速度調整、録音/キャンセル、テキスト非表示トグル、波形アニメ |
| Feedback | `/feedback/:id` | スコア表示、テキスト比較 (diffハイライト)、録音再生、AIコーチ (リトライ対応) |
| Progress | `/progress` | スコア推移グラフ、弱点分析、統計 |
| Settings | `/settings` | テーマ、TTS速度、デイリー目標設定、**練習リマインダー通知**、データリセット、About・ライセンスへのリンク |
| About | `/about` | バージョン情報、ライセンス一覧、プライバシーポリシー、利用規約 |

## 7. Lesson Content
- **16レッスン** (各約250-320語)
- **カテゴリ:** ニュース、ビジネス、日常会話、TEDスタイル、スポーツ、時事ネタ
- **難易度別 WPM:** 初級 100 / 中級 130 / 上級 150

## 8. Test Coverage
- **総テスト数:** 55件以上
- **test/widget_test.dart:** Home / Library / Progress / Navigation ウィジェットテスト (22件)
- **test/score_utils_test.dart:** ScoreUtils ユニットテスト
- **test/streak_logic_test.dart:** ProgressRepository ストリークロジックテスト
- **test/text_diff_test.dart:** computeWordDiff / buildDiffTextSpan ユニットテスト (16件)
- **test/feedback_repository_test.dart:** FeedbackRepository CRUD テスト (12件)
- **test/lesson_repository_test.dart:** LessonRepository CRUD テスト (14件)
- **test/home_with_feedback_test.dart:** Feedback データ統合表示テスト (7件)

## 9. 本日完了したタスク (2026-05-08)
- テスト拡充 (Phase M)
  - `test/text_diff_test.dart`: computeWordDiff LCS アルゴリズムの16テスト（identical, missing, extra, case insensitive, partial overlap, duplicate words, long texts, swapped words + buildDiffTextSpan テスト）
  - `test/feedback_repository_test.dart`: FeedbackRepository の12テスト（save/find/delete/serialization/problemWords 保存/nullable フィールド保存）
  - `test/lesson_repository_test.dart`: LessonRepository の14テスト（CRUD/search/bookmark/difficulty filter/category filter/serialization）
  - `test/home_with_feedback_test.dart`: ホーム画面でのフィードバック統合テスト7件（最近の練習表示、スコア表示、改善ポイント、週間統計、空状態、デイリー目標）
  - `test/widget_test.dart`: SharedPreferences mock 追加（オンボーディングリダイレクト回避）

## 10. Handover Note for Next Run
Phase A-M まで全て完了。テストカバレッジを 22件 → 55件超に拡充。text_diff アルゴリズム、FeedbackRepository、LessonRepository のユニットテスト、ホーム画面でのフィードバック統合テストを追加。既存 widget_test.dart の SharedPreferences mock 未設定バグも修正。

次は **リリース準備の残り** として以下から着手:
- App icon (1024x1024 PNG) の作成・設定
- Splash screen の設定 (flutter_native_splash)
- Android ビルド確認 (`flutter build apk`) & リリース署名設定
- App Store / Google Play メタデータ準備

**前提:** テスト実行前に `dart run build_runner build --delete-conflicting-outputs` で .freezed.dart / .g.dart を生成すること。
