import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/features/chatbot/data/chat_service.dart';
import 'package:tadweer/features/chatbot/models/message_model.dart';
import 'package:tadweer/features/home/models/task_model.dart';

class ChatBotScreen extends StatefulWidget {
  final List<TaskModel> tasks;

  const ChatBotScreen({super.key, required this.tasks});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  final List<MessageModel> _messages = [];
  bool _isLoading = false;

  void _sendMessage() async {
    final userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.insert(0, MessageModel(message: userText, isUser: true, sentAt: DateTime.now()));
      _isLoading = true;
    });
    _controller.clear();

    final botResponse = await _chatService.getChatResponse(userText, widget.tasks);

    if (mounted) {
      setState(() {
        _messages.insert(0, MessageModel(message: botResponse, isUser: false, sentAt: DateTime.now()));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("AI Assistant", style: AppTextStyles.font18SemiBold),
        backgroundColor: DarkAppColors.primary800,
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _buildChatBubble(_messages[index]),
              ),
            ),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: LinearProgressIndicator(
                  color: DarkAppColors.primary800,
                  backgroundColor: Colors.grey[900],
                ),
              ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(MessageModel message) {
    bool isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isUser ? DarkAppColors.primary800 : Colors.grey[850],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isUser ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(16.r),
          ),
        ),
        child: Text(
          message.message,
          style: AppTextStyles.font14Regular.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 10.h,
        bottom: MediaQuery.of(context).padding.bottom + 10.h,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: DarkAppColors.primary800),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}