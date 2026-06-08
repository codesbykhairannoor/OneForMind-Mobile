import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_coach_repository.g.dart';

@Riverpod(keepAlive: true)
AiCoachRepository aiCoachRepository(AiCoachRepositoryRef ref) {
  return AiCoachRepository();
}

class AiCoachRepository {
  final Dio _dio = Dio();

  Future<String> getInsight() async {
    try {
      final response = await _dio.get('https://api.example.com/insight');
      if (response.statusCode == 200) {
        return response.data['insight'];
      } else {
        throw Exception('Failed to load insight');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<List<String>> chat(String message) async {
    try {
      final response = await _dio.post(
        'https://api.example.com/chat',
        data: {'message': message},
      );
      if (response.statusCode == 200) {
        return List<String>.from(response.data['responses']);
      } else {
        throw Exception('Failed to get chat response');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<void> destroySession(String sessionId) async {
    try {
      final response = await _dio.delete(
        'https://api.example.com/session/$sessionId',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to destroy session');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> synergy() async {
    try {
      final response = await _dio.get('https://api.example.com/synergy');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to get synergy data');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> suggestHabitStack() async {
    try {
      final response = await _dio.get('https://api.example.com/habit-stack');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to get habit stack suggestions');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> adaptToMood(String mood) async {
    try {
      final response = await _dio.post(
        'https://api.example.com/habit-mood',
        data: {'mood': mood},
      );
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to adapt to mood');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> auditFriction() async {
    try {
      final response = await _dio.get('https://api.example.com/habit-audit');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to audit friction');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<Map<String, dynamic>> auditStagnation() async {
    try {
      final response = await _dio.get('https://api.example.com/habit-stagnation');
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to audit stagnation');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response?.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
