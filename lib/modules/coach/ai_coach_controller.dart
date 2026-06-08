import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/services/ai_service.dart';

final aiCoachControllerProvider = StateNotifierProvider<AIChatController, AIChatState>((ref) {
  return AIChatController(ref: ref);
});

class AIChatState {
  final List<AIChatMessage> messages;
  final String? error;

  AIChatState({this.messages = const [], this.error});

  AIChatState copyWith({List<AIChatMessage>? messages, String? error}) {
    return AIChatState(
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }
}

class AIChatMessage {
  final String text;
  final bool isUser;

  AIChatMessage({required this.text, required this.isUser});
}

class AIChatController extends StateNotifier<AIChatState> {
  final Ref _ref;

  AIChatController({required Ref ref}) : _ref = ref, super(AIChatState());

  Future<void> fetchInsight() async {
    state = state.copyWith(error: null);

    try {
      final insight = await _ref.read(aiService).getInsight();
      state = state.copyWith(messages: [AIChatMessage(text: insight, isUser: false)]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendMessage(String message) async {
    state = state.copyWith(error: null);

    try {
      final response = await _ref.read(aiService).chat(message);
      state = state.copyWith(messages: [...state.messages, AIChatMessage(text: message, isUser: true), AIChatMessage(text: response, isUser: false)]);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> startNewSession() async {
    state = AIChatState();
  }
}
