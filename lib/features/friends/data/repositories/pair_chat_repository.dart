import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/friends/data/repositories/friends_repository.dart'
    show mapAppwriteFriendsException;
import 'package:resonate/features/live_audio/data/livekit_join.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:resonate/core/services/room_join_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/pair_chat_repository.g.dart';

@Riverpod(keepAlive: true)
PairChatRepository pairChatRepository(Ref ref) => PairChatRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  roomJoin: ref.watch(roomJoinServiceProvider),
);

class PairChatRepository {
  PairChatRepository({
    required TablesDB tables,
    required Realtime realtime,
    required RoomJoinService roomJoin,
  }) : _tables = tables,
       _realtime = realtime,
       _roomJoin = roomJoin;

  final TablesDB _tables;
  final Realtime _realtime;
  final RoomJoinService _roomJoin;

  static String activePairsChannel() =>
      'databases.$masterDatabaseId.tables.$activePairsTableId.rows';

  Future<String> createPairRequest({
    required Map<String, dynamic> data,
  }) async {
    try {
      final requestDoc = await _tables.createRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: ID.unique(),
        data: data,
      );
      return requestDoc.$id;
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Future<void> convertRequestToRandom(String requestDocId) async {
    try {
      await _tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: requestDocId,
        data: <String, dynamic>{'isRandom': true},
      );
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Future<void> deletePairRequest(String requestDocId) async {
    try {
      await _tables.deleteRow(
        databaseId: masterDatabaseId,
        tableId: pairRequestTableId,
        rowId: requestDocId,
      );
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Future<List<ResonateUser>> listOnlineUsers({required String excludeUid}) async {
    final result = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: pairRequestTableId,
      queries: [
        Query.notEqual('uid', excludeUid),
        Query.notEqual('isAnonymous', true),
        Query.limit(100),
      ],
    );

    final users = <ResonateUser>[];
    for (final doc in result.rows) {
      try {
        users.add(ResonateUser.fromJson({...doc.data, 'docId': doc.$id}));
      } catch (_) {
        // Skip rows that have missing/malformed fields.
      }
    }
    return users;
  }

  Future<void> createActivePair({
    required String uid1,
    required String uid2,
    String? userName1,
    String? userName2,
    String? requestDocId1,
    String? requestDocId2,
  }) async {
    try {
      await _tables.createRow(
        databaseId: masterDatabaseId,
        tableId: activePairsTableId,
        rowId: ID.unique(),
        data: <String, dynamic>{
          'uid1': uid1,
          'uid2': uid2,
          'userName1': userName1,
          'userName2': userName2,
          'userDocId1': requestDocId1,
          'userDocId2': requestDocId2,
        },
      );
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  // Deleting an already-deleted pair is fine — the other side ended first.
  Future<void> deleteActivePair(String activePairDocId) async {
    try {
      await _tables.deleteRow(
        databaseId: masterDatabaseId,
        tableId: activePairsTableId,
        rowId: activePairDocId,
      );
    } on AppwriteException catch (e) {
      if (e.code == 404 || e.type == 'document_not_found') return;
      throw mapAppwriteFriendsException(e);
    }
  }

  Future<String?> getUserProfileImageUrl(String uid) async {
    try {
      final userDoc = await _tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: uid,
      );
      return userDoc.data['profileImageUrl'] as String?;
    } catch (_) {
      // Missing user rows shouldn't kill a match.
      return null;
    }
  }

  Future<void> updateUserRating({
    required String uid,
    required double ratingTotal,
    required int ratingCount,
  }) async {
    try {
      await _tables.updateRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: uid,
        data: <String, dynamic>{
          'ratingTotal': ratingTotal,
          'ratingCount': ratingCount,
        },
      );
    } on AppwriteException catch (e) {
      throw mapAppwriteFriendsException(e);
    }
  }

  Stream<RealtimeMessage> activePairsStream() {
    final subscription = _realtime.subscribe([activePairsChannel()]);
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

  Stream<RealtimeMessage> pairRequestsStream() {
    final channel = 'databases.$masterDatabaseId.tables.$pairRequestTableId.rows';
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

  Future<({String liveKitUri, String roomToken})> pairJoinInfo({
    required String roomId,
    required String userId,
  }) async {
    final response = await _roomJoin.joinRoom(roomId, userId);
    return liveKitJoinFromResponse(response);
  }
}
