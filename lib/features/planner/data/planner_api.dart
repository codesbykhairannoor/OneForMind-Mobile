import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'planner_api.g.dart';

@riverpod
PlannerApi plannerApi(PlannerApiRef ref) {
  return PlannerApi(ref.watch(dioProvider));
}

class PlannerApi {
  final Dio _dio;

  PlannerApi(this._dio);

  Future<Response> getTasks({required String date}) async {
    return _dio.get('/planner', queryParameters: {'date': date});
  }

  Future<Response> createTask({
    required String title,
    required String date,
    required String startTime,
    required String priority,
  }) async {
    return _dio.post(
      '/planner/task',
      data: {
        'title': title,
        'date': date,
        'start_time': startTime,
        'priority': priority,
      },
    );
  }
}
