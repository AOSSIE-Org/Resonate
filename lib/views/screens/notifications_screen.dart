import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/notification.dart';
import 'package:resonate/utils/enums/notification_type.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import '../../utils/app_images.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications = getMockNotifications();

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            size: 36,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifications',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16),
            child: InkWell(
              child: const CircleAvatar(
                backgroundImage: AssetImage(
                  AppImages.userImage,
                ),
              ),
              onTap: () {
                Get.to(ProfileScreen());
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationTile(notification: notification);
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    String message;
    Icon icon;

    switch (notification.notificationType) {
      case NotificationType.tag:
        message = notification.isTagInUpcomingRoom
            ? '${notification.initiatorUsername} tagged you in an upcoming room: ${notification.subject}'
            : '${notification.initiatorUsername} tagged you in room: ${notification.subject}';
        icon = const Icon(Icons.tag, color: Colors.green);
        break;
      case NotificationType.like:
        message =
            '${notification.initiatorUsername} liked your story: ${notification.subject}';
        icon = const Icon(Icons.favorite, color: Colors.redAccent);
        break;
      case NotificationType.subscribe:
        message =
            '${notification.initiatorUsername} subscribed to your room: ${notification.subject}';
        icon = const Icon(Icons.notifications, color: Colors.orangeAccent);
        break;
      case NotificationType.follow:
        message = '${notification.initiatorUsername} started following you';
        icon = const Icon(Icons.person_add, color: Colors.blueAccent);
        break;
      default:
        message = 'You have a new notification';
        icon = const Icon(Icons.notifications, color: Colors.grey);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(notification.initiatorProfileImgUrl),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          icon,
        ],
      ),
    );
  }
}

List<NotificationModel> getMockNotifications() {
  return [
    NotificationModel(
      notificationType: NotificationType.subscribe,
      initiatorUsername: 'john_doe',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: 'Machine Learning 101',
      isTagInUpcomingRoom: false,
    ),
    NotificationModel(
      notificationType: NotificationType.like,
      initiatorUsername: 'jane_doe',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: 'Deep Dive into AI',
      isTagInUpcomingRoom: false,
    ),
    NotificationModel(
      notificationType: NotificationType.follow,
      initiatorUsername: 'mark_smith',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: '',
      isTagInUpcomingRoom: false,
    ),
    NotificationModel(
      notificationType: NotificationType.tag,
      initiatorUsername: 'lucy_brown',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: 'Upcoming Coding Room',
      isTagInUpcomingRoom: true,
    ),
    NotificationModel(
      notificationType: NotificationType.subscribe,
      initiatorUsername: 'anna_kim',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: 'AI for Beginners',
      isTagInUpcomingRoom: true,
    ),
    NotificationModel(
      notificationType: NotificationType.like,
      initiatorUsername: 'alex_lee',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: 'Quantum Computing Basics',
      isTagInUpcomingRoom: false,
    ),
    NotificationModel(
      notificationType: NotificationType.follow,
      initiatorUsername: 'sara_white',
      initiatorProfileImgUrl:
          'https://www.perfocal.com/blog/content/images/2021/01/Perfocal_17-11-2019_TYWFAQ_100_standard-3.jpg',
      subject: '',
      isTagInUpcomingRoom: false,
    ),
  ];
}
