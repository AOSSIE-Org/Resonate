import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/live_audio/data/services/livekit_controller.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/widgets/participant_block.dart';
import 'package:resonate/features/rooms/view/widgets/report_widget.dart';
import 'package:resonate/utils/enums/report_type_enum.dart';

import '../../profile/fake_profile_repository.dart';
import '../rooms_test_helpers.dart';

/// The moderation menu behind a participant tile. `participant_block_test.dart`
/// covers how the tile renders; this covers what its menu can do.
void main() {
  final room = fakeAppwriteRoom();
  late FakeRoomSession session;

  final admin = fakeParticipant(
    uid: 'me',
    isAdmin: true,
    isModerator: true,
    isSpeaker: true,
  );
  final moderator = fakeParticipant(
    uid: 'me',
    isModerator: true,
    isSpeaker: true,
  );
  final listener = fakeParticipant(uid: 'me');

  Future<void> pumpBlock(
    WidgetTester tester, {
    required Participant me,
    required Participant participant,
    bool reportFails = false,
  }) async {
    session = FakeRoomSession(
      SingleRoomState(me: me, participants: [participant]),
      reportFails: reportFails,
    );
    await pumpTestApp(
      tester,
      ParticipantBlock(room: room, participant: participant),
      rootOverlay: true,
      overrides: [
        requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
        liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
        profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
        roomSessionProvider(room).overrideWith(() => session),
      ],
    );
    await tester.pumpAndSettle();
  }

  // The holder opens on tap, not long-press.
  Future<void> openMenu(WidgetTester tester) async {
    await tester.tap(find.byType(ParticipantBlock));
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String label) async {
    await openMenu(tester);
    await tester.tap(find.text(label).last);
    await tester.pumpAndSettle();
  }

  group('what an admin is offered', () {
    testAppWidget('a plain listener can be promoted or removed', (
      tester,
    ) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest'),
      );

      await openMenu(tester);

      expect(find.text('Add Moderator'), findsOneWidget);
      expect(find.text('Kick Out'), findsOneWidget);
      expect(find.text('Report Participant'), findsOneWidget);
    });

    testAppWidget('a raised hand can be made a speaker', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(
          uid: 'guest',
          hasRequestedToBeSpeaker: true,
        ),
      );

      await openMenu(tester);

      expect(find.text('Add Speaker'), findsOneWidget);
    });

    testAppWidget('a speaker can be sent back to listening', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest', isSpeaker: true),
      );

      await openMenu(tester);

      expect(find.text('Make Listener'), findsOneWidget);
    });

    testAppWidget('a moderator can be demoted', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest', isModerator: true),
      );

      await openMenu(tester);

      expect(find.text('Remove Moderator'), findsOneWidget);
      expect(find.text('Add Moderator'), findsNothing);
    });

    // The host outranks everyone, including other admins.
    testAppWidget('another admin is left alone', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest', isAdmin: true),
      );

      await openMenu(tester);

      expect(find.text('Kick Out'), findsNothing);
      expect(find.text('Add Moderator'), findsNothing);
    });
  });

  group('what a plain listener is offered', () {
    // Moderation is for admins and moderators only.
    testAppWidget('nothing at all', (tester) async {
      await pumpBlock(
        tester,
        me: listener,
        participant: fakeParticipant(uid: 'guest'),
      );

      await openMenu(tester);

      expect(find.text('Kick Out'), findsNothing);
      expect(find.text('Report Participant'), findsNothing);
    });
  });

  group('what a moderator is offered', () {
    testAppWidget('a listener can still be removed', (tester) async {
      await pumpBlock(
        tester,
        me: moderator,
        participant: fakeParticipant(uid: 'guest'),
      );

      await openMenu(tester);

      expect(find.text('Kick Out'), findsOneWidget);
    });

    // A moderator may not act on a peer.
    testAppWidget('another moderator is left alone', (tester) async {
      await pumpBlock(
        tester,
        me: moderator,
        participant: fakeParticipant(uid: 'guest', isModerator: true),
      );

      await openMenu(tester);

      expect(find.text('Kick Out'), findsNothing);
    });
  });

  group('acting on a participant', () {
    testAppWidget('promoting sets the moderator role', (tester) async {
      final guest = fakeParticipant(uid: 'guest');
      await pumpBlock(tester, me: admin, participant: guest);

      await choose(tester, 'Add Moderator');

      expect(session.setRoleCount, 1);
      expect(session.lastRole, ParticipantRole.moderator);
      expect(session.lastRoleParticipant?.uid, 'guest');
    });

    testAppWidget('demoting sets the listener role', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest', isModerator: true),
      );

      await choose(tester, 'Remove Moderator');

      expect(session.lastRole, ParticipantRole.listener);
    });

    testAppWidget('kicking removes them', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest'),
      );

      await choose(tester, 'Kick Out');

      expect(session.kickOutCount, 1);
      expect(session.lastKicked?.uid, 'guest');
    });
  });

  group('reporting', () {
    Future<void> fileReport(WidgetTester tester) async {
      await choose(tester, 'Report Participant');
      expect(find.byType(ReportWidget), findsOneWidget);

      await tester.tap(
        find.widgetWithText(
          RadioListTile<ReportTypeEnum>,
          'Spam / Scams / Fraud',
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'Submit Report'));
      await tester.pumpAndSettle();
      // The result toast sets a 2s dismiss timer that must not outlive the test.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    }

    testAppWidget('opens the report form and files it', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest'),
      );

      await fileReport(tester);

      expect(session.reportAndKickCount, 1);
      expect(session.lastReported?.uid, 'guest');
      expect(session.lastReportDraft?.type, ReportTypeEnum.spam);
    });

    // Backing out of the form must not file anything.
    testAppWidget('a dismissed form files nothing', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest'),
      );

      await choose(tester, 'Report Participant');
      Navigator.of(tester.element(find.byType(ReportWidget))).pop();
      await tester.pumpAndSettle();

      expect(session.reportAndKickCount, 0);
    });

    testAppWidget('a failed filing still returns cleanly', (tester) async {
      await pumpBlock(
        tester,
        me: admin,
        participant: fakeParticipant(uid: 'guest'),
        reportFails: true,
      );

      await fileReport(tester);

      expect(session.reportAndKickCount, 1);
      expect(tester.takeException(), isNull);
    });
  });
}
