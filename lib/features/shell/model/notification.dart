import 'package:resonate/utils/enums/notification_type.dart';

class NotificationModel {
  final NotificationType notificationType;
  final String initiatorUsername;
  final String initiatorProfileImgUrl;
  final String subject;
  final bool isTagInUpcomingRoom;

  NotificationModel({
    required this.notificationType,
    required this.initiatorUsername,
    required this.initiatorProfileImgUrl,
    required this.subject,
    required this.isTagInUpcomingRoom,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationType': notificationType.name,
      'initiatorUsername': initiatorUsername,
      'initiatorProfileImgUrl': initiatorProfileImgUrl,
      'subject': subject,
      'isTagInUpcomingRoom': isTagInUpcomingRoom,
    };
  }
}
