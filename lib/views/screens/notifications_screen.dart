import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/notification.dart';
import 'package:resonate/utils/enums/notification_type.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/l10n/app_localizations.dart';
import '../../utils/app_images.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationModel> notifications = [];

  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 36),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16),
            child: InkWell(
              child: const CircleAvatar(
                backgroundImage: AssetImage(AppImages.userImage),
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
            ? AppLocalizations.of(context)!.taggedYouInUpcomingRoom(
                notification.initiatorUsername,
                notification.subject,
              )
            : AppLocalizations.of(context)!.taggedYouInRoom(
                notification.initiatorUsername,
                notification.subject,
              );
        icon = const Icon(Icons.tag, color: Colors.green);
        break;
      case NotificationType.like:
        message = AppLocalizations.of(
          context,
        )!.likedYourStory(notification.initiatorUsername, notification.subject);
        icon = const Icon(Icons.favorite, color: Colors.redAccent);
        break;
      case NotificationType.subscribe:
        message = AppLocalizations.of(context)!.subscribedToYourRoom(
          notification.initiatorUsername,
          notification.subject,
        );
        icon = const Icon(Icons.notifications, color: Colors.orangeAccent);
        break;
      case NotificationType.follow:
        message = AppLocalizations.of(
          context,
        )!.startedFollowingYou(notification.initiatorUsername);
        icon = const Icon(Icons.person_add, color: Colors.blueAccent);
        break;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
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
