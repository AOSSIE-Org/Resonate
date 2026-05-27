import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../helpers/test_root_container.dart';
import 'explore_story_controller_test.mocks.dart';

@GenerateMocks([TablesDB, Storage, Functions])
List<Row> mockStoryDocuments = [
  Row(
    $id: 'doc1',
    $tableId: storyTableId,
    $databaseId: storyDatabaseId,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $permissions: ['any'],
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
    $sequence: 0,
  ),
  Row(
    $id: 'doc2',
    $tableId: storyTableId,
    $databaseId: storyDatabaseId,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $permissions: ['any'],
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
    $sequence: 1,
  ),
];
List<Row> mockUsersDocuments = [
  Row(
    $id: 'doc1',
    $tableId: usersTableID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $permissions: ['any'],
    data: {
      'name': 'Test User 1',
      'dob': '2000-01-01',
      'username': 'testuser1',
      'profileImageUrl': 'https://example.com/profile1.jpg',
      'email': 'testuser1@example.com',
      'profileImageId': 'profileImageId1',
      'ratingCount': 7,
      'ratingTotal': 25,
    },
    $sequence: 0,
  ),
  Row(
    $id: 'doc2',
    $tableId: usersTableID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $updatedAt: DateTime.fromMillisecondsSinceEpoch(1754337186).toIso8601String(),
    $permissions: ['any'],
    data: {
      'name': 'Test User 2',
      'dob': '2000-01-01',
      'username': 'testuser2',
      'profileImageUrl': 'https://example.com/profile2.jpg',
      'email': 'testuser2@example.com',
      'profileImageId': 'profileImageId2',
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
    tintColor: const Color(0xff0000FF),
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
    tintColor: const Color(0xff0000FF),
    chapters: [],
  ),
];

void main() {
  late MockTablesDB tables;
  late ExploreStoryController exploreStoryController;

  setUp(() async {
    await installTestRootContainer(
      authState: AuthState.authenticated(fakeAuthUser(uid: 'id2')),
    );

    tables = MockTablesDB();
    exploreStoryController = ExploreStoryController(
      tables: tables,
      storage: MockStorage(),
      functions: MockFunctions(),
    );

    when(
      tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.equal('creatorId', 'id2')],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 2),
        () => RowList(total: 1, rows: [mockStoryDocuments[1]]),
      ),
    );
    when(
      tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.equal('creatorId', 'id1')],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 2),
        () => RowList(total: 1, rows: [mockStoryDocuments[0]]),
      ),
    );
    when(
      tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: [Query.limit(10)],
      ),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(seconds: 2),
        () => RowList(total: 2, rows: mockStoryDocuments),
      ),
    );
  });

  test('convertAppwriteDocListToStoryList maps fields correctly', () async {
    final stories = await exploreStoryController
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
    // userIsCreator depends on auth uid; we set it to id2, story[1].creatorId == id2.
    expect(stories[1].userIsCreator, true);
  });

  test('fetchStoryRecommendation populates recommendedStories', () async {
    exploreStoryController.fetchStoryRecommendation();
    expect(exploreStoryController.isLoadingRecommendedStories.value, true);
    await Future.delayed(const Duration(seconds: 3));
    expect(exploreStoryController.isLoadingRecommendedStories.value, false);
    expect(exploreStoryController.recommendedStories.length, 2);
    for (var i = 0; i < exploreStoryController.recommendedStories.length; i++) {
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
    }
  });

  test('fetchUserCreatedStories populates userCreatedStories', () async {
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

  test('convertAppwriteDocListToUserList maps fields correctly', () async {
    final users = exploreStoryController.convertAppwriteDocListToUserList(
      mockUsersDocuments,
    );
    expect(users.length, 2);
    expect(users[0].name, 'Test User 1');
    expect(users[1].name, 'Test User 2');
    expect(users[0].email, 'testuser1@example.com');
    expect(users[1].email, 'testuser2@example.com');
    expect(users[0].profileImageUrl, 'https://example.com/profile1.jpg');
    expect(users[1].profileImageUrl, 'https://example.com/profile2.jpg');
    expect(users[0].userRating, 25 / 7);
    expect(users[1].userRating, 15 / 5);
    expect(users[0].dateOfBirth, '2000-01-01');
    expect(users[1].dateOfBirth, '2000-01-01');
    expect(users[0].docId, 'doc1');
    expect(users[1].docId, 'doc2');
    expect(users[0].uid, 'doc1');
    expect(users[1].uid, 'doc2');
  });

  test('convertMeilisearchResultsToStoryList maps fields correctly',
      () async {
    final stories = await exploreStoryController
        .convertMeilisearchResultsToStoryList(mockMeilisearchStoryResults);
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
    expect(stories[1].userIsCreator, true);
  });

  test('convertMeilisearchResultsToUserList maps fields correctly', () {
    final users = exploreStoryController
        .convertMeilisearchResultsToUserList(mockMeilisearchUserResults);
    expect(users.length, 2);
    expect(users[0].name, 'Test User 1');
    expect(users[1].name, 'Test User 2');
    expect(users[0].email, 'testuser1@example.com');
    expect(users[1].email, 'testuser2@example.com');
    expect(users[0].profileImageUrl, 'https://example.com/profile1.jpg');
    expect(users[1].profileImageUrl, 'https://example.com/profile2.jpg');
    expect(users[0].userRating, 25 / 7);
    expect(users[1].userRating, 15 / 5);
    expect(users[0].dateOfBirth, '2000-01-01');
    expect(users[1].dateOfBirth, '2000-01-01');
    expect(users[0].docId, 'doc1');
    expect(users[1].docId, 'doc2');
    expect(users[0].uid, 'doc1');
    expect(users[1].uid, 'doc2');
  });
}
