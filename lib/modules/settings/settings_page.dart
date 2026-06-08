import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/modules/settings/settings_controller.dart';

class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final user = watch(settingsControllerProvider).state;
    final settingsController = watch(settingsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user.name}'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(labelText: 'New Name'),
              onChanged: (value) => settingsController.updateUserName(value),
            ),
            SizedBox(height: 16),
            Text('Email: ${user.email}'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(labelText: 'New Email'),
              onChanged: (value) => settingsController.updateEmail(value),
            ),
            SizedBox(height: 16),
            Text('Password:'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(labelText: 'Current Password'),
              obscureText: true,
              onChanged: (value) => settingsController.updatePassword(value, ''),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
              onChanged: (value) => settingsController.updatePassword('', value),
            ),
            SizedBox(height: 16),
            Text('Notification Preferences:'),
            SizedBox(height: 8),
            ...user.notificationPreferences.entries.map((entry) {
              return CheckboxListTile(
                title: Text(entry.key),
                value: entry.value,
                onChanged: (bool? value) {
                  final newPreferences = Map<String, bool>.from(user.notificationPreferences);
                  newPreferences[entry.key] = value ?? false;
                  settingsController.updateNotificationPreferences(newPreferences);
                },
              );
            }).toList(),
            SizedBox(height: 16),
            Text('Time Zone: ${user.timezone}'),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: user.timezone,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  settingsController.updateTimeZone(newValue);
                }
              },
              items: <String>['UTC', 'EST', 'PST'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
