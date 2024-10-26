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
            // color: Colors.black,
            size: 36,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifications'),
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
      body: const Padding(
        padding:  EdgeInsets.all(16.0),
        child: Text("Notification screen under development")
      ),
    );
  }
    
  }

  String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return dateTime.toIso8601String();
    }
  }

List<NotificationModel> getMockNotifications() {
  return [
    NotificationModel(
      notificationType: NotificationType.subscribe,
      initiatorUsername: 'john_doe',
      initiatorProfileImgUrl: 'https://example.com/profile1.jpg',
      subject: 'Upcoming Room Name',
            isTagInUpcomingRoom: false
    ),
    NotificationModel(
      notificationType: NotificationType.like,
      initiatorUsername: 'jane_doe',
      initiatorProfileImgUrl: 'https://example.com/profile2.jpg',
      subject: 'Story Name',
            isTagInUpcomingRoom: false
    ),
    NotificationModel(
      notificationType: NotificationType.follow,
      initiatorUsername: 'mark_smith',
      initiatorProfileImgUrl: 'https://example.com/profile3.jpg',
      subject: 'null',
      isTagInUpcomingRoom: false
    ),
    NotificationModel(
      notificationType: NotificationType.tag,
      initiatorUsername: 'lucy_brown',
      initiatorProfileImgUrl: 'https://example.com/profile4.jpg',
      subject: 'Room Name',
      isTagInUpcomingRoom: true
    ),
    NotificationModel(
      notificationType: NotificationType.tag,
      initiatorUsername: 'lucy_brown',
      initiatorProfileImgUrl: 'https://example.com/profile4.jpg',
      subject: 'Upcoming Name',
      isTagInUpcomingRoom: false
    ),
    NotificationModel(
      notificationType: NotificationType.follow,
      initiatorUsername: 'peter_williams',
      initiatorProfileImgUrl: 'https://example.com/profile5.jpg',
      subject: 'null',
      isTagInUpcomingRoom: false
    ),
  ];
}
