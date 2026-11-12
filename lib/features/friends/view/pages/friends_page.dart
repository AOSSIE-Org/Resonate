import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/activity_status/view/widgets/activity_dot.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/start_call_outcome.dart';
import 'package:resonate/features/friends/view/widgets/friend_list_tile.dart';
import 'package:resonate/features/friends/view/widgets/friends_empty_view.dart';
import 'package:resonate/features/friends/viewmodel/friends_list_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';

class FriendsPage extends ConsumerWidget {
  const FriendsPage({super.key});

  Future<void> _call(
    WidgetRef ref,
    FriendsModel friend,
    AppLocalizations l10n,
  ) async {
    final notifier = ref.read(friendsListProvider.notifier);
    final otherName = notifier.otherNameOf(friend);
    final outcome = await notifier.startCall(friend);
    switch (outcome) {
      case StartCallStarted():
        break;
      case StartCallBlocked(:final status):
        customSnackbar(
          l10n.callBlocked,
          status.callBlockedMessage(l10n, otherName),
          LogType.info,
        );
      case StartCallFailed(:final message):
        customSnackbar(l10n.error, message, LogType.error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(friendsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.friends)),
      body: state.rows.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const FriendsEmptyView(isRequestsScreen: false),
        data: (friends) {
          if (friends.isEmpty) {
            return const FriendsEmptyView(isRequestsScreen: false);
          }
          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return FriendListTile(
                friendModel: friend,
                isRequest: false,
                isProcessing: state.isBusy(friend.docId),
                onCall: () => _call(ref, friend, l10n),
              );
            },
          );
        },
      ),
    );
  }
}
