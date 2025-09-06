import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';

class PairChatUsersScreen extends StatefulWidget {
  const PairChatUsersScreen({super.key});

  @override
  State<PairChatUsersScreen> createState() => _PairChatUsersScreenState();
}

class _PairChatUsersScreenState extends State<PairChatUsersScreen> {
  final PairChatController pairChatController = Get.find<PairChatController>();

  @override
  void initState() {
    super.initState();
    pairChatController.loadUsers();
  }

  @override
  void dispose() {
    pairChatController.cancelRequest();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.onlineUsers),
        actions: [
          IconButton(
            onPressed: () async {
              await pairChatController.convertToRandom();
            },
            icon: Icon(Icons.casino_outlined),
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 16.0),
      ),
      body: Obx(
        () => pairChatController.isUserListLoading.value
            ? Center(child: CircularProgressIndicator())
            : pairChatController.usersList.isEmpty
            ? Center(child: Text(AppLocalizations.of(context)!.noOnlineUsers))
            : ListView.builder(
                itemCount: pairChatController.usersList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      await pairChatController.pairWithSelectedUser(
                        pairChatController.usersList[index],
                      );
                    },
                    title: Text(pairChatController.usersList[index].userName!),
                    subtitle: Text(pairChatController.usersList[index].name!),

                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        pairChatController.usersList[index].profileImageUrl!,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Text(
                          pairChatController.usersList[index].userRating!
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                    // ...other fields
                  );
                },
              ),
      ),
    );
  }
}
