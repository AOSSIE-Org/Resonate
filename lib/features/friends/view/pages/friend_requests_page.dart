import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/friends/viewmodel/friend_requests_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';

class FriendRequestsPage extends ConsumerWidget {
  const FriendRequestsPage({super.key});

  Future<void> _accept(
    WidgetRef ref,
    FriendsModel friend,
    AppLocalizations l10n,
  ) async {
    final ok = await ref.read(friendRequestsProvider.notifier).accept(friend);
    customSnackbar(
      ok ? l10n.friendRequestAccepted : l10n.error,
      ok ? l10n.friendRequestAcceptedTo(friend.senderName) : l10n.tryAgain,
      ok ? LogType.success : LogType.error,
    );
  }

  Future<void> _decline(
    WidgetRef ref,
    FriendsModel friend,
    AppLocalizations l10n,
  ) async {
    final ok = await ref.read(friendRequestsProvider.notifier).decline(friend);
    customSnackbar(
      ok ? l10n.friendRequestDeclined : l10n.error,
      ok ? l10n.friendRequestDeclinedTo(friend.senderName) : l10n.tryAgain,
      ok ? LogType.info : LogType.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(friendRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.friendRequests)),
      body: state.rows.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const FriendsEmptyView(isRequestsScreen: true),
        data: (requests) {
          if (requests.isEmpty) {
            return const FriendsEmptyView(isRequestsScreen: true);
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final friend = requests[index];
              return FriendListTile(
                friendModel: friend,
                isRequest: true,
                isProcessing: state.isBusy(friend.docId),
                onAccept: () => _accept(ref, friend, l10n),
                onDecline: () => _decline(ref, friend, l10n),
              );
            },
          );
        },
      ),
    );
  }
}
