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
- [x] Phase M: Release準備 - Splash Screen & Android リリースビルド構成
- [ ] Release準備 (アイコンデザイン最終化、ストア申請) <- **Next**

## 4. Feature Backlog (Prioritized)
1. ~~App icon & Splash screen 設定~~ → Phase M で基盤構成完了（プレースホルダーアイコン置き換え待ち）
2. ~~Android リリース署名設定~~ → Phase M で構成完了（key.properties 作成待ち）
3. ~~Privacy policy URL 作成~~ → About画面内にプライバシーポリシー表示を実装済み
4. App Store / Google Play メタデータ準備
5. App icon デザイン最終化（1024x1024 PNG をデザイナーに依頼）
6. Flutter DevTools でメモリリーク検証
7. iOS 16+ / Android API 23+ 実機テスト
8. ~~ローカル通知によるリマインダー機能~~ → Phase L で実装済み
9. 追加レッスンコンテンツ拡充

## 5. Technical Debt & Issues
- `text_diff.dart` の LCS アルゴリズムはO(n*m)であり、非常に長いテキストではパフォーマンス懸念あり
- シミュレーターでは録音が不可のためフォールバック処理で分析をスキップしている（実機テストが必要）
- Widget tests は 22件だが、Feedback / Lesson 画面のテストが不足

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

## 8. 本日完了したタスク (2026-04-20)
- Release準備: Splash Screen & Android リリースビルド構成 (Phase M)
  - `pubspec.yaml`: flutter_native_splash ^2.4.4, flutter_launcher_icons ^0.14.3 追加 & 設定
  - Android splash screen: Deep Indigo (#1A237E) 背景色設定（ライト/ダーク両対応）
  - Android 12+ (API 31+): windowSplashScreenBackground & アイコン設定
  - iOS LaunchScreen.storyboard: 背景色を Deep Indigo に変更
  - `build.gradle.kts`: リリース署名構成（key.properties 条件読み込み）、R8 minify/shrink 有効化
  - `proguard-rules.pro`: Flutter, Hive, ExoPlayer, record, flutter_tts, notifications 向けルール
  - `key.properties.example`: リリース署名テンプレート
  - `assets/icon/`: プレースホルダーアイコン (1024x1024) 作成

## 9. Handover Note for Next Run
Phase A-M まで完了。スプラッシュ画面とAndroidリリースビルドの基盤構成が整った。
次のステップ:
- `assets/icon/app_icon.png` をデザイナー作成のアイコンに置き換え
- `dart run flutter_launcher_icons` でプラットフォーム別アイコン生成
- `dart run flutter_native_splash:create` でスプラッシュ画面生成
- `key.properties` を作成してリリース署名を有効化
- `flutter build apk --release` でリリースビルド確認
- App Store / Google Play メタデータ準備
