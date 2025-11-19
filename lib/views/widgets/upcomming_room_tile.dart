import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/models/appwrite_upcomming_room.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class UpCommingListTile extends StatelessWidget {
  UpCommingListTile({super.key, required this.appwriteUpcommingRoom});
  final AppwriteUpcommingRoom appwriteUpcommingRoom;
  final UpcomingRoomsController upcomingRoomsController = Get.put(
    UpcomingRoomsController(),
  );

  Future<void> _showRemoveDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.removeRoom),
          content: Text(AppLocalizations.of(context)!.removeRoomConfirmation),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(context)!.hide),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await upcomingRoomsController.removeUpcomingRoom(
                    appwriteUpcommingRoom.id,
                  );
                  customSnackbar(
                    AppLocalizations.of(Get.context!)!.success,
                    AppLocalizations.of(Get.context!)!.roomRemovedSuccessfully,
                    LogType.success,
                  );
                } catch (e) {
                  customSnackbar(
                    AppLocalizations.of(Get.context!)!.error,
                    AppLocalizations.of(Get.context!)!.failedToRemoveRoom,
                    LogType.error,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

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
                appwriteUpcommingRoom.scheduledDateTime.dateToLocalFormatted(
                  const Locale('en'),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            appwriteUpcommingRoom.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: subscriberAvatars
                .map((avatarUrl) => CustomCircleAvatar(userImage: avatarUrl))
                .toList()
                .withSpacing(7),
          ),
          appwriteUpcommingRoom.tags != []
              ? const SizedBox(height: 8)
              : const SizedBox(),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: appwriteUpcommingRoom.tags
                .map(
                  (tag) => Text(
                    "#$tag",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 14,
                    ),
                  ),
                )
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
          const SizedBox(height: 10),
          if (appwriteUpcommingRoom.userIsCreator)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: UiSizes.height_50,
                  width: UiSizes.width_56,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    onPressed: () {
                      upcomingRoomsController.openUpcomingChatSheet(
                        appwriteUpcommingRoom,
                      );
                    },
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: UiSizes.size_20,
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    await upcomingRoomsController.deleteUpcomingRoom(
                      appwriteUpcommingRoom.id,
                    );
                    await upcomingRoomsController.getUpcomingRooms();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
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
                                .toList(),
                          );
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
                IconButton(
                  onPressed: () => _showRemoveDialog(context),
                  icon: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  tooltip: AppLocalizations.of(context)!.removeRoomFromList,
                ),
                Spacer(),
                SizedBox(
                  height: UiSizes.height_50,
                  width: UiSizes.width_56,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    onPressed: () {
                      upcomingRoomsController.openUpcomingChatSheet(
                        appwriteUpcommingRoom,
                      );
                    },
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: UiSizes.size_20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (appwriteUpcommingRoom.hasUserSubscribed) {
                        upcomingRoomsController.removeUserFromSubscriberList(
                          appwriteUpcommingRoom.id,
                        );
                      } else {
                        upcomingRoomsController.addUserToSubscriberList(
                          appwriteUpcommingRoom.id,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appwriteUpcommingRoom.hasUserSubscribed
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      appwriteUpcommingRoom.hasUserSubscribed
                          ? AppLocalizations.of(context)!.unsubscribe
                          : AppLocalizations.of(context)!.subscribe,
                    ),
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
          image: CachedNetworkImageProvider(userImage),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
    );
  }
}

extension SpacedWidgets on List<Widget> {
  List<Widget> withSpacing(double spacing) {
    return asMap()
        .map((index, widget) {
          return MapEntry(index, [
            widget,
            if (index < length - 1) SizedBox(width: spacing),
          ]);
        })
        .values
        .expand((element) => element)
        .toList();
  }
}
