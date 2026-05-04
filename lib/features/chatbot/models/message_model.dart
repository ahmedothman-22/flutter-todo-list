class MessageModel {
  final String message;
  final bool isUser;
  final DateTime sentAt;

  MessageModel({
    required this.message,
    required this.isUser,
    required this.sentAt,
  });
}