import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/features/stories/model/stories_failure.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row storyRow({
  String id = 'story-1',
  String title = 'A Story',
  String description = 'desc',
  String category = 'drama',
  String creatorId = 'creator-1',
  String creatorName = 'Creator',
  String creatorImgUrl = 'https://example.com/a.jpg',
  String coverImgUrl = 'https://example.com/c.jpg',
  int likes = 0,
  int playDuration = 1000,
  String tintColor = 'cbc6c6',
  List<String> tags = const [],
}) =>
    buildRow(
      id: id,
      tableId: storyTableId,
      databaseId: storyDatabaseId,
      data: {
        'title': title,
        'description': description,
        'category': category,
        'creatorId': creatorId,
        'creatorName': creatorName,
        'creatorImgUrl': creatorImgUrl,
        'coverImgUrl': coverImgUrl,
        'likes': likes,
        'playDuration': playDuration,
        'tintColor': tintColor,
        'tags': tags,
      },
    );

Row chapterRow({
  String id = 'chapter-1',
  String title = 'A Chapter',
  String description = 'desc',
  String lyrics = '',
  String coverImgUrl = 'https://example.com/cc.jpg',
  String audioFileUrl = 'https://example.com/audio.mp3',
  int playDuration = 250,
  String tintColor = 'cbc6c6',
}) =>
    buildRow(
      id: id,
      tableId: chapterTableId,
      databaseId: storyDatabaseId,
      data: {
        'title': title,
        'description': description,
        'lyrics': lyrics,
        'coverImgUrl': coverImgUrl,
        'audioFileUrl': audioFileUrl,
        'playDuration': playDuration,
        'tintColor': tintColor,
      },
    );

Row likeRow({String id = 'like-1', String uid = 'me', String storyId = 'story-1'}) =>
    buildRow(
      id: id,
      tableId: likeTableId,
      databaseId: storyDatabaseId,
      data: {'uId': uid, 'storyId': storyId},
    );

Row userRow({
  String id = 'user-1',
  String name = 'Alice',
  String username = 'alice',
  String profileImageUrl = 'https://example.com/u.jpg',
  int ratingCount = 1,
  double ratingTotal = 4,
}) =>
    buildRow(
      id: id,
      tableId: usersTableID,
      databaseId: userDatabaseID,
      data: {
        'name': name,
        'username': username,
        'profileImageUrl': profileImageUrl,
        'ratingCount': ratingCount,
        'ratingTotal': ratingTotal,
      },
    );

void main() {
  late MockTablesDB tables;
  late MockStorage storage;
  late MockFunctions functions;
  late StoriesRepository repo;

  setUp(() {
    tables = MockTablesDB();
    storage = MockStorage();
    functions = MockFunctions();
    repo = StoriesRepository(
      tables: tables,
      storage: storage,
      functions: functions,
    );
  });

  void stubStoryList(List<Row> rows) {
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => RowList(total: rows.length, rows: rows));
  }

  group('fetchRecommendedStories', () {
    test('parses rows and flags the current user as creator', () async {
      stubStoryList([storyRow(id: 's1', creatorId: 'me')]);

      final stories = await repo.fetchRecommendedStories('me');

      expect(stories, hasLength(1));
      expect(stories.first.storyId, 's1');
      expect(stories.first.userIsCreator, isTrue);
    });

    test('skips malformed rows instead of throwing', () async {
      stubStoryList([
        storyRow(id: 'ok'),
        storyRow(id: 'bad', category: 'not-a-real-category'),
      ]);

      final stories = await repo.fetchRecommendedStories('me');

      expect(stories, hasLength(1));
      expect(stories.first.storyId, 'ok');
    });

    test('returns an empty list on AppwriteException', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: anyNamed('queries'),
      )).thenThrow(AppwriteException('boom', 500));

      expect(await repo.fetchRecommendedStories('me'), isEmpty);
    });
  });

  group('fetchStoriesByCategory', () {
    test('returns stories for the requested category', () async {
      stubStoryList([storyRow(category: 'horror')]);

      final stories = await repo.fetchStoriesByCategory(StoryCategory.horror, 'me');

      expect(stories.single.category, StoryCategory.horror);
    });
  });

  group('fetchCreatedStories', () {
    // userIsCreator is about who is *looking*, not whose stories these are —
    // so it depends on viewerUid, not on creatorId.
    test('marks stories as owned when the viewer is the creator', () async {
      stubStoryList([storyRow(creatorId: 'creator-9')]);

      final stories = await repo.fetchCreatedStories(
        'creator-9',
        viewerUid: 'creator-9',
      );

      expect(stories.single.userIsCreator, isTrue);
    });

    test('does not mark them owned when someone else is viewing', () async {
      stubStoryList([storyRow(creatorId: 'creator-9')]);

      final stories = await repo.fetchCreatedStories(
        'creator-9',
        viewerUid: 'someone-else',
      );

      expect(stories.single.userIsCreator, isFalse);
    });

    test('does not mark them owned for a signed-out viewer', () async {
      stubStoryList([storyRow(creatorId: 'creator-9')]);

      final stories = await repo.fetchCreatedStories('creator-9');

      expect(stories.single.userIsCreator, isFalse);
    });
  });

  group('fetchLikedStories', () {
    test('resolves each like into its story and skips missing ones', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 2,
            rows: [
              likeRow(id: 'l1', storyId: 's1'),
              likeRow(id: 'l2', storyId: 'missing'),
            ],
          ));
      when(tables.getRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
      )).thenAnswer((_) async => storyRow(id: 's1'));
      when(tables.getRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 'missing',
      )).thenThrow(AppwriteException('not found', 404));

      final stories = await repo.fetchLikedStories('me');

      expect(stories, hasLength(1));
      expect(stories.first.storyId, 's1');
    });
  });

  group('fetchChaptersForStory', () {
    test('maps chapter rows into Chapter objects', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 1,
            rows: [chapterRow(id: 'c1', title: 'Chapter 1')],
          ));

      final chapters = await repo.fetchChaptersForStory('s1');

      expect(chapters, hasLength(1));
      expect(chapters.first.chapterId, 'c1');
      expect(chapters.first.title, 'Chapter 1');
    });
  });

  group('fetchLikesCount', () {
    test('reads the likes attribute off the story row', () async {
      when(tables.getRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => buildRow(
            id: 's1',
            tableId: storyTableId,
            databaseId: storyDatabaseId,
            data: {'likes': 7},
          ));

      expect(await repo.fetchLikesCount('s1'), 7);
    });
  });

  group('checkIfStoryLikedByUser', () {
    test('returns true when a like row exists', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 1, rows: [likeRow()]));

      expect(await repo.checkIfStoryLikedByUser('s1', 'me'), isTrue);
    });

    test('returns false when no like row exists', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      expect(await repo.checkIfStoryLikedByUser('s1', 'me'), isFalse);
    });
  });

  group('fetchLiveChapterForStory', () {
    test('returns null when there is no live chapter', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: liveChaptersTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      expect(await repo.fetchLiveChapterForStory('s1'), isNull);
    });

    test('builds the model with attendees when one exists', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: liveChaptersTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 1,
            rows: [
              buildRow(
                id: 'lc1',
                tableId: liveChaptersTableId,
                databaseId: storyDatabaseId,
                data: {
                  '\$id': 'lc1',
                  'livekitRoomId': 'room-1',
                  'authorUid': 'creator-1',
                  'authorProfileImageUrl': 'https://example.com/a.jpg',
                  'authorName': 'Creator',
                  'chapterTitle': 'Live One',
                  'chapterDescription': 'desc',
                  'storyId': 's1',
                  'followersFCMToken': <String>[],
                },
              ),
            ],
          ));
      when(tables.getRow(
        databaseId: userDatabaseID,
        tableId: liveChapterAttendeesTableId,
        rowId: 'lc1',
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => buildRow(
            id: 'lc1',
            tableId: liveChapterAttendeesTableId,
            databaseId: userDatabaseID,
            data: {
              'liveChapterId': 'lc1',
              'users': [
                {'\$id': 'u1', 'name': 'U', 'profileImageUrl': ''},
              ],
            },
          ));

      final live = await repo.fetchLiveChapterForStory('s1');

      expect(live, isNotNull);
      expect(live!.id, 'lc1');
      expect(live.chapterTitle, 'Live One');
      expect(live.attendees!.users, hasLength(1));
    });
  });

  group('loadStoryDetail', () {
    test('aggregates chapters, likes, like-status and live chapter', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 1, rows: [chapterRow()]));
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.getRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => buildRow(
            id: 's1',
            tableId: storyTableId,
            databaseId: storyDatabaseId,
            data: {'likes': 3},
          ));
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: liveChaptersTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      final state = await repo.loadStoryDetail('s1', 'me');

      expect(state.chapters, hasLength(1));
      expect(state.likesCount, 3);
      expect(state.isLikedByCurrentUser, isFalse);
      expect(state.liveChapter, isNull);
    });
  });

  group('search (Appwrite path)', () {
    test('returns matching stories and users', () async {
      stubStoryList([storyRow(title: 'Adventure')]);
      when(tables.listRows(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 1, rows: [userRow()]));

      final state = await repo.search('adv', 'me');

      expect(state.stories, hasLength(1));
      expect(state.users, hasLength(1));
      expect(state.users.first.userName, 'alice');
    });

    test('matches creator-chosen tags as well as the text columns', () async {
      stubStoryList([storyRow(tags: const ['tech talks'])]);
      when(tables.listRows(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));

      final state = await repo.search('Tech  Talks', 'me');

      expect(state.stories.single.tags, ['tech talks']);

      final queries = verify(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: captureAnyNamed('queries'),
      )).captured.single as List<String>;
      // The query is normalised the same way the stored tags were.
      expect(
        queries.first,
        Query.or([
          Query.search('title', 'Tech  Talks'),
          Query.search('creatorName', 'Tech  Talks'),
          Query.search('description', 'Tech  Talks'),
          Query.contains('tags', ['tech talks']),
        ]),
      );
    });
  });

  group('likeStory', () {
    test('inserts a like row and increments the story counter', () async {
      final story = fakeStory(storyId: 's1', likesCount: 5);
      when(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => likeRow());
      when(tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        data: anyNamed('data'),
      )).thenAnswer((_) async => storyRow(id: 's1'));

      await repo.likeStory(story, 'me');

      verify(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
      verify(tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        data: {'likes': 6},
      )).called(1);
    });

    test('throws StoriesFailure.unknown when the SDK errors', () async {
      when(tables.createRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(AppwriteException('nope', 500));

      expect(
        repo.likeStory(fakeStory(storyId: 's1'), 'me'),
        throwsA(isA<StoriesFailureUnknown>()),
      );
    });
  });

  group('unlikeStory', () {
    test('deletes the like row and decrements the counter', () async {
      final story = fakeStory(storyId: 's1', likesCount: 5);
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 1, rows: [likeRow(id: 'like-7')]));
      when(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        rowId: 'like-7',
      )).thenAnswer((_) async => '');
      when(tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        data: anyNamed('data'),
      )).thenAnswer((_) async => storyRow(id: 's1'));

      await repo.unlikeStory(story, 'me');

      verify(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        rowId: 'like-7',
      )).called(1);
      verify(tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        data: {'likes': 4},
      )).called(1);
    });
  });

  group('createStory', () {
    test('writes the story row when the cover is already a URL', () async {
      when(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => storyRow());

      await repo.createStory(
        user: fakeAuthUser(uid: 'me'),
        title: 'My Story',
        description: 'desc',
        category: StoryCategory.drama,
        coverImgRef: 'https://example.com/cover.jpg',
        storyPlayDuration: 100,
        chapters: const [],
      );

      verify(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).called(1);
      verifyNever(functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ));
    });

    test('stores the tags normalised', () async {
      when(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => storyRow());

      await repo.createStory(
        user: fakeAuthUser(uid: 'me'),
        title: 'My Story',
        description: 'desc',
        category: StoryCategory.drama,
        coverImgRef: 'https://example.com/cover.jpg',
        storyPlayDuration: 100,
        chapters: const [],
        tags: const [' Tech Talks ', 'TECH TALKS', 'ai'],
      );

      final data = verify(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: anyNamed('rowId'),
        data: captureAnyNamed('data'),
      )).captured.single as Map;
      expect(data['tags'], ['tech talks', 'ai']);
    });

    test('throws StoriesFailure.unknown when the row write fails', () async {
      when(tables.createRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      )).thenThrow(AppwriteException('invalid structure', 400));

      expect(
        repo.createStory(
          user: fakeAuthUser(uid: 'me'),
          title: 'My Story',
          description: 'desc',
          category: StoryCategory.drama,
          coverImgRef: 'https://example.com/cover.jpg',
          storyPlayDuration: 100,
          chapters: const [],
        ),
        throwsA(isA<StoriesFailureUnknown>()),
      );
    });
  });

  group('addChaptersToStory', () {
    test('recomputes play duration from the persisted chapters', () async {
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(
            total: 2,
            rows: [
              chapterRow(id: 'c1', playDuration: 200),
              chapterRow(id: 'c2', playDuration: 300),
            ],
          ));
      when(tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        data: anyNamed('data'),
      )).thenAnswer((_) async => storyRow(id: 's1'));

      await repo.addChaptersToStory(const [], 's1');

      verify(tables.updateRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
        data: {'playDuration': 500},
      )).called(1);
    });
  });

  group('deleteStory', () {
    test('removes cover, chapters, likes and the story row', () async {
      final story = fakeStory(storyId: 's1');
      when(storage.deleteFile(
        bucketId: storyBucketId,
        fileId: anyNamed('fileId'),
      )).thenAnswer((_) async => null);
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: likeTableId,
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
      )).thenAnswer((_) async => '');

      await repo.deleteStory(story);

      verify(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
      )).called(1);
    });

    test('throws StoriesFailure.unknown when the row delete fails', () async {
      final story = fakeStory(storyId: 's1');
      when(storage.deleteFile(
        bucketId: storyBucketId,
        fileId: anyNamed('fileId'),
      )).thenAnswer((_) async => null);
      when(tables.listRows(
        databaseId: storyDatabaseId,
        tableId: anyNamed('tableId'),
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => RowList(total: 0, rows: []));
      when(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        rowId: 's1',
      )).thenThrow(AppwriteException('locked', 500));

      expect(repo.deleteStory(story), throwsA(isA<StoriesFailureUnknown>()));
    });
  });

  group('deleteChapter', () {
    test('removes the cover, audio and chapter row', () async {
      final chapter = fakeChapter(chapterId: 'c1');
      when(storage.deleteFile(
        bucketId: storyBucketId,
        fileId: anyNamed('fileId'),
      )).thenAnswer((_) async => null);
      when(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        rowId: 'c1',
      )).thenAnswer((_) async => '');

      await repo.deleteChapter(chapter);

      verify(storage.deleteFile(bucketId: storyBucketId, fileId: 'c1')).called(1);
      verify(storage.deleteFile(bucketId: storyBucketId, fileId: 'audioForc1'))
          .called(1);
      verify(tables.deleteRow(
        databaseId: storyDatabaseId,
        tableId: chapterTableId,
        rowId: 'c1',
      )).called(1);
    });
  });
}
