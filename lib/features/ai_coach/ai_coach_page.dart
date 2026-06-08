import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/core/providers.dart';
import 'package:oneformind/features/ai_coach/ai_coach_controller.dart';

class AiCoachPage extends ConsumerWidget {
  const AiCoachPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiCoachState = ref.watch(aiCoachControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: aiCoachState.messageController,
              decoration: const InputDecoration(
                labelText: 'Ask your AI Coach',
              ),
              onSubmitted: (value) => aiCoachState.sendMessage(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: aiCoachState.messages.length,
                itemBuilder: (context, index) {
                  final message = aiCoachState.messages[index];
                  return ListTile(
                    title: Text(message.content),
                    subtitle: Text(message.sender),
                    trailing: Text(message.timestamp.toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => aiCoachState.sendMessage(),
        child: const Icon(Icons.send),
      ),
    );
  }
}
