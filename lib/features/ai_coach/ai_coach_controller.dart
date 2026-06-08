import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/core/services/ai_service.dart';
import 'package:oneformind/core/models/message.dart';

final aiCoachControllerProvider = StateNotifierProvider<AiCoachController, AiCoachState>(
  (ref) => AiCoachController(ref.read(aiServiceProvider)),
);

class AiCoachState {
  final TextEditingController messageController;
  final List<Message> messages;

  AiCoachState({
    required this.messageController,
    required this.messages,
  });

  AiCoachState copyWith({
    TextEditingController? messageController,
    List<Message>? messages,
  }) {
    return AiCoachState(
      messageController: messageController ?? this.messageController,
      messages: messages ?? this.messages,
    );
  }
}

class AiCoachController extends StateNotifier<AiCoachState> {
  final AiService _aiService;

  AiCoachController(this._aiService) : super(AiCoachState(
    messageController: TextEditingController(),
    messages: [],
  ));

  void sendMessage() async {
    final messageContent = state.messageController.text.trim();
    if (messageContent.isEmpty) return;

    state.messageController.clear();

    final userMessage = Message(
      content: messageContent,
      sender: 'User',
      timestamp: DateTime.now(),
    );

    state.messages.add(userMessage);
    state = state.copyWith(messages: state.messages);

    final aiResponse = await _aiService.getAiResponse(messageContent);
    final aiMessage = Message(
      content: aiResponse,
      sender: 'AI Coach',
      timestamp: DateTime.now(),
    );

    state.messages.add(aiMessage);
    state = state.copyWith(messages: state.messages);
  }
}
