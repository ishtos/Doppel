import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/services/notification_service.dart';
import '../../../../shared/services/stable_id.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);

class SettingsState {
  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.ttsSpeed = 0.5,
    this.hasCompletedOnboarding = false,
    this.dailyGoal = 3,
    this.isReminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.isPremium = false,
    this.quotaDate = '',
    this.quotaLessonId,
    this.cloudAnalysisConsent = false,
    this.appAccountToken = '',
  });

  final ThemeMode themeMode;
  final double ttsSpeed;
  final bool hasCompletedOnboarding;
  final int dailyGoal;
  final bool isReminderEnabled;
  final int reminderHour;
  final int reminderMinute;

  /// Freemium: premium users have no daily lesson limit.
  final bool isPremium;

  /// yyyy-MM-dd of the day the free lesson quota was last consumed.
  final String quotaDate;

  /// The single free lesson practiced on [quotaDate] (re-entry allowed).
  final String? quotaLessonId;

  /// Opt-in consent for cloud analysis. When false (the default) the app never
  /// sends audio or data to OpenAI (Whisper transcription + AI coach) and uses
  /// local/simulated results only. Toggled explicitly by the user in settings.
  final bool cloudAnalysisConsent;

  /// Stable per-install id (UUID) linking this device to its server-side IAP
  /// entitlement. Generated once and persisted.
  final String appAccountToken;

  String get reminderTimeLabel =>
      '${reminderHour.toString().padLeft(2, '0')}:${reminderMinute.toString().padLeft(2, '0')}';

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? ttsSpeed,
    bool? hasCompletedOnboarding,
    int? dailyGoal,
    bool? isReminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? isPremium,
    String? quotaDate,
    String? quotaLessonId,
    bool? cloudAnalysisConsent,
    String? appAccountToken,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isPremium: isPremium ?? this.isPremium,
      quotaDate: quotaDate ?? this.quotaDate,
      quotaLessonId: quotaLessonId ?? this.quotaLessonId,
      cloudAnalysisConsent: cloudAnalysisConsent ?? this.cloudAnalysisConsent,
      appAccountToken: appAccountToken ?? this.appAccountToken,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  static const _themeModeKey = 'theme_mode';
  static const _ttsSpeedKey = 'tts_speed';
  static const _onboardingCompletedKey = 'onboarding_completed';
  static const _dailyGoalKey = 'daily_goal';
  static const _reminderEnabledKey = 'reminder_enabled';
  static const _reminderHourKey = 'reminder_hour';
  static const _reminderMinuteKey = 'reminder_minute';
  static const _isPremiumKey = 'is_premium';
  static const _quotaDateKey = 'quota_date';
  static const _quotaLessonIdKey = 'quota_lesson_id';
  static const _cloudConsentKey = 'cloud_analysis_consent';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    final ttsSpeed = prefs.getDouble(_ttsSpeedKey);
    final onboardingCompleted =
        prefs.getBool(_onboardingCompletedKey) ?? false;
    final dailyGoal = prefs.getInt(_dailyGoalKey);
    final reminderEnabled = prefs.getBool(_reminderEnabledKey) ?? false;
    final reminderHour = prefs.getInt(_reminderHourKey) ?? 20;
    final reminderMinute = prefs.getInt(_reminderMinuteKey) ?? 0;
    final isPremium = prefs.getBool(_isPremiumKey) ?? false;
    final quotaDate = prefs.getString(_quotaDateKey) ?? '';
    final quotaLessonId = prefs.getString(_quotaLessonIdKey);
    final cloudConsent = prefs.getBool(_cloudConsentKey) ?? false;

    // Set state immediately (including the onboarding flag the router depends
    // on) using whatever token prefs already holds, so a slow Keychain read can
    // never delay first render.
    state = SettingsState(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex]
          : ThemeMode.system,
      ttsSpeed: ttsSpeed ?? 0.5,
      hasCompletedOnboarding: onboardingCompleted,
      dailyGoal: dailyGoal ?? 3,
      isReminderEnabled: reminderEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      isPremium: isPremium,
      quotaDate: quotaDate,
      quotaLessonId: quotaLessonId,
      cloudAnalysisConsent: cloudConsent,
      appAccountToken: prefs.getString(StableId.key) ?? '',
    );

    // Resolve the stable, Keychain-backed per-install id (survives an iOS
    // reinstall) without blocking initial load.
    final appAccountToken = await StableId().resolve(prefs);
    if (appAccountToken != state.appAccountToken) {
      state = state.copyWith(appAccountToken: appAccountToken);
    }
  }

  // ── Daily lesson quota (freemium: 1 lesson/day for free) ──

  static const int freeLessonsPerDay = 1;

  static String todayString([DateTime? now]) {
    final d = now ?? DateTime.now();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  /// Pure quota decision (unit-testable, no clock/storage dependency).
  static bool computeCanAccess({
    required bool isPremium,
    required String quotaDate,
    required String? quotaLessonId,
    required String today,
    required String lessonId,
  }) {
    if (isPremium) return true;
    if (quotaDate != today) return true; // new day → free quota available
    return quotaLessonId == lessonId; // same lesson may be re-entered
  }

  /// Whether [lessonId] can be practiced now under the current quota.
  bool canAccessLesson(String lessonId, {DateTime? now}) {
    return computeCanAccess(
      isPremium: state.isPremium,
      quotaDate: state.quotaDate,
      quotaLessonId: state.quotaLessonId,
      today: todayString(now),
      lessonId: lessonId,
    );
  }

  /// Whether the free daily lesson has already been used (for UI display).
  bool hasUsedFreeLessonToday({DateTime? now}) {
    if (state.isPremium) return false;
    return state.quotaDate == todayString(now) && state.quotaLessonId != null;
  }

  /// Record that [lessonId] is the free lesson used today. Idempotent for the
  /// same lesson; a no-op for premium users.
  Future<void> registerLessonAccess(String lessonId, {DateTime? now}) async {
    if (state.isPremium) return;
    final today = todayString(now);
    if (state.quotaDate != today) {
      state = state.copyWith(quotaDate: today, quotaLessonId: lessonId);
    } else if (state.quotaLessonId == null) {
      state = state.copyWith(quotaLessonId: lessonId);
    } else {
      return; // already set for today
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quotaDateKey, state.quotaDate);
    await prefs.setString(_quotaLessonIdKey, state.quotaLessonId!);
  }

  /// Placeholder for real IAP (StoreKit / RevenueCat). Toggles premium locally.
  Future<void> setPremium(bool value) async {
    state = state.copyWith(isPremium: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumKey, value);
  }

  /// Set the cloud-analysis consent (opt-in for sending audio/data to OpenAI).
  Future<void> setCloudAnalysisConsent(bool value) async {
    state = state.copyWith(cloudAnalysisConsent: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_cloudConsentKey, value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> setTtsSpeed(double speed) async {
    state = state.copyWith(ttsSpeed: speed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_ttsSpeedKey, speed);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(hasCompletedOnboarding: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  Future<void> setDailyGoal(int goal) async {
    state = state.copyWith(dailyGoal: goal);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dailyGoalKey, goal);
  }

  Future<void> setReminderEnabled(bool enabled) async {
    state = state.copyWith(isReminderEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderEnabledKey, enabled);

    final notificationService = NotificationService.instance;
    if (enabled) {
      final granted = await notificationService.requestPermission();
      if (!granted) {
        // Permission denied — revert the toggle
        state = state.copyWith(isReminderEnabled: false);
        await prefs.setBool(_reminderEnabledKey, false);
        return;
      }
      await notificationService.scheduleDailyReminder(
        hour: state.reminderHour,
        minute: state.reminderMinute,
      );
    } else {
      await notificationService.cancelAll();
    }
  }

  Future<void> setReminderTime(int hour, int minute) async {
    state = state.copyWith(reminderHour: hour, reminderMinute: minute);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_reminderHourKey, hour);
    await prefs.setInt(_reminderMinuteKey, minute);

    // Reschedule if reminder is currently enabled
    if (state.isReminderEnabled) {
      await NotificationService.instance.scheduleDailyReminder(
        hour: hour,
        minute: minute,
      );
    }
  }
}
