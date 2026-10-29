import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/features/friends/model/friends_failure.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/features/shell/model/notification.dart';
import 'package:resonate/utils/dev_log.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';
import 'package:resonate/utils/enums/notification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friends_repository.g.dart';

@Riverpod(keepAlive: true)
FriendsRepository friendsRepository(Ref ref) => FriendsRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  functions: ref.watch(appwriteFunctionsProvider),
);

class FriendsRepository {
  FriendsRepository({
    required TablesDB tables,
    required Realtime realtime,
    required Functions functions,
  }) : _tables = tables,
       _functions = functions,
       _realtime = realtime;

  final TablesDB _tables;
  final Realtime _realtime;
  final Functions _functions;

  // Best effort, like the like/follow/subscribe notifications: the row is
  // already written, so a failed push must not fail the request itself.
  Future<void> _notify({
    required String targetUid,
    required String title,
    required String body,
    required NotificationType type,
    required String initiatorUsername,
    required String initiatorProfileImgUrl,
    required String subject,
  }) async {
    try {
      await _functions.createExecution(
        functionId: sendSocialNotificationFunctionID,
        body: json.encode({
          'targetUid': targetUid,
          'payload': {'title': title, 'body': body},
          'data': NotificationModel(
            notificationType: type,
            initiatorUsername: initiatorUsername,
            initiatorProfileImgUrl: initiatorProfileImgUrl,
            subject: subject,
            isTagInUpcomingRoom: false,
          ).toJson(),
        }),
      );
    } catch (e) {
      log('Failed to send friend notification: $e');
    }
  }

  Future<({List<FriendsModel> friends, List<FriendsModel> requests})>
  loadFriends(String uid) async {
    final userDoc = await _tables.getRow(
      databaseId: databaseId,
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
      final friendModel = FriendsModel(
        senderId: sender.uid,
        recieverId: recieverId,
        senderProfileImgUrl: sender.profileImageUrl ?? '',
        recieverProfileImgUrl: recieverProfileImageUrl,
        senderUsername: sender.userName ?? '',
        recieverUsername: recieverUsername,
        senderName: sender.displayName,
        recieverName: recieverName,
        requestStatus: FriendRequestStatus.sent,
        requestSentByUserId: sender.uid,
        docId: docId,
        users: [sender.uid, recieverId],
        senderRating: sender.ratingCount == 0
            ? 0
            : sender.ratingTotal / sender.ratingCount,
        recieverRating: recieverRating,
      );
      await _tables.createRow(
        databaseId: databaseId,
        tableId: friendsTableID,
        rowId: docId,
        data: friendModel.toJson(),
      );
      await _notify(
        targetUid: recieverId,
        title: 'New friend request',
        body: '${sender.userName ?? sender.displayName} sent you a friend request',
        type: NotificationType.friendRequest,
        initiatorUsername: sender.userName ?? '',
        initiatorProfileImgUrl: sender.profileImageUrl ?? '',
        subject: sender.displayName,
      );
      return friendModel;
    } on AppwriteException catch (e) {
      throw FriendsFailure.fromAppwrite(e);
    }
  }

  Future<FriendsModel> acceptFriendRequest(FriendsModel friendModel) async {
    try {
      final updated = friendModel.copyWith(
        requestStatus: FriendRequestStatus.accepted,
        users: [friendModel.senderId, friendModel.recieverId],
      );
      await _tables.updateRow(
        databaseId: databaseId,
        tableId: friendsTableID,
        rowId: friendModel.docId,
        data: updated.toJson(),
      );
      // The accepter is whichever side did not send the request.
      final accepterIsReciever =
          friendModel.requestSentByUserId == friendModel.senderId;
      await _notify(
        targetUid: friendModel.requestSentByUserId,
        title: 'Friend request accepted',
        body:
            '${accepterIsReciever ? friendModel.recieverUsername : friendModel.senderUsername} accepted your friend request',
        type: NotificationType.friendAccepted,
        initiatorUsername: accepterIsReciever
            ? friendModel.recieverUsername
            : friendModel.senderUsername,
        initiatorProfileImgUrl: accepterIsReciever
            ? friendModel.recieverProfileImgUrl
            : friendModel.senderProfileImgUrl,
        subject: accepterIsReciever
            ? friendModel.recieverName
            : friendModel.senderName,
      );
      return updated;
    } on AppwriteException catch (e) {
      throw FriendsFailure.fromAppwrite(e);
    }
  }

  // Used for both declining a request and removing an accepted friend.
  Future<void> deleteFriendRow(String docId) async {
    try {
      await _tables.deleteRow(
        databaseId: databaseId,
        tableId: friendsTableID,
        rowId: docId,
      );
    } on AppwriteException catch (e) {
      throw FriendsFailure.fromAppwrite(e);
    }
  }

  // Emits every friends-table change involving uid.
  Stream<RealtimeMessage> friendsStream(String uid) {
    final channel = 'databases.$databaseId.tables.$friendsTableID.rows';
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
