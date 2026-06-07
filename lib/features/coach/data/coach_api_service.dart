import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/coach_message_model.dart';

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

  Future<List<CoachMessage>> getSessions() async {
    final response = await client.get(
      Uri.parse('$baseUrl/coach'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map((e) => CoachMessage.fromJson(e)).toList();
      }
      if (data is Map && data['messages'] is List) {
        return (data['messages'] as List).map((e) => CoachMessage.fromJson(e)).toList();
      }
      return [];
    }
    throw Exception('Failed to load sessions: ${response.statusCode} - ${response.body}');
  }

  Future<CoachMessage> sendMessage(String message) async {
    final response = await client.post(
      Uri.parse('$baseUrl/coach/chat'),
      headers: _headers,
      body: jsonEncode({'message': message}),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CoachMessage.fromJson(data['message'] ?? data);
    }
    throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
  }

  Future<void> deleteSession(String sessionId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/coach/session/$sessionId'),
      headers: _headers,
    );
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete session: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getSynergy() async {
    final response = await client.post(
      Uri.parse('$baseUrl/coach/synergy'),
      headers: _headers,
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to get synergy: ${response.statusCode} - ${response.body}');
  }
}

final coachApiServiceProvider = Provider<CoachApiService>((ref) {
  return CoachApiService(
    client: http.Client(),
    baseUrl: 'https://api.oneformind.com', 
    token: null, 
  );
});
