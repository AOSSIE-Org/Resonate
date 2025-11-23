import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/friend_calling_controller.dart';
import 'package:resonate/models/friend_call_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';

import 'friend_calling_controller_test.mocks.dart';

@GenerateMocks([TablesDB])
@GenerateNiceMocks([
  MockSpec<Realtime>(),
  MockSpec<FlutterCallkitIncoming>(),
  MockSpec<Functions>(),
])
final FriendCallModel mockFriendCallModel = FriendCallModel(
  callerName: 'Test User 1',
  recieverName: "Test User 2",
  callerUsername: "Test User 1",
  recieverUsername: "Test User 2",
  callerUid: "id1",
  recieverUid: "id2",
  callerProfileImageUrl: "https://example.com/profile1.jpg",
  recieverProfileImageUrl: "https://example.com/profile2.jpg",
  livekitRoomId: "room1",
  callStatus: FriendCallStatus.waiting,
  docId: "doc1",
);
final Row mockFriendCallRow = Row(
  $id: 'doc1',
  $tableId: friendCallsCollectionId,
  $databaseId: masterDatabaseId,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {...mockFriendCallModel.toJson(), '\$id': 'doc1'},
  $sequence: 0,
);
final Row mockFriendCallEndedRow = Row(
  $id: 'doc1',
  $tableId: friendCallsCollectionId,
  $databaseId: masterDatabaseId,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {
    ...mockFriendCallModel
        .copyWith(callStatus: FriendCallStatus.ended)
        .toJson(),
    '\$id': 'doc1',
  },
  $sequence: 0,
);
final Row mockFriendCallDeclinedRow = Row(
  $id: 'doc1',
  $tableId: friendCallsCollectionId,
  $databaseId: masterDatabaseId,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {
    ...mockFriendCallModel
        .copyWith(callStatus: FriendCallStatus.declined)
        .toJson(),
    '\$id': 'doc1',
  },
  $sequence: 0,
);
final Row mockFriendCallAcceptedRow = Row(
  $id: 'doc1',
  $tableId: friendCallsCollectionId,
  $databaseId: masterDatabaseId,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {
    ...mockFriendCallModel
        .copyWith(callStatus: FriendCallStatus.connected)
        .toJson(),
    '\$id': 'doc1',
  },
  $sequence: 0,
);
StreamController<RealtimeMessage> mockRealtimeMessageStreamController =
    StreamController<RealtimeMessage>.broadcast();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockTablesDB tables;
  late MockRealtime realtime;
  late FriendCallingController friendCallingController;
  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();

    friendCallingController = FriendCallingController(
      tables: tables,
      functions: MockFunctions(),
      realtime: realtime,
    );

    when(
      tables.getRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsCollectionId,
        rowId: 'doc1',
      ),
    ).thenAnswer((_) => Future.value(mockFriendCallRow));
    when(
      tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsCollectionId,
        rowId: 'doc1',
        data: mockFriendCallModel
            .copyWith(callStatus: FriendCallStatus.declined)
            .toJson(),
      ),
    ).thenAnswer((_) => Future.value(mockFriendCallDeclinedRow));
    when(
      tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsCollectionId,
        rowId: 'doc1',
        data: mockFriendCallModel
            .copyWith(callStatus: FriendCallStatus.connected)
            .toJson(),
      ),
    ).thenAnswer((_) => Future.value(mockFriendCallAcceptedRow));
    when(
      tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsCollectionId,
        rowId: 'doc1',
        data: mockFriendCallModel
            .copyWith(callStatus: FriendCallStatus.ended)
            .toJson(),
      ),
    ).thenAnswer((_) => Future.value(mockFriendCallEndedRow));
    when(
      tables.createRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsCollectionId,
        rowId: anyNamed('rowId'),
        data: mockFriendCallModel.toJson(),
      ),
    ).thenAnswer((_) => Future.value(mockFriendCallRow));

    when(realtime.subscribe(any)).thenAnswer(
      (_) => RealtimeSubscription(
        close: () async {},
        channels: [
          'databases.$masterDatabaseId.collections.$friendCallsCollectionId.documents.doc1',
        ],
        controller: mockRealtimeMessageStreamController,
      ),
    );

    Get.testMode = true;
  });

  test('test startCall', () async {
    await friendCallingController.startCall(
      mockFriendCallModel.callerName,
      mockFriendCallModel.recieverName,
      mockFriendCallModel.callerUsername,
      mockFriendCallModel.recieverUsername,
      mockFriendCallModel.callerUid,
      mockFriendCallModel.recieverUid,
      mockFriendCallModel.callerProfileImageUrl,
      mockFriendCallModel.recieverProfileImageUrl,
      mockFriendCallModel.livekitRoomId,
      "testToken2",
    );
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.waiting,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
    expect(
      friendCallingController.friendCallModel.value!.recieverName,
      'Test User 2',
    );
    expect(friendCallingController.friendCallModel.value!.callerUid, 'id1');
    expect(friendCallingController.friendCallModel.value!.recieverUid, 'id2');
  });
  test('test listenToCallChanges', () async {
    await friendCallingController.startCall(
      mockFriendCallModel.callerName,
      mockFriendCallModel.recieverName,
      mockFriendCallModel.callerUsername,
      mockFriendCallModel.recieverUsername,
      mockFriendCallModel.callerUid,
      mockFriendCallModel.recieverUid,
      mockFriendCallModel.callerProfileImageUrl,
      mockFriendCallModel.recieverProfileImageUrl,
      mockFriendCallModel.livekitRoomId,
      "testToken2",
    );
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.waiting,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
    mockRealtimeMessageStreamController.add(
      RealtimeMessage(
        events: [
          'databases.$masterDatabaseId.collections.$friendCallsCollectionId.documents.${friendCallingController.friendCallModel.value!.docId}.update',
        ],
        payload: {
          "ip": "",
          "\$id": friendCallingController.friendCallModel.value!.docId,
          "\$createdAt": DateTime.now().toIso8601String(),
          "\$updatedAt": DateTime.now().toIso8601String(),
          "\$permissions": [],
          "\$collectionId": friendCallsCollectionId,
          "\$databaseId": masterDatabaseId,
          ...mockFriendCallModel
              .copyWith(callStatus: FriendCallStatus.connected)
              .toJson(),
        },
        channels: [
          'databases.$masterDatabaseId.collections.$friendCallsCollectionId.documents',
        ],
        timestamp: DateTime.now().toIso8601String(),
      ),
    );
    await Future.delayed(Duration(seconds: 3));
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.connected,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );

    await Future.delayed(Duration(seconds: 3));
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.connected,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
    mockRealtimeMessageStreamController.add(
      RealtimeMessage(
        events: [
          'databases.$masterDatabaseId.collections.$friendCallsCollectionId.documents.${friendCallingController.friendCallModel.value!.docId}.update',
        ],
        payload: {
          "ip": "",
          "\$id": friendCallingController.friendCallModel.value!.docId,
          "\$createdAt": DateTime.now().toIso8601String(),
          "\$updatedAt": DateTime.now().toIso8601String(),
          "\$permissions": [],
          "\$collectionId": friendCallsCollectionId,
          "\$databaseId": masterDatabaseId,
          ...mockFriendCallModel
              .copyWith(callStatus: FriendCallStatus.ended)
              .toJson(),
        },
        channels: [
          'databases.$masterDatabaseId.collections.$friendCallsCollectionId.documents',
        ],
        timestamp: DateTime.now().toIso8601String(),
      ),
    );
    await Future.delayed(Duration(seconds: 3));
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.ended,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
  });
  test('test onAnswerCall', () async {
    await friendCallingController.onAnswerCall({'call_id': 'doc1'});
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.connected,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
    expect(
      friendCallingController.friendCallModel.value!.recieverName,
      'Test User 2',
    );
    expect(friendCallingController.friendCallModel.value!.callerUid, 'id1');
    expect(friendCallingController.friendCallModel.value!.recieverUid, 'id2');
  });
  test('test onDeclinedCall', () async {
    await friendCallingController.onDeclinedCall({'call_id': 'doc1'});
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.declined,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
    expect(
      friendCallingController.friendCallModel.value!.recieverName,
      'Test User 2',
    );
    expect(friendCallingController.friendCallModel.value!.callerUid, 'id1');
    expect(friendCallingController.friendCallModel.value!.recieverUid, 'id2');
  });
  test('test onEndedCall', () async {
    await friendCallingController.onEndedCall({'call_id': 'doc1'});
    expect(
      friendCallingController.friendCallModel.value!.callStatus,
      FriendCallStatus.ended,
    );
    expect(
      friendCallingController.friendCallModel.value!.callerName,
      'Test User 1',
    );
    expect(
      friendCallingController.friendCallModel.value!.recieverName,
      'Test User 2',
    );
    expect(friendCallingController.friendCallModel.value!.callerUid, 'id1');
    expect(friendCallingController.friendCallModel.value!.recieverUid, 'id2');
  });
  test('test toggleMic', () async {
    expect(friendCallingController.isMicOn.value, false);
    friendCallingController.toggleMic();
    expect(friendCallingController.isMicOn.value, true);
  });
  test('test toggleLoudSpeaker', () async {
    expect(friendCallingController.isLoudSpeakerOn.value, true);
    friendCallingController.toggleLoudSpeaker();
    expect(friendCallingController.isLoudSpeakerOn.value, false);
  });
}
