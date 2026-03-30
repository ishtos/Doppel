# 設計書: オンボーディング画面

## 実装アプローチ
- Feature-first architecture に従い `lib/features/onboarding/` に配置
- SettingsNotifier に `hasCompletedOnboarding` フラグを追加
- GoRouter の `redirect` で初回判定

## 変更するファイル一覧
1. `lib/features/onboarding/presentation/screens/onboarding_screen.dart` (新規)
2. `lib/features/settings/presentation/providers/settings_provider.dart` (フラグ追加)
3. `lib/app/router.dart` (ルート追加 + redirect)

## データ構造
- SharedPreferences: `onboarding_completed` (bool)

## 影響範囲
- 初回起動フローのみ。既存画面への影響なし
