import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/rooms/model/poll.dart';
import 'package:resonate/features/rooms/model/poll_vote.dart';
import 'package:resonate/features/rooms/model/room_message.dart';
import 'package:resonate/features/rooms/model/room_polls_state.dart';
import 'package:resonate/features/rooms/view/widgets/poll_card.dart';
import 'package:resonate/features/rooms/viewmodel/room_polls_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../rooms_test_helpers.dart';

const _roomId = 'room-1';
const _pollId = 'poll-1';

// Fake RoomPollsNotifier: build() serves a canned state, vote/closePoll only
// record their arguments and return configurable results (no repository).
class FakeRoomPolls extends RoomPollsNotifier {
  FakeRoomPolls(
    this._state, {
    this.voteResult = true,
    this.closeResult = true,
  });

  final RoomPollsState _state;
  final bool voteResult;
  final bool closeResult;

  int voteCount = 0;
  String? lastVotedPollId;
  int? lastVotedOptionIndex;
  int closeCount = 0;
  String? lastClosedPollId;

  @override
  Future<RoomPollsState> build(String roomId) async => _state;

  @override
  Future<bool> vote({required String pollId, required int optionIndex}) async {
    voteCount++;
    lastVotedPollId = pollId;
    lastVotedOptionIndex = optionIndex;
    return voteResult;
  }

  @override
  Future<bool> closePoll(String pollId) async {
    closeCount++;
    lastClosedPollId = pollId;
    return closeResult;
  }
}

Poll fakePoll({
  String pollId = _pollId,
  String question = 'Favorite color?',
  List<String> options = const ['Red', 'Blue', 'Green'],
  bool isClosed = false,
}) => Poll(
  pollId: pollId,
  roomId: _roomId,
  question: question,
  options: options,
  createdBy: 'host-1',
  isClosed: isClosed,
);

PollVote fakeVote(String uid, int optionIndex, {String pollId = _pollId}) =>
    PollVote(
      voteId: 'v-$uid',
      pollId: pollId,
      roomId: _roomId,
      uid: uid,
      optionIndex: optionIndex,
    );

RoomMessage pollMessage({String pollId = _pollId}) => RoomMessage(
  roomId: _roomId,
  messageId: 'm-1',
  creatorId: 'host-1',
  creatorUsername: 'alice',
  creatorName: 'alice',
  creatorImgUrl: 'https://example.com/a.jpg',
  hasValidTag: false,
  index: 0,
  isEdited: false,
  content: 'Favorite color?',
  creationDateTime: DateTime(2024, 1, 1, 12),
  pollId: pollId,
);

List<Override> pollOverrides(RoomPollsNotifier Function() fake) => [
  requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
  roomPollsProvider(_roomId).overrideWith(fake),
];

// customSnackbar draws on rootNavigatorKey's overlay, which roomsTestApp does
// not wire up (so the toast silently no-ops there). This local variant of
// pumpRoomsPage attaches the key so the toast is actually rendered; kept here
// instead of the shared helpers on purpose.
Future<void> pumpWithRootOverlay(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        navigatorKey: rootNavigatorKey,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Builder(
          builder: (context) {
            UiSizes.init(context);
            return Scaffold(body: child);
          },
        ),
      ),
    ),
  );
}

void main() {
  group('PollCard rendering', () {
    testRoomsWidget('renders question, options, creator name and Poll label', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(
          () => FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Favorite color?'), findsOneWidget);
      expect(find.text('Red'), findsOneWidget);
      expect(find.text('Blue'), findsOneWidget);
      expect(find.text('Green'), findsOneWidget);
      // Creator name is capitalized.
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Poll'), findsOneWidget);
      expect(find.byIcon(Icons.poll_outlined), findsOneWidget);
    });

    testRoomsWidget('votes 2/1/1 show 50%/25%/25% and total votes text', (
      tester,
    ) async {
      final state = RoomPollsState(
        polls: [fakePoll()],
        votes: [
          fakeVote('u1', 0),
          fakeVote('u2', 0),
          fakeVote('u3', 1),
          fakeVote('u4', 2),
        ],
      );
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(() => FakeRoomPolls(state)),
      );
      await tester.pumpAndSettle();

      expect(find.text('50%'), findsOneWidget);
      expect(find.text('25%'), findsNWidgets(2));
      expect(find.text('4 votes'), findsOneWidget);
    });

    testRoomsWidget('zero votes show No votes yet and no percentages', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(
          () => FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No votes yet'), findsOneWidget);
      expect(find.textContaining('%'), findsNothing);
    });

    testRoomsWidget('my vote shows the check_circle on my option row', (
      tester,
    ) async {
      final state = RoomPollsState(
        polls: [fakePoll()],
        votes: [fakeVote('me', 1)],
      );
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(() => FakeRoomPolls(state)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      // And it sits inside the tapped option's row ("Blue" = index 1).
      final blueRow = find.ancestor(
        of: find.text('Blue'),
        matching: find.byType(InkWell),
      );
      expect(
        find.descendant(of: blueRow, matching: find.byIcon(Icons.check_circle)),
        findsOneWidget,
      );
    });

    testRoomsWidget('message pointing to an unknown poll shows unavailable', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(pollId: 'nope'), isUserAdmin: false),
        overrides: pollOverrides(
          () => FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This poll is no longer available'), findsOneWidget);
      // No poll body rendered for it.
      expect(find.text('Favorite color?'), findsNothing);
    });
  });

  group('Voting', () {
    testRoomsWidget('tapping an option calls vote with pollId and index', (
      tester,
    ) async {
      late FakeRoomPolls fake;
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(
          () => fake = FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Green'));
      await tester.pumpAndSettle();

      expect(fake.voteCount, 1);
      expect(fake.lastVotedPollId, _pollId);
      expect(fake.lastVotedOptionIndex, 2);
    });

    testRoomsWidget('vote failure shows the error toast', (tester) async {
      late FakeRoomPolls fake;
      await pumpWithRootOverlay(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(
          () => fake = FakeRoomPolls(
            RoomPollsState(polls: [fakePoll()]),
            voteResult: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Red'));
      await tester.pump();
      await tester.pump();

      expect(fake.voteCount, 1);
      expect(find.text('Failed to record your vote'), findsOneWidget);

      // Let the toast's auto-dismiss timer fire so no timers stay pending.
      await tester.pump(const Duration(seconds: 3));
      expect(find.text('Failed to record your vote'), findsNothing);
    });

    testRoomsWidget('closed poll: tap is a no-op, Final results, no End poll', (
      tester,
    ) async {
      late FakeRoomPolls fake;
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: true),
        overrides: pollOverrides(
          () => fake = FakeRoomPolls(
            RoomPollsState(polls: [fakePoll(isClosed: true)]),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Red'));
      await tester.pumpAndSettle();

      expect(fake.voteCount, 0);
      expect(find.text('Final results'), findsOneWidget);
      // Even for the host, a closed poll has no End poll action.
      expect(find.text('End poll'), findsNothing);
    });
  });

  group('End poll', () {
    testRoomsWidget('host confirms End poll -> closePoll called', (
      tester,
    ) async {
      late FakeRoomPolls fake;
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: true),
        overrides: pollOverrides(
          () => fake = FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('End poll'), findsOneWidget);
      await tester.tap(find.text('End poll'));
      await tester.pumpAndSettle();

      // Confirm dialog is up.
      expect(find.text('End this poll?'), findsOneWidget);
      // Two "End poll" texts now: card button + dialog action.
      await tester.tap(find.text('End poll').last);
      await tester.pumpAndSettle();

      expect(fake.closeCount, 1);
      expect(fake.lastClosedPollId, _pollId);
      expect(find.text('End this poll?'), findsNothing);
    });

    testRoomsWidget('host cancels the confirm dialog -> no closePoll', (
      tester,
    ) async {
      late FakeRoomPolls fake;
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: true),
        overrides: pollOverrides(
          () => fake = FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('End poll'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(fake.closeCount, 0);
      // Poll is still open and actionable.
      expect(find.text('End poll'), findsOneWidget);
    });

    testRoomsWidget('non-admin does not see the End poll button', (
      tester,
    ) async {
      await pumpRoomsPage(
        tester,
        PollCard(message: pollMessage(), isUserAdmin: false),
        overrides: pollOverrides(
          () => FakeRoomPolls(RoomPollsState(polls: [fakePoll()])),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('End poll'), findsNothing);
    });
  });
}
