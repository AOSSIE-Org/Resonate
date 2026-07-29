import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/rooms/data/livekit_join.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/features/friends/data/repositories/friends_repository.dart'
    show mapAppwriteFriendsException;
import 'package:resonate/core/services/room_join_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/friend_call_repository.g.dart';

@Riverpod(keepAlive: true)
FriendCallRepository friendCallRepository(Ref ref) => FriendCallRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  functions: ref.watch(appwriteFunctionsProvider),
  roomJoin: ref.watch(roomJoinServiceProvider),
);

class FriendCallRepository {
  FriendCallRepository({
    required TablesDB tables,
    required Realtime realtime,
    required Functions functions,
    required RoomJoinService roomJoin,
  }) : _tables = tables,
       _realtime = realtime,
       _functions = functions,
       _roomJoin = roomJoin;

  final TablesDB _tables;
  final Realtime _realtime;
  final Functions _functions;
  final RoomJoinService _roomJoin;

  Future<FriendCallModel> createCall({
    required String callerName,
    required String recieverName,
    required String callerUsername,
    required String recieverUsername,
    required String callerUid,
    required String recieverUid,
    required String callerProfileImageUrl,
    required String recieverProfileImageUrl,
    required String livekitRoomId,
  }) async {
    try {
      final callModel = FriendCallModel(
        callerName: callerName,
        recieverName: recieverName,
        callerUsername: callerUsername,
        recieverUsername: recieverUsername,
        callerUid: callerUid,
        recieverUid: recieverUid,
        callerProfileImageUrl: callerProfileImageUrl,
        recieverProfileImageUrl: recieverProfileImageUrl,
        livekitRoomId: livekitRoomId,
        callStatus: FriendCallStatus.waiting,
        docId: ID.unique(),
      );
      await _tables.createRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsTableId,
        rowId: callModel.docId,
        data: callModel.toJson(),
      );
      return callModel;
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  // Triggers the cloud function that delivers the incoming-call FCM push.
  Future<void> sendCallNotification({
    required FriendCallModel call,
    required String recieverFCMToken,
  }) async {
    final notificationData = {
      "recieverFCMToken": recieverFCMToken,
      "data": {
        "caller_name": call.callerName,
        "caller_username": call.callerUsername,
        "caller_profile_image_url": call.callerProfileImageUrl,
        "caller_uid": call.callerUid,

        "call_id": call.docId,
        "type": "incoming_call",
        "extra": jsonEncode(call.toJson()),
        "livekit_room_id": call.livekitRoomId,
      },
    };
    await _functions.createExecution(
      functionId: startFriendCallFunctionID,
      body: jsonEncode(notificationData),
    );
  }

  Future<FriendCallModel> getCall(String callId) async {
    try {
      final callDoc = await _tables.getRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsTableId,
        rowId: callId,
      );
      return FriendCallModel.fromJson(callDoc.data);
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Future<FriendCallModel> setCallStatus(
    FriendCallModel call,
    FriendCallStatus status,
  ) async {
    try {
      final updated = call.copyWith(callStatus: status);
      await _tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsTableId,
        rowId: updated.docId,
        data: updated.toJson(),
      );
      return updated;
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Stream<RealtimeMessage> callStream(String callDocId) {
    final channel =
        'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.$callDocId';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<RealtimeMessage>();
    final sub = subscription.stream.listen((event) {
      if (event.payload.isNotEmpty) controller.add(event);
    });
    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }

  Future<({String liveKitUri, String roomToken})> callJoinInfo({
    required String roomId,
    required String userId,
  }) async {
    final response = await _roomJoin.joinRoom(roomId, userId);
    return liveKitJoinFromResponse(response);
  }
}
