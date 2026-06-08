import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/core/providers.dart';
import 'package:oneformind/ai_coach/ai_coach_controller.dart';

class AiCoachView extends ConsumerWidget {
  const AiCoachView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final aiCoachState = watch(aiCoachControllerProvider);
    final aiCoachController = watch(aiCoachControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: aiCoachController.messageController,
              decoration: const InputDecoration(
                labelText: 'Type your message',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                aiCoachController.sendMessage();
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: aiCoachState.messages.length,
                itemBuilder: (context, index) {
                  final message = aiCoachState.messages[index];
                  return ListTile(
                    title: Text(message.text),
                    subtitle: Text(message.sender == 'user' ? 'You' : 'AI Coach'),
                    tileColor: message.sender == 'user' ? Colors.blue[50] : Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
