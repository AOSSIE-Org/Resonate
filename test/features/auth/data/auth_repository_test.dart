import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/utils/constants.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([Account, TablesDB, Functions, FirebaseMessaging])
User buildUser({
  String id = '123',
  bool emailVerified = true,
  bool profileComplete = true,
}) {
  return User(
    $id: id,
    name: 'Test User',
    email: 'test@test.com',
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
}

Row buildUserRow({int reportsCount = 0}) {
  return Row(
    $id: '123',
    $tableId: usersTableID,
    $databaseId: userDatabaseID,
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: const ['any'],
    $sequence: 0,
    data: {
      'username': 'testuser',
      'profileImageUrl': 'https://example.com/p.jpg',
      'profileImageID': 'p1',
      'ratingTotal': 5,
      'ratingCount': 1,
      'followers': const [],
      'userReports': List.filled(reportsCount, {'reason': 'spam'}),
    },
  );
}

void main() {
  late MockAccount account;
  late MockTablesDB tables;
  late MockFunctions functions;
  late MockFirebaseMessaging messaging;
  late AuthRepository repo;

  setUp(() {
    account = MockAccount();
    tables = MockTablesDB();
    functions = MockFunctions();
    messaging = MockFirebaseMessaging();
    repo = AuthRepository(
      account: account,
      tables: tables,
      functions: functions,
      messaging: messaging,
    );
  });

  group('loadCurrentUser', () {
    test('returns unauthenticated when account.get() throws', () async {
      when(account.get()).thenThrow(Exception('no session'));
      final state = await repo.loadCurrentUser();
      expect(state, isA<AuthStateUnauthenticated>());
    });

    test('returns needsOnboarding when profile is incomplete', () async {
      when(account.get()).thenAnswer(
        (_) async => buildUser(profileComplete: false),
      );
      final state = await repo.loadCurrentUser();
      expect(state, isA<AuthStateNeedsOnboarding>());
      // Table should NOT be hit when profile is incomplete.
      verifyNever(tables.getRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        queries: anyNamed('queries'),
      ));
    });

    test('returns blocked when reportsCount > 5', () async {
      when(account.get()).thenAnswer((_) async => buildUser());
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: '123',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => buildUserRow(reportsCount: 6));

      final state = await repo.loadCurrentUser();
      expect(state, isA<AuthStateBlocked>());
    });

    test('returns authenticated normally', () async {
      when(account.get()).thenAnswer((_) async => buildUser());
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: '123',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => buildUserRow(reportsCount: 0));

      final state = await repo.loadCurrentUser();
      expect(state, isA<AuthStateAuthenticated>());
      final user = (state as AuthStateAuthenticated).user;
      expect(user.uid, '123');
      expect(user.userName, 'testuser');
      expect(user.profileImageUrl, 'https://example.com/p.jpg');
      expect(user.reportsCount, 0);
    });
  });

  // login() never throws: failures are mapped to typed AuthFailures and land
  // in repo.sessionState as the error of an AsyncError.
  group('login error mapping', () {
    test('userInvalidCredentials → AuthFailure.invalidCredentials', () async {
      when(
        account.createEmailPasswordSession(
          email: 'a@b.c',
          password: 'pw',
        ),
      ).thenThrow(AppwriteException('bad', 401, userInvalidCredentials));

      await repo.login(email: 'a@b.c', password: 'pw');

      expect(repo.sessionState.error, isA<AuthFailureInvalidCredentials>());
    });

    test(
      'generalArgumentInvalid w/ password-related message → '
      'AuthFailure.passwordTooShort',
      () async {
        when(
          account.createEmailPasswordSession(
            email: 'a@b.c',
            password: 'short',
          ),
        ).thenThrow(
          AppwriteException(
            'Password must be at least 8 characters',
            400,
            generalArgumentInvalid,
          ),
        );

        await repo.login(email: 'a@b.c', password: 'short');

        expect(repo.sessionState.error, isA<AuthFailurePasswordTooShort>());
      },
    );

    test(
      'generalArgumentInvalid w/ unrelated message → AuthFailure.unknown '
      '(no longer mis-mapped to passwordTooShort)',
      () async {
        when(
          account.createEmailPasswordSession(
            email: 'bad-email',
            password: 'pw',
          ),
        ).thenThrow(
          AppwriteException(
            'Invalid `email` param',
            400,
            generalArgumentInvalid,
          ),
        );

        await repo.login(email: 'bad-email', password: 'pw');

        expect(repo.sessionState.error, isA<AuthFailureUnknown>());
      },
    );

    test('user_already_exists → AuthFailure.userAlreadyExists', () async {
      when(
        account.createEmailPasswordSession(
          email: 'a@b.c',
          password: 'pw',
        ),
      ).thenThrow(AppwriteException('exists', 409, 'user_already_exists'));

      await repo.login(email: 'a@b.c', password: 'pw');

      expect(repo.sessionState.error, isA<AuthFailureUserAlreadyExists>());
    });

    test('unknown Appwrite type → AuthFailure.unknown', () async {
      when(
        account.createEmailPasswordSession(
          email: 'a@b.c',
          password: 'pw',
        ),
      ).thenThrow(AppwriteException('weird', 500, 'something_else'));

      await repo.login(email: 'a@b.c', password: 'pw');

      expect(repo.sessionState.error, isA<AuthFailureUnknown>());
    });
  });

  group('logout', () {
    test('calls deleteSession and flips the session to unauthenticated',
        () async {
      when(account.deleteSession(sessionId: 'current'))
          .thenAnswer((_) async {});

      await repo.logout();

      verify(account.deleteSession(sessionId: 'current')).called(1);
      expect(repo.sessionState.value, isA<AuthStateUnauthenticated>());
    });
  });

  group('session state', () {
    test('starts loading; ensureSessionLoaded loads once and is idempotent',
        () async {
      when(account.get()).thenThrow(Exception('no session'));

      expect(repo.sessionState.isLoading, true);

      final first = await repo.ensureSessionLoaded();
      final second = await repo.ensureSessionLoaded();

      expect(first, isA<AuthStateUnauthenticated>());
      expect(second, isA<AuthStateUnauthenticated>());
      expect(repo.sessionState.value, isA<AuthStateUnauthenticated>());
      verify(account.get()).called(1);
    });

    test('login success reloads the user into sessionState and emits '
        'loading → data on the stream', () async {
      when(messaging.getToken()).thenAnswer((_) async => null);
      when(account.createEmailPasswordSession(email: 'a@b.c', password: 'pw'))
          .thenAnswer((_) async => Session(
                $id: 'sess',
                $createdAt: DateTime.now().toIso8601String(),
                $updatedAt: DateTime.now().toIso8601String(),
                userId: '123',
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
              ));
      when(account.get()).thenAnswer((_) async => buildUser());
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: '123',
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => buildUserRow());

      final emitted = <AsyncValue<AuthState>>[];
      final sub = repo.sessionStateChanges.listen(emitted.add);
      addTearDown(sub.cancel);

      await repo.login(email: 'a@b.c', password: 'pw');

      expect(repo.sessionState.value, isA<AuthStateAuthenticated>());
      expect(emitted.first.isLoading, true);
      expect(emitted.last.value, isA<AuthStateAuthenticated>());
    });

    test('refresh reloads the current user into sessionState', () async {
      when(account.get()).thenThrow(Exception('no session'));

      await repo.refresh();

      expect(repo.sessionState.value, isA<AuthStateUnauthenticated>());
      verify(account.get()).called(1);
    });
  });

  group('addRegistrationToken', () {
    test('no-op when FCM token is null', () async {
      when(messaging.getToken()).thenAnswer((_) async => null);

      await repo.addRegistrationToken(uid: 'u1');

      verifyNever(tables.listRows(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        queries: anyNamed('queries'),
      ));
    });

    test('appends FCM token to every subscribed + created room', () async {
      when(messaging.getToken()).thenAnswer((_) async => 'tok');

      final sub = Row(
        $id: 'sub1',
        $tableId: subscribedUserTableId,
        $databaseId: upcomingRoomsDatabaseId,
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
        $permissions: const ['any'],
        $sequence: 0,
        data: {'registrationTokens': <dynamic>['old']},
      );
      final room = Row(
        $id: 'room1',
        $tableId: upcomingRoomsTableId,
        $databaseId: upcomingRoomsDatabaseId,
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
        $permissions: const ['any'],
        $sequence: 0,
        data: {'creator_fcm_tokens': <dynamic>[]},
      );

      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 1, rows: [sub]));
      when(
        tables.listRows(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
          queries: anyNamed('queries'),
        ),
      ).thenAnswer((_) async => RowList(total: 1, rows: [room]));
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((inv) async => sub);

      await repo.addRegistrationToken(uid: 'u1');

      verify(
        tables.updateRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: subscribedUserTableId,
          rowId: 'sub1',
          data: {
            'registrationTokens': ['old', 'tok'],
          },
        ),
      ).called(1);
      verify(
        tables.updateRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: upcomingRoomsTableId,
          rowId: 'room1',
          data: {
            'creator_fcm_tokens': ['tok'],
          },
        ),
      ).called(1);
    });
  });
}
