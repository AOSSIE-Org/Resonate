import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/user_profile_controller.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import 'explore_story_controller_test.mocks.dart';

@GenerateMocks([Databases, Account, Client, FirebaseMessaging, Functions])
List<Document> mockStoryDocuments = [
  Document(
    $id: 'doc1',
    $collectionId: storyCollectionId,
    $databaseId: storyDatabaseId,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $permissions: ['any'],
    data: {
      'title': 'Story 1',
      'description': 'Description of Story 1',
      'category': "comedy",
      'coverImgUrl': 'https://example.com/image1.jpg',
      'creatorId': "id1",
      "creatorName": "Creator 1",
      "creatorImgUrl": "https://example.com/profile1.jpg",
      'likes': 10,
      'tintColor': '0000FF',
      'playDuration': 120,
    },
    $sequence: 0,
  ),
  Document(
    $id: 'doc2',
    $collectionId: storyCollectionId,
    $databaseId: storyDatabaseId,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $permissions: ['any'],
    data: {
      'title': 'Story 2',
      'description': 'Description of Story 2',
      'category': "thriller",
      'coverImgUrl': 'https://example.com/image2.jpg',
      'creatorId': "id2",
      "creatorName": "Creator 2",
      "creatorImgUrl": "https://example.com/profile2.jpg",
      'likes': 10,
      'tintColor': '0000FF',
      'playDuration': 120,
    },
    $sequence: 1,
  ),
];

final Document mockSearchedUserDocument = Document(
  $id: 'doc1',
  $collectionId: usersCollectionID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {
    'name': "Test User 1",
    'dob': "2000-01-01",
    'username': "testuser1",
    'profileImageUrl': "https://example.com/profile1.jpg",
    'email': "testuser1@example.com",
    'profileImageId': "profileImageId1",
    'ratingCount': 7,
    'ratingTotal': 25,
    'followers': [
      {
        "followerUserId": "id2",
        "followerUsername": "testu2",
        "followerName": "Test User 2",
        "followerFCMToken": "testToken2",
        "followerProfileImageUrl": "https://example.com/profile2.jpg",
        "followerRating": 5,
        "\$id": "doc2",
      },
      {
        "followerUserId": "id3",
        "followerUsername": "testu3",
        "followerName": "Test User 3",
        "followerFCMToken": "testToken3",
        "followerProfileImageUrl": "https://example.com/profile3.jpg",
        "followerRating": 5,
        "\$id": "doc3",
      },
    ],
  },
  $sequence: 0,
);
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
    'followers': [
      {
        "followerUserId": "id1",
        "followerUsername": "testu1",
        "followerName": "Test User 1",
        "followerFCMToken": "testToken1",
        "followerProfileImageUrl": "https://example.com/profile1.jpg",
        "followerRating": 5,
        "\$id": "doc2",
      },
      {
        "followerUserId": "id3",
        "followerUsername": "testu3",
        "followerName": "Test User 3",
        "followerFCMToken": "testToken3",
        "followerProfileImageUrl": "https://example.com/profile3.jpg",
        "followerRating": 5,
        "\$id": "doc3",
      },
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
final FollowerUserModel mockFollowerUserModel = FollowerUserModel(
  docId: 'fdocid1',
  uid: 'id2',
  username: 'testu2',
  profileImageUrl: 'https://example.com/profile2.jpg',
  name: 'Test User 2',
  fcmToken: 'testToken2',
  followingUserId: 'id1',
  followerRating: 5,
);
final Document mockFollowerDocument = Document(
  $id: 'fdocid1',
  $collectionId: followersCollectionID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  data: {
    "followerUserId": "id2",
    "followerUsername": "testu2",
    "followerName": "Test User 2",
    "followerFCMToken": "testToken2",
    "followerProfileImageUrl": "https://example.com/profile2.jpg",
    "followerRating": 5,
    "followingUserId": "id1",
  },
  $sequence: 0,
);
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockDatabases databases;
  late MockAccount mockAccount;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late UserProfileController userProfileController;

  setUp(() {
    Get.testMode = true;
    databases = MockDatabases();
    mockAccount = MockAccount();
    mockFirebaseMessaging = MockFirebaseMessaging();
    userProfileController = UserProfileController(
      authStateController: AuthStateController(
        account: mockAccount,
        client: MockClient(),
        databases: databases,
        messaging: mockFirebaseMessaging,
      ),
      databases: databases,
    );

    userProfileController.authStateController.uid = 'id2';

    when(
      databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [
          Query.equal(
            'creatorId',
            userProfileController.authStateController.uid,
          ),
        ],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        Duration(seconds: 2),
        () => DocumentList(total: 1, documents: [mockStoryDocuments[1]]),
      ),
    );
    when(
      databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [Query.equal('creatorId', 'id1')],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        Duration(seconds: 2),
        () => DocumentList(total: 1, documents: [mockStoryDocuments[0]]),
      ),
    );
    when(
      databases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: 'id1',
      ),
    ).thenAnswer(
      (_) =>
          Future.delayed(Duration(seconds: 2), () => mockSearchedUserDocument),
    );
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
        collectionId: followersCollectionID,
        documentId: anyNamed('documentId'),
        data: mockFollowerUserModel.toJson(),
      ),
    ).thenAnswer(
      (_) => Future.delayed(Duration(seconds: 2), () => mockFollowerDocument),
    );
    when(mockAccount.get()).thenAnswer((_) => Future.value(mockUser));
    when(
      mockFirebaseMessaging.getToken(),
    ).thenAnswer((_) => Future.value('testToken2'));
  });

  test('test convertAppwriteDocListToStoryList', () async {
    final storiesList = await userProfileController
        .convertAppwriteDocListToStoryList(mockStoryDocuments);
    expect(storiesList.length, 2);
    expect(storiesList[0].title, 'Story 1');
    expect(storiesList[1].title, 'Story 2');
    expect(storiesList[0].storyId, 'doc1');
    expect(storiesList[1].storyId, 'doc2');
    expect(storiesList[0].category, StoryCategory.comedy);
    expect(storiesList[1].category, StoryCategory.thriller);
    expect(storiesList[0].creatorId, 'id1');
    expect(storiesList[1].creatorId, 'id2');
    expect(storiesList[0].creatorName, 'Creator 1');
    expect(storiesList[1].creatorName, 'Creator 2');
    expect(storiesList[0].creatorImgUrl, 'https://example.com/profile1.jpg');
    expect(storiesList[1].creatorImgUrl, 'https://example.com/profile2.jpg');
    expect(storiesList[0].likesCount.value, 10);
    expect(storiesList[1].likesCount.value, 10);
    expect(storiesList[0].playDuration, 120);
    expect(storiesList[1].playDuration, 120);
    expect(storiesList[0].tintColor, Color(0xff0000FF));
    expect(storiesList[1].tintColor, Color(0xff0000FF));
    expect(storiesList[0].chapters, []);
    expect(storiesList[1].chapters, []);
    expect(storiesList[0].userIsCreator, false);
    expect(storiesList[1].userIsCreator, false);
  });

  test('test fetchUserCreatedStories', () async {
    await userProfileController.fetchUserCreatedStories('id1');
    expect(userProfileController.searchedUserStories.length, 1);
    expect(userProfileController.searchedUserStories[0].storyId, 'doc1');
    expect(userProfileController.searchedUserStories[0].title, 'Story 1');
    expect(
      userProfileController.searchedUserStories[0].description,
      'Description of Story 1',
    );
    expect(userProfileController.searchedUserStories[0].userIsCreator, false);
  });

  test('test fetchUserFollowers', () async {
    await userProfileController.fetchUserFollowers('id1');
    expect(userProfileController.searchedUserFollowers.length, 2);
    expect(userProfileController.searchedUserFollowers[0].name, 'Test User 2');
    expect(userProfileController.searchedUserFollowers[1].name, 'Test User 3');
    expect(
      userProfileController.searchedUserFollowers[0].profileImageUrl,
      'https://example.com/profile2.jpg',
    );
    expect(
      userProfileController.searchedUserFollowers[1].profileImageUrl,
      'https://example.com/profile3.jpg',
    );
    expect(userProfileController.searchedUserFollowers[0].username, 'testu2');
    expect(userProfileController.searchedUserFollowers[1].username, 'testu3');
    expect(userProfileController.searchedUserFollowers[0].docId, 'doc2');
    expect(userProfileController.searchedUserFollowers[1].docId, 'doc3');
    expect(userProfileController.searchedUserFollowers[0].uid, 'id2');
    expect(userProfileController.searchedUserFollowers[1].uid, 'id3');
    expect(userProfileController.isFollowingUser.value, true);
    expect(userProfileController.followerDocumentId, 'doc2');
  });

  test('test followCreator', () async {
    await userProfileController.authStateController.setUserProfileData();
    await userProfileController.followCreator('id1');
    expect(userProfileController.isFollowingUser.value, true);
    expect(userProfileController.searchedUserFollowers.length, 1);
    expect(userProfileController.searchedUserFollowers[0].uid, 'id2');
    expect(userProfileController.searchedUserFollowers[0].username, 'testu2');
    expect(
      userProfileController.searchedUserFollowers[0].profileImageUrl,
      'https://example.com/profile2.jpg',
    );
    expect(userProfileController.searchedUserFollowers[0].name, 'Test User 2');
    expect(
      userProfileController.searchedUserFollowers[0].fcmToken,
      'testToken2',
    );
    expect(
      userProfileController.searchedUserFollowers[0].followingUserId,
      'id1',
    );
    expect(userProfileController.searchedUserFollowers[0].followerRating, 5);
  });
}
