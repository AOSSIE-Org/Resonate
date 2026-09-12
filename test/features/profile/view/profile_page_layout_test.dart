import 'package:flutter/material.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/friends/data/friends.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/shared/model/resonate_user.dart';

import '../../friends/friends_test_helpers.dart' show FakeFriendsNotifier;
import '../profile_test_helpers.dart';

void main() {
  void useNarrowPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  List<Override> overridesFor(AuthUser me) => [
    currentUserProvider.overrideWithValue(me),
    friendsProvider.overrideWith(FakeFriendsNotifier.new),
  ];

  testWidgets('own profile with an unverified email lays out at 360dp', (
    tester,
  ) async {
    final me = fakeAuthUser(uid: 'me', isEmailVerified: false);
    await mockNetworkImagesFor(() async {
      useNarrowPhone(tester);
      await pumpProfilePage(
        tester,
        ProfilePage(),
        authState: AuthState.authenticated(me),
        overrides: overridesFor(me),
      );

      expect(find.text('Verify Email'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      // Empty-state art for created + liked stories.
      expect(find.byType(Image), findsWidgets);
    });
  });

  testWidgets('another user\'s profile lays out at 360dp', (tester) async {
    final me = fakeAuthUser(uid: 'me');
    final creator = ResonateUser(uid: 'creator-1', name: 'Creator');
    await mockNetworkImagesFor(() async {
      useNarrowPhone(tester);
      await pumpProfilePage(
        tester,
        ProfilePage(isCreatorProfile: true, creator: creator),
        authState: AuthState.authenticated(me),
        overrides: overridesFor(me),
      );

      // Follow sits beside Add Friend, the pair that used to overflow.
      expect(find.text('Follow'), findsOneWidget);
      expect(find.text('Add Friend'), findsOneWidget);
    });
  });
}
