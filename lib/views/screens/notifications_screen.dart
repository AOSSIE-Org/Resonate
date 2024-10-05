import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/mock_models/notification_model.dart';
import 'package:resonate/views/screens/profile_screen.dart';

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
                  "assets/images/user.jpeg",
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
        child: AnimatedList(
          initialItemCount: notifications.length,
          itemBuilder: (context, index, animation) {
            final notification = notifications[index];
            return Card(
              color: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              elevation: 5,
              shadowColor: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                leading: CircleAvatar(
                  backgroundColor: notification.isRead
                      ? Colors.grey.shade300
                      : Colors.blue.shade100,
                  child: Icon(
                    notification.isRead
                        ? Icons.notifications_none
                        : Icons.notifications,
                    color: notification.isRead ? Colors.grey : Colors.blue,
                  ),
                ),
                title: Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDateTime(notification.dateTime),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 16.0, color: Colors.grey.shade400),
                onTap: () {
                  // Handle notification tap
                },
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
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
}

List<NotificationModel> getMockNotifications() {
  return [
    NotificationModel(
      title: "Welcome to Resonate!",
      message: "Start by exploring rooms and joining conversations.",
      dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      title: "New Follow Request",
      message: "John Doe has requested to follow you.",
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      title: "Room Recommendation",
      message: "Join the 'Flutter Developers' room happening now.",
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      title: "Room Recommendation",
      message: "Join the 'Flutter Developers' room happening now.",
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      title: "New Follow Request",
      message: "John Doe has requested to follow you.",
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];
}
