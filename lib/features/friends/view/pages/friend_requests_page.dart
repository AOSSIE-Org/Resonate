import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/friends/viewmodel/friends_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';

class FriendRequestsPage extends ConsumerWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.friendRequests)),
      body: friendsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const FriendsEmptyView(isRequestsScreen: true),
        data: (state) {
          // Only requests addressed to us
          final incomingRequests = state.friendRequests
              .where(
                (friend) =>
                    friend.requestSentByUserId != requireCurrentAuthUser.uid,
              )
              .toList();
          if (incomingRequests.isEmpty) {
            return const FriendsEmptyView(isRequestsScreen: true);
          }
          return ListView.builder(
            itemCount: incomingRequests.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FriendListTile(
                friendModel: incomingRequests[index],
                isRequest: true,
              );
            },
          );
        },
      ),
    );
  }
}
