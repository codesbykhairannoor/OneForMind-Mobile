class SettingsModel {
  final String theme;
  final bool notificationsEnabled;
  final String language;
  final String currency;
  final bool privacyEnabled;

  const SettingsModel({
    required this.theme,
    required this.notificationsEnabled,
    required this.language,
    required this.currency,
    required this.privacyEnabled,
  });

  SettingsModel.initial()
      : this(
          theme: 'light',
          notificationsEnabled: true,
          language: 'en',
          currency: 'USD',
          privacyEnabled: true,
        );

  SettingsModel copyWith({
    String? theme,
    bool? notificationsEnabled,
    String? language,
    String? currency,
    bool? privacyEnabled,
  }) {
    return SettingsModel(
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      privacyEnabled: privacyEnabled ?? this.privacyEnabled,
    );
  }
}
