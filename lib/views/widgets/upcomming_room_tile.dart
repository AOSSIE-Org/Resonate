import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpCommingListTile extends StatelessWidget {
  UpCommingListTile({super.key, required this.appwriteUpcommingRoom});
  final AppwriteUpcommingRoom appwriteUpcommingRoom;
  final UpcomingRoomsController upcomingRoomsController =
      Get.put(UpcomingRoomsController());

  @override
  Widget build(BuildContext context) {
    // Display the first three subscribers or as many as available.
    List<String> subscriberAvatars =
        appwriteUpcommingRoom.subscribersAvatarUrls.length > 3
            ? appwriteUpcommingRoom.subscribersAvatarUrls.sublist(0, 3)
            : appwriteUpcommingRoom.subscribersAvatarUrls;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appwriteUpcommingRoom.scheduledDateTime
                    .dateToLocalFormatted(const Locale('en')),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            appwriteUpcommingRoom.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: subscriberAvatars
                .map((avatarUrl) => CustomCircleAvatar(userImage: avatarUrl))
                .toList()
                .withSpacing(7),
          ),
          appwriteUpcommingRoom.tags != []
              ? const SizedBox(
                  height: 8,
                )
              : const SizedBox(),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: appwriteUpcommingRoom.tags
                .map((tag) => Text(
                      "#$tag",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Text(
            appwriteUpcommingRoom.description,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (appwriteUpcommingRoom.userIsCreator)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    upcomingRoomsController
                        .deleteUpcomingRoom(appwriteUpcommingRoom.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: appwriteUpcommingRoom.isTime
                      ? () {
                          upcomingRoomsController.convertUpcomingRoomtoRoom(
                              appwriteUpcommingRoom.id,
                              appwriteUpcommingRoom.name,
                              appwriteUpcommingRoom.description,
                              appwriteUpcommingRoom.tags
                                  .map((item) => item.toString())
                                  .toList());
                        }
                      : null, // Disable button if isTime is false
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appwriteUpcommingRoom.isTime
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.start),
                ),
              ],
            )
          else // If not creator, show subscribe/unsubscribe button for subscribers
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (appwriteUpcommingRoom.hasUserSubscribed) {
                      upcomingRoomsController.removeUserFromSubscriberList(
                          appwriteUpcommingRoom.id);
                    } else {
                      upcomingRoomsController
                          .addUserToSubscriberList(appwriteUpcommingRoom.id);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appwriteUpcommingRoom.hasUserSubscribed
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),                  child: Text(
                    appwriteUpcommingRoom.hasUserSubscribed
                        ? AppLocalizations.of(context)!.unsubscribe
                        : AppLocalizations.of(context)!.subscribe,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.userImage,
    this.width = 36,
    this.height = 36,
  });
  final String userImage;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            userImage,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
    );
  }
}

extension SpacedWidgets on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    return asMap()
        .map((index, widget) {
          return MapEntry(
            index,
            [
              widget,
              if (index < length - 1) SizedBox(width: spacing),
            ],
          );
        })
        .values
        .expand((element) => element)
        .toList();
  }
}
