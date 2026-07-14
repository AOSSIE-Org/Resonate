import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/widgets/live_room_tile.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/data/live_rooms.dart';
import 'package:resonate/features/rooms/viewmodel/single_room_notifier.dart';

import '../rooms_test_helpers.dart';

List<Override> buildOverrides({
  FakeRoomLauncher? launcher,
  FakeLiveRooms? liveRooms,
}) {
  final me = fakeParticipant(uid: 'me');
  return [
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
    roomLauncherProvider.overrideWithValue(launcher ?? FakeRoomLauncher()),
    liveRoomsProvider.overrideWith(() => liveRooms ?? FakeLiveRooms()),
    // Any room the sheet opens resolves to this deterministic state.
    singleRoomProvider.overrideWith(() => FakeSingleRoom(SingleRoomState(me: me))),
  ];
}

void main() {
  group('CustomLiveRoomTile rendering', () {
    testRoomsWidget('shows at most 3 avatars even with more members', (
      tester,
    ) async {
      final room = fakeAppwriteRoom(
        memberAvatarUrls: const [
          'https://example.com/1.jpg',
          'https://example.com/2.jpg',
          'https://example.com/3.jpg',
          'https://example.com/4.jpg',
          'https://example.com/5.jpg',
        ],
      );
      await pumpRoomsPage(
        tester,
        CustomLiveRoomTile(appwriteRoom: room),
        overrides: buildOverrides(),
      );
      await tester.pump();

      expect(find.byType(CustomCircleAvatar), findsNWidgets(3));
    });

    testRoomsWidget('renders one avatar per member when 3 or fewer', (
      tester,
    ) async {
      final room = fakeAppwriteRoom(
        memberAvatarUrls: const [
          'https://example.com/1.jpg',
          'https://example.com/2.jpg',
        ],
      );
      await pumpRoomsPage(
        tester,
        CustomLiveRoomTile(appwriteRoom: room),
        overrides: buildOverrides(),
      );
      await tester.pump();

      expect(find.byType(CustomCircleAvatar), findsNWidgets(2));
    });

    testRoomsWidget('renders a share IconButton', (tester) async {
      await pumpRoomsPage(
        tester,
        CustomLiveRoomTile(appwriteRoom: fakeAppwriteRoom()),
        overrides: buildOverrides(),
      );
      await tester.pump();

      expect(find.byIcon(Icons.share), findsOneWidget);
    });
  });

  group('CustomLiveRoomTile interactions', () {
    testRoomsWidget('tapping Join calls RoomLauncher.joinRoom', (
      tester,
    ) async {
      final launcher = FakeRoomLauncher();
      final room = fakeAppwriteRoom(id: 'r1', isUserAdmin: false);
      await pumpRoomsPage(
        tester,
        CustomLiveRoomTile(appwriteRoom: room),
        overrides: buildOverrides(launcher: launcher),
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Join'));
      await tester.pump();

      expect(launcher.joinCount, 1);
      expect(launcher.lastJoined?.id, 'r1');

      // Let the modal sheet finish opening so pending timers/frames drain.
      await tester.pumpAndSettle();
    });

    testRoomsWidget('a failed join refreshes the rooms list', (tester) async {
      final launcher = FakeRoomLauncher(joinThrows: true);
      final liveRooms = FakeLiveRooms();
      final room = fakeAppwriteRoom(id: 'r1');
      await pumpRoomsPage(
        tester,
        CustomLiveRoomTile(appwriteRoom: room),
        overrides: buildOverrides(launcher: launcher, liveRooms: liveRooms),
      );
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Join'));
      await tester.pumpAndSettle();

      expect(launcher.joinCount, 1);
      expect(liveRooms.refreshCount, 1);
    });

    testRoomsWidget('tapping the share button does not throw', (tester) async {
      await pumpRoomsPage(
        tester,
        CustomLiveRoomTile(appwriteRoom: fakeAppwriteRoom()),
        overrides: buildOverrides(),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.share));
      await tester.pump();
    });
  });
}
