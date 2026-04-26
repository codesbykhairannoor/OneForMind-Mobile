import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'profile_api.g.dart';

@riverpod
ProfileApi profileApi(ProfileApiRef ref) {
  return ProfileApi(ref.watch(dioProvider));
}

class ProfileApi {
  final Dio _dio;

  ProfileApi(this._dio);

  Future<Response> getProfile() async {
    return _dio.get('/profile');
  }

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    return _dio.put('/profile', data: data);
  }

  Future<Response> updatePassword(String currentPassword, String newPassword, String confirmation) async {
    return _dio.put(
      '/profile/password',
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': confirmation,
      },
    );
  }
}
