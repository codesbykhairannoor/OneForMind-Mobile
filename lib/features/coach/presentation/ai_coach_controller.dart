import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/coach_message_model.dart';

class AiCoachController extends AsyncNotifier<List<CoachMessage>> {
  @override
  Future<List<CoachMessage>> build() async {
    return [
      const CoachMessage(
        id: '1',
        text: 'Hello! I am your AI Coach. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    final currentMessages = state.value ?? [];
    final userMessage = CoachMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = AsyncValue.data([...currentMessages, userMessage]);

    // Simulate API call to /coach/chat
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));

    final aiMessage = CoachMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: 'That\'s a great question! Based on your recent activity, I suggest focusing on your top 3 priorities today.',
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = AsyncValue.data([...currentMessages, userMessage, aiMessage]);
  }

  Future<void> triggerAction(String action) async {
    final currentMessages = state.value ?? [];
    state = const AsyncValue.loading();
    
    await Future.delayed(const Duration(seconds: 1));

    String responseText = '';
    switch (action) {
      case 'habit-stack':
        responseText = 'I\'ve analyzed your habits. Try stacking your "Read 10 pages" habit right after your "Morning Coffee" habit.';
        break;
      case 'habit-mood':
        responseText = 'Noticing you\'re feeling a bit low today. Let\'s scale back to just 1 core habit to maintain momentum without burnout.';
        break;
      case 'synergy':
        responseText = 'Your Finance and Goal modules show great synergy! Your savings rate aligns perfectly with your "Buy a House" goal timeline.';
        break;
      default:
        responseText = 'Action processed.';
    }

    final aiMessage = CoachMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = AsyncValue.data([...currentMessages, aiMessage]);
  }
}

final aiCoachControllerProvider =
    AsyncNotifierProvider<AiCoachController, List<CoachMessage>>(
  AiCoachController.new,
);
