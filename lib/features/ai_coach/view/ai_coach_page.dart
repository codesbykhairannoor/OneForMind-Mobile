import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_for_mind/core/utils/enums.dart';
import 'package:one_for_mind/core/utils/extensions.dart';
import 'package:one_for_mind/core/utils/theme.dart';
import 'package:one_for_mind/features/ai_coach/controller/ai_coach_controller.dart';
import 'package:one_for_mind/features/ai_coach/model/ai_chat_model.dart';

class AiCoachPage extends ConsumerWidget {
  const AiCoachPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiChatController = ref.watch(aiCoachControllerProvider.notifier);
    final aiChats = ref.watch(aiCoachControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('AI Coach'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => aiChatController.clearChats(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: aiChats.length,
              itemBuilder: (context, index) {
                final chat = aiChats[index];
                return _ChatBubble(
                  chat: chat,
                  isUser: chat.isUser,
                );
              },
            ),
          ),
          _ChatInputField(
            onSend: (message) => aiChatController.addUserMessage(message),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final AiChatModel chat;
  final bool isUser;

  const _ChatBubble({
    required this.chat,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isUser)
            SizedBox(width: 16.0)
          else
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.robot, color: Colors.white),
            ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 8.0, right: 16.0, top: 4.0, bottom: 2.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.secondaryColor : AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                chat.message,
                style: TextStyle(
                  color: isUser ? AppTheme.textColor : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatInputField extends ConsumerWidget {
  final void Function(String) onSend;

  const _ChatInputField({
    required this.onSend,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiChatController = ref.watch(aiCoachControllerProvider.notifier);
    final textEditingController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          ElevatedButton(
            onPressed: () {
              final message = textEditingController.text.trim();
              if (message.isNotEmpty) {
                onSend(message);
                textEditingController.clear();
              }
            },
            child: Text('Send'),
          ),
        ],
      ),
    );
  }
}
