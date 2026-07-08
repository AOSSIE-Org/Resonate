import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/view/pages/delete_account_page.dart';

import 'profile_test_helpers.dart';

void main() {
  ElevatedButton deleteButton(WidgetTester tester) =>
      tester.widget<ElevatedButton>(find.byType(ElevatedButton));

  testWidgets('delete button stays disabled until the typed username matches',
      (tester) async {
    await pumpProfilePage(
      tester,
      const DeleteAccountPage(),
      authState: AuthState.authenticated(fakeAuthUser(userName: 'testuser')),
    );

    // Disabled on first render.
    expect(deleteButton(tester).onPressed, isNull);

    // Wrong username keeps it disabled.
    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.pump();
    expect(deleteButton(tester).onPressed, isNull);

    // Exact match enables it.
    await tester.enterText(find.byType(TextField), 'testuser');
    await tester.pump();
    expect(deleteButton(tester).onPressed, isNotNull);

    // Editing away from the match disables it again.
    await tester.enterText(find.byType(TextField), 'testuse');
    await tester.pump();
    expect(deleteButton(tester).onPressed, isNull);
  });
}
