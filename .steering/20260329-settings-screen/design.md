# 設計書: 設定画面

## 変更コンポーネント
- `lib/features/settings/presentation/providers/settings_provider.dart` (新規)
- `lib/features/settings/presentation/screens/settings_screen.dart` (新規)
- `lib/app/router.dart` (ルート追加)
- `lib/main.dart` (themeMode反映)
- `lib/features/home/presentation/screens/home_screen.dart` (ナビゲーション接続)

## 状態管理
- `SettingsNotifier` (StateNotifier) で設定値を管理
- shared_preferencesで永続化
- themeModeの変更はDoppelAppのbuildで参照

## 設定項目
| 項目 | 型 | デフォルト | 永続化キー |
|------|------|-----------|-----------|
| テーマモード | ThemeMode | system | theme_mode |
| TTS速度 | double | 0.5 | tts_speed |
