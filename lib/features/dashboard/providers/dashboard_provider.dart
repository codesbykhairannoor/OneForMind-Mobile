import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    baseUrl: 'https://api.example.com/api/v1', // TODO: Replace with your actual API base URL
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ));
  
  // TODO: Add interceptor for Bearer token here
  // dio.interceptors.add(InterceptorsWrapper(
  //   onRequest: (options, handler) {
  //     // options.headers['Authorization'] = 'Bearer $token';
  //     return handler.next(options);
  //   },
  // ));
});

final financeStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/finance');
  return response.data as Map<String, dynamic>;
});

final habitStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/habits');
  // Laravel might return { data: [...] } or just the array depending on the controller
  return response.data is List ? {'habits': response.data} : (response.data as Map<String, dynamic>);
});

final plannerTasksProvider = FutureProvider<List<dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/planner');
  return response.data is List ? response.data : (response.data['data'] as List<dynamic>? ?? []);
});

final goalStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/goals/stats');
  return response.data as Map<String, dynamic>;
});
