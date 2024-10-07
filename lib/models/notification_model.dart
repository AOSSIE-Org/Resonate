class NotificationModel {
  final String title;
  final String message;
  final DateTime dateTime;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.dateTime,
    this.isRead = false,
  });
}
