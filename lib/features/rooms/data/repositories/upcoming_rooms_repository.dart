import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/upcoming_rooms_repository.g.dart';

@Riverpod(keepAlive: true)
UpcomingRoomsRepository upcomingRoomsRepository(Ref ref) =>
    UpcomingRoomsRepository(
      tables: ref.watch(appwriteTablesProvider),
      messaging: ref.watch(firebaseMessagingProvider),
    );

class UpcomingRoomsRepository {
  UpcomingRoomsRepository({
    required TablesDB tables,
    required FirebaseMessaging messaging,
  }) : _tables = tables,
       _messaging = messaging;

  final TablesDB _tables;
  final FirebaseMessaging _messaging;

  Future<List<AppwriteUpcomingRoom>> loadUpcoming({
    required String userUid,
    required Set<String> hiddenRoomIds,
  }) async {
    final list = await _tables.listRows(
      databaseId: upcomingRoomsDatabaseId,
      tableId: upcomingRoomsTableId,
    );

    final visible = list.rows.where((r) => !hiddenRoomIds.contains(r.$id));
    final upcomingFutures =
        visible.map((row) => _hydrateUpcomingRoom(row, userUid));
    return Future.wait(upcomingFutures);
  }

  Future<Set<String>> liveUpcomingRoomIds() async {
    final list = await _tables.listRows(
      databaseId: upcomingRoomsDatabaseId,
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
        databaseId: upcomingRoomsDatabaseId,
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
    final fcmToken = await _messaging.getToken();
    await _tables.createRow(
      databaseId: upcomingRoomsDatabaseId,
      tableId: upcomingRoomsTableId,
      rowId: ID.unique(),
      data: {
        'name': name,
        'scheduledDateTime': scheduledDateTime,
        'tags': tags,
        'description': description,
        'creatorUid': creatorUid,
        'creator_fcm_tokens': [fcmToken],
      },
    );
  }

  Future<void> addSubscriber({
    required String upcomingRoomId,
    required String userUid,
    required String profileImageUrl,
  }) async {
    final fcmToken = await _messaging.getToken();
    await _tables.createRow(
      databaseId: upcomingRoomsDatabaseId,
      tableId: subscribedUserTableId,
      rowId: ID.unique(),
      data: {
        'userID': userUid,
        'upcomingRoomId': upcomingRoomId,
        'registrationTokens': [fcmToken],
        'userProfileUrl': profileImageUrl,
      },
    );
  }

  Future<void> removeSubscriber({
    required String upcomingRoomId,
    required String userUid,
  }) async {
    final result = await _tables.listRows(
      databaseId: upcomingRoomsDatabaseId,
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
      databaseId: upcomingRoomsDatabaseId,
      tableId: subscribedUserTableId,
      rowId: result.rows.first.$id,
    );
  }

  Future<void> deleteUpcomingRoom(String upcomingRoomId) async {
    await _tables.deleteRow(
      databaseId: upcomingRoomsDatabaseId,
      tableId: upcomingRoomsTableId,
      rowId: upcomingRoomId,
    );
    final subscribers = await _tables.listRows(
      databaseId: upcomingRoomsDatabaseId,
      tableId: subscribedUserTableId,
      queries: [
        Query.equal('upcomingRoomId', [upcomingRoomId]),
      ],
    );
    for (final sub in subscribers.rows) {
      await _tables.deleteRow(
        databaseId: upcomingRoomsDatabaseId,
        tableId: subscribedUserTableId,
        rowId: sub.$id,
      );
    }
  }
}
