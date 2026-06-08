import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/models/settings_model.dart';

class SettingsController extends StateNotifier<SettingsModel> {
  SettingsController() : super(SettingsModel.initial());

  void updateTheme(String theme) {
    state = state.copyWith(theme: theme);
  }

  void updateNotificationPreferences(bool notificationsEnabled) {
    state = state.copyWith(notificationsEnabled: notificationsEnabled);
  }

  void updateLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void updatePrivacySettings(bool privacyEnabled) {
    state = state.copyWith(privacyEnabled: privacyEnabled);
  }

  void resetSettings() {
    state = SettingsModel.initial();
  }
}

final settingsProvider = StateNotifierProvider<SettingsController, SettingsModel>((ref) {
  return SettingsController();
});
