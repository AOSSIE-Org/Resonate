import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/auth/viewmodel/forgot_password_notifier.dart';

import '../../../helpers/test_root_container.mocks.dart';

void main() {
  late MockAccount account;
  late MockTablesDB tables;
  late MockFunctions functions;
  late MockFirebaseMessaging messaging;

  setUp(() {
    account = MockAccount();
    tables = MockTablesDB();
    functions = MockFunctions();
    messaging = MockFirebaseMessaging();
  });

  ProviderContainer makeContainer() {
    final c = ProviderContainer(
      overrides: [
        appwriteAccountProvider.overrideWithValue(account),
        appwriteTablesProvider.overrideWithValue(tables),
        appwriteFunctionsProvider.overrideWithValue(functions),
        firebaseMessagingProvider.overrideWithValue(messaging),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  group('ForgotPassword', () {
    test('initial state is AsyncData(false)', () {
      final container = makeContainer();
      final state = container.read(forgotPasswordProvider);
      expect(state, isA<AsyncData<bool>>());
      expect(state.value, false);
    });

    test(
      'sendRecoveryEmail success → state becomes AsyncData(true)',
      () async {
        when(account.createRecovery(
          email: 'x@y.z',
          url: 'https://app/reset',
        )).thenAnswer((_) async => Token(
              $id: 't1',
              $createdAt: DateTime.now().toIso8601String(),
              userId: 'u1',
              secret: '',
              expire: DateTime.now()
                  .add(const Duration(minutes: 10))
                  .toIso8601String(),
              phrase: '',
            ));

        final container = makeContainer();
        final ok = await container
            .read(forgotPasswordProvider.notifier)
            .sendRecoveryEmail(
              email: 'x@y.z',
              redirectUrl: 'https://app/reset',
            );

        expect(ok, true);
        expect(container.read(forgotPasswordProvider).value, true);
        verify(account.createRecovery(
          email: 'x@y.z',
          url: 'https://app/reset',
        )).called(1);
      },
    );

    test('sendRecoveryEmail error → state becomes AsyncError', () async {
      when(account.createRecovery(
        email: 'x@y.z',
        url: 'u',
      )).thenThrow(AppwriteException('boom', 500));

      final container = makeContainer();
      final ok = await container
          .read(forgotPasswordProvider.notifier)
          .sendRecoveryEmail(email: 'x@y.z', redirectUrl: 'u');

      expect(ok, false);
      expect(container.read(forgotPasswordProvider).hasError, true);
    });
  });
}
