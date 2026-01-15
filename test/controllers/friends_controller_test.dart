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

@GenerateMocks([Databases, Account, Client, FirebaseMessaging, Functions])
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
final List<Document> mockFriendDocuments = [
  Document(
    $id: 'doc1',
    $collectionId: friendsCollectionID,
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
  Document(
    $id: 'doc2',
    $collectionId: friendsCollectionID,
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

  Document(
    $id: 'doc4',
    $collectionId: friendsCollectionID,
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
final Document mockUserDocument = Document(
  $id: 'doc1',
  $collectionId: usersCollectionID,
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
      {"\$id": 'doc1', ...mockFriendDocuments[0].data},
      {"\$id": 'doc2', ...mockFriendDocuments[1].data},
      {"\$id": 'doc4', ...mockFriendDocuments[2].data},
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
final Document mockSentFriendRequestDocument = Document(
  $id: 'doc3',
  $collectionId: friendsCollectionID,
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
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockDatabases databases;
  late MockAccount mockAccount;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late FriendsController friendsController;

  setUp(() {
    Get.testMode = true;
    databases = MockDatabases();
    mockAccount = MockAccount();
    mockFirebaseMessaging = MockFirebaseMessaging();
    friendsController = FriendsController(
      authStateController: AuthStateController(
        account: mockAccount,
        client: MockClient(),
        databases: databases,
        messaging: mockFirebaseMessaging,
      ),
      databases: databases,
      firebaseMessaging: mockFirebaseMessaging,
      functions: MockFunctions(),
      realtime: MockRealtime(),
    );

    friendsController.authStateController.uid = 'id2';

    when(
      databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: 'id2',
      ),
    ).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 2), () => mockUserDocument),
    );
    when(
      databases.createDocument(
        databaseId: userDatabaseID,
        collectionId: friendsCollectionID,
        documentId: anyNamed('documentId'),
        data: mockSentFriendRequest.toJson(),
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        Duration(seconds: 2),
        () => mockSentFriendRequestDocument,
      ),
    );
    when(mockAccount.get()).thenAnswer((_) => Future.value(mockUser));
    when(
      mockFirebaseMessaging.getToken(),
    ).thenAnswer((_) => Future.value('testToken2'));
    when(
      databases.deleteDocument(
        databaseId: userDatabaseID,
        collectionId: friendsCollectionID,
        documentId: anyNamed('documentId'),
      ),
    ).thenAnswer((_) => Future.delayed(Duration(seconds: 0)));
    when(
      databases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: friendsCollectionID,
        documentId: anyNamed('documentId'),
        data: mockAcceptedRequestModel.toJson(),
      ),
    ).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 2), () => mockFriendDocuments[2]),
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
