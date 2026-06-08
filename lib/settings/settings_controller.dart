import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(SettingsState.initial());

  void updateNotificationPreferences(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void updateThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void resetSettings() {
    state = SettingsState.initial();
  }
}

class SettingsState {
  final bool notificationsEnabled;
  final ThemeMode themeMode;
  final String currency;

  SettingsState({
    required this.notificationsEnabled,
    required this.themeMode,
    required this.currency,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    ThemeMode? themeMode,
    String? currency,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
    );
  }

  factory SettingsState.initial() {
    return SettingsState(
      notificationsEnabled: true,
      themeMode: ThemeMode.system,
      currency: 'USD',
    );
  }
}

final settingsControllerProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController();
});
