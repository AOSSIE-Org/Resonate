import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/shared/widgets/speaking_profile_avatar.dart';

import '../features/friends/friends_test_helpers.dart';

const _placeholder = 'https://example.com/placeholder.png';
const _stored = 'https://old-host.example.com/stored.jpg';
const _live = 'https://example.com/current.jpg';

void main() {
  Future<String?> pumpAvatar(
    WidgetTester tester, {
    String imageUrl = _stored,
    Map<String, String?> avatarUrls = const {},
  }) async {
    await pumpFriendsPage(
      tester,
      SpeakingProfileAvatar(uid: 'u-1', imageUrl: imageUrl, radius: 20),
      overrides: [
        userProfileImagePlaceholderUrlProvider.overrideWithValue(_placeholder),
      ],
      avatarUrls: avatarUrls,
    );
    await tester.pumpAndSettle();

    final avatar = tester
        .widgetList<CircleAvatar>(find.byType(CircleAvatar))
        .firstWhere((a) => a.foregroundImage != null);
    return (avatar.foregroundImage! as NetworkImage).url;
  }

  testWidgets('the user\'s current picture wins over the stored copy', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      // Friend and call rows carry a copy from when they were written.
      expect(await pumpAvatar(tester, avatarUrls: {'u-1': _live}), _live);
    });
  });

  testWidgets('the stored copy still shows when there is no user row', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      expect(await pumpAvatar(tester), _stored);
    });
  });

  testWidgets('a cleared picture falls back to the placeholder', (
    tester,
  ) async {
    await mockNetworkImagesFor(() async {
      expect(
        await pumpAvatar(tester, imageUrl: '', avatarUrls: {'u-1': ''}),
        _placeholder,
      );
    });
  });
}
