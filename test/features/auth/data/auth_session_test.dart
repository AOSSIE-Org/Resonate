import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';


User _buildUser({
  String id = 'u1',
  bool emailVerified = true,
  bool profileComplete = true,
}) =>
    User(
      $id: id,
      name: 'Foo',
      email: 'foo@example.com',
      emailVerification: emailVerified,
      prefs: Preferences(data: {'isUserProfileComplete': profileComplete}),
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      accessedAt: DateTime.now().toIso8601String(),
      registration: DateTime.now().toIso8601String(),
      phone: '',
      phoneVerification: false,
      mfa: false,
      passwordUpdate: DateTime.now().toIso8601String(),
      status: true,
      password: '',
      labels: const [],
      hash: 'Argon2',
      targets: const [],
      hashOptions: const {},
    );

Row _buildUserRow({String id = 'u1', int reportsCount = 0}) => buildRow(
      id: id,
      tableId: usersTableID,
      databaseId: userDatabaseID,
      data: {
        'username': 'foo',
        'profileImageUrl': 'https://example.com/p.jpg',
        'profileImageID': 'p1',
        'ratingTotal': 5,
        'ratingCount': 1,
        'followers': const [],
        'userReports': List.filled(reportsCount, {'reason': 'spam'}),
      },
    );

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
    // Default: no FCM token, nothing in the upcoming-room tables.
    when(messaging.getToken()).thenAnswer((_) async => null);
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

  group('authSessionProvider', () {
    test('resolves to whatever the repository loads', () async {
      when(account.get()).thenAnswer((_) async => _buildUser());
      when(tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'u1',
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => _buildUserRow());

      final container = makeContainer();
      final state = await container.read(authSessionProvider.future);

      expect(state, isA<AuthStateAuthenticated>());
      expect((state as AuthStateAuthenticated).user.uid, 'u1');
    });

    test('mirrors login: session flips to authenticated', () async {
      // First load: unauthenticated.
      var hasSession = false;
      when(account.get()).thenAnswer((_) async {
        if (!hasSession) throw Exception('no session');
        return _buildUser();
      });
      when(account.createEmailPasswordSession(
        email: 'a@b.c',
        password: 'pw',
      )).thenAnswer((_) async {
        hasSession = true;
        return Session(
          $id: 'sess',
          $createdAt: DateTime.now().toIso8601String(),
          $updatedAt: DateTime.now().toIso8601String(),
          userId: 'u1',
          expire: DateTime.now()
              .add(const Duration(days: 30))
              .toIso8601String(),
          provider: 'email',
          providerUid: 'a@b.c',
          providerAccessToken: '',
          providerAccessTokenExpiry: '',
          providerRefreshToken: '',
          ip: '',
          osCode: '',
          osName: '',
          osVersion: '',
          clientType: '',
          clientCode: '',
          clientName: '',
          clientVersion: '',
          clientEngine: '',
          clientEngineVersion: '',
          deviceName: '',
          deviceBrand: '',
          deviceModel: '',
          countryCode: '',
          countryName: '',
          current: true,
          factors: const [],
          secret: '',
          mfaUpdatedAt: '',
        );
      });
      when(tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'u1',
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => _buildUserRow());

      final container = makeContainer();
      await container.read(authSessionProvider.future);
      expect(container.read(authSessionProvider).value,
          isA<AuthStateUnauthenticated>());

      await container
          .read(authRepositoryProvider)
          .login(email: 'a@b.c', password: 'pw');

      expect(container.read(authSessionProvider).requireValue,
          isA<AuthStateAuthenticated>());
      verify(account.createEmailPasswordSession(
        email: 'a@b.c',
        password: 'pw',
      )).called(1);
    });

    test('mirrors logout: session flips to unauthenticated', () async {
      var hasSession = true;
      when(account.get()).thenAnswer((_) async {
        if (!hasSession) throw Exception('no session');
        return _buildUser();
      });
      when(tables.getRow(
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: 'u1',
        queries: anyNamed('queries'),
      )).thenAnswer((_) async => _buildUserRow());
      when(account.deleteSession(sessionId: 'current')).thenAnswer((_) async {
        hasSession = false;
      });

      final container = makeContainer();
      await container.read(authSessionProvider.future);
      expect(container.read(authSessionProvider).requireValue,
          isA<AuthStateAuthenticated>());

      await container.read(authRepositoryProvider).logout();

      expect(container.read(authSessionProvider).requireValue,
          isA<AuthStateUnauthenticated>());
      verify(account.deleteSession(sessionId: 'current')).called(1);
    });
  });
}
