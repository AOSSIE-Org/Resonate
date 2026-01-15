import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import 'explore_story_controller_test.mocks.dart';

@GenerateMocks([
  Databases,
  Storage,
  // ThemeController,
  Account,
  Client,
  FirebaseMessaging,
  Functions,
])
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
List<Document> mockUsersDocuments = [
  Document(
    $id: 'doc1',
    $collectionId: usersCollectionID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
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
    },
    $sequence: 0,
  ),
  Document(
    $id: 'doc2',
    $collectionId: usersCollectionID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(
      1754337186,
    ).toIso8601String(),
    $permissions: ['any'],
    data: {
      'name': "Test User 2",
      'dob': "2000-01-01",
      'username': "testuser2",
      'profileImageUrl': "https://example.com/profile2.jpg",
      'email': "testuser2@example.com",
      'profileImageId': "profileImageId2",
      'ratingCount': 5,
      'ratingTotal': 15,
    },
    $sequence: 1,
  ),
];

List<Map<String, dynamic>> mockMeilisearchStoryResults = mockStoryDocuments
    .map(
      (doc) => doc.data
        ..['\$id'] = doc.$id
        ..['\$createdAt'] = doc.$createdAt,
    )
    .toList();
List<Map<String, dynamic>> mockMeilisearchUserResults = mockUsersDocuments
    .map((doc) => doc.data..['\$id'] = doc.$id)
    .toList();

List<Story> mockStoriesList = [
  Story(
    title: 'Story 1',
    storyId: 'doc1',
    description: 'Description of Story 1',
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl: 'https://example.com/image1.jpg',
    creatorId: 'id1',
    creatorName: 'Creator 1',
    creatorImgUrl: 'https://example.com/profile1.jpg',
    creationDate: DateTime.fromMillisecondsSinceEpoch(1754337186),
    likesCount: 10,
    isLikedByCurrentUser: false,
    playDuration: 120,
    tintColor: Color(0xff0000FF),
    chapters: [],
  ),
  Story(
    title: 'Story 2',
    storyId: 'doc2',
    description: 'Description of Story 2',
    userIsCreator: true,
    category: StoryCategory.thriller,
    coverImageUrl: 'https://example.com/image2.jpg',
    creatorId: 'id2',
    creatorName: 'Creator 2',
    creatorImgUrl: 'https://example.com/profile2.jpg',
    creationDate: DateTime.fromMillisecondsSinceEpoch(1754337186),
    likesCount: 10,
    isLikedByCurrentUser: false,
    playDuration: 120,
    tintColor: Color(0xff0000FF),
    chapters: [],
  ),
];

void main() {
  late MockDatabases databases;
  late ExploreStoryController exploreStoryController;
  setUp(() {
    databases = MockDatabases();
    exploreStoryController = ExploreStoryController(
      authStateController: AuthStateController(
        account: MockAccount(),
        client: MockClient(),
        databases: databases,
        messaging: MockFirebaseMessaging(),
      ),
      databases: databases,
      storage: MockStorage(),
      functions: MockFunctions(),
    );
    exploreStoryController.authStateController.uid = 'id2';

    when(
      databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [
          Query.equal(
            'creatorId',
            exploreStoryController.authStateController.uid,
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
      databases.listDocuments(
        databaseId: storyDatabaseId,
        collectionId: storyCollectionId,
        queries: [Query.limit(10)],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        Duration(seconds: 2),
        () => DocumentList(total: 2, documents: mockStoryDocuments),
      ),
    );
  });

  test('test convertAppwriteDocListToStoryList', () async {
    final storiesList = await exploreStoryController
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
    expect(storiesList[1].userIsCreator, true);
  });

  test('test fetchStoryRecommendation', () async {
    exploreStoryController.fetchStoryRecommendation();
    expect(exploreStoryController.isLoadingRecommendedStories.value, true);
    await Future.delayed(Duration(seconds: 3));
    expect(exploreStoryController.isLoadingRecommendedStories.value, false);
    expect(exploreStoryController.recommendedStories.length, 2);
    for (int i = 0; i < exploreStoryController.recommendedStories.length; i++) {
      expect(
        mockStoriesList[i].storyId,
        exploreStoryController.recommendedStories[i].storyId,
      );
      expect(
        mockStoriesList[i].title,
        exploreStoryController.recommendedStories[i].title,
      );
      expect(
        mockStoriesList[i].description,
        exploreStoryController.recommendedStories[i].description,
      );
      expect(
        mockStoriesList[i].userIsCreator,
        exploreStoryController.recommendedStories[i].userIsCreator,
      );
      //Do not need to check everything as that is handled by the test above
    }
  });

  test('test fetchUserCreatedStories', () async {
    await exploreStoryController.fetchUserCreatedStories();
    expect(exploreStoryController.userCreatedStories.length, 1);
    expect(exploreStoryController.userCreatedStories[0].storyId, 'doc2');
    expect(exploreStoryController.userCreatedStories[0].title, 'Story 2');
    expect(
      exploreStoryController.userCreatedStories[0].description,
      'Description of Story 2',
    );
    expect(exploreStoryController.userCreatedStories[0].userIsCreator, true);
  });

  test('test convertAppwriteDocListToUserList', () async {
    final usersList = exploreStoryController.convertAppwriteDocListToUserList(
      mockUsersDocuments,
    );
    expect(usersList.length, 2);
    expect(usersList[0].name, 'Test User 1');
    expect(usersList[1].name, 'Test User 2');
    expect(usersList[0].email, 'testuser1@example.com');
    expect(usersList[1].email, 'testuser2@example.com');
    expect(usersList[0].profileImageUrl, 'https://example.com/profile1.jpg');
    expect(usersList[1].profileImageUrl, 'https://example.com/profile2.jpg');
    expect(usersList[0].userRating, 25 / 7);
    expect(usersList[1].userRating, 15 / 5);
    expect(usersList[0].dateOfBirth, '2000-01-01');
    expect(usersList[1].dateOfBirth, '2000-01-01');
    expect(usersList[0].docId, 'doc1');
    expect(usersList[1].docId, 'doc2');
    expect(usersList[0].uid, 'doc1');
    expect(usersList[1].uid, 'doc2');
  });
  test('test convertMeilisearchResultsToStoryList', () async {
    final storiesList = await exploreStoryController
        .convertMeilisearchResultsToStoryList(mockMeilisearchStoryResults);
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
    expect(storiesList[1].userIsCreator, true);
  });

  test('test convertMeilisearchResultsToUserList', () async {
    final usersList = exploreStoryController
        .convertMeilisearchResultsToUserList(mockMeilisearchUserResults);
    expect(usersList.length, 2);
    expect(usersList[0].name, 'Test User 1');
    expect(usersList[1].name, 'Test User 2');
    expect(usersList[0].email, 'testuser1@example.com');
    expect(usersList[1].email, 'testuser2@example.com');
    expect(usersList[0].profileImageUrl, 'https://example.com/profile1.jpg');
    expect(usersList[1].profileImageUrl, 'https://example.com/profile2.jpg');
    expect(usersList[0].userRating, 25 / 7);
    expect(usersList[1].userRating, 15 / 5);
    expect(usersList[0].dateOfBirth, '2000-01-01');
    expect(usersList[1].dateOfBirth, '2000-01-01');
    expect(usersList[0].docId, 'doc1');
    expect(usersList[1].docId, 'doc2');
    expect(usersList[0].uid, 'doc1');
    expect(usersList[1].uid, 'doc2');
  });
}
