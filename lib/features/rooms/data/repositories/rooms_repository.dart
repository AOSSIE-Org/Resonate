import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/live_audio/data/livekit_join.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/room_failure.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/core/services/execute_function.dart';
import 'package:resonate/core/services/room_join_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/rooms_repository.g.dart';

@Riverpod(keepAlive: true)
RoomsRepository roomsRepository(Ref ref) => RoomsRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  functions: ref.watch(appwriteFunctionsProvider),
  roomJoin: ref.watch(roomJoinServiceProvider),
);

class RoomsRepository {
  RoomsRepository({
    required TablesDB tables,
    required Realtime realtime,
    required Functions functions,
    required RoomJoinService roomJoin,
    FlutterSecureStorage? secureStorage,
  }) : _tables = tables,
       _realtime = realtime,
       _functions = functions,
       _roomJoin = roomJoin,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final TablesDB _tables;
  final Realtime _realtime;
  final Functions _functions;
  final RoomJoinService _roomJoin;
  final FlutterSecureStorage _secureStorage;

  TablesDB get tables => _tables;

  static const _pageSize = 100;

  // How many member avatars the room card shows.
  static const _avatarCount = 3;

  Future<List<AppwriteRoom>> loadRooms(String userUid) async {
    final result = await _tables.listRows(
      databaseId: databaseId,
      tableId: roomsTableId,
      queries: [Query.limit(_pageSize)],
    );

    final rooms = await _buildAppwriteRooms(result.rows, userUid);
    return [
      for (final room in rooms)
        if (!room.reportedUsers.contains(userUid)) room,
    ];
  }

  Future<AppwriteRoom?> getRoomById(String roomId, String userUid) async {
    try {
      final row = await _tables.getRow(
        databaseId: databaseId,
        tableId: roomsTableId,
        rowId: roomId,
      );
      final rooms = await _buildAppwriteRooms([row], userUid);
      return rooms.isEmpty ? null : rooms.first;
    } on AppwriteException catch (e) {
      if (e.code == 404) return null;
      throw RoomFailure.fromAppwrite(e);
    }
  }

  Future<List<AppwriteRoom>> _buildAppwriteRooms(
    List<Row> rows,
    String userUid,
  ) async {
    if (rows.isEmpty) return const [];

    final uidsByRoom = await _avatarUidsByRoom([
      for (final row in rows) row.$id,
    ]);
    final avatars = await _avatarUrls({
      for (final uids in uidsByRoom.values) ...uids,
    });

    final rooms = <AppwriteRoom>[];
    for (final row in rows) {
      try {
        final data = row.data;
        rooms.add(
          AppwriteRoom(
            id: row.$id,
            name: (data['name'] as String?) ?? 'Untitled',
            description: (data['description'] as String?) ?? '',
            totalParticipants:
                (data['totalParticipants'] as num?)?.toInt() ?? 0,
            tags: List<String>.from(data['tags'] as List? ?? const []),
            memberAvatarUrls: [
              for (final uid in uidsByRoom[row.$id] ?? const <String>[])
                if (avatars[uid] case final url?) url,
            ],
            state: RoomState.live,
            isUserAdmin: data['adminUid'] == userUid,
            reportedUsers: List<String>.from(
              data['reportedUsers'] as List? ?? const [],
            ),
          ),
        );
      } catch (_) {
        // Skiping rows that have missing/malformed fields.
      }
    }
    return rooms;
  }

  Stream<RealtimeMessage> roomStream() => _rowStream(roomsTableId);

  // The first few participant uids of each room, in one query over all of them.
  Future<Map<String, List<String>>> _avatarUidsByRoom(
    List<String> roomIds,
  ) async {
    final byRoom = <String, List<String>>{};
    if (roomIds.isEmpty) return byRoom;
    try {
      final result = await _tables.listRows(
        databaseId: databaseId,
        tableId: participantsTableId,
        queries: [
          Query.equal('roomId', roomIds),
          Query.select(['roomId', 'uid']),
          // Enough to fill _avatarCount slots per room with room to spare.
          Query.limit(roomIds.length * _avatarCount * 4),
        ],
      );
      for (final row in result.rows) {
        final roomId = row.data['roomId'];
        final uid = row.data['uid'];
        if (roomId is! String || uid is! String) continue;
        final slots = byRoom.putIfAbsent(roomId, () => <String>[]);
        if (slots.length < _avatarCount) slots.add(uid);
      }
    } catch (_) {
      // Skiping avatars we can't fetch; the rooms still render.
    }
    return byRoom;
  }

  Future<List<Row>> _usersByIds(Set<String> uids, List<String> columns) async {
    if (uids.isEmpty) return const [];
    final ids = uids.toList();
    final rows = <Row>[];
    for (var i = 0; i < ids.length; i += _pageSize) {
      final end = i + _pageSize > ids.length ? ids.length : i + _pageSize;
      final chunk = ids.sublist(i, end);
      final result = await _tables.listRows(
        databaseId: databaseId,
        tableId: usersTableID,
        queries: [
          Query.equal(r'$id', chunk),
          Query.select([r'$id', ...columns]),
          Query.limit(chunk.length),
        ],
      );
      rows.addAll(result.rows);
    }
    return rows;
  }

  Future<Map<String, String>> _avatarUrls(Set<String> uids) async {
    final urls = <String, String>{};
    try {
      for (final row in await _usersByIds(uids, const ['profileImageUrl'])) {
        final url = row.data['profileImageUrl'];
        if (url is String && url.isNotEmpty) urls[row.$id] = url;
      }
    } catch (_) {
      // Skiping avatars we can't fetch.
    }
    return urls;
  }

  Future<Map<String, Row>> _userRows(Set<String> uids) async {
    final rows = await _usersByIds(uids, const [
      'email',
      'name',
      'profileImageUrl',
    ]);
    return {for (final row in rows) row.$id: row};
  }

  Future<({String roomId, String myDocId, String liveKitUri, String roomToken})>
  createRoom({
    required String name,
    required String description,
    required List<String> tags,
    required String adminUid,
  }) async {
    try {
      final response = await _functions.execute(
        functionId: createRoomServiceId,
        body: {
          'name': name,
          'description': description,
          'adminUid': adminUid,
          'tags': tags,
        },
      );
      final roomId = response['livekit_room']['name'] as String;
      final join = liveKitJoinFromResponse(response);

      await _secureStorage.write(
        key: 'createdRoomAdminToken',
        value: join.roomToken,
      );
      await _secureStorage.write(
        key: 'createdRoomLivekitUrl',
        value: join.liveKitUri,
      );

      final myDocId = await _addParticipant(
        roomId: roomId,
        uid: adminUid,
        isAdmin: true,
      );

      return (
        roomId: roomId,
        myDocId: myDocId,
        liveKitUri: join.liveKitUri,
        roomToken: join.roomToken,
      );
    } on AppwriteException catch (e) {
      throw RoomFailure.fromAppwrite(e);
    }
  }

  Future<({String myDocId, String liveKitUri, String roomToken})> joinRoom({
    required String roomId,
    required String userId,
    required bool isAdmin,
  }) async {
    try {
      final response = await _roomJoin.joinRoom(roomId, userId);
      final join = liveKitJoinFromResponse(response);

      final myDocId = await _addParticipant(
        roomId: roomId,
        uid: userId,
        isAdmin: isAdmin,
      );

      return (
        myDocId: myDocId,
        liveKitUri: join.liveKitUri,
        roomToken: join.roomToken,
      );
    } on AppwriteException catch (e) {
      throw RoomFailure.fromAppwrite(e);
    }
  }

  Future<String> _addParticipant({
    required String roomId,
    required String uid,
    required bool isAdmin,
  }) async {
    final existing = await _tables.listRows(
      databaseId: databaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal('uid', [uid]),
        Query.equal('roomId', [roomId]),
      ],
    );
    for (final doc in existing.rows) {
      await _tables.deleteRow(
        databaseId: databaseId,
        tableId: participantsTableId,
        rowId: doc.$id,
      );
    }

    final participantDoc = await _tables.createRow(
      databaseId: databaseId,
      tableId: participantsTableId,
      rowId: ID.unique(),
      data: {
        'roomId': roomId,
        'room': roomId,
        'uid': uid,
        'isAdmin': isAdmin,
        'isModerator': isAdmin,
        'isSpeaker': isAdmin,
        'isMicOn': false,
      },
    );

    if (!isAdmin) {
      await _bumpParticipantCount(roomId, 1 - existing.rows.length);
    }

    return participantDoc.$id;
  }

  Future<int?> _bumpParticipantCount(String roomId, int delta) async {
    if (delta == 0) return null;
    final row = delta > 0
        ? await _tables.incrementRowColumn(
            databaseId: databaseId,
            tableId: roomsTableId,
            rowId: roomId,
            column: 'totalParticipants',
            value: delta.toDouble(),
          )
        : await _tables.decrementRowColumn(
            databaseId: databaseId,
            tableId: roomsTableId,
            rowId: roomId,
            column: 'totalParticipants',
            value: (-delta).toDouble(),
          );
    return (row.data['totalParticipants'] as num?)?.toInt();
  }

  Future<bool> leaveRoom({
    required String roomId,
    required String userId,
  }) async {
    try {
      final participantDocs = await _tables.listRows(
        databaseId: databaseId,
        tableId: participantsTableId,
        queries: [
          Query.equal('uid', [userId]),
          Query.equal('roomId', [roomId]),
        ],
      );
      await Future.wait([
        for (final doc in participantDocs.rows)
          _tables.deleteRow(
            databaseId: databaseId,
            tableId: participantsTableId,
            rowId: doc.$id,
          ),
      ]);

      final remaining =
          await _bumpParticipantCount(roomId, -participantDocs.rows.length) ??
          await _participantCount(roomId);
      if (remaining <= 0) {
        await _tables.deleteRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: roomId,
        );
      }
      return true;
    } on AppwriteException catch (e) {
      throw RoomFailure.fromAppwrite(e);
    }
  }

  Future<int> _participantCount(String roomId) async {
    final row = await _tables.getRow(
      databaseId: databaseId,
      tableId: roomsTableId,
      rowId: roomId,
      queries: [
        Query.select(['totalParticipants']),
      ],
    );
    return (row.data['totalParticipants'] as num?)?.toInt() ?? 0;
  }

  Future<void> _deleteParticipantRow(String rowId) => _tables.deleteRow(
    databaseId: databaseId,
    tableId: participantsTableId,
    rowId: rowId,
  );

  Future<void> deleteRoom({required String roomId}) async {
    try {
      final token = await _secureStorage.read(key: 'createdRoomAdminToken');
      if (token != null) {
        try {
          await _functions.execute(
            functionId: deleteRoomServiceId,
            body: {'appwriteRoomDocId': roomId, 'token': token},
          );
        } catch (_) {}
      }
      try {
        final participantDocs = await _tables.listRows(
          databaseId: databaseId,
          tableId: participantsTableId,
          queries: [
            Query.equal('roomId', [roomId]),
          ],
        );
        Row? adminRow;
        for (final doc in participantDocs.rows) {
          if ((doc.data['isAdmin'] as bool?) ?? false) {
            adminRow = doc;
            break;
          }
        }
        if (adminRow != null) await _deleteParticipantRow(adminRow.$id);

        await Future.wait([
          for (final doc in participantDocs.rows)
            if (doc.$id != adminRow?.$id) _deleteParticipantRow(doc.$id),
        ]);
      } catch (_) {}
      // Ensure the room doc is deleted even when the server call above failed
      try {
        await _tables.deleteRow(
          databaseId: databaseId,
          tableId: roomsTableId,
          rowId: roomId,
        );
      } on AppwriteException catch (e) {
        if (e.code != 404) rethrow;
      }
    } on AppwriteException catch (e) {
      throw RoomFailure.fromAppwrite(e);
    }
  }

  Future<List<Participant>> loadParticipants(String roomId) async {
    final result = await _tables.listRows(
      databaseId: databaseId,
      tableId: participantsTableId,
      queries: [Query.equal('roomId', roomId), Query.limit(_pageSize)],
    );

    // One user query for the whole room, not one per participant.
    final users = await _userRows({
      for (final row in result.rows)
        if (row.data['uid'] case final String uid) uid,
    });

    final participants = <Participant>[];
    for (final row in result.rows) {
      try {
        participants.add(_participantFrom(row.data, users[row.data['uid']]));
      } catch (_) {
        // Skiping rows that have missing/malformed fields.
      }
    }
    return participants;
  }

  // Takes the map, not a Row: Row.fromMap throws without $sequence, which a
  // realtime payload need not carry.
  Future<Participant> buildParticipantFromData(
    Map<String, dynamic> data,
  ) async {
    final uid = data['uid'] as String;
    final users = await _userRows({uid});
    return _participantFrom(data, users[uid]);
  }

  Participant _participantFrom(Map<String, dynamic> data, Row? userDoc) {
    if (userDoc == null) {
      throw StateError('No user row for participant ${data['uid']}');
    }
    return Participant(
      uid: data['uid'] as String,
      // Soft: a user row with no email should not cost us the participant.
      email: userDoc.data['email'] as String? ?? '',
      name: userDoc.data['name'] as String? ?? 'Unknown',
      dpUrl: userDoc.data['profileImageUrl'] as String? ?? '',
      isAdmin: data['isAdmin'] as bool? ?? false,
      isMicOn: data['isMicOn'] as bool? ?? false,
      isModerator: data['isModerator'] as bool? ?? false,
      isSpeaker: data['isSpeaker'] as bool? ?? false,
      hasRequestedToBeSpeaker:
          data['hasRequestedToBeSpeaker'] as bool? ?? false,
    );
  }

  Stream<RealtimeMessage> participantStream(String roomId) =>
      _rowStream(participantsTableId, roomId: roomId);

  // Participant rows carry only the uid and the role flags, so a rename or a
  // new avatar never shows up on the participants channel. Watch users too.
  Stream<RealtimeMessage> userProfileStream() => _rowStream(usersTableID);

  Stream<RealtimeMessage> _rowStream(String tableId, {String? roomId}) {
    final channel = 'databases.$databaseId.tables.$tableId.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<RealtimeMessage>();
    final sub = subscription.stream.listen((event) {
      if (event.payload.isEmpty) return;
      if (roomId != null && event.payload['roomId'] != roomId) return;
      controller.add(event);
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
      databaseId: databaseId,
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
      databaseId: databaseId,
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
      databaseId: databaseId,
      tableId: roomsTableId,
      rowId: roomId,
      data: {
        'reportedUsers': [...currentReported, participantUid],
      },
    );
  }

  /// Files a user report. Was previously written straight from the report
  /// dialog, which put an SDK call in a widget.
  Future<void> submitUserReport(UserReportModel report) async {
    await _tables.createRow(
      databaseId: databaseId,
      tableId: userReportsTableID,
      rowId: ID.unique(),
      data: report.toJson(),
    );
  }

  Future<void> kickParticipant(String docId) async {
    await _tables.deleteRow(
      databaseId: databaseId,
      tableId: participantsTableId,
      rowId: docId,
    );
  }

  static String participantChannel() =>
      'databases.$databaseId.tables.$participantsTableId.rows';
}
