import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  });

  final ThemeMode themeMode;
  final double ttsSpeed;
  final bool hasCompletedOnboarding;
  final int dailyGoal;

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? ttsSpeed,
    bool? hasCompletedOnboarding,
    int? dailyGoal,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      dailyGoal: dailyGoal ?? this.dailyGoal,
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

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    final ttsSpeed = prefs.getDouble(_ttsSpeedKey);
    final onboardingCompleted =
        prefs.getBool(_onboardingCompletedKey) ?? false;
    final dailyGoal = prefs.getInt(_dailyGoalKey);

    state = SettingsState(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex]
          : ThemeMode.system,
      ttsSpeed: ttsSpeed ?? 0.5,
      hasCompletedOnboarding: onboardingCompleted,
      dailyGoal: dailyGoal ?? 3,
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
}
