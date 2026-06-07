import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  void addMessage(String text, bool isUser) {
    state = [
      ...state,
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
      ),
    ];
  }

  void clearMessages() {
    state = [];
  }
}

final aiCoachProvider = Provider<AiCoachService>((ref) {
  final dio = ref.watch(dioProvider);
  return AiCoachService(dio);
});

class AiCoachService {
  final Dio _dio;

  AiCoachService(this._dio);

  Future<String> sendMessage(String message, {String? action}) async {
    try {
      final response = await _dio.post('/coach/chat', data: {
        'message': message,
        if (action != null) 'action': action,
      });
      return response.data['reply'] ?? 'No response from AI.';
    } catch (e) {
      return 'Error: Failed to get response from AI Coach.';
    }
  }

  Future<String> triggerAction(String action, {Map<String, dynamic>? payload}) async {
    try {
      final response = await _dio.post('/coach/$action', data: payload ?? {});
      return response.data['reply'] ?? 'Action completed.';
    } catch (e) {
      return 'Error: Failed to trigger action.';
    }
  }
}
