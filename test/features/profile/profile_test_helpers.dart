import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../helpers/test_root_container.dart';
import 'fake_profile_repository.dart';

export '../../helpers/test_root_container.dart' show fakeAuthUser;
export 'fake_profile_repository.dart';


Widget profileTestApp(Widget child) {
  return MaterialApp(
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
        return child;
      },
    ),
  );
}

Future<void> pumpProfilePage(
  WidgetTester tester,
  Widget child, {
  required AuthState authState,
  FakeProfileRepository? profileRepo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(authState)),
        profileRepositoryProvider
            .overrideWithValue(profileRepo ?? FakeProfileRepository()),
      ],
      child: profileTestApp(child),
    ),
  );
  // Warm the session so synchronous ref.read(currentUserProvider) is ready.
  final container = ProviderScope.containerOf(
    tester.element(find.byType(MaterialApp)),
  );
  await container.read(authSessionProvider.future);
  await tester.pumpAndSettle();
}
