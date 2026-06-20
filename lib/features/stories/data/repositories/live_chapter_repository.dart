import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/rooms/data/livekit_join.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
import 'package:resonate/services/api_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/live_chapter_repository.g.dart';

typedef LiveKitJoinParams = ({String liveKitUri, String roomToken});

@Riverpod(keepAlive: true)
LiveChapterRepository liveChapterRepository(Ref ref) => LiveChapterRepository(
  tables: ref.watch(appwriteTablesProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
  functions: ref.watch(appwriteFunctionsProvider),
  apiService: ApiService(functions: ref.watch(appwriteFunctionsProvider)),
);

// Appwrite docs, realtime feed, cloud-function room ops and follower notification
class LiveChapterRepository {
  LiveChapterRepository({
    required TablesDB tables,
    required Realtime realtime,
    required Functions functions,
    required ApiService apiService,
    FlutterSecureStorage? secureStorage,
  }) : _tables = tables,
       _realtime = realtime,
       _functions = functions,
       _api = apiService,
       _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final TablesDB _tables;
  final Realtime _realtime;
  final Functions _functions;
  final ApiService _api;
  final FlutterSecureStorage _secureStorage;

  // LiveKit room (cloud functions)

  Future<LiveKitJoinParams> createLiveChapterRoom({
    required String appwriteRoomId,
    required String adminUid,
  }) async {
    final response = await _api.createLiveChapterRoom(appwriteRoomId, adminUid);
    final join = liveKitJoinFromResponse(response);
    // The admin token is needed later to delete the room.
    await _secureStorage.write(
      key: "createdRoomAdminToken",
      value: join.roomToken,
    );
    await _secureStorage.write(
      key: "createdRoomLivekitUrl",
      value: join.liveKitUri,
    );
    return join;
  }

  Future<LiveKitJoinParams> joinLiveChapterRoom({
    required String roomId,
    required String userId,
  }) async {
    final response = await _api.joinRoom(roomId, userId);
    return liveKitJoinFromResponse(response);
  }

  Future<void> deleteLiveChapterRoom(String roomId) async {
    final token = await _secureStorage.read(key: "createdRoomAdminToken");
    if (token == null) return;
    await _api.deleteLiveChapterRoom(roomId, token);
  }

  // Appwrite documents

  Future<void> createLiveChapterDocs(LiveChapterModel model) async {
    await _tables.createRow(
      databaseId: storyDatabaseId,
      tableId: liveChaptersTableId,
      rowId: model.id,
      data: model.toJson(),
    );
    await _tables.createRow(
      databaseId: userDatabaseID,
      tableId: liveChapterAttendeesTableId,
      rowId: model.id,
      data: model.attendees!.toJson(),
    );
  }

  Future<void> updateAttendees(
    String roomId,
    LiveChapterAttendeesModel attendees,
  ) async {
    await _tables.updateRow(
      databaseId: userDatabaseID,
      tableId: liveChapterAttendeesTableId,
      rowId: roomId,
      data: attendees.toJson(),
    );
  }

  Future<void> deleteLiveChapterDocs(String roomId) async {
    try {
      await _tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: liveChaptersTableId,
        rowId: roomId,
      );
      await _tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: liveChapterAttendeesTableId,
        rowId: roomId,
      );
    } catch (e) {
      log('Failed to delete live chapter docs: $e');
    }
  }

  // Realtime

  static String attendeesChannel(String roomId) =>
      "databases.$userDatabaseID.tables.$liveChapterAttendeesTableId.rows.$roomId";

  // Stream of attendee-table events for a live chapter. 
  Stream<RealtimeMessage> attendeesStream(String roomId) {
    final subscription = _realtime.subscribe([attendeesChannel(roomId)]);
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

  // Notification

  Future<void> sendLiveChapterNotification({
    required String creatorId,
    required String title,
    required String body,
  }) async {
    try {
      await _functions.createExecution(
        functionId: sendStoryNotificationFunctionID,
        body: json.encode({
          'creatorId': creatorId,
          'payload': {'title': title, 'body': body},
        }),
      );
    } catch (e) {
      log('Failed to send live chapter notification: $e');
    }
  }
}
