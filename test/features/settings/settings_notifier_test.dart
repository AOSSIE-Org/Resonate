import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/activity_status/data/my_activity_status.dart';
import 'package:resonate/features/settings/viewmodel/settings_notifier.dart';

import '../../helpers/test_root_container.dart';

void main() {
  test('logout publishes offline before the session is destroyed', () async {
    final repo = FakeAuthRepository(
      AuthState.authenticated(fakeAuthUser(uid: 'me')),
    );
    final container = await installTestRootContainer(authRepository: repo);
    final activityStatus =
        container.read(myActivityStatusProvider.notifier) as FakeMyActivityStatus;

    await container.read(settingsProvider.notifier).logout();

    expect(activityStatus.goOfflineCount, 1);
    expect(repo.logoutCount, 1);
  });
}
