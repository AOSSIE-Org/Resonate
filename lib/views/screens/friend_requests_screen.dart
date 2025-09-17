import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/views/widgets/friend_request_list_tile.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsController = Get.find<FriendsController>();
    final authStateController = Get.find<AuthStateController>();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.friendRequests)),
      body: Obx(() {
        final availableFriendRequests = friendsController.friendRequestsList
            .where(
              (friend) => friend.requestSentByUserId != authStateController.uid,
            )
            .toList();
        return ListView.builder(
          itemCount: availableFriendRequests.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final friendModel = availableFriendRequests[index];
            return FriendsListTile(friendModel: friendModel, isRequest: true);
          },
        );
      }),
    );
  }
}
