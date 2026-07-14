import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/l10n/app_localizations.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.friends)),
      body: friendsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const FriendsEmptyView(isRequestsScreen: false),
        data: (state) {
          if (state.friends.isEmpty) {
            return const FriendsEmptyView(isRequestsScreen: false);
          }
          return ListView.builder(
            itemCount: state.friends.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FriendListTile(
                friendModel: state.friends[index],
                isRequest: false,
              );
            },
          );
        },
      ),
    );
  }
}
