import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/friend_calling_controller.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/friends_model.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class FriendsListTile extends StatelessWidget {
  final FriendsModel friendModel;
  final bool isRequest;

  const FriendsListTile({
    required this.friendModel,
    required this.isRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final friendsController = Get.find<FriendsController>();
    final authStateController = Get.find<AuthStateController>();
    final friendCallingController = Get.put(FriendCallingController());
    final RxBool isProcessing = false.obs;
    final bool userIsSender = friendModel.senderId == authStateController.uid;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(
              creator: userIsSender
                  ? friendModel.recieverToResonateUserForRequestsPage()
                  : friendModel.senderToResonateUserForRequestsPage(),
              isCreatorProfile: true,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              userIsSender
                  ? friendModel.recieverProfileImgUrl
                  : friendModel.senderProfileImgUrl,
            ),
            radius: 25,
          ),
          trailing: Obx(
            () => isProcessing.value
                ? LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: [Theme.of(context).colorScheme.primary],
                  )
                : isRequest
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          isProcessing.value = true;
                          await friendsController.acceptFriendRequest(
                            friendModel,
                          );
                          isProcessing.value = false;
                          customSnackbar(
                            AppLocalizations.of(context)!.friendRequestAccepted,
                            AppLocalizations.of(
                              context,
                            )!.friendRequestAcceptedTo(friendModel.senderName),
                            LogType.success,
                          );
                        },
                        icon: Icon(Icons.check),
                        color: Colors.green,
                      ),
                      IconButton(
                        onPressed: () async {
                          isProcessing.value = true;
                          await friendsController.declineFriendRequest(
                            friendModel,
                          );
                          isProcessing.value = false;
                          customSnackbar(
                            AppLocalizations.of(context)!.friendRequestDeclined,
                            AppLocalizations.of(
                              context,
                            )!.friendRequestDeclinedTo(friendModel.senderName),
                            LogType.info,
                          );
                        },
                        icon: Icon(Icons.close),
                        color: Colors.red,
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () async {
                      if (userIsSender) {
                        await friendCallingController.startCall(
                          friendModel.senderName,
                          friendModel.recieverName,
                          friendModel.senderUsername,
                          friendModel.recieverUsername,
                          friendModel.senderId,
                          friendModel.recieverId,
                          friendModel.senderProfileImgUrl,
                          friendModel.recieverProfileImgUrl,
                          friendModel.docId,
                          friendModel.recieverFCMToken!,
                        );
                      } else {
                        await friendCallingController.startCall(
                          friendModel.recieverName,
                          friendModel.senderName,
                          friendModel.recieverUsername,
                          friendModel.senderUsername,
                          friendModel.recieverId,
                          friendModel.senderId,
                          friendModel.recieverProfileImgUrl,
                          friendModel.senderProfileImgUrl,
                          friendModel.docId,
                          friendModel.senderFCMToken!,
                        );
                      }
                    },
                    icon: Icon(Icons.call),
                  ),
          ),
          title: Text(
            userIsSender ? friendModel.recieverName : friendModel.senderName,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 17,
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
                  fontSize: 12,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Text(
                    userIsSender
                        ? friendModel.recieverRating!.toStringAsFixed(1)
                        : friendModel.senderRating!.toStringAsFixed(1),
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
