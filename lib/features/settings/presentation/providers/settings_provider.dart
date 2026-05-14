import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/services/notification_service.dart';

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
    this.isInitialized = false,
  });

  final ThemeMode themeMode;
  final double ttsSpeed;
  final bool hasCompletedOnboarding;
  final int dailyGoal;
  final bool isReminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final bool isInitialized;

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
    bool? isInitialized,
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
      isInitialized: isInitialized ?? this.isInitialized,
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
      isInitialized: true,
    );
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
