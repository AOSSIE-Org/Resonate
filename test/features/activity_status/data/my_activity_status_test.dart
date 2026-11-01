import 'dart:async';

import 'package:appwrite/models.dart' show Row;
import 'package:flutter/widgets.dart' hide Row;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/providers/app_lifecycle_provider.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/activity_status/data/my_activity_status.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/activity_status.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

// Lets a test drive foreground/background without a real WidgetsBinding.
class FakeAppLifecycle extends AppLifecycle {
  FakeAppLifecycle([this.initial = AppLifecycleState.resumed]);

  final AppLifecycleState initial;

  @override
  AppLifecycleState build() => initial;

  void emit(AppLifecycleState next) => state = next;
}

void main() {
  late MockTablesDB tables;
  late MockRealtime realtime;

  Row row(String? status) => buildRow(
    id: 'me',
    tableId: usersTableID,
    databaseId: userDatabaseID,
    data: {'status': status},
  );

  // The status values written to Appwrite, in order.
  List<String> writes() =>
      verify(
            tables.updateRow(
              databaseId: userDatabaseID,
              tableId: usersTableID,
              rowId: 'me',
              data: captureAnyNamed('data'),
            ),
          ).captured
          .map((d) => (d as Map)['status'] as String)
          .toList();

  void stubStoredStatus(String? status) {
    when(
      tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        queries: anyNamed('queries'),
      ),
    ).thenAnswer((_) async => row(status));
  }

  ProviderContainer makeContainer({
    bool signedIn = true,
    AuthUser? user,
    AppLifecycleState lifecycle = AppLifecycleState.resumed,
  }) {
    final container = ProviderContainer(
      overrides: [
        appwriteTablesProvider.overrideWithValue(tables),
        appwriteRealtimeProvider.overrideWithValue(realtime),
        currentUserProvider.overrideWithValue(
          signedIn ? (user ?? fakeAuthUser(uid: 'me')) : null,
        ),
        liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
        appLifecycleProvider.overrideWith(() => FakeAppLifecycle(lifecycle)),
      ],
    );
    addTearDown(container.dispose);

    container.listen(myActivityStatusProvider, (_, _) {}, fireImmediately: true);
    return container;
  }

  setUp(() {
    tables = MockTablesDB();
    realtime = MockRealtime();
    stubStoredStatus('online');
    when(
      tables.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((_) async => row('online'));
  });

  group('sign-in state', () {
    test('reports offline and writes nothing with no signed-in user', () async {
      final container = makeContainer(signedIn: false);

      expect(container.read(myActivityStatusProvider), ActivityStatus.offline);
      await pumpEventQueue();

      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });

    test('publishes online for a signed-in user', () async {
      final container = makeContainer();

      expect(container.read(myActivityStatusProvider), ActivityStatus.online);
      await pumpEventQueue();

      expect(writes(), ['online']);
    });

    test('restores a deliberate dnd left behind by the last run', () async {
      stubStoredStatus('dnd');
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      expect(container.read(myActivityStatusProvider), ActivityStatus.dnd);
      // dnd is the FIRST thing published: nothing is written before the stored
      // status is known, so there is no online flash for a dnd user to leak a
      // call through on launch.
      expect(writes(), ['dnd']);
    });

    test('falls back to online when the last run left inroom behind', () async {
      stubStoredStatus('inroom');
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      expect(container.read(myActivityStatusProvider), ActivityStatus.online);
      // Nothing to correct: online was already written on the first pass.
      expect(writes(), ['online']);
    });

    test('publishes nothing until the stored status is known', () async {
      final gate = Completer<Row>();
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) => gate.future);

      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      // The read is still in flight, so nothing has been broadcast yet.
      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );

      gate.complete(row('invisible'));
      await pumpEventQueue();

      expect(writes(), ['invisible']);
    });

    test('a pick made mid-hydrate is not clobbered by the stored value', () async {
      final gate = Completer<Row>();
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) => gate.future);

      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container
          .read(myActivityStatusProvider.notifier)
          .setStatus(ActivityStatus.dnd);

      gate.complete(row('invisible'));
      await pumpEventQueue();

      expect(container.read(myActivityStatusProvider), ActivityStatus.dnd);
      expect(writes(), ['dnd']);
    });

    test('a failed hydrate leaves activity status usable', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          queries: anyNamed('queries'),
        ),
      ).thenThrow(Exception('offline'));

      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      expect(container.read(myActivityStatusProvider), ActivityStatus.online);
    });
  });

  group('room sessions', () {
    test('joining publishes inroom and leaving restores the choice', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container
          .read(liveKitControllerProvider.notifier)
          .connect(liveKitUri: 'uri', roomToken: 'token');
      expect(container.read(myActivityStatusProvider), ActivityStatus.inRoom);
      await pumpEventQueue();

      await container.read(liveKitControllerProvider.notifier).disconnect();
      expect(container.read(myActivityStatusProvider), ActivityStatus.online);
      await pumpEventQueue();

      expect(writes(), ['online', 'inroom', 'online']);
    });

    test('leaving a room restores dnd, not online', () async {
      stubStoredStatus('dnd');
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container
          .read(liveKitControllerProvider.notifier)
          .connect(liveKitUri: 'uri', roomToken: 'token');
      await pumpEventQueue();
      await container.read(liveKitControllerProvider.notifier).disconnect();
      await pumpEventQueue();

      expect(container.read(myActivityStatusProvider), ActivityStatus.dnd);
      expect(writes(), ['dnd', 'inroom', 'dnd']);
    });
  });

  group('app lifecycle', () {
    test('backgrounding an online user publishes offline', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      final lifecycle =
          container.read(appLifecycleProvider.notifier) as FakeAppLifecycle;
      lifecycle.emit(AppLifecycleState.paused);
      expect(container.read(myActivityStatusProvider), ActivityStatus.offline);
      await pumpEventQueue();

      lifecycle.emit(AppLifecycleState.resumed);
      expect(container.read(myActivityStatusProvider), ActivityStatus.online);
      await pumpEventQueue();

      expect(writes(), ['online', 'offline', 'online']);
    });

    test('inactive is not treated as away', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      (container.read(appLifecycleProvider.notifier) as FakeAppLifecycle).emit(
        AppLifecycleState.inactive,
      );

      expect(container.read(myActivityStatusProvider), ActivityStatus.online);
      await pumpEventQueue();
      expect(writes(), ['online']);
    });

    test('backgrounding does not override a deliberate dnd', () async {
      stubStoredStatus('dnd');
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      (container.read(appLifecycleProvider.notifier) as FakeAppLifecycle).emit(
        AppLifecycleState.paused,
      );

      expect(container.read(myActivityStatusProvider), ActivityStatus.dnd);
      await pumpEventQueue();
      expect(writes(), ['dnd']);
    });

    test('a room session outranks being backgrounded', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container
          .read(liveKitControllerProvider.notifier)
          .connect(liveKitUri: 'uri', roomToken: 'token');
      (container.read(appLifecycleProvider.notifier) as FakeAppLifecycle).emit(
        AppLifecycleState.paused,
      );

      expect(container.read(myActivityStatusProvider), ActivityStatus.inRoom);
      await pumpEventQueue();
      expect(writes(), ['online', 'inroom']);
    });
  });

  group('setStatus', () {
    test('publishes the pick and remembers it as the choice', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container
          .read(myActivityStatusProvider.notifier)
          .setStatus(ActivityStatus.invisible);

      expect(container.read(myActivityStatusProvider), ActivityStatus.invisible);
      expect(
        container.read(myActivityStatusProvider.notifier).chosen,
        ActivityStatus.invisible,
      );
      expect(writes(), ['online', 'invisible']);
    });

    test('a pick made during a room session applies on leaving', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container
          .read(liveKitControllerProvider.notifier)
          .connect(liveKitUri: 'uri', roomToken: 'token');
      await pumpEventQueue();

      await container
          .read(myActivityStatusProvider.notifier)
          .setStatus(ActivityStatus.dnd);
      // Still in the room, so the room wins for now.
      expect(container.read(myActivityStatusProvider), ActivityStatus.inRoom);

      await container.read(liveKitControllerProvider.notifier).disconnect();
      await pumpEventQueue();

      expect(container.read(myActivityStatusProvider), ActivityStatus.dnd);
      expect(writes(), ['online', 'inroom', 'dnd']);
    });

    test('repeating the current status writes once', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      final notifier = container.read(myActivityStatusProvider.notifier);
      await notifier.setStatus(ActivityStatus.dnd);
      await notifier.setStatus(ActivityStatus.dnd);
      await notifier.setStatus(ActivityStatus.dnd);

      expect(writes(), ['online', 'dnd']);
    });

    test('a failed write is swallowed and retried on the next change', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenThrow(Exception('network'));

      final notifier = container.read(myActivityStatusProvider.notifier);
      await notifier.setStatus(ActivityStatus.dnd);
      // The local view still moved, so the UI is not stuck.
      expect(container.read(myActivityStatusProvider), ActivityStatus.dnd);

      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => row('dnd'));

      // Same status again: the cleared dedupe lets the failed write retry.
      await notifier.setStatus(ActivityStatus.dnd);
      expect(writes(), ['online', 'dnd', 'dnd']);
    });
  });

  group('goOffline', () {
    test('publishes offline while the session still exists', () async {
      final container = makeContainer();
      container.read(myActivityStatusProvider);
      await pumpEventQueue();

      await container.read(myActivityStatusProvider.notifier).goOffline();

      expect(writes(), ['online', 'offline']);
    });

    test('is a no-op with no signed-in user', () async {
      final container = makeContainer(signedIn: false);
      container.read(myActivityStatusProvider);

      await container.read(myActivityStatusProvider.notifier).goOffline();

      verifyNever(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      );
    });
  });
}
