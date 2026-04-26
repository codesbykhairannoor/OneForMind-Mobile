import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_api.dart';
import '../../../core/storage/secure_storage.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(authApiProvider).register(
            name: name,
            email: email,
            password: password,
            passwordConfirmation: password,
          );

      if (response.data['status'] == 'success') {
        final token = response.data['data']['token'];
        if (token != null) {
          await ref.read(secureStorageProvider).saveToken(token);
        }
      } else {
        throw response.data['message'] ?? 'Registration failed';
      }
    });
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(authApiProvider).login(
            email: email,
            password: password,
            deviceName: 'mobile_app',
          );

      if (response.data['status'] == 'success') {
        final token = response.data['data']['token'];
        if (token != null) {
          await ref.read(secureStorageProvider).saveToken(token);
        }
      } else {
        throw response.data['message'] ?? 'Login failed';
      }
    });
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authApiProvider).logout();
      await ref.read(secureStorageProvider).deleteToken();
    });
  }
}
