import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/services/api_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/rooms_repository.g.dart';

@Riverpod(keepAlive: true)
RoomsRepository roomsRepository(Ref ref) => RoomsRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  apiService: ApiService(functions: ref.watch(appwriteFunctionsProvider)),
);

class RoomsRepository {
  RoomsRepository({
    required TablesDB tables,
    required Realtime realtime,
    required ApiService apiService,
    FlutterSecureStorage? secureStorage,
  }) : _tables = tables,
       _realtime = realtime,
       _api = apiService,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final TablesDB _tables;
  final Realtime _realtime;
  final ApiService _api;
  final FlutterSecureStorage _secureStorage;

  TablesDB get tables => _tables;

  Future<List<AppwriteRoom>> loadRooms(String userUid) async {
    final result = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: roomsTableId,
    );

    final rooms = <AppwriteRoom>[];
    for (final row in result.rows) {
      try {
        final room = await _buildAppwriteRoom(row, userUid);
        if (!room.reportedUsers.contains(userUid)) {
          rooms.add(room);
        }
      } catch (_) {
        // Skiping rows that have missing/malformed fields.
      }
    }
    return rooms;
  }

  Future<AppwriteRoom?> getRoomById(String roomId, String userUid) async {
    try {
      final row = await _tables.getRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
      );
      return _buildAppwriteRoom(row, userUid);
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      throw _mapException(e);
    }
  }

  Future<AppwriteRoom> _buildAppwriteRoom(Row row, String userUid) async {
    final participantList = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [Query.equal('roomId', row.$id), Query.limit(3)],
    );

    final memberAvatarUrls = <String>[];
    for (final p in participantList.rows) {
      try {
        final userDoc = await _tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: p.data['uid'] as String,
        );
        final url = userDoc.data['profileImageUrl'];
        if (url is String) memberAvatarUrls.add(url);
      } catch (_) {
        // Skiping avatars we can't fetch.
      }
    }

    final data = row.data;
    return AppwriteRoom(
      id: row.$id,
      name: (data['name'] as String?) ?? 'Untitled',
      description: (data['description'] as String?) ?? '',
      totalParticipants: (data['totalParticipants'] as num?)?.toInt() ?? 0,
      tags: List<String>.from(data['tags'] as List? ?? const []),
      memberAvatarUrls: memberAvatarUrls,
      state: RoomState.live,
      isUserAdmin: data['adminUid'] == userUid,
      reportedUsers:
          List<String>.from(data['reportedUsers'] as List? ?? const []),
    );
  }

  Future<({String roomId, String myDocId, String liveKitUri, String roomToken})>
  createRoom({
    required String name,
    required String description,
    required List<String> tags,
    required String adminUid,
  }) async {
    try {
      final response = await _api.createRoom(name, description, adminUid, tags);
      final roomId = response['livekit_room']['name'] as String;
      final roomToken = response['access_token'] as String;
      final socketUrl = response['livekit_socket_url'] as String;
      final liveKitUri = socketUrl == 'wss://host.docker.internal:7880'
          ? localhostLivekitEndpoint
          : socketUrl;

      await _secureStorage.write(key: 'createdRoomAdminToken', value: roomToken);
      await _secureStorage.write(key: 'createdRoomLivekitUrl', value: liveKitUri);

      final myDocId = await _addParticipant(
        roomId: roomId,
        uid: adminUid,
        isAdmin: true,
      );

      return (
        roomId: roomId,
        myDocId: myDocId,
        liveKitUri: liveKitUri,
        roomToken: roomToken,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  Future<({String myDocId, String liveKitUri, String roomToken})> joinRoom({
    required String roomId,
    required String userId,
    required bool isAdmin,
  }) async {
    try {
      final response = await _api.joinRoom(roomId, userId);
      final roomToken = response['access_token'] as String;
      final socketUrl = response['livekit_socket_url'] as String;
      final liveKitUri = socketUrl == 'wss://host.docker.internal:7880'
          ? localhostLivekitEndpoint
          : socketUrl;

      final myDocId = await _addParticipant(
        roomId: roomId,
        uid: userId,
        isAdmin: isAdmin,
      );

      return (myDocId: myDocId, liveKitUri: liveKitUri, roomToken: roomToken);
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  Future<String> _addParticipant({
    required String roomId,
    required String uid,
    required bool isAdmin,
  }) async {
    final existing = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal('uid', [uid]),
        Query.equal('roomId', [roomId]),
      ],
    );
    for (final doc in existing.rows) {
      await _tables.deleteRow(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        rowId: doc.$id,
      );
    }

    final participantDoc = await _tables.createRow(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      rowId: ID.unique(),
      data: {
        'roomId': roomId,
        'uid': uid,
        'isAdmin': isAdmin,
        'isModerator': isAdmin,
        'isSpeaker': isAdmin,
        'isMicOn': false,
      },
    );

    if (!isAdmin) {
      final roomDoc = await _tables.getRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
      );
      final newCount =
          ((roomDoc.data['totalParticipants'] as num?)?.toInt() ?? 0) -
              existing.rows.length +
              1;
      await _tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
        data: {'totalParticipants': newCount},
      );
    }

    return participantDoc.$id;
  }

  Future<bool> leaveRoom({required String roomId, required String userId}) async {
    try {
      final roomDoc = await _tables.getRow(
        databaseId: masterDatabaseId,
        tableId: roomsTableId,
        rowId: roomId,
      );

      final participantDocs = await _tables.listRows(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        queries: [
          Query.equal('uid', [userId]),
          Query.equal('roomId', [roomId]),
        ],
      );
      for (final doc in participantDocs.rows) {
        await _tables.deleteRow(
          databaseId: masterDatabaseId,
          tableId: participantsTableId,
          rowId: doc.$id,
        );
      }

      final remaining =
          ((roomDoc.data['totalParticipants'] as num?)?.toInt() ?? 0) -
              participantDocs.rows.length;
      if (remaining == 0) {
        await _tables.deleteRow(
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: roomId,
        );
      } else {
        await _tables.updateRow(
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: roomId,
          data: {'totalParticipants': remaining},
        );
      }
      return true;
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> deleteRoom({required String roomId}) async {
    try {
      final token = await _secureStorage.read(key: 'createdRoomAdminToken');
      if (token == null) {
        throw const RoomFailure.permissionDenied();
      }
      await _api.deleteRoom(roomId, token);

      final participantDocs = await _tables.listRows(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        queries: [
          Query.equal('roomId', [roomId]),
        ],
      );
      for (final doc in participantDocs.rows) {
        await _tables.deleteRow(
          databaseId: masterDatabaseId,
          tableId: participantsTableId,
          rowId: doc.$id,
        );
      }
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  Future<List<Participant>> loadParticipants(String roomId) async {
    final result = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [Query.equal('roomId', roomId)],
    );

    final participants = <Participant>[];
    for (final row in result.rows) {
      try {
        participants.add(await buildParticipantFromRow(row));
      } catch (_) {
        // Skiping rows that have missing/malformed fields.
      }
    }
    return participants;
  }

  Future<Participant> buildParticipantFromRow(Row row) async {
    final userDoc = await _tables.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: row.data['uid'] as String,
    );
    return Participant(
      uid: row.data['uid'] as String,
      email: userDoc.data['email'] as String,
      name: userDoc.data['name'] as String? ?? 'Unknown',
      dpUrl: userDoc.data['profileImageUrl'] as String? ?? '',
      isAdmin: row.data['isAdmin'] as bool,
      isMicOn: row.data['isMicOn'] as bool,
      isModerator: row.data['isModerator'] as bool,
      isSpeaker: row.data['isSpeaker'] as bool,
      hasRequestedToBeSpeaker:
          row.data['hasRequestedToBeSpeaker'] as bool? ?? false,
    );
  }

  Stream<RealtimeMessage> participantStream(String roomId) {
    final channel =
        'databases.$masterDatabaseId.tables.$participantsTableId.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<RealtimeMessage>();
    final sub = subscription.stream.listen((event) {
      if (event.payload.isNotEmpty &&
          event.payload['roomId'] == roomId) {
        controller.add(event);
      }
    });
    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }

  Future<String?> getParticipantDocId({
    required String roomId,
    required String participantUid,
  }) async {
    final docs = await _tables.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal('roomId', roomId),
        Query.equal('uid', participantUid),
      ],
    );
    if (docs.rows.isEmpty) return null;
    return docs.rows.first.$id;
  }

  Future<void> updateParticipantDoc({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      rowId: docId,
      data: data,
    );
  }

  Future<void> reportParticipant({
    required String roomId,
    required String participantUid,
    required List<String> currentReported,
  }) async {
    await _tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: roomsTableId,
      rowId: roomId,
      data: {
        'reportedUsers': [...currentReported, participantUid],
      },
    );
  }

  Future<void> kickParticipant(String docId) async {
    await _tables.deleteRow(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      rowId: docId,
    );
  }

  static String participantChannel() =>
      'databases.$masterDatabaseId.tables.$participantsTableId.rows';

  RoomFailure _mapException(AppwriteException e) {
    return switch (e.code) {
      404 => const RoomFailure.notFound(),
      401 || 403 => const RoomFailure.permissionDenied(),
      _ => RoomFailure.unknown(e.message ?? e.toString()),
    };
  }
}
