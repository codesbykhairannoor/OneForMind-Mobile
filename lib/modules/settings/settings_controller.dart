import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/models/user.dart';
import 'package:oneformind/services/user_service.dart';

class SettingsController extends StateNotifier<User> {
  final UserService _userService;

  SettingsController(this._userService) : super(User.initial());

  Future<void> loadUserSettings(String userId) async {
    final user = await _userService.getUserById(userId);
    state = user;
  }

  Future<void> updateUserName(String newName) async {
    final updatedUser = state.copyWith(name: newName);
    await _userService.updateUser(updatedUser);
    state = updatedUser;
  }

  Future<void> updateEmail(String newEmail) async {
    final updatedUser = state.copyWith(email: newEmail);
    await _userService.updateUser(updatedUser);
    state = updatedUser;
  }

  Future<void> updatePassword(String currentPassword, String newPassword) async {
    if (state.password == currentPassword) {
      final updatedUser = state.copyWith(password: newPassword);
      await _userService.updateUser(updatedUser);
      state = updatedUser;
    } else {
      throw Exception('Current password is incorrect.');
    }
  }

  Future<void> updateNotificationPreferences(Map<String, bool> preferences) async {
    final updatedUser = state.copyWith(notificationPreferences: preferences);
    await _userService.updateUser(updatedUser);
    state = updatedUser;
  }

  Future<void> updateTimeZone(String newTimeZone) async {
    final updatedUser = state.copyWith(timezone: newTimeZone);
    await _userService.updateUser(updatedUser);
    state = updatedUser;
  }
}

final settingsControllerProvider = StateNotifierProvider<SettingsController, User>((ref) {
  final userService = ref.watch(userServiceProvider);
  return SettingsController(userService);
});
