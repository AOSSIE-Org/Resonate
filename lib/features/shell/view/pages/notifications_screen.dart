import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/features/shell/model/notification.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/enums/notification_type.dart';
import 'package:resonate/utils/ui_sizes.dart';

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
          icon: Icon(Icons.keyboard_arrow_down, size: UiSizes.size_35),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: TextStyle(fontSize: UiSizes.size_24, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: UiSizes.width_16, left: UiSizes.width_16),
            child: InkWell(
              child: const CircleAvatar(
                backgroundImage: AssetImage(AppImages.userImage),
              ),
              onTap: () {
                context.push(RoutePaths.profile);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(UiSizes.width_16),
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
      margin: EdgeInsets.symmetric(vertical: UiSizes.height_8),
      padding: EdgeInsets.all(UiSizes.width_10),
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
            radius: UiSizes.size_24,
          ),
          SizedBox(width: UiSizes.width_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: UiSizes.size_16,
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
