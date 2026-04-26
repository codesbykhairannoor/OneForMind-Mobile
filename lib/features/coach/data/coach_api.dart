import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'coach_api.g.dart';

@riverpod
CoachApi coachApi(CoachApiRef ref) {
  return CoachApi(ref.watch(dioProvider));
}

class CoachApi {
  final Dio _dio;

  CoachApi(this._dio);

  Future<Response> sendMessage(String message) async {
    return _dio.post(
      '/coach',
      data: {'message': message},
    );
  }

  Future<Response> getChatHistory() async {
    return _dio.get('/coach/history');
  }
}
