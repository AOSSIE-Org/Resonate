import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/rooms/model/room_polls_state.dart';
import 'package:resonate/features/rooms/view/widgets/create_poll_sheet.dart';
import 'package:resonate/features/rooms/data/room_polls.dart';

import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _roomName = 'Test Room';


class FakeRoomPolls extends RoomPollsNotifier {
  FakeRoomPolls({this.createResult = true});

  final bool createResult;

  int createCount = 0;
  String? lastQuestion;
  List<String>? lastOptions;
  String? lastRoomName;

  @override
  Future<RoomPollsState> build(String roomId) async => const RoomPollsState();

  @override
  Future<bool> createPoll({
    required String question,
    required List<String> options,
    required String roomName,
  }) async {
    createCount++;
    lastQuestion = question;
    lastOptions = options;
    lastRoomName = roomName;
    return createResult;
  }
}

List<Override> sheetOverrides(RoomPollsNotifier Function() fake) => [
  requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  roomPollsProvider(_roomId).overrideWith(fake),
];


Future<void> pumpSheet(
  WidgetTester tester, {
  required List<Override> overrides,
}) async {
  await pumpRoomsPage(
    tester,
    Builder(
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () => openCreatePollSheet(
            context,
            roomId: _roomId,
            roomName: _roomName,
          ),
          child: const Text('open sheet'),
        ),
      ),
    ),
    overrides: overrides,
  );
  await tester.tap(find.text('open sheet'));
  await tester.pumpAndSettle();
  expect(find.byType(CreatePollSheet), findsOneWidget);
}

Finder get _createButton =>
    find.widgetWithText(ElevatedButton, 'Create poll');

void main() {
  group('CreatePollSheet layout', () {
    testRoomsWidget('renders question field and exactly 2 option fields', (
      tester,
    ) async {
      await pumpSheet(tester, overrides: sheetOverrides(FakeRoomPolls.new));

      // 1 question + 2 options.
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Question'), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Add option'), findsOneWidget);
      // No remove buttons at the 2-option minimum.
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testRoomsWidget('Add option grows to 5 fields then the button disappears', (
      tester,
    ) async {
      await pumpSheet(tester, overrides: sheetOverrides(FakeRoomPolls.new));

      await tester.tap(find.text('Add option'));
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNWidgets(4));
      expect(find.text('Option 3'), findsOneWidget);

      await tester.tap(find.text('Add option'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add option'));
      await tester.pumpAndSettle();

      // 1 question + 5 options; the add button is gone at the max.
      expect(find.byType(TextField), findsNWidgets(6));
      expect(find.text('Add option'), findsNothing);
    });

    testRoomsWidget('remove buttons only appear with >2 options and work', (
      tester,
    ) async {
      await pumpSheet(tester, overrides: sheetOverrides(FakeRoomPolls.new));

      await tester.tap(find.text('Add option'));
      await tester.pumpAndSettle();
      // Every option row gets a remove button once above the minimum.
      expect(find.byIcon(Icons.close), findsNWidgets(3));

      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();

      // Back at the minimum: 3 fields, no remove buttons.
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.byIcon(Icons.close), findsNothing);
    });
  });

  group('CreatePollSheet validation', () {
    testRoomsWidget('empty question -> createPoll not called, sheet stays', (
      tester,
    ) async {
      final fake = FakeRoomPolls();
      await pumpSheet(tester, overrides: sheetOverrides(() => fake));

      await tester.enterText(find.byType(TextField).at(1), 'Red');
      await tester.enterText(find.byType(TextField).at(2), 'Blue');
      await tester.tap(_createButton);
      await tester.pumpAndSettle();

      expect(fake.createCount, 0);
      expect(find.byType(CreatePollSheet), findsOneWidget);
    });

    testRoomsWidget('fewer than 2 filled options -> createPoll not called', (
      tester,
    ) async {
      final fake = FakeRoomPolls();
      await pumpSheet(tester, overrides: sheetOverrides(() => fake));

      await tester.enterText(find.byType(TextField).at(0), 'Favorite color?');
      await tester.enterText(find.byType(TextField).at(1), 'Red');
      // Whitespace-only option must not count as filled.
      await tester.enterText(find.byType(TextField).at(2), '   ');
      await tester.tap(_createButton);
      await tester.pumpAndSettle();

      expect(fake.createCount, 0);
      expect(find.byType(CreatePollSheet), findsOneWidget);
    });
  });

  group('CreatePollSheet submit', () {
    testRoomsWidget('valid submit calls createPoll trimmed and pops sheet', (
      tester,
    ) async {
      final fake = FakeRoomPolls();
      await pumpSheet(tester, overrides: sheetOverrides(() => fake));

      await tester.enterText(
        find.byType(TextField).at(0),
        '  Favorite color?  ',
      );
      await tester.enterText(find.byType(TextField).at(1), ' Red ');
      await tester.enterText(find.byType(TextField).at(2), 'Blue');
      await tester.tap(_createButton);
      await tester.pumpAndSettle();

      expect(fake.createCount, 1);
      expect(fake.lastQuestion, 'Favorite color?');
      expect(fake.lastOptions, ['Red', 'Blue']);
      // Success pops the sheet.
      expect(find.byType(CreatePollSheet), findsNothing);
    });

    testRoomsWidget('createPoll returning false keeps the sheet open', (
      tester,
    ) async {
      final fake = FakeRoomPolls(createResult: false);
      await pumpSheet(tester, overrides: sheetOverrides(() => fake));

      await tester.enterText(find.byType(TextField).at(0), 'Favorite color?');
      await tester.enterText(find.byType(TextField).at(1), 'Red');
      await tester.enterText(find.byType(TextField).at(2), 'Blue');
      await tester.tap(_createButton);
      await tester.pumpAndSettle();

      expect(fake.createCount, 1);
      expect(find.byType(CreatePollSheet), findsOneWidget);
      // Submitting state was reset: button label back, no spinner.
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(_createButton, findsOneWidget);
    });
  });
}
