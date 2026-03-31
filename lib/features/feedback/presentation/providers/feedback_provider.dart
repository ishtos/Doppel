import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/db_providers.dart';
import '../../../../shared/services/ai_coach_service.dart';
import '../../data/models/feedback_model.dart';

/// Single feedback by ID.
final feedbackByIdProvider =
    Provider.family<FeedbackModel?, String>((ref, id) {
  return ref.watch(feedbackRepositoryProvider).findById(id);
});

/// Recent feedbacks list.
final recentFeedbacksProvider = Provider<List<FeedbackModel>>((ref) {
  return ref.watch(feedbackRepositoryProvider).findRecent(limit: 10);
});

/// Feedbacks for a specific lesson.
final feedbacksByLessonProvider =
    Provider.family<List<FeedbackModel>, String>((ref, lessonId) {
  return ref.watch(feedbackRepositoryProvider).findByLessonId(lessonId);
});

// ── AI Coach message regeneration ──

enum CoachRegenerateStatus { idle, loading, success, error }

class CoachRegenerateState {
  const CoachRegenerateState({
    this.status = CoachRegenerateStatus.idle,
    this.message,
    this.errorMessage,
  });

  final CoachRegenerateStatus status;
  final String? message;
  final String? errorMessage;
}

/// Manages AI Coach message regeneration for a given feedback.
final coachRegenerateProvider = StateNotifierProvider.autoDispose
    .family<CoachMessageRegenerator, CoachRegenerateState, String>(
  (ref, feedbackId) => CoachMessageRegenerator(ref, feedbackId),
);

class CoachMessageRegenerator extends StateNotifier<CoachRegenerateState> {
  CoachMessageRegenerator(this._ref, this._feedbackId)
      : super(const CoachRegenerateState());

  final Ref _ref;
  final String _feedbackId;

  Future<void> regenerate() async {
    final feedback = _ref.read(feedbackRepositoryProvider).findById(_feedbackId);
    if (feedback == null) return;

    state = const CoachRegenerateState(status: CoachRegenerateStatus.loading);

    try {
      final aiCoach = _ref.read(aiCoachServiceProvider);
      final newMessage = await aiCoach.regenerateFeedback(
        pronunciationScore: feedback.pronunciationScore,
        rhythmScore: feedback.rhythmScore,
        intonationScore: feedback.intonationScore,
        problemWords: feedback.problemWords.map((pw) => pw.word).toList(),
      );

      // Update feedback in DB
      final updated = feedback.copyWith(coachMessage: newMessage);
      await _ref.read(feedbackRepositoryProvider).save(updated);

      // Invalidate the feedback provider to refresh UI
      _ref.invalidate(feedbackByIdProvider(_feedbackId));

      state = CoachRegenerateState(
        status: CoachRegenerateStatus.success,
        message: newMessage,
      );
    } catch (e) {
      state = CoachRegenerateState(
        status: CoachRegenerateStatus.error,
        errorMessage: 'AIコーチへの接続に失敗しました。再度お試しください。',
      );
    }
  }
}
