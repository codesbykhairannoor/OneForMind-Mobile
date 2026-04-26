import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'auth_api.g.dart';

@riverpod
AuthApi authApi(AuthApiRef ref) {
  return AuthApi(ref.watch(dioProvider));
}

class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return _dio.post(
      '/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    return _dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
        'device_name': deviceName,
      },
    );
  }

  Future<Response> logout() async {
    return _dio.post('/logout');
  }

  Future<Response> getUser() async {
    return _dio.get('/user');
  }
}
