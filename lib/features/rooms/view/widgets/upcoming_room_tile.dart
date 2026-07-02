import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/rooms/view/pages/room_chat_page.dart';
import 'package:resonate/features/rooms/viewmodel/upcoming_rooms_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class UpcomingListTile extends ConsumerWidget {
  const UpcomingListTile({super.key, required this.appwriteUpcomingRoom});

  final AppwriteUpcomingRoom appwriteUpcomingRoom;

  Future<void> _showRemoveDialog(BuildContext context, WidgetRef ref) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(dialogCtx)!.removeRoom),
          content: Text(
            AppLocalizations.of(dialogCtx)!.removeRoomConfirmation,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(dialogCtx)!.cancel),
              onPressed: () => Navigator.of(dialogCtx).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogCtx).colorScheme.error,
              ),
              child: Text(AppLocalizations.of(dialogCtx)!.hide),
              onPressed: () async {
                final l10n = AppLocalizations.of(dialogCtx)!;
                final successTitle = l10n.success;
                final successBody = l10n.roomRemovedSuccessfully;
                final errorTitle = l10n.error;
                final errorBody = l10n.failedToRemoveRoom;

                Navigator.of(dialogCtx).pop();
                try {
                  await ref
                      .read(upcomingRoomsProvider.notifier)
                      .hideLocally(appwriteUpcomingRoom.id);
                  customSnackbar(successTitle, successBody, LogType.success);
                } catch (_) {
                  customSnackbar(errorTitle, errorBody, LogType.error);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriberAvatars =
        appwriteUpcomingRoom.subscribersAvatarUrls.length > 3
        ? appwriteUpcomingRoom.subscribersAvatarUrls.sublist(0, 3)
        : appwriteUpcomingRoom.subscribersAvatarUrls;

    return Container(
      padding: EdgeInsets.all(UiSizes.width_10),
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
                appwriteUpcomingRoom.scheduledDateTime.dateToLocalFormatted(
                  const Locale('en'),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: UiSizes.size_15,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: UiSizes.height_5),
          Text(
            appwriteUpcomingRoom.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: UiSizes.size_15),
          ),
          SizedBox(height: UiSizes.height_8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: subscriberAvatars
                .map((avatarUrl) => _UpcomingAvatar(userImage: avatarUrl))
                .toList()
                .withSpacing(7),
          ),
          if (appwriteUpcomingRoom.tags.isNotEmpty) SizedBox(height: UiSizes.height_8),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: appwriteUpcomingRoom.tags
                .map(
                  (tag) => Text(
                    '#$tag',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: UiSizes.size_14,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: UiSizes.height_8),
          Text(
            appwriteUpcomingRoom.description,
            maxLines: 2,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: UiSizes.size_15,
            ),
          ),
          SizedBox(height: UiSizes.height_10),
          if (appwriteUpcomingRoom.userIsCreator)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: UiSizes.height_50,
                  width: UiSizes.width_56,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    onPressed: () => openUpcomingChatSheet(
                      context,
                      appwriteUpcomingRoom,
                    ),
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: UiSizes.size_20,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    final l10n = AppLocalizations.of(context)!;
                    try {
                      await ref
                          .read(upcomingRoomsProvider.notifier)
                          .deleteUpcoming(appwriteUpcomingRoom.id);
                    } catch (e) {
                      customSnackbar(l10n.error, e.toString(), LogType.error);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: UiSizes.width_10),
                ElevatedButton(
                  onPressed: appwriteUpcomingRoom.isTime
                      ? () async {
                          final l10n = AppLocalizations.of(context)!;
                          try {
                            await ref
                                .read(upcomingRoomsProvider.notifier)
                                .convertToLive(
                                  upcomingRoomId: appwriteUpcomingRoom.id,
                                  name: appwriteUpcomingRoom.name,
                                  description: appwriteUpcomingRoom.description,
                                  tags: appwriteUpcomingRoom.tags,
                                );
                          } catch (e) {
                            customSnackbar(
                              l10n.error,
                              e.toString(),
                              LogType.error,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appwriteUpcomingRoom.isTime
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
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => _showRemoveDialog(context, ref),
                  icon: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  tooltip: AppLocalizations.of(context)!.removeRoomFromList,
                ),
                const Spacer(),
                SizedBox(
                  height: UiSizes.height_50,
                  width: UiSizes.width_56,
                  child: FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 234, 93, 83),
                    onPressed: () => openUpcomingChatSheet(
                      context,
                      appwriteUpcomingRoom,
                    ),
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: UiSizes.size_20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: UiSizes.width_8),
                  child: ElevatedButton(
                    onPressed: () {
                      final notifier = ref.read(
                        upcomingRoomsProvider.notifier,
                      );
                      if (appwriteUpcomingRoom.hasUserSubscribed) {
                        notifier.unsubscribe(appwriteUpcomingRoom.id);
                      } else {
                        notifier.subscribe(appwriteUpcomingRoom.id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appwriteUpcomingRoom.hasUserSubscribed
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      appwriteUpcomingRoom.hasUserSubscribed
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

class _UpcomingAvatar extends StatelessWidget {
  const _UpcomingAvatar({required this.userImage});
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: UiSizes.size_35,
      height: UiSizes.size_35,
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
