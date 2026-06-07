import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/coach_message_model.dart';
import '../../data/coach_api_service.dart';

class CoachState {
  final List<CoachMessage> messages;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? synergy;

  CoachState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.synergy,
  });

  CoachState copyWith({
    List<CoachMessage>? messages,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? synergy,
  }) {
    return CoachState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      synergy: synergy ?? this.synergy,
    );
  }
}

class CoachNotifier extends StateNotifier<CoachState> {
  final CoachApiService _apiService;

  CoachNotifier(this._apiService) : super(CoachState());

  Future<void> loadMessages() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final messages = await _apiService.getSessions();
      state = state.copyWith(messages: messages, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> sendMessage(String content) async {
    final userMessage = CoachMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: content,
    );
    
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    try {
      final responseMessage = await _apiService.sendMessage(content);
      state = state.copyWith(
        messages: [...state.messages, responseMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
        messages: state.messages.sublist(0, state.messages.length - 1),
      );
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _apiService.deleteSession(sessionId);
      state = state.copyWith(
        messages: state.messages.where((m) => m.id != sessionId).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> loadSynergy() async {
    try {
      final synergyData = await _apiService.getSynergy();
      state = state.copyWith(synergy: synergyData);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final coachProvider = StateNotifierProvider<CoachNotifier, CoachState>((ref) {
  final apiService = ref.watch(coachApiServiceProvider);
  return CoachNotifier(apiService);
});
