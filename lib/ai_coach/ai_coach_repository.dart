import 'dart:convert';
import 'package:http/http.dart' as http;

class AiCoachRepository {
  final String _baseUrl = 'https://api.example.com/ai-coach';

  Future<String> getResponse(String message) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['response'];
    } else {
      throw Exception('Failed to get AI response');
    }
  }
}

final aiCoachRepositoryProvider = Provider<AiCoachRepository>((ref) => AiCoachRepository());
