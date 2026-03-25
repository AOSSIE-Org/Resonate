import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/views/widgets/friend_request_list_tile.dart';
import 'package:resonate/views/screens/friends_empty_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsController = Get.find<FriendsController>();
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.friends)),
      body: Obx(() {
        final availableFriends = friendsController.friendsList;
        if (availableFriends.isEmpty) {
          return const FriendsEmptyState(isRequestsScreen: false);
        }
        return ListView.builder(
          itemCount: availableFriends.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final friendModel = availableFriends[index];
            return FriendsListTile(friendModel: friendModel, isRequest: false);
          },
        );
      }),
    );
  }
}
