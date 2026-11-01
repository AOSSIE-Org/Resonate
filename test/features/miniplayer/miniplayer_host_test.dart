import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/miniplayer/data/services/pip_controller.dart';
import 'package:resonate/features/miniplayer/data/session_presented.dart';
import 'package:resonate/features/miniplayer/model/miniplayer_session.dart';
import 'package:resonate/features/miniplayer/view/widgets/miniplayer_host.dart';
import 'package:resonate/features/miniplayer/view/widgets/session_miniplayer.dart';
import 'package:resonate/features/miniplayer/viewmodel/miniplayer_notifier.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';

import '../friends/friends_test_helpers.dart';

const _session = MiniplayerSession(
  speakerUid: 'friend',
  avatarUrl: 'https://example.com/friend.jpg',
  isMicOn: false,
  canToggleMic: true,
);

// Serves a fixed session instead of deriving one from a live room or call.
class _FakeMiniplayer extends Miniplayer {
  _FakeMiniplayer(this.session);

  final MiniplayerSession? session;
  int toggleMicCount = 0;

  @override
  MiniplayerSession? build() => session;

  @override
  Future<void> toggleMic() async => toggleMicCount++;
}

// The real one talks to an Android method channel that is absent under test.
class _FakePipMode extends PipMode {
  _FakePipMode({this.inPip = false});

  final bool inPip;
  final List<bool> sessionActiveCalls = [];

  @override
  bool build() => inPip;

  @override
  Future<void> setSessionActive({required bool active}) async =>
      sessionActiveCalls.add(active);

  @override
  Future<void> enterNow() async {}
}

Future<void> _pumpHost(
  WidgetTester tester, {
  MiniplayerSession? session = _session,
  _FakePipMode? pip,
  bool presented = false,
}) async {
  await pumpFriendsPage(
    tester,
    MiniplayerHost(
      child: const Scaffold(body: Center(child: Text('app body'))),
    ),
    overrides: [
      userProfileImagePlaceholderUrlProvider.overrideWithValue(
        'https://example.com/placeholder.png',
      ),
      miniplayerProvider.overrideWith(() => _FakeMiniplayer(session)),
      pipModeProvider.overrideWith(() => pip ?? _FakePipMode()),
    ],
  );
  if (presented) _presence(tester).enter();
  await tester.pumpAndSettle();
}

SessionPresented _presence(WidgetTester tester) => ProviderScope.containerOf(
  tester.element(find.text('app body', skipOffstage: false)),
).read(sessionPresentedProvider.notifier);

void main() {
  testWidgets('no session, no miniplayer', (tester) async {
    await mockNetworkImagesFor(() async {
      await _pumpHost(tester, session: null);

      expect(find.byType(SessionMiniplayer), findsNothing);
      expect(find.text('app body'), findsOneWidget);
    });
  });

  testWidgets('a session whose screen has never been up does not float', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      // A call is connected a beat before its page is pushed; the bar must not
      // flash over the ringing screen in between.
      await _pumpHost(tester);

      expect(find.byType(SessionMiniplayer), findsNothing);
    });
  });

  testWidgets('a session floats over the app once its screen is dismissed', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await _pumpHost(tester, presented: true);
      expect(find.byType(SessionMiniplayer), findsNothing);

      _presence(tester).exit();
      await tester.pumpAndSettle();

      expect(find.byType(SessionMiniplayer), findsOneWidget);
      expect(find.text('app body'), findsOneWidget);
    });
  });

  testWidgets('the bar stands down while the session screen is up', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await _pumpHost(tester, presented: true);

      expect(find.byType(SessionMiniplayer), findsNothing);
    });
  });

  testWidgets('in PiP the window is the session, and the app stays mounted', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      await _pumpHost(tester, pip: _FakePipMode(inPip: true), presented: true);

      final player = tester.widget<SessionMiniplayer>(
        find.byType(SessionMiniplayer),
      );
      expect(player.pip, isTrue);
      // Offstage, not unmounted: the route behind it must survive PiP.
      expect(find.text('app body', skipOffstage: false), findsOneWidget);
      expect(find.text('app body'), findsNothing);
    });
  });

  testWidgets('PiP is armed while a session is live, and only then', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      final pip = _FakePipMode();
      await _pumpHost(tester, session: null, pip: pip);
      expect(pip.sessionActiveCalls, isEmpty);

      // A session starting is what arms Android's auto-enter.
      final context = tester.element(find.text('app body'));
      ProviderScope.containerOf(
        context,
      ).read(miniplayerProvider.notifier).state = _session;
      await tester.pumpAndSettle();

      expect(pip.sessionActiveCalls, [true]);
    });
  });

  testWidgets('the mic control routes through the view model', (tester) async {
    await mockNetworkImagesFor(() async {
      final fake = _FakeMiniplayer(_session);
      await pumpFriendsPage(
        tester,
        MiniplayerHost(
          child: const Scaffold(body: Center(child: Text('app body'))),
        ),
        overrides: [
          userProfileImagePlaceholderUrlProvider.overrideWithValue(
            'https://example.com/placeholder.png',
          ),
          miniplayerProvider.overrideWith(() => fake),
          pipModeProvider.overrideWith(_FakePipMode.new),
        ],
      );
      // Up, then dismissed: that is when the bar takes over.
      _presence(tester)
        ..enter()
        ..exit();
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('miniplayer-mic')));
      await tester.pump();

      expect(fake.toggleMicCount, 1);
    });
  });
}
