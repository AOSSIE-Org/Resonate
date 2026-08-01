import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:resonate/features/friends/data/services/pair_chat_session.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

class PairChatUsersPage extends ConsumerStatefulWidget {
  const PairChatUsersPage({super.key});

  @override
  ConsumerState<PairChatUsersPage> createState() => _PairChatUsersPageState();
}

class _PairChatUsersPageState extends ConsumerState<PairChatUsersPage> {
  late final PairChat _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(pairChatProvider.notifier);
    _notifier.loadUsers();
  }

  @override
  void dispose() {
    _notifier.cancelRequest();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(pairChatProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.onlineUsers),
        actions: [
          IconButton(
            onPressed: () async {
              final router = GoRouter.of(context);
              await _notifier.convertToRandom();
              router.push(RoutePaths.pairing);
            },
            icon: Icon(Icons.casino_outlined),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: UiSizes.width_16),
      ),
      body: chatState.isUserListLoading
          ? Center(child: CircularProgressIndicator())
          : chatState.onlineUsers.isEmpty
          ? Center(child: Text(AppLocalizations.of(context)!.noOnlineUsers))
          : ListView.builder(
              itemCount: chatState.onlineUsers.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final user = chatState.onlineUsers[index];
                return ListTile(
                  onTap: () async {
                    await _notifier.pairWithSelectedUser(user);
                  },
                  title: Text(user.userName ?? ''),
                  subtitle: Text(user.name ?? ''),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImageUrl ?? ''),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text((user.userRating ?? 0).toStringAsFixed(1)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
