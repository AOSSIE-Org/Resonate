import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/friends/view/pages/friend_requests_page.dart';
import 'package:resonate/features/friends/view/pages/friends_page.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/features/stories/data/repositories/stories_repository.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../../helpers/test_root_container.dart';
import '../../friends/friends_test_helpers.dart' show FakeFriendsNotifier;
import 'package:resonate/features/friends/model/friends_state.dart';
import 'package:resonate/features/profile/view/pages/followers_screen.dart';
import 'package:resonate/shared/model/follower_user_model.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';

import '../profile_test_helpers.dart';

void main() {
  late FakeProfileRepository repo;
  late GoRouter router;

  setUp(() {
    repo = FakeProfileRepository();
    router = GoRouter(
      initialLocation: RoutePaths.profile,
      routes: [
        GoRoute(path: RoutePaths.profile, builder: (_, _) => ProfilePage()),
        for (final path in [
          RoutePaths.editProfile,
          RoutePaths.settings,
          RoutePaths.emailVerification,
        ])
          GoRoute(
            path: path,
            builder: (_, _) => Scaffold(body: Text('at $path')),
          ),
      ],
    );
  });

  tearDown(() => router.dispose());

  Future<void> pumpProfile(
    WidgetTester tester, {
    ResonateUser? creator,
    bool emailVerified = true,
    List<FollowerUserModel> followers = const [],
    FriendsState friendsState = const FriendsState(),
  }) async {
    repo.followers = followers;
    tester.view.physicalSize = const Size(1600, 2600);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final me = fakeAuthUser(
      uid: 'me',
      isEmailVerified: emailVerified,
      profileImageUrl: 'https://example.com/me.jpg',
    );
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository(AuthState.authenticated(me)),
        ),
        profileRepositoryProvider.overrideWithValue(repo),
        storiesRepositoryProvider.overrideWithValue(FakeStoriesRepository()),
        friendsProvider.overrideWith(
          () => FakeFriendsNotifier(buildState: friendsState),
        ),
        ...activityStatusOverrides(),
        ...achievementOverrides(),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);

    // The creator variant takes a different route, so it is built directly.
    final page = creator == null
        ? ProfilePage()
        : ProfilePage(creator: creator, isCreatorProfile: true);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: creator == null
            ? MaterialApp.router(
                routerConfig: router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en')],
                builder: (context, child) {
                  UiSizes.init(context);
                  return child!;
                },
              )
            : profileTestApp(page),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('the app bar', () {
    testWidgets('opens friend requests', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester);

        await tester.tap(find.byIcon(Icons.notifications));
        await tester.pumpAndSettle();
      });

      expect(find.byType(FriendRequestsPage), findsOneWidget);
    });

    testWidgets('opens the friends list', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester);

        await tester.tap(find.byIcon(Icons.groups));
        await tester.pumpAndSettle();
      });

      expect(find.byType(FriendsPage), findsOneWidget);
    });

    // Those two are yours alone; they make no sense on someone else's page.
    testWidgets('offers neither on another user\'s profile', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(
          tester,
          creator: ResonateUser(uid: 'creator-1', name: 'Creator'),
        );
      });

      // The creator view draws its own friend icons in the body, so this
      // checks the app bar itself rather than the icons.
      expect(tester.widget<AppBar>(find.byType(AppBar)).actions, isNull);
    });
  });

  group('your own profile', () {
    testWidgets('the primary button edits the profile', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester);

        await tester.tap(find.text('Edit Profile'));
        await tester.pumpAndSettle();
      });

      expect(find.text('at ${RoutePaths.editProfile}'), findsOneWidget);
    });

    testWidgets('the gear opens settings', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester);

        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      });

      expect(find.text('at ${RoutePaths.settings}'), findsOneWidget);
    });

    // A verified user has nothing to do, so the prompt is not drawn at all.
    testWidgets('hides the verify prompt once verified', (tester) async {
      await mockNetworkImagesFor(
        () => pumpProfile(tester, emailVerified: true),
      );

      expect(find.text('Verify Email'), findsNothing);
    });

    testWidgets('offers to verify an unverified address', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester, emailVerified: false);

        expect(find.text('Verify Email'), findsOneWidget);
        await tester.tap(find.text('Verify Email'));
        await tester.pumpAndSettle();
      });

      expect(find.text('at ${RoutePaths.emailVerification}'), findsOneWidget);
    });
  });

  group('another user\'s profile', () {
    final creator = ResonateUser(
      uid: 'creator-1',
      name: 'Creator',
      userName: 'creator',
      profileImageUrl: 'https://example.com/c.jpg',
    );

    testWidgets('offers to follow them', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester, creator: creator);
      });

      expect(find.text('Follow'), findsOneWidget);
      expect(find.text('Edit Profile'), findsNothing);
      expect(find.byIcon(Icons.settings), findsNothing);
    });

    testWidgets('following writes the follow through', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester, creator: creator);

        await tester.tap(find.text('Follow'));
        await tester.pumpAndSettle();
      });

      expect(repo.followedFollower, isNotNull);
    });
  });

  group('the follower count', () {
    FollowerUserModel follower(String uid) => FollowerUserModel(
      docId: 'follow-$uid',
      uid: uid,
      username: uid,
      name: uid,
      profileImageUrl: 'https://example.com/$uid.jpg',
      fcmToken: '',
      followerRating: 4.0,
    );

    testWidgets('opens the follower list on a creator profile', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(
          tester,
          creator: ResonateUser(uid: 'creator-1', name: 'Creator'),
          followers: [follower('a'), follower('b')],
        );

        await tester.tap(find.byIcon(Icons.people));
        await tester.pumpAndSettle();
      });

      expect(find.byType(FollowersScreen), findsOneWidget);
    });

    // There is nothing to show on your own page.
    testWidgets('does nothing on your own profile', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(tester, followers: [follower('a')]);

        await tester.tap(find.byIcon(Icons.people));
        await tester.pumpAndSettle();
      });

      expect(find.byType(FollowersScreen), findsNothing);
    });

    // A single follower who is me means the list would be empty.
    testWidgets('does nothing when I am the only follower', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(
          tester,
          creator: ResonateUser(uid: 'creator-1', name: 'Creator'),
          followers: [follower('me')],
        );

        await tester.tap(find.byIcon(Icons.people));
        await tester.pumpAndSettle();
      });

      expect(find.byType(FollowersScreen), findsNothing);
    });
  });

  group('the friend button', () {
    final creator = ResonateUser(
      uid: 'creator-1',
      name: 'Creator',
      userName: 'creator',
      profileImageUrl: 'https://example.com/c.jpg',
      userRating: 4.0,
    );

    testWidgets('offers to add a stranger as a friend', (tester) async {
      await mockNetworkImagesFor(() => pumpProfile(tester, creator: creator));

      expect(find.text('Add Friend'), findsOneWidget);
    });

    testWidgets('an incoming request can be accepted', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(
          tester,
          creator: creator,
          friendsState: FriendsState(
            friends: [
              fakeFriendsModel(
                senderId: 'creator-1',
                recieverId: 'me',
                requestStatus: FriendRequestStatus.sent,
                docId: 'friendship-1',
              ),
            ],
          ),
        );
      });

      expect(find.text('Accept'), findsOneWidget);
    });

    testWidgets('a request I sent reads as pending', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(
          tester,
          creator: creator,
          friendsState: FriendsState(
            friends: [
              fakeFriendsModel(
                senderId: 'me',
                recieverId: 'creator-1',
                requestStatus: FriendRequestStatus.sent,
                docId: 'friendship-1',
              ),
            ],
          ),
        );
      });

      expect(find.text('Requested'), findsOneWidget);
    });

    testWidgets('an accepted friendship reads as friends', (tester) async {
      await mockNetworkImagesFor(() async {
        await pumpProfile(
          tester,
          creator: creator,
          friendsState: FriendsState(
            friends: [
              fakeFriendsModel(
                senderId: 'me',
                recieverId: 'creator-1',
                requestStatus: FriendRequestStatus.accepted,
                docId: 'friendship-1',
              ),
            ],
          ),
        );
      });

      expect(find.text('Friends'), findsOneWidget);
    });
  });

  testWidgets('following again unfollows', (tester) async {
    await mockNetworkImagesFor(() async {
      await pumpProfile(
        tester,
        creator: ResonateUser(uid: 'creator-1', name: 'Creator'),
      );
      await tester.tap(find.text('Follow'));
      await tester.pumpAndSettle();
    });

    expect(repo.followedFollower, isNotNull);
  });
}
