import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the AI Coach State
class AiCoachState {
  final String advice;
  final bool isLoading;

  AiCoachState({required this.advice, required this.isLoading});

  AiCoachState.initial() : advice = '', isLoading = false;

  AiCoachState copyWith({String? advice, bool? isLoading}) {
    return AiCoachState(
      advice: advice ?? this.advice,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Define the AI Coach Notifier
final aiCoachProvider = StateNotifierProvider<AiCoachNotifier, AiCoachState>(
  (ref) => AiCoachNotifier(),
);

class AiCoachNotifier extends StateNotifier<AiCoachState> {
  AiCoachNotifier() : super(AiCoachState.initial());

  Future<void> fetchAdvice() async {
    state = state.copyWith(isLoading: true);
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      final advice = "Stay focused and take regular breaks to maintain productivity.";
      state = state.copyWith(advice: advice, isLoading: false);
    } catch (e) {
      state = state.copyWith(advice: 'Failed to fetch advice', isLoading: false);
    }
  }
}

// Define the AI Coach Screen
class AiCoachScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aiCoachState = watch(aiCoachProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Coach'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (aiCoachState.isLoading)
              CircularProgressIndicator()
            else
              Text(
                aiCoachState.advice,
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read(aiCoachProvider).fetchAdvice();
              },
              child: Text('Get Advice'),
            ),
          ],
        ),
      ),
    );
  }
}
