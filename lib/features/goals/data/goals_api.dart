import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'goals_api.g.dart';

@riverpod
GoalsApi goalsApi(GoalsApiRef ref) {
  return GoalsApi(ref.watch(dioProvider));
}

class GoalsApi {
  final Dio _dio;

  GoalsApi(this._dio);

  Future<Response> getGoals() async {
    return _dio.get('/goals');
  }

  Future<Response> getGoalStats() async {
    return _dio.get('/goals/stats');
  }

  Future<Response> createGoal(Map<String, dynamic> data) async {
    return _dio.post('/goals', data: data);
  }

  Future<Response> getGoalDetails(int id) async {
    return _dio.get('/goals/$id');
  }

  Future<Response> updateGoal(int id, Map<String, dynamic> data) async {
    return _dio.patch('/goals/$id', data: data);
  }

  Future<Response> deleteGoal(int id) async {
    return _dio.delete('/goals/$id');
  }

  // Milestones
  Future<Response> addMilestone(int goalId, Map<String, dynamic> data) async {
    return _dio.post('/goals/$goalId/milestones', data: data);
  }

  Future<Response> updateMilestone(int goalId, int milestoneId, Map<String, dynamic> data) async {
    return _dio.patch('/goals/$goalId/milestones/$milestoneId', data: data);
  }

  Future<Response> toggleMilestone(int goalId, int milestoneId) async {
    return _dio.post('/goals/$goalId/milestones/$milestoneId/toggle');
  }

  Future<Response> deleteMilestone(int goalId, int milestoneId) async {
    return _dio.delete('/goals/$goalId/milestones/$milestoneId');
  }
}
