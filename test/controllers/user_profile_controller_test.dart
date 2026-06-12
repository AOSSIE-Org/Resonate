import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/user_profile_controller.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../helpers/test_root_container.dart';
import 'user_profile_controller_test.mocks.dart';

@GenerateMocks([TablesDB, FirebaseMessaging])
List<Row> mockStoryDocuments = [
  Row(
    $id: 'doc1',
    $tableId: storyTableId,
    $databaseId: storyDatabaseId,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $permissions: ['any'],
    $sequence: 0,
    data: {
      'title': 'Story 1',
      'description': 'Description of Story 1',
      'category': 'comedy',
      'coverImgUrl': 'https://example.com/image1.jpg',
      'creatorId': 'id1',
      'creatorName': 'Creator 1',
      'creatorImgUrl': 'https://example.com/profile1.jpg',
      'likes': 10,
      'tintColor': '0000FF',
      'playDuration': 120,
    },
  ),
  Row(
    $id: 'doc2',
    $tableId: storyTableId,
    $databaseId: storyDatabaseId,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $permissions: ['any'],
    $sequence: 1,
    data: {
      'title': 'Story 2',
      'description': 'Description of Story 2',
      'category': 'thriller',
      'coverImgUrl': 'https://example.com/image2.jpg',
      'creatorId': 'id2',
      'creatorName': 'Creator 2',
      'creatorImgUrl': 'https://example.com/profile2.jpg',
      'likes': 10,
      'tintColor': '0000FF',
      'playDuration': 120,
    },
  ),
];

final Row mockSearchedUserDocument = Row(
  $id: 'doc1',
  $tableId: usersTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  $sequence: 0,
  data: {
    'name': 'Test User 1',
    'dob': '2000-01-01',
    'username': 'testuser1',
    'profileImageUrl': 'https://example.com/profile1.jpg',
    'email': 'testuser1@example.com',
    'profileImageId': 'profileImageId1',
    'ratingCount': 7,
    'ratingTotal': 25,
    'followers': [
      {
        'followerUserId': 'id2',
        'followerUsername': 'testu2',
        'followerName': 'Test User 2',
        'followerFCMToken': 'testToken2',
        'followerProfileImageUrl': 'https://example.com/profile2.jpg',
        'followerRating': 5,
        '\$id': 'doc2',
      },
      {
        'followerUserId': 'id3',
        'followerUsername': 'testu3',
        'followerName': 'Test User 3',
        'followerFCMToken': 'testToken3',
        'followerProfileImageUrl': 'https://example.com/profile3.jpg',
        'followerRating': 5,
        '\$id': 'doc3',
      },
    ],
  },
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

final Row mockFollowerDocument = Row(
  $id: 'fdocid1',
  $tableId: followersTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
  $permissions: ['any'],
  $sequence: 0,
  data: {
    'followerUserId': 'id2',
    'followerUsername': 'testu2',
    'followerName': 'Test User 2',
    'followerFCMToken': 'testToken2',
    'followerProfileImageUrl': 'https://example.com/profile2.jpg',
    'followerRating': 5,
    'followingUserId': 'id1',
  },
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockTablesDB tablesDB;
  late MockFirebaseMessaging mockFirebaseMessaging;
  late UserProfileController userProfileController;

  setUp(() async {
    Get.testMode = true;
    tablesDB = MockTablesDB();
    mockFirebaseMessaging = MockFirebaseMessaging();

    // followCreator uses rootContainer.read(firebaseMessagingProvider).getToken(),
    // so we override the FCM provider with our mock.
    await installTestRootContainer(
      authState: AuthState.authenticated(
        fakeAuthUser(
          uid: 'id2',
          userName: 'testu2',
          profileImageUrl: 'https://example.com/profile2.jpg',
          displayName: 'Test User 2',
          ratingTotal: 25.0,
          ratingCount: 5,
        ),
      ),
      messaging: mockFirebaseMessaging,
    );

    userProfileController = UserProfileController(tablesDB: tablesDB);

    when(
      tablesDB.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.equal('creatorId', 'id2')],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => RowList(total: 1, rows: [mockStoryDocuments[1]]),
      ),
    );
    when(
      tablesDB.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.equal('creatorId', 'id1')],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => RowList(total: 1, rows: [mockStoryDocuments[0]]),
      ),
    );
    when(
      tablesDB.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'id1',
        queries: [Query.select(['*', 'followers.*'])],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => mockSearchedUserDocument,
      ),
    );
    when(
      tablesDB.createRow(
        databaseId: userDatabaseID,
        tableId: followersTableID,
        rowId: anyNamed('rowId'),
        data: mockFollowerUserModel.toJson(),
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 1),
        () => mockFollowerDocument,
      ),
    );
    when(mockFirebaseMessaging.getToken())
        .thenAnswer((_) async => 'testToken2');
  });

  test('convertAppwriteDocListToStoryList maps fields correctly', () async {
    final stories = await userProfileController
        .convertAppwriteDocListToStoryList(mockStoryDocuments);
    expect(stories.length, 2);
    expect(stories[0].title, 'Story 1');
    expect(stories[1].title, 'Story 2');
    expect(stories[0].storyId, 'doc1');
    expect(stories[1].storyId, 'doc2');
    expect(stories[0].category, StoryCategory.comedy);
    expect(stories[1].category, StoryCategory.thriller);
    expect(stories[0].creatorId, 'id1');
    expect(stories[1].creatorId, 'id2');
    expect(stories[0].creatorName, 'Creator 1');
    expect(stories[1].creatorName, 'Creator 2');
    expect(stories[0].creatorImgUrl, 'https://example.com/profile1.jpg');
    expect(stories[1].creatorImgUrl, 'https://example.com/profile2.jpg');
    expect(stories[0].likesCount.value, 10);
    expect(stories[1].likesCount.value, 10);
    expect(stories[0].playDuration, 120);
    expect(stories[1].playDuration, 120);
    expect(stories[0].tintColor, const Color(0xff0000FF));
    expect(stories[1].tintColor, const Color(0xff0000FF));
    expect(stories[0].chapters, isEmpty);
    expect(stories[1].chapters, isEmpty);
    expect(stories[0].userIsCreator, false);
    expect(stories[1].userIsCreator, false);
  });

  test('fetchUserCreatedStories populates searchedUserStories', () async {
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

  test(
    'fetchUserFollowers populates list and sets isFollowingUser correctly',
    () async {
      await userProfileController.fetchUserFollowers('id1');
      expect(userProfileController.searchedUserFollowers.length, 2);
      expect(
        userProfileController.searchedUserFollowers[0].name,
        'Test User 2',
      );
      expect(
        userProfileController.searchedUserFollowers[1].name,
        'Test User 3',
      );
      expect(
        userProfileController.searchedUserFollowers[0].profileImageUrl,
        'https://example.com/profile2.jpg',
      );
      expect(
        userProfileController.searchedUserFollowers[1].profileImageUrl,
        'https://example.com/profile3.jpg',
      );
      expect(
        userProfileController.searchedUserFollowers[0].username,
        'testu2',
      );
      expect(
        userProfileController.searchedUserFollowers[1].username,
        'testu3',
      );
      expect(userProfileController.searchedUserFollowers[0].docId, 'doc2');
      expect(userProfileController.searchedUserFollowers[1].docId, 'doc3');
      expect(userProfileController.searchedUserFollowers[0].uid, 'id2');
      expect(userProfileController.searchedUserFollowers[1].uid, 'id3');
      expect(userProfileController.isFollowingUser.value, true);
      expect(userProfileController.followerDocumentId, 'doc2');
    },
  );

  test('followCreator adds the current user to the followers list', () async {
    await userProfileController.followCreator('id1');
    expect(userProfileController.isFollowingUser.value, true);
    expect(userProfileController.searchedUserFollowers.length, 1);
    expect(userProfileController.searchedUserFollowers[0].uid, 'id2');
    expect(userProfileController.searchedUserFollowers[0].username, 'testu2');
    expect(
      userProfileController.searchedUserFollowers[0].profileImageUrl,
      'https://example.com/profile2.jpg',
    );
    expect(
      userProfileController.searchedUserFollowers[0].name,
      'Test User 2',
    );
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
