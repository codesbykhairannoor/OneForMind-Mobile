import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/api/api_provider.dart';

part 'jobs_api.g.dart';

@riverpod
JobsApi jobsApi(JobsApiRef ref) {
  return JobsApi(ref.watch(dioProvider));
}

class JobsApi {
  final Dio _dio;

  JobsApi(this._dio);

  Future<Response> getJobs({int page = 1}) async {
    return _dio.get('/jobs', queryParameters: {'page': page});
  }

  Future<Response> getJobStats() async {
    return _dio.get('/jobs/stats');
  }

  Future<Response> createJob(Map<String, dynamic> data) async {
    return _dio.post('/jobs', data: data);
  }

  Future<Response> updateJob(int id, Map<String, dynamic> data) async {
    return _dio.patch('/jobs/$id', data: data);
  }

  Future<Response> deleteJob(int id) async {
    return _dio.delete('/jobs/$id');
  }

  Future<Response> getJobTitles() async {
    return _dio.get('/jobs/titles');
  }
}
