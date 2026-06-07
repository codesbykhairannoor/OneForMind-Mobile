import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/features/coach/domain/coach_session_model.dart';
import 'package:oneformind/features/coach/data/coach_api_service.dart';

final coachApiServiceProvider = Provider<CoachApiService>((ref) {
  throw UnimplementedError('Provide CoachApiService dependencies (http.Client, baseUrl, token)');
});

class CoachState {
  final List<CoachSession> sessions;
  final List<Map<String, dynamic>> messages;
  final bool isLoading;
  final String? error;
  final String? currentSessionId;

  const CoachState({
    this.sessions = const [],
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.currentSessionId,
  });

  CoachState copyWith({
    List<CoachSession>? sessions,
    List<Map<String, dynamic>>? messages,
    bool? isLoading,
    String? error,
    String? currentSessionId,
  }) {
    return CoachState(
      sessions: sessions ?? this.sessions,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentSessionId: currentSessionId ?? this.currentSessionId,
    );
  }
}

class CoachController extends Notifier<CoachState> {
  @override
  CoachState build() {
    return const CoachState();
  }

  CoachApiService get _api => ref.read(coachApiServiceProvider);

  Future<void> loadSessions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final sessions = await _api.getSessions();
      state = state.copyWith(sessions: sessions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String message) async {
    if (state.currentSessionId == null) return;
    
    final userMsg = {'role': 'user', 'content': message};
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isLoading: true,
      error: null,
    );

    try {
      final response = await _api.sendMessage(state.currentSessionId!, message);
      final assistantMsg = {
        'role': 'assistant', 
        'content': response['message'] ?? 'Response received'
      };
      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _api.deleteSession(sessionId);
      state = state.copyWith(
        sessions: state.sessions.where((s) => s.id != sessionId).toList(),
        currentSessionId: state.currentSessionId == sessionId ? null : state.currentSessionId,
        messages: state.currentSessionId == sessionId ? [] : state.messages,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void selectSession(String sessionId) {
    state = state.copyWith(currentSessionId: sessionId, messages: []);
  }

  Future<void> getSynergy() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _api.getSynergy();
      final assistantMsg = {
        'role': 'assistant', 
        'content': response['message'] ?? 'Synergy insight generated'
      };
      state = state.copyWith(
        messages: [...state.messages, assistantMsg],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final coachControllerProvider = NotifierProvider<CoachController, CoachState>(CoachController.new);
