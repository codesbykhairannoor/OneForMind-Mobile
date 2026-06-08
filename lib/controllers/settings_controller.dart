import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool isDarkTheme;
  final String language;
  final bool isNotificationsEnabled;

  SettingsState({
    required this.isDarkTheme,
    required this.language,
    required this.isNotificationsEnabled,
  });

  SettingsState copyWith({
    bool? isDarkTheme,
    String? language,
    bool? isNotificationsEnabled,
  }) {
    return SettingsState(
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      language: language ?? this.language,
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsController, SettingsState>(
  (ref) => SettingsController(),
);

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController() : super(SettingsState(
    isDarkTheme: false,
    language: 'en',
    isNotificationsEnabled: true,
  ));

  void toggleDarkTheme() {
    state = state.copyWith(isDarkTheme: !state.isDarkTheme);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleNotifications() {
    state = state.copyWith(isNotificationsEnabled: !state.isNotificationsEnabled);
  }
}
