import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../helpers/test_root_container.dart';

export '../../helpers/test_root_container.dart'
    show fakeAuthUser, FakeAuthRepository;

Widget authTestApp(Widget child) {
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

Future<ProviderContainer> buildAuthContainer({
  AuthState authState = const AuthState.unauthenticated(),
  AuthRepository? authRepository,
}) async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider
          .overrideWithValue(authRepository ?? FakeAuthRepository(authState)),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authSessionProvider.future);
  return container;
}

Future<void> pumpAuthPage(
  WidgetTester tester,
  Widget child, {
  AuthState authState = const AuthState.unauthenticated(),
  AuthRepository? authRepository,
  bool settle = true,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider
            .overrideWithValue(authRepository ?? FakeAuthRepository(authState)),
      ],
      child: authTestApp(child),
    ),
  );
  // pumpAndSettle resolves async auth since FakeAuthRepository is immediate.
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}
