import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  final String _baseUrl = 'https://api.example.com/ai';

  Future<String> getAiResponse(String message) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else {
      throw Exception('Failed to get AI response');
    }
  }
}
