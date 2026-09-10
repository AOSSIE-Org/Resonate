import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meilisearch/meilisearch.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';
import '../fake_meili_client.dart';

void main() {
  late MockTablesDB tables;
  late MockStorage storage;
  late MockFunctions functions;
  late FakeMeiliClient meili;

  // Passing the client is what puts search on Meilisearch; omitting it is the
  // Appwrite path, exactly as the provider wires it from the build flag.
  StoriesRepository repo({required bool useMeilisearch}) => StoriesRepository(
    tables: tables,
    storage: storage,
    functions: functions,
    meili: useMeilisearch ? meili : null,
  );

  // Local functions, not getters — a function body cannot declare a getter.
  FakeMeiliIndex storyIndex() => meili.indexNamed('stories');
  FakeMeiliIndex userIndex() => meili.indexNamed('users');

  void stubAppwriteStories(List<Row> rows) {
    when(
      tables.listRows(
        databaseId: storyDatabaseId,
        tableId: storyTableId,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => RowList(total: rows.length, rows: rows));
  }

  Row appwriteStoryRow({String id = 'appwrite-story'}) => buildRow(
    id: id,
    tableId: storyTableId,
    databaseId: storyDatabaseId,
    data: {
      'title': 'From Appwrite',
      'description': 'desc',
      'category': 'drama',
      'creatorId': 'creator-1',
      'creatorName': 'Creator',
      'creatorImgUrl': 'https://example.com/a.jpg',
      'coverImgUrl': 'https://example.com/c.jpg',
      'likes': 0,
      'playDuration': 100,
      'tintColor': 'cbc6c6',
      'tags': const ['gym'],
    },
  );

  setUp(() {
    tables = MockTablesDB();
    storage = MockStorage();
    functions = MockFunctions();
    meili = FakeMeiliClient();
    userIndex().hits = const [];
    when(
      tables.listRows(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => RowList(total: 0, rows: []));
  });

  group('semantic story search', () {
    test('asks for a hybrid ranking over the story index', () async {
      storyIndex().hits = [meiliStoryHit(title: 'Leg day', tags: const ['gym'])];

      final result = await repo(useMeilisearch: true).search(
        'fitness motivation',
        'me',
      );

      expect(result.stories.single.title, 'Leg day');
      expect(result.stories.single.tags, ['gym']);

      final sent = storyIndex().queries.single!.toSparseMap();
      expect(sent['hybrid'], {
        'embedder': storySemanticEmbedder,
        'semanticRatio': semanticSearchRatio,
      });
      // Vector search always returns its nearest neighbours; the floor is what
      // stops a nonsense query from answering with them.
      expect(sent['rankingScoreThreshold'], semanticScoreThreshold);
    });

    test('retries without the embedder when the index has none', () async {
      // What an index with no embedder configured actually answers.
      storyIndex().errors = [
        MeiliSearchApiException('embedder `stories-semantic` does not exist'),
      ];
      storyIndex().hits = [meiliStoryHit(title: 'Keyword hit')];

      final result = await repo(useMeilisearch: true).search('gym', 'me');

      expect(result.stories.single.title, 'Keyword hit');
      expect(storyIndex().queries, hasLength(2));
      expect(storyIndex().queries.first!.toSparseMap()['hybrid'], isNotNull);
      expect(storyIndex().queries.last!.toSparseMap()['hybrid'], isNull);
    });

    test('falls back to Appwrite when the index cannot answer at all', () async {
      storyIndex().errors = [
        MeiliSearchApiException('unreachable'),
        MeiliSearchApiException('unreachable'),
      ];
      stubAppwriteStories([appwriteStoryRow()]);

      final result = await repo(useMeilisearch: true).search('gym', 'me');

      expect(result.stories.single.title, 'From Appwrite');
      expect(storyIndex().queries, hasLength(2));
    });

    test('returns nothing rather than throwing when both sources fail', () async {
      storyIndex().errors = [
        MeiliSearchApiException('unreachable'),
        MeiliSearchApiException('unreachable'),
      ];
      when(
        tables.listRows(
          databaseId: storyDatabaseId,
          tableId: storyTableId,
          queries: anyNamed('queries'),
        ),
      ).thenThrow(Exception('offline'));

      final result = await repo(useMeilisearch: true).search('gym', 'me');

      expect(result.stories, isEmpty);
    });

    test('never touches the index while Meilisearch is off', () async {
      stubAppwriteStories([appwriteStoryRow()]);

      final result = await repo(useMeilisearch: false).search('gym', 'me');

      expect(result.stories.single.title, 'From Appwrite');
      expect(storyIndex().queries, isEmpty);
    });
  });
}
