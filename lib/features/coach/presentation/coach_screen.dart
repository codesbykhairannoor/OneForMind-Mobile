import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oneformind/features/coach/presentation/coach_controller.dart';

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(coachControllerProvider.notifier).loadSessions();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final coachState = ref.watch(coachControllerProvider);
    final notifier = ref.read(coachControllerProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Slate
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo.withOpacity(0.15),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(notifier),
                Expanded(child: _buildChatList(coachState)),
                _buildInputArea(coachState, notifier),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(CoachController notifier) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Color(0xFF8B5CF6), size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Coach',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Neural OS Active',
                  style: TextStyle(color: Colors.indigo.shade300, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6)),
            onPressed: notifier.getSynergy,
            tooltip: 'Get Synergy Insight',
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(CoachState state) {
    if (state.isLoading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6)));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(24),
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final msg = state.messages[index];
        final isUser = msg['role'] == 'user';
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF4F46E5) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 20),
              ),
              border: isUser ? null : Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Text(
              msg['content'] ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea(CoachState state, CoachController notifier) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Ask your coach...',
                      hintStyle: TextStyle(color: Colors.white38),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty && state.currentSessionId != null) {
                        notifier.sendMessage(value.trim());
                        _messageController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: state.isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Color(0xFF4F46E5), strokeWidth: 2))
                    : const Icon(Icons.send_rounded, color: Color(0xFF4F46E5)),
                  onPressed: state.isLoading || state.currentSessionId == null
                    ? null
                    : () {
                        if (_messageController.text.trim().isNotEmpty) {
                          notifier.sendMessage(_messageController.text.trim());
                          _messageController.clear();
                        }
                      },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
