import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oneformind/features/coach/domain/coach_session_model.dart';

class CoachApiService {
  final http.Client client;
  final String baseUrl;
  final String? token;

  CoachApiService({
    required this.client,
    required this.baseUrl,
    this.token,
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  Future<List<CoachSession>> getSessions() async {
    final response = await client.get(
      Uri.parse('$baseUrl/v1/coach'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => CoachSession.fromJson(e)).toList();
    }
    throw Exception('Failed to load sessions: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> sendMessage(String sessionId, String message) async {
    final response = await client.post(
      Uri.parse('$baseUrl/v1/coach/chat'),
      headers: _headers,
      body: jsonEncode({'session_id': sessionId, 'message': message}),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to send message: ${response.statusCode}');
  }

  Future<void> deleteSession(String sessionId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/v1/coach/session/$sessionId'),
      headers: _headers,
    );
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete session: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getSynergy() async {
    final response = await client.post(
      Uri.parse('$baseUrl/v1/coach/synergy'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to get synergy: ${response.statusCode}');
  }
}
