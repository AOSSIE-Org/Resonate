import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/models/friends_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import 'friends_controller_test.mocks.dart';

@GenerateMocks([TablesDB, Functions, FirebaseMessaging, Account, Client])
@GenerateNiceMocks([MockSpec<Realtime>()])
final List<FriendsModel> mockFriendModelList = [
  FriendsModel(
    senderId: "id2",
    recieverId: 'id1',
    senderProfileImgUrl: 'example.com/1',
    recieverProfileImgUrl: 'example.com/2',
    senderUsername: 'testu2',
    recieverUsername: 'testu1',
    senderName: "Test User 2",
    recieverName: "Test User 1",
    requestStatus: FriendRequestStatus.sent,
    requestSentByUserId: 'testu2',
    senderRating: 5.0,
    recieverRating: 5.0,
    docId: 'doc1',
    users: ['id2', 'id1'],
    senderFCMToken: 'testToken2',
  ),
  FriendsModel(
    senderId: "id2",
    recieverId: 'id3',
    senderProfileImgUrl: 'example.com/1',
    recieverProfileImgUrl: 'example.com/3',
    senderUsername: 'testu2',
    recieverUsername: 'testu3',
    senderName: "Test User 2",
    recieverName: "Test User 3",
    requestStatus: FriendRequestStatus.accepted,
    requestSentByUserId: 'testu2',
    senderRating: 5.0,
    recieverRating: 5.0,
    docId: 'doc2',
    users: ['id2', 'id3'],
    senderFCMToken: 'testToken2',
    recieverFCMToken: 'testToken3',
  ),
  FriendsModel(
    senderId: "id5",
    recieverId: 'id2',
    senderProfileImgUrl: 'example.com/5',
    recieverProfileImgUrl: 'example.com/2',
    senderUsername: 'testu5',
    recieverUsername: 'testu2',
    senderName: "Test User 5",
    recieverName: "Test User 2",
    requestStatus: FriendRequestStatus.sent,
    requestSentByUserId: 'testu5',
    senderRating: 5.0,
    recieverRating: 5.0,
    docId: 'doc4',
    users: ['id5', 'id2'],
    senderFCMToken: 'testToken5',
  ),
];
final List<Row> mockFriendRows = [
  Row(
    $id: 'doc1',
    $tableId: friendsTableID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $permissions: ['any'],
    data: mockFriendModelList[0].toJson(),
    $sequence: 0,
  ),
  Row(
    $id: 'doc2',
    $tableId: friendsTableID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $permissions: ['any'],
    data: mockFriendModelList[1].toJson(),
    $sequence: 1,
  ),
  Row(
    $id: 'doc4',
    $tableId: friendsTableID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $permissions: ['any'],
    data: mockFriendModelList[2].toJson(),
    $sequence: 2,
  ),
];
final Row mockUserRow = Row(
  $id: 'doc1',
  $tableId: usersTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {
    'name': "Test User 2",
    'dob': "2000-01-01",
    'username': "testu2",
    'profileImageUrl': "https://example.com/profile2.jpg",
    'email': "testuser2@example.com",
    'profileImageId': "profileImageId2",
    'ratingCount': 5,
    'ratingTotal': 25,
    'followers': [],
    'friends': [
      {"\$id": 'doc1', ...mockFriendRows[0].data},
      {"\$id": 'doc2', ...mockFriendRows[1].data},
      {"\$id": 'doc4', ...mockFriendRows[2].data},
    ],
  },
  $sequence: 0,
);
final User mockUser = User(
  $id: 'id2',
  name: 'Test User 2',
  email: 'test2@test.com',
  emailVerification: true,
  prefs: Preferences(data: {'isUserProfileComplete': true}),
  $createdAt: DateTime.now().toIso8601String(),
  $updatedAt: DateTime.now().toIso8601String(),
  accessedAt: DateTime.now().toIso8601String(),
  registration: DateTime.now().toIso8601String(),
  phone: '1234567890',
  phoneVerification: false,
  mfa: false,
  passwordUpdate: DateTime.now().toIso8601String(),
  status: true,
  password: 'password',
  labels: [],
  hash: 'Argon2',
  targets: [],
  hashOptions: {},
);
final FriendsModel mockSentFriendRequest = FriendsModel(
  senderId: 'id2',
  recieverId: 'id4',
  senderProfileImgUrl: 'https://example.com/profile2.jpg',
  recieverProfileImgUrl: 'example.com/4',
  senderUsername: 'testu2',
  recieverUsername: 'testu4',
  senderName: 'Test User 2',
  recieverName: 'Test User 4',
  requestStatus: FriendRequestStatus.sent,
  requestSentByUserId: 'id2',
  senderRating: 5.0,
  recieverRating: 4.0,
  docId: 'doc3',
  users: ['id2', 'id4'],
  senderFCMToken: 'testToken2',
);
final Row mockSentFriendRequestRow = Row(
  $id: 'doc3',
  $tableId: friendsTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: mockSentFriendRequest.toJson(),
  $sequence: 0,
);
final FriendsModel mockAcceptedRequestModel = mockFriendModelList[2].copyWith(
  recieverFCMToken: 'testToken2',
  requestStatus: FriendRequestStatus.accepted,
);

void main() {
  late MockTablesDB tables;
  late MockAccount mockAccount;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late FriendsController friendsController;

  setUp(() {
    Get.testMode = true;
    tables = MockTablesDB();
    mockAccount = MockAccount();
    mockFirebaseMessaging = MockFirebaseMessaging();
    friendsController = FriendsController(
      authStateController: AuthStateController(
        account: mockAccount,
        client: MockClient(),
        tables: tables,
        messaging: mockFirebaseMessaging,
      ),
      tables: tables,
      firebaseMessaging: mockFirebaseMessaging,
      functions: MockFunctions(),
      realtime: MockRealtime(),
    );

    friendsController.authStateController.uid = 'id2';
    friendsController.authStateController.userName = 'testu2';
    friendsController.authStateController.profileImageUrl = 'https://example.com/profile2.jpg';
    friendsController.authStateController.displayName = 'Test User 2';
    friendsController.authStateController.ratingTotal = 25.0;
    friendsController.authStateController.ratingCount = 5;

    when(
      tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'id2',
        queries: [Query.select(["*", "friends.*"])],
      ),
    ).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 2), () => mockUserRow),
    );
    when(
      tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'id2',
        queries: anyNamed('queries'),
      ),
    ).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 2), () => mockUserRow),
    );
    // Add stub for getRow on friendsTableID
    when(
      tables.getRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: anyNamed('rowId'),
      ),
    ).thenAnswer((invocation) {
      final String? rowId = invocation.namedArguments[#rowId];
      if (rowId == 'doc1') return Future.value(mockFriendRows[0]);
      if (rowId == 'doc2') return Future.value(mockFriendRows[1]);
      if (rowId == 'doc4') return Future.value(mockFriendRows[2]);
      throw Exception('Unexpected rowId: $rowId');
    });
    when(
      tables.createRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: anyNamed('rowId'),
        data: mockSentFriendRequest.toJson(),
      ),
    ).thenAnswer(
      (_) =>
          Future.delayed(Duration(seconds: 2), () => mockSentFriendRequestRow),
    );
    when(mockAccount.get()).thenAnswer((_) => Future.value(mockUser));
    when(
      mockFirebaseMessaging.getToken(),
    ).thenAnswer((_) => Future.value('testToken2'));
    when(
      tables.deleteRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: anyNamed('rowId'),
      ),
    ).thenAnswer((_) => Future.delayed(Duration(seconds: 0)));
    when(
      tables.updateRow(
        databaseId: userDatabaseID,
        tableId: friendsTableID,
        rowId: anyNamed('rowId'),
        data: mockAcceptedRequestModel.toJson(),
      ),
    ).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 2), () => mockFriendRows[2]),
    );
  });

  test('test getFriendsList', () async {
    expect(friendsController.isLoadingFriends.value, false);
    friendsController.getFriendsList();
    expect(friendsController.isLoadingFriends.value, true);
    expect(friendsController.friendsList, isEmpty);
    expect(friendsController.friendRequestsList, isEmpty);
    await Future.delayed(Duration(seconds: 2));
    expect(friendsController.isLoadingFriends.value, false);
    expect(friendsController.friendsList.length, 1);
    expect(friendsController.friendsList[0].senderName, 'Test User 2');
    expect(friendsController.friendsList[0].recieverName, 'Test User 3');
    expect(friendsController.friendsList[0].senderFCMToken, 'testToken2');
    expect(friendsController.friendsList[0].recieverFCMToken, 'testToken3');
    expect(friendsController.friendRequestsList.length, 2);
    expect(friendsController.friendRequestsList[0].senderName, 'Test User 2');
    expect(friendsController.friendRequestsList[0].recieverName, 'Test User 1');
    expect(
      friendsController.friendRequestsList[0].senderFCMToken,
      'testToken2',
    );
    expect(friendsController.friendRequestsList[0].recieverFCMToken, null);
  });
  test('test sendFriendRequest', () async {
    await friendsController.authStateController.setUserProfileData();
    await friendsController.sendFriendRequest(
      'id4',
      'example.com/4',
      'testu4',
      'Test User 4',
      4,
    );

    expect(friendsController.friendRequestsList.length, 1);
    expect(friendsController.friendRequestsList[0].recieverName, 'Test User 4');
    expect(friendsController.friendRequestsList[0].senderName, 'Test User 2');
    expect(friendsController.friendRequestsList[0].recieverUsername, 'testu4');
    expect(
      friendsController.friendRequestsList[0].senderFCMToken,
      'testToken2',
    );
  });
  test('test removeFriend', () async {
    await friendsController.authStateController.setUserProfileData();
    await friendsController.getFriendsList();

    expect(friendsController.friendsList.length, 1);
    expect(friendsController.friendRequestsList.length, 2);

    await friendsController.removeFriend(mockFriendModelList[1]);

    expect(friendsController.friendsList.length, 0);
    expect(friendsController.friendRequestsList.length, 2);
  });
  test('test acceptFriendRequest', () async {
    await friendsController.authStateController.setUserProfileData();
    await friendsController.getFriendsList();

    expect(friendsController.friendsList.length, 1);
    expect(friendsController.friendRequestsList.length, 2);

    await friendsController.acceptFriendRequest(mockFriendModelList[2]);

    expect(friendsController.friendsList.length, 2);
    expect(friendsController.friendRequestsList.length, 1);
    expect(friendsController.friendsList[1].recieverName, 'Test User 2');
    expect(friendsController.friendsList[1].recieverFCMToken, 'testToken2');
  });
  test('test declineFriendRequest', () async {
    await friendsController.authStateController.setUserProfileData();
    await friendsController.getFriendsList();

    expect(friendsController.friendsList.length, 1);
    expect(friendsController.friendRequestsList.length, 2);

    await friendsController.declineFriendRequest(mockFriendModelList[2]);

    expect(friendsController.friendsList.length, 1);
    expect(friendsController.friendRequestsList.length, 1);
  });
}
