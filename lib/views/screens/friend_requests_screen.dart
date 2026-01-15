import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/views/widgets/friend_request_list_tile.dart';
import 'package:resonate/views/widgets/friends_empty_state.dart';

class FriendRequestsScreen extends StatelessWidget {
  const FriendRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsController = Get.find<FriendsController>();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.friendRequests)),
      body: Obx(() {
        final availableFriendRequests = friendsController.friendRequestsList
            .where(
              (friend) =>
                  friend.requestSentByUserId !=
                  friendsController.authStateController.uid,
            )
            .toList();
        if (availableFriendRequests.isEmpty) {
          return const FriendsEmptyState(isRequestsScreen: true);
        }
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
