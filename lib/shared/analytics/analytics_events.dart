/// Canonical product event names. Keep these in sync with the funnel/retention
/// dashboard so instrumentation and analysis never drift.
///
/// Funnel of interest: onboarding_completed -> lesson_started ->
/// first_score_shown (the "aha") -> lesson_completed -> day2_return.
class AnalyticsEvents {
  AnalyticsEvents._();

  static const onboardingCompleted = 'onboarding_completed';
  static const lessonStarted = 'lesson_started';
  static const recordingCompleted = 'recording_completed';

  /// First score shown to the user — the activation "aha" moment.
  static const firstScoreShown = 'first_score_shown';
  static const feedbackViewed = 'feedback_viewed';
  static const coachRetry = 'coach_retry';
  static const lessonCompleted = 'lesson_completed';

  /// User returns on a later calendar day than their previous practice.
  static const day2Return = 'day2_return';

  static const paywallViewed = 'paywall_viewed';
  static const purchaseCompleted = 'purchase_completed';
}
