# 設計書: AI Coach リトライUI

## 実装アプローチ
Riverpod の StateNotifierProvider を使い、再生成状態を管理する。
FeedbackModel は変更せず、再生成されたメッセージは StateNotifier 内で管理し、
成功時に FeedbackRepository 経由で DB 更新する。

## 変更するコンポーネント・ファイル一覧
1. `lib/features/feedback/presentation/providers/feedback_provider.dart`
   - `CoachMessageRegenerator` StateNotifier + Provider 追加
2. `lib/features/feedback/presentation/screens/feedback_screen.dart`
   - AI Coach カードを `_AiCoachCard` ウィジェットに分離
   - 再生成ボタン、ローディング、エラー状態の表示

## データ構造
```dart
// 再生成状態
enum CoachRegenerateStatus { idle, loading, success, error }

class CoachRegenerateState {
  final CoachRegenerateStatus status;
  final String? message;
  final String? errorMessage;
}
```

## 影響範囲
- feedback_screen.dart の AI Coach カード部分のみ
- 既存のデータフローには影響しない
