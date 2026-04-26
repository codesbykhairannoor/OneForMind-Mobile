import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'habits_api.g.dart';

@riverpod
HabitsApi habitsApi(HabitsApiRef ref) {
  return HabitsApi(ref.watch(dioProvider));
}

class HabitsApi {
  final Dio _dio;

  HabitsApi(this._dio);

  Future<Response> getHabits({required String date}) async {
    return _dio.get('/habits', queryParameters: {'date': date});
  }

  Future<Response> logHabit({required int habitId}) async {
    return _dio.post('/habits/$habitId/log');
  }
}
