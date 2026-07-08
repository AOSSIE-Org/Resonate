import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/view/pages/room_page.dart';
import 'package:resonate/features/rooms/viewmodel/rooms_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:share_plus/share_plus.dart';

class CustomLiveRoomTile extends ConsumerWidget {
  const CustomLiveRoomTile({super.key, required this.appwriteRoom});

  final AppwriteRoom appwriteRoom;

  Future<void> _join(BuildContext context, WidgetRef ref) async {
    final rootNavigator = Navigator.of(context, rootNavigator: true);
    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (ctx) => Center(
        child: LoadingAnimationWidget.threeRotatingDots(
          color: Theme.of(ctx).primaryColor,
          size: MediaQuery.of(ctx).devicePixelRatio * 20,
        ),
      ),
    );

    void closeDialog() {
      if (rootNavigator.canPop()) rootNavigator.pop();
    }

    try {
      final joined =
          await ref.read(roomsProvider.notifier).joinRoom(appwriteRoom);
      closeDialog();
      if (context.mounted) {
        await openRoomSheet(context, joined);
      }
    } catch (_) {
      closeDialog();
      await ref.read(roomsProvider.notifier).refresh();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.error)),
        );
      }
    }
    await dialogFuture; // ensure dialog is fully torn down before returning
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAvatars = appwriteRoom.memberAvatarUrls.length > 3
        ? appwriteRoom.memberAvatarUrls.sublist(0, 3)
        : appwriteRoom.memberAvatarUrls;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(UiSizes.width_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    appwriteRoom.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: UiSizes.size_16,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text: AppLocalizations.of(context)!.shareRoomMessage(
                          appwriteRoom.name,
                          appwriteRoom.description,
                          appwriteRoom.totalParticipants,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            Wrap(
              spacing: UiSizes.width_8,
              runSpacing: UiSizes.height_4,
              children: appwriteRoom.tags
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
              appwriteRoom.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: UiSizes.size_14,
              ),
            ),
            SizedBox(height: UiSizes.height_5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: UiSizes.width_123_4,
                      height: UiSizes.height_50,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: memberAvatars
                            .asMap()
                            .entries
                            .map(
                              (entry) => Positioned(
                                left: 28.0 * entry.key,
                                child: CustomCircleAvatar(
                                  height: UiSizes.size_40,
                                  width: UiSizes.size_40,
                                  userImage: entry.value,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          color: Theme.of(context).colorScheme.primary,
                          size: UiSizes.size_20,
                        ),
                        SizedBox(width: UiSizes.width_4),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.participantsCount(appwriteRoom.totalParticipants),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: UiSizes.size_14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _join(context, ref),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(AppLocalizations.of(context)!.join),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    required this.userImage,
    this.width = 40,
    this.height = 40,
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
          image: NetworkImage(userImage),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
