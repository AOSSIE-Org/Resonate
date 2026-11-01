import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/achievements/data/badge_showcase.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/activity_status/data/user_activity_status.dart';
import 'package:resonate/features/activity_status/model/call_blocked_by_activity_status.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_avatar.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/secondary_list_card.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class FriendListTile extends ConsumerStatefulWidget {
  final FriendsModel friendModel;
  final bool isRequest;

  const FriendListTile({
    required this.friendModel,
    required this.isRequest,
    super.key,
  });

  @override
  ConsumerState<FriendListTile> createState() => _FriendListTileState();
}

class _FriendListTileState extends ConsumerState<FriendListTile> {
  bool _isProcessing = false;

  FriendsModel get friendModel => widget.friendModel;

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _isProcessing = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool userIsSender =
        friendModel.senderId == ref.read(requireUserProvider).uid;
    final otherUid = userIsSender
        ? friendModel.recieverId
        : friendModel.senderId;
    final otherName = userIsSender
        ? friendModel.recieverName
        : friendModel.senderName;
    final status = ref.watch(userActivityStatusProvider)[otherUid];
    final worn = ref.watch(avatarBadgeProvider(otherUid));
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(
              creator: userIsSender
                  ? friendModel.recieverToResonateUserForRequestsPage()
                  : friendModel.senderToResonateUserForRequestsPage(),
              isCreatorProfile: true,
            ),
          ),
        );
      },
      child: SecondaryListCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: ActivityAvatar(
            imageUrl: userIsSender
                ? friendModel.recieverProfileImgUrl
                : friendModel.senderProfileImgUrl,
            status: status,
            radius: UiSizes.size_25,
            badgeGlyph: worn?.icon,
            badgeLabel: worn?.label(AppLocalizations.of(context)!),
          ),
          trailing: _isProcessing
              ? LoadingIndicator(
                  indicatorType: Indicator.ballRotate,
                  colors: [Theme.of(context).colorScheme.primary],
                )
              : widget.isRequest
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _runAction(() async {
                        final l10n = AppLocalizations.of(context)!;
                        await ref
                            .read(friendsProvider.notifier)
                            .acceptFriendRequest(friendModel);
                        customSnackbar(
                          l10n.friendRequestAccepted,
                          l10n.friendRequestAcceptedTo(friendModel.senderName),
                          LogType.success,
                        );
                      }),
                      icon: Icon(Icons.check),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    IconButton(
                      onPressed: () => _runAction(() async {
                        final l10n = AppLocalizations.of(context)!;
                        await ref
                            .read(friendsProvider.notifier)
                            .declineFriendRequest(friendModel);
                        customSnackbar(
                          l10n.friendRequestDeclined,
                          l10n.friendRequestDeclinedTo(friendModel.senderName),
                          LogType.info,
                        );
                      }),
                      icon: Icon(Icons.close),
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ],
                )
              : IconButton(
                  onPressed: () => _runAction(() async {
                    final l10n = AppLocalizations.of(context)!;
                    try {
                      await ref
                          .read(friendCallCoordinatorProvider.notifier)
                          .startCall(friendModel);
                    } on CallBlockedByActivityStatus catch (e) {
                      customSnackbar(
                        l10n.callBlocked,
                        e.status.callBlockedMessage(l10n, otherName),
                        LogType.info,
                      );
                    } catch (e) {
                      customSnackbar(l10n.error, e.toString(), LogType.error);
                    }
                  }),
                  color: (status?.blocksCalls ?? false)
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : null,
                  icon: Icon(
                    (status?.blocksCalls ?? false)
                        ? Icons.phone_disabled
                        : Icons.call,
                  ),
                ),
          title: Text(
            userIsSender ? friendModel.recieverName : friendModel.senderName,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: UiSizes.size_17,
              fontStyle: FontStyle.normal,
              fontFamily: 'Inter',
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                userIsSender
                    ? friendModel.recieverUsername
                    : friendModel.senderUsername,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: UiSizes.size_12,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    userIsSender
                        ? (friendModel.recieverRating ?? 0).toStringAsFixed(1)
                        : (friendModel.senderRating ?? 0).toStringAsFixed(1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
