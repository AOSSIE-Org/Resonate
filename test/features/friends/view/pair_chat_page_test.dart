import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/friends/view/pages/pair_chat_page.dart';
import 'package:resonate/features/friends/view/widgets/call_user_info_row.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';

import '../friends_test_helpers.dart';

const _placeholder = 'https://example.com/placeholder.png';


Future<void> _pumpPage(
  WidgetTester tester,
  List<Override> overrides,
) async {
  await pumpFriendsPage(tester, const PairChatPage(), overrides: overrides);
  await tester.pump();
}


Future<void> _disposePage(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}

List<Override> buildOverrides({
  required PairChatState state,
  FakePairChatNotifier? fake,
}) {
  final chat = fake ?? FakePairChatNotifier(state);
  return [
    requireUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    userProfileImagePlaceholderUrlProvider.overrideWithValue(_placeholder),
    liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
    pairChatProvider.overrideWith(() => chat),
  ];
}

void main() {
  group('PairChatPage render', () {
    testFriendsWidget('anonymous shows placeholder avatars + user1/user2', (
      tester,
    ) async {
      await _pumpPage(
        tester,
        buildOverrides(state: const PairChatState(isAnonymous: true)),
      );

      // Two info rows are always rendered.
      expect(find.byType(CallUserInfoRow), findsNWidgets(2));
      expect(find.text('User 1'), findsOneWidget);
      expect(find.text('User 2'), findsOneWidget);
      await _disposePage(tester);
    });

    testFriendsWidget('authenticated shows requireUser + pair fields', (
      tester,
    ) async {
      await _pumpPage(
        tester,
        buildOverrides(
          state: const PairChatState(
            isAnonymous: false,
            pairUsername: 'PartnerName',
            pairProfileImageUrl: 'https://example.com/partner.png',
          ),
        ),
      );

      expect(find.byType(CallUserInfoRow), findsNWidgets(2));
      // requireUser().userName from fakeAuthUser default.
      expect(find.text('TestUser'), findsOneWidget);
      expect(find.text('PartnerName'), findsOneWidget);
      await _disposePage(tester);
    });

  });

  group('PairChatPage control wiring', () {
    testFriendsWidget('mic button calls toggleMic', (tester) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await _pumpPage(
        tester,
        buildOverrides(state: const PairChatState(), fake: fake),
      );

      await tester.tap(find.byIcon(Icons.mic_off));
      await tester.pump();
      expect(fake.toggleMicCount, 1);
      await _disposePage(tester);
    });

    testFriendsWidget('speaker button calls toggleLoudSpeaker', (tester) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await _pumpPage(
        tester,
        buildOverrides(state: const PairChatState(), fake: fake),
      );

      await tester.tap(find.byIcon(Icons.volume_up));
      await tester.pump();
      expect(fake.toggleLoudSpeakerCount, 1);
      await _disposePage(tester);
    });

    testFriendsWidget('end button calls endChat', (tester) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await _pumpPage(
        tester,
        buildOverrides(state: const PairChatState(), fake: fake),
      );

      await tester.tap(find.byIcon(Icons.cancel_outlined));
      await tester.pump();
      expect(fake.endChatCount, greaterThanOrEqualTo(1));
      await _disposePage(tester);
    });
  });
}
