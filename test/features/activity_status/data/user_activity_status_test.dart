import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/activity_status/data/user_activity_status.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/activity_status.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

class FakeFriends extends FriendsNotifier {
  FakeFriends(this.initial);

  final FriendsState initial;

  @override
  Future<FriendsState> build() async => initial;
}

Row userRow({required String id, String? status}) => buildRow(
  id: id,
  tableId: usersTableID,
  databaseId: userDatabaseID,
  data: {'status': status},
);

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;
  late MockRealtimeSubscription sub;
  late StreamController<RealtimeMessage> events;
  late String channel;


  final friendsState = FriendsState(
    friends: [
      fakeFriendsModel(
        docId: 'friend-1',
        senderId: 'me',
        recieverId: 'them-1',
      ),
      fakeFriendsModel(
        docId: 'friend-2',
        senderId: 'them-2',
        recieverId: 'me',
      ),
    ],
    friendRequests: [
      fakeFriendsModel(
        docId: 'friend-3',
        senderId: 'them-3',
        recieverId: 'me',
      ),
    ],
  );

  RealtimeMessage activityStatusEvent({
    required String uid,
    required String status,
    String action = 'update',
  }) => RealtimeMessage(
    events: ['$channel.$uid.$action'],
    payload: {r'$id': uid, 'status': status},
    channels: [channel],
    timestamp: DateTime.now().toIso8601String(),
  );

  ProviderContainer makeContainer({FriendsState? friends}) {
    final container = ProviderContainer(
      overrides: [
        appwriteTablesProvider.overrideWithValue(tables),
        appwriteRealtimeProvider.overrideWithValue(realtime),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        friendsProvider.overrideWith(
          () => FakeFriends(friends ?? friendsState),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    sub = MockRealtimeSubscription();
    events = StreamController<RealtimeMessage>.broadcast();
    channel = 'databases.$userDatabaseID.tables.$usersTableID.rows';

    when(realtime.subscribe([channel])).thenReturn(sub);
    when(sub.stream).thenAnswer((_) => events.stream);
    when(sub.close).thenReturn(() async {});

    when(
      tables.listRows(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        queries: anyNamed('queries'),
      ),
    ).thenAnswer(
      (_) async => RowList(
        total: 3,
        rows: [
          userRow(id: 'them-1', status: 'online'),
          userRow(id: 'them-2', status: 'dnd'),
          userRow(id: 'them-3', status: 'invisible'),
        ],
      ),
    );
  });

  tearDown(() => events.close());

  test('is empty until the friends list resolves', () {
    final container = makeContainer();
    expect(container.read(userActivityStatusProvider), isEmpty);
  });

  test('loads the status of every friend, from either side of the row', () async {
    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    expect(container.read(userActivityStatusProvider), {
      'them-1': ActivityStatus.online,
      'them-2': ActivityStatus.dnd,
      // Invisible is private to its owner: everyone else sees offline.
      'them-3': ActivityStatus.offline,
    });

    final queries =
        verify(
              tables.listRows(
                databaseId: userDatabaseID,
                tableId: usersTableID,
                queries: captureAnyNamed('queries'),
              ),
            ).captured.single
            as List<String>;
    expect(queries[1], Query.select([r'$id', 'status']));
  });

  test('never surfaces invisible to other users', () async {
    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    expect(
      container.read(userActivityStatusProvider).values,
      isNot(contains(ActivityStatus.invisible)),
    );
  });

  test('applies realtime updates for tracked friends', () async {
    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    events.add(activityStatusEvent(uid: 'them-1', status: 'inroom'));
    await pumpEventQueue();

    expect(
      container.read(userActivityStatusProvider)['them-1'],
      ActivityStatus.inRoom,
    );
  });

  test('maps a realtime invisible onto offline', () async {
    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    events.add(activityStatusEvent(uid: 'them-1', status: 'invisible'));
    await pumpEventQueue();

    expect(
      container.read(userActivityStatusProvider)['them-1'],
      ActivityStatus.offline,
    );
  });

  test('ignores realtime updates for people who are not friends', () async {
    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    events.add(activityStatusEvent(uid: 'stranger', status: 'dnd'));
    await pumpEventQueue();

    expect(container.read(userActivityStatusProvider).containsKey('stranger'), isFalse);
  });

  test('a failed load leaves the map empty rather than throwing', () async {
    when(
      tables.listRows(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        queries: anyNamed('queries'),
      ),
    ).thenThrow(Exception('network'));

    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    expect(container.read(userActivityStatusProvider), isEmpty);
  });

  test('statusOf reads through to the cache', () async {
    final container = makeContainer();
    await container.read(friendsProvider.future);
    container.read(userActivityStatusProvider);
    await pumpEventQueue();

    expect(
      container.read(userActivityStatusProvider.notifier).statusOf('them-2'),
      ActivityStatus.dnd,
    );
    expect(
      container.read(userActivityStatusProvider.notifier).statusOf('nobody'),
      isNull,
    );
  });
}
