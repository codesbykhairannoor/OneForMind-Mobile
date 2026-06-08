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

  Future<String> sendMessage(String message, {String? action, String? sessionId}) async {
    try {
      final response = await _dio.post('/coach/chat', data: {
        'message': message,
        if (action != null) 'action': action,
        if (sessionId != null) 'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return response.data['reply'] ?? response.data['message'] ?? 'No response from AI.';
      } else {
        throw Exception('Failed to get response from AI Coach. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging purposes
      print('Error: Failed to get response from AI Coach. Error: $e');
      return 'Error: Failed to get response from AI Coach. Please try again.';
    }
  }

  Future<String> triggerAction(String action, {Map<String, dynamic>? payload, String? sessionId}) async {
    try {
      final response = await _dio.post('/coach/$action', data: {
        ...payload ?? {},
        if (sessionId != null) 'session_id': sessionId,
      });

      if (response.statusCode == 200) {
        return response.data['reply'] ?? response.data['message'] ?? 'Action completed successfully.';
      } else {
        throw Exception('Failed to trigger action. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging purposes
      print('Error: Failed to trigger action. Error: $e');
      return 'Error: Failed to trigger action. Please try again.';
    }
  }
}

final aiSessionProvider = StateProvider<String?>((ref) => null);

final aiLoadingProvider = StateProvider<bool>((ref) => false);

final aiCoachControllerProvider = Provider<AiCoachController>((ref) {
  final aiCoachService = ref.watch(aiCoachProvider);
  final aiSession = ref.watch(aiSessionProvider);
  final aiLoading = ref.watch(aiLoadingProvider.notifier);

  return AiCoachController(aiCoachService, aiSession, aiLoading);
});

class AiCoachController {
  final AiCoachService _aiCoachService;
  final String? _sessionId;
  final StateController<bool> _loadingController;

  AiCoachController(this._aiCoachService, this._sessionId, this._loadingController);

  Future<void> sendMessage(String message) async {
    _loadingController.state = true;
    try {
      final response = await _aiCoachService.sendMessage(message, sessionId: _sessionId);
      ref.read(chatMessagesProvider.notifier).addMessage(response, isUser: false);
    } catch (e) {
      ref.read(chatMessagesProvider.notifier).addMessage('Error: Failed to get response from AI Coach. Please try again.', isUser: false);
    } finally {
      _loadingController.state = false;
    }
  }

  Future<void> triggerAction(String action, {Map<String, dynamic>? payload}) async {
    _loadingController.state = true;
    try {
      final response = await _aiCoachService.triggerAction(action, payload: payload, sessionId: _sessionId);
      ref.read(chatMessagesProvider.notifier).addMessage(response, isUser: false);
    } catch (e) {
      ref.read(chatMessagesProvider.notifier).addMessage('Error: Failed to trigger action. Please try again.', isUser: false);
    } finally {
      _loadingController.state = false;
    }
  }
}
