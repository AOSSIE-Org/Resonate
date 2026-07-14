import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

Row _storyRow({String id = 's1', String category = 'horror'}) => buildRow(
      id: id,
      tableId: storyTableId,
      databaseId: storyDatabaseId,
      data: {
        'title': 'Story $id',
        'description': 'desc',
        'category': category,
        'creatorId': 'creator-1',
        'creatorName': 'Creator',
        'creatorImgUrl': 'https://example.com/a.jpg',
        'coverImgUrl': 'https://example.com/c.jpg',
        'likes': 0,
        'playDuration': 1000,
        'tintColor': 'cbc6c6',
      },
    );

void main() {
  late MockTablesDB tables;
  late MockStorage storage;
  late MockFunctions functions;

  setUp(() {
    tables = MockTablesDB();
    storage = MockStorage();
    functions = MockFunctions();
  });

  Future<dynamic> install() => installTestRootContainer(
        authState: AuthState.authenticated(fakeAuthUser(uid: 'me')),
        tables: tables,
        storage: storage,
        functions: functions,
      );

  test('build returns stories for the requested category', () async {
    when(tables.listRows(
      databaseId: storyDatabaseId,
      tableId: storyTableId,
      queries: anyNamed('queries'),
    )).thenAnswer((_) async =>
        RowList(total: 1, rows: [_storyRow(category: 'horror')]));

    final container = await install();
    final key = categoryStoriesProvider(StoryCategory.horror);
    container.listen(key, (_, _) {});

    final stories = await container.read(key.future);

    expect(stories, hasLength(1));
    expect(stories.first.category, StoryCategory.horror);
  });
}
