import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friends_repository.g.dart';

@Riverpod(keepAlive: true)
FriendsRepository friendsRepository(Ref ref) => FriendsRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  messaging: ref.watch(firebaseMessagingProvider),
);

class FriendsRepository {
  FriendsRepository({
    required TablesDB tables,
    required Realtime realtime,
    required FirebaseMessaging messaging,
  }) : _tables = tables,
       _realtime = realtime,
       _messaging = messaging;

  final TablesDB _tables;
  final Realtime _realtime;
  final FirebaseMessaging _messaging;

  Future<({List<FriendsModel> friends, List<FriendsModel> requests})>
  loadFriends(String uid) async {
    final userDoc = await _tables.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      queries: [
        Query.select(["*", "friends.*"]),
      ],
    );

    final friends = <FriendsModel>[];
    final requests = <FriendsModel>[];
    for (final friend in (userDoc.data['friends'] ?? []) as List<dynamic>) {
      try {
        final model = FriendsModel.fromJson(friend);
        if (model.requestStatus == FriendRequestStatus.accepted) {
          friends.add(model);
        } else {
          requests.add(model);
        }
      } catch (_) {
        // Skip rows that have missing/malformed fields.
      }
    }
    return (friends: friends, requests: requests);
  }

  Future<FriendsModel> sendFriendRequest({
    required AuthUser sender,
    required String recieverId,
    required String recieverProfileImageUrl,
    required String recieverUsername,
    required String recieverName,
    required double recieverRating,
  }) async {
    try {
      final docId = ID.unique();
      final senderFCMToken = await _messaging.getToken();

      final friendModel = FriendsModel(
        senderId: sender.uid,
        recieverId: recieverId,
        senderProfileImgUrl: sender.profileImageUrl!,
        recieverProfileImgUrl: recieverProfileImageUrl,
        senderUsername: sender.userName!,
        recieverUsername: recieverUsername,
        senderName: sender.displayName,
        recieverName: recieverName,
        requestStatus: FriendRequestStatus.sent,
        requestSentByUserId: sender.uid,
        docId: docId,
        senderFCMToken: senderFCMToken,
        users: [sender.uid, recieverId],
        senderRating: sender.ratingCount == 0
            ? 0
            : sender.ratingTotal / sender.ratingCount,
        recieverRating: recieverRating,
      );
      await _tables.createRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: docId,
        data: friendModel.toJson(),
      );
      return friendModel;
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Future<FriendsModel> acceptFriendRequest(FriendsModel friendModel) async {
    try {
      final recieverFCMToken = await _messaging.getToken();

      final updated = friendModel.copyWith(
        requestStatus: FriendRequestStatus.accepted,
        recieverFCMToken: recieverFCMToken,
        users: [friendModel.senderId, friendModel.recieverId],
      );
      await _tables.updateRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: friendModel.docId,
        data: updated.toJson(),
      );
      return updated;
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  // Used for both declining a request and removing an accepted friend.
  Future<void> deleteFriendRow(String docId) async {
    try {
      await _tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: docId,
      );
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  // Emits every friends-table change involving uid.
  Stream<RealtimeMessage> friendsStream(String uid) {
    final channel = 'databases.$userDatabaseID.tables.$friendsTableID.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<RealtimeMessage>();
    final sub = subscription.stream.listen((event) {
      if (event.payload.isNotEmpty &&
          (event.payload['senderId'] == uid ||
              event.payload['recieverId'] == uid)) {
        controller.add(event);
      }
    });
    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }
}

FriendsFailure mapAppwriteFriendsException(AppwriteException e) {
  return switch (e.code) {
    404 => const FriendsFailure.notFound(),
    401 || 403 => const FriendsFailure.permissionDenied(),
    _ => FriendsFailure.unknown(e.message ?? e.toString()),
  };
}
