import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/ai_coach/ai_coach_repository.dart';

class AiCoachMessage {
  final String text;
  final String sender;

  AiCoachMessage({required this.text, required this.sender});
}

class AiCoachState {
  final List<AiCoachMessage> messages;
  final TextEditingController messageController;

  AiCoachState({this.messages = const [], this.messageController = const TextEditingController()});
}

class AiCoachController extends StateNotifier<AiCoachState> {
  final AiCoachRepository _repository;

  AiCoachController(this._repository) : super(AiCoachState());

  void sendMessage() {
    final messageText = state.messageController.text;
    if (messageText.isNotEmpty) {
      state.messageController.clear();
      state.messages.add(AiCoachMessage(text: messageText, sender: 'user'));
      _fetchResponse(messageText);
    }
  }

  Future<void> _fetchResponse(String message) async {
    final response = await _repository.getResponse(message);
    state = state.copyWith(messages: [...state.messages, AiCoachMessage(text: response, sender: 'ai')]);
  }
}

final aiCoachControllerProvider = StateNotifierProvider<AiCoachController, AiCoachState>((ref) {
  final repository = ref.watch(aiCoachRepositoryProvider);
  return AiCoachController(repository);
});
