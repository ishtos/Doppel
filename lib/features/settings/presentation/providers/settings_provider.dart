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
  });

  final ThemeMode themeMode;
  final double ttsSpeed;

  SettingsState copyWith({ThemeMode? themeMode, double? ttsSpeed}) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _load();
  }

  static const _themeModeKey = 'theme_mode';
  static const _ttsSpeedKey = 'tts_speed';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey);
    final ttsSpeed = prefs.getDouble(_ttsSpeedKey);

    state = SettingsState(
      themeMode: themeModeIndex != null
          ? ThemeMode.values[themeModeIndex]
          : ThemeMode.system,
      ttsSpeed: ttsSpeed ?? 0.5,
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
}
