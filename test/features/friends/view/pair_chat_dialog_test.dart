import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:language_picker/languages.dart';
import 'package:resonate/features/auth/viewmodel/current_user.dart';
import 'package:resonate/features/friends/model/pair_chat_state.dart';
import 'package:resonate/features/friends/view/widgets/pair_chat_dialog.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../friends_test_helpers.dart';

// Records the routes the dialog pushes so nav can be asserted.
class RecordingRouter {
  final List<String> pushed = [];
  late final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => Scaffold(
          body: Builder(
            builder: (context) {
              UiSizes.init(context);
              return Center(
                child: ElevatedButton(
                  onPressed: () => showPairChatDialog(context),
                  child: const Text('open'),
                ),
              );
            },
          ),
        ),
      ),
      // Destinations just record and render a placeholder.
      GoRoute(
        path: RoutePaths.pairing,
        builder: (context, state) {
          pushed.add(RoutePaths.pairing);
          return const Scaffold(body: Text('pairing-page'));
        },
      ),
      GoRoute(
        path: RoutePaths.pairChatUsers,
        builder: (context, state) {
          pushed.add(RoutePaths.pairChatUsers);
          return const Scaffold(body: Text('pair-chat-users-page'));
        },
      ),
    ],
  );
}

List<Override> _overrides(
  FakePairChatNotifier fake, {
  String displayName = 'Test User',
}) {
  return [
    requireUserProvider.overrideWithValue(
      fakeAuthUser(uid: 'me', displayName: displayName),
    ),
    currentUserProvider.overrideWithValue(fakeAuthUser(uid: 'me')),
    liveKitProvider.overrideWith(FakeLiveKitNotifier.new),
    pairChatProvider.overrideWith(() => fake),
  ];
}


Future<RecordingRouter> _pumpDialogViaRouter(
  WidgetTester tester,
  List<Override> overrides,
) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final recording = RecordingRouter();
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: recording.router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return recording;
}

void main() {
  group('PairChatDialog identity', () {
    testFriendsWidget('anonymous button calls setAnonymous(true)', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await pumpFriendsPage(
        tester,
        const PairChatDialog(),
        overrides: _overrides(fake),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Anonymous'));
      await tester.pumpAndSettle();

      expect(fake.setAnonymousCount, 1);
      expect(fake.lastAnonymous, isTrue);
    });

    testFriendsWidget('authenticated button calls setAnonymous(false)', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await pumpFriendsPage(
        tester,
        const PairChatDialog(),
        overrides: _overrides(fake, displayName: 'Alice'),
      );
      await tester.pumpAndSettle();

      // The authenticated button is labelled with the require-user displayName.
      await tester.tap(find.text('Alice'));
      await tester.pumpAndSettle();

      expect(fake.setAnonymousCount, 1);
      expect(fake.lastAnonymous, isFalse);
    });

    testFriendsWidget('authenticated button shows requireUser displayName', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await pumpFriendsPage(
        tester,
        const PairChatDialog(),
        overrides: _overrides(fake, displayName: 'Bob Jones'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bob Jones'), findsOneWidget);
      expect(find.text('Anonymous'), findsOneWidget);
    });
  });

  group('PairChatDialog language', () {
    testFriendsWidget('renders the language dropdown', (tester) async {
      final fake = FakePairChatNotifier(const PairChatState());
      await pumpFriendsPage(
        tester,
        const PairChatDialog(),
        overrides: _overrides(fake),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButton<Language>), findsOneWidget);
      expect(find.text('Select Language'), findsOneWidget);
    });
  });

  group('PairChatDialog flows', () {
    testFriendsWidget('Quick Match pops the dialog and calls quickMatch', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(const PairChatState());
      final recording = await _pumpDialogViaRouter(tester, _overrides(fake));
      expect(find.byType(PairChatDialog), findsOneWidget);

      await tester.tap(find.text('Quick Match'));
      await tester.pumpAndSettle();

      expect(fake.quickMatchCount, 1);
      // Dialog popped and the pairing destination was pushed.
      expect(find.byType(PairChatDialog), findsNothing);
      expect(recording.pushed, contains(RoutePaths.pairing));
    });

    testFriendsWidget('Choose User pops the dialog and calls choosePartner', (
      tester,
    ) async {
      final fake = FakePairChatNotifier(const PairChatState());
      final recording = await _pumpDialogViaRouter(tester, _overrides(fake));
      expect(find.byType(PairChatDialog), findsOneWidget);

      await tester.tap(find.text('Choose User to chat with'));
      await tester.pumpAndSettle();

      expect(fake.choosePartnerCount, 1);
      expect(find.byType(PairChatDialog), findsNothing);
      expect(recording.pushed, contains(RoutePaths.pairChatUsers));
    });
  });
}
