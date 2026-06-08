import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;

class AiCoachRepository {
  final http.Client _client;

  AiCoachRepository(this._client);

  Future<Map<String, dynamic>> getInsight(String userId) async {
    final response = await _client.get(
      Uri.parse('https://api.example.com/ai-coach/insight/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load insight: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> chat(String userId, String message) async {
    final response = await _client.post(
      Uri.parse('https://api.example.com/ai-coach/chat/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send chat: ${response.statusCode}');
    }
  }

  Future<void> destroySession(String userId, String sessionId) async {
    final response = await _client.delete(
      Uri.parse('https://api.example.com/ai-coach/session/$userId/$sessionId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to destroy session: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> suggestStack(String userId) async {
    final response = await _client.get(
      Uri.parse('https://api.example.com/ai-coach/habit-stack/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to suggest habit stack: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> adaptToMood(String userId, String mood) async {
    final response = await _client.post(
      Uri.parse('https://api.example.com/ai-coach/habit-mood/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mood': mood}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to adapt to mood: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> auditFriction(String userId) async {
    final response = await _client.get(
      Uri.parse('https://api.example.com/ai-coach/habit-audit/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to audit friction: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> auditStagnation(String userId) async {
    final response = await _client.get(
      Uri.parse('https://api.example.com/ai-coach/habit-stagnation/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to audit stagnation: ${response.statusCode}');
    }
  }
}

final aiCoachRepositoryProvider = Provider<AiCoachRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  return AiCoachRepository(client);
});

final httpClientProvider = Provider<http.Client>((ref) => http.Client());
