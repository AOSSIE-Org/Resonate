import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/shell/model/notification.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/dev_log.dart';
import 'package:resonate/utils/enums/notification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/upcoming_rooms_repository.g.dart';

@Riverpod(keepAlive: true)
UpcomingRoomsRepository upcomingRoomsRepository(Ref ref) =>
    UpcomingRoomsRepository(
      tables: ref.watch(appwriteTablesProvider),
      functions: ref.watch(appwriteFunctionsProvider),
    );

class UpcomingRoomsRepository {
  UpcomingRoomsRepository({
    required TablesDB tables,
    required Functions functions,
  }) : _tables = tables,
       _functions = functions;

  final TablesDB _tables;
  final Functions _functions;

  Future<List<AppwriteUpcomingRoom>> loadUpcoming({
    required String userUid,
    required Set<String> hiddenRoomIds,
  }) async {
    final list = await _tables.listRows(
      databaseId: databaseId,
      tableId: upcomingRoomsTableId,
    );

    final visible = list.rows.where((r) => !hiddenRoomIds.contains(r.$id));
    final upcomingFutures = visible.map(
      (row) => _hydrateUpcomingRoom(row, userUid),
    );
    return Future.wait(upcomingFutures);
  }

  Future<Set<String>> liveUpcomingRoomIds() async {
    final list = await _tables.listRows(
      databaseId: databaseId,
      tableId: upcomingRoomsTableId,
    );
    return list.rows.map((r) => r.$id).toSet();
  }

  Future<AppwriteUpcomingRoom> _hydrateUpcomingRoom(
    Row upcomingRoom,
    String userUid,
  ) async {
    try {
      final subscribers = await _tables.listRows(
        databaseId: databaseId,
        tableId: subscribedUserTableId,
        queries: [
          Query.equal('upcomingRoomId', [upcomingRoom.$id]),
        ],
      );

      final userIsCreator = upcomingRoom.data['creatorUid'] == userUid;
      final subscriberAvatars = <String>[];
      var hasUserSubscribed = false;
      for (final doc in subscribers.rows) {
        subscriberAvatars.add(doc.data['userProfileUrl'] as String);
        if (!userIsCreator && doc.data['userID'] == userUid) {
          hasUserSubscribed = true;
        }
      }

      return AppwriteUpcomingRoom(
        id: upcomingRoom.$id,
        name: upcomingRoom.data['name'] as String,
        isTime: upcomingRoom.data['isTime'] as bool,
        scheduledDateTime: DateTime.parse(
          upcomingRoom.data['scheduledDateTime'] as String,
        ),
        description: upcomingRoom.data['description'] as String,
        totalSubscriberCount: subscribers.rows.length,
        tags: List<String>.from(upcomingRoom.data['tags'] as List? ?? const []),
        subscribersAvatarUrls: subscriberAvatars,
        userIsCreator: userIsCreator,
        hasUserSubscribed: hasUserSubscribed,
      );
    } catch (_) {
      return AppwriteUpcomingRoom(
        id: '',
        name: 'Unknown',
        isTime: false,
        scheduledDateTime: DateTime.now(),
        description: 'Error fetching upcomingRoom details',
        totalSubscriberCount: 0,
        tags: const [],
        subscribersAvatarUrls: const [],
        userIsCreator: false,
        hasUserSubscribed: false,
      );
    }
  }

  Future<void> createUpcomingRoom({
    required String name,
    required String description,
    required List<String> tags,
    required String scheduledDateTime,
    required String creatorUid,
  }) async {
    await _tables.createRow(
      databaseId: databaseId,
      tableId: upcomingRoomsTableId,
      rowId: ID.unique(),
      data: {
        'name': name,
        'scheduledDateTime': scheduledDateTime,
        'tags': tags,
        'description': description,
        'creatorUid': creatorUid,
      },
    );
  }

  Future<void> addSubscriber({
    required String upcomingRoomId,
    required String userUid,
    required String profileImageUrl,
  }) async {
    await _tables.createRow(
      databaseId: databaseId,
      tableId: subscribedUserTableId,
      rowId: ID.unique(),
      data: {
        'userID': userUid,
        'upcomingRoomId': upcomingRoomId,
        'userProfileUrl': profileImageUrl,
      },
    );

    await _notifyHostOfSubscriber(
      upcomingRoomId: upcomingRoomId,
      subscriberUid: userUid,
    );
  }

  Future<void> _notifyHostOfSubscriber({
    required String upcomingRoomId,
    required String subscriberUid,
  }) async {
    try {
      final room = await _tables.getRow(
        databaseId: databaseId,
        tableId: upcomingRoomsTableId,
        rowId: upcomingRoomId,
      );
      final hostUid = room.data['creatorUid'] as String?;
      if (hostUid == null || hostUid == subscriberUid) return;

      final subscriber = await _tables.getRow(
        databaseId: databaseId,
        tableId: usersTableID,
        rowId: subscriberUid,
      );
      final username = (subscriber.data['username'] as String?) ?? '';
      final roomName = (room.data['name'] as String?) ?? '';

      await _functions.createExecution(
        functionId: sendSocialNotificationFunctionID,
        body: json.encode({
          'targetUid': hostUid,
          'payload': {
            'title': 'New subscriber',
            'body': '$username subscribed to "$roomName"',
          },
          'data': NotificationModel(
            notificationType: NotificationType.subscribe,
            initiatorUsername: username,
            initiatorProfileImgUrl:
                (subscriber.data['profileImageUrl'] as String?) ?? '',
            subject: roomName,
            isTagInUpcomingRoom: true,
          ).toJson(),
        }),
      );
    } catch (e) {
      log('Failed to send subscribe notification: $e');
    }
  }

  Future<void> removeSubscriber({
    required String upcomingRoomId,
    required String userUid,
  }) async {
    final result = await _tables.listRows(
      databaseId: databaseId,
      tableId: subscribedUserTableId,
      queries: [
        Query.and([
          Query.equal('userID', userUid),
          Query.equal('upcomingRoomId', upcomingRoomId),
        ]),
      ],
    );
    if (result.rows.isEmpty) return;
    await _tables.deleteRow(
      databaseId: databaseId,
      tableId: subscribedUserTableId,
      rowId: result.rows.first.$id,
    );
  }

  Future<void> deleteUpcomingRoom(String upcomingRoomId) async {
    await _tables.deleteRow(
      databaseId: databaseId,
      tableId: upcomingRoomsTableId,
      rowId: upcomingRoomId,
    );
    final subscribers = await _tables.listRows(
      databaseId: databaseId,
      tableId: subscribedUserTableId,
      queries: [
        Query.equal('upcomingRoomId', [upcomingRoomId]),
      ],
    );
    for (final sub in subscribers.rows) {
      await _tables.deleteRow(
        databaseId: databaseId,
        tableId: subscribedUserTableId,
        rowId: sub.$id,
      );
    }
  }
}
