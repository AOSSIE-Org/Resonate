import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/utils/constants.dart';

import '../../../helpers/test_root_container.dart';
import '../../../helpers/test_root_container.mocks.dart';

User buildUser({String id = '123'}) => User(
  $id: id,
  name: 'Test User',
  email: 'test@test.com',
  emailVerification: true,
  prefs: Preferences(data: const {}),
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

  MockExecution execution({
    ExecutionStatus status = ExecutionStatus.completed,
    int code = 200,
    String body = '{"ok":true}',
  }) {
    final exec = MockExecution();
    when(exec.status).thenReturn(status);
    when(exec.responseStatusCode).thenReturn(code);
    when(exec.responseBody).thenReturn(body);
    when(exec.errors).thenReturn('');
    when(exec.logs).thenReturn('');
    return exec;
  }

  void stubPrefs([Map<String, dynamic> data = const {}]) {
    when(account.getPrefs()).thenAnswer((_) async => Preferences(data: data));
    when(
      account.updatePrefs(prefs: anyNamed('prefs')),
    ).thenAnswer((_) async => buildUser());
  }

  String bodyOf(String functionId) =>
      verify(
            functions.createExecution(
              functionId: functionId,
              body: captureAnyNamed('body'),
            ),
          ).captured.single
          as String;

  group('signupWithEmail', () {
    test('creates the account and signs straight in', () async {
      when(
        account.create(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => buildUser());
      when(
        account.createEmailPasswordSession(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(AppwriteException('stop here'));

      // The session read that follows is out of scope; the calls above are
      // what this asserts.
      await repo
          .signupWithEmail(email: 'new@test.com', password: 'hunter2hunter2')
          .catchError((_) {});

      verify(
        account.create(
          userId: anyNamed('userId'),
          email: 'new@test.com',
          password: 'hunter2hunter2',
        ),
      ).called(1);
      verify(
        account.createEmailPasswordSession(
          email: 'new@test.com',
          password: 'hunter2hunter2',
        ),
      ).called(1);
    });

    test('maps a taken e-mail to userAlreadyExists', () async {
      when(
        account.create(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(AppwriteException('taken', 409, 'user_already_exists'));

      await repo.signupWithEmail(email: 'taken@test.com', password: 'hunter2');

      expect(repo.sessionState.error, isA<AuthFailureUserAlreadyExists>());
    });

    test('maps a short password to passwordTooShort', () async {
      when(
        account.create(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(
        AppwriteException(
          'Invalid `password` param: Password must be at least 8 characters',
          400,
          generalArgumentInvalid,
        ),
      );

      await repo.signupWithEmail(email: 'new@test.com', password: 'short');

      expect(repo.sessionState.error, isA<AuthFailurePasswordTooShort>());
    });

    test('anything else falls through to unknown', () async {
      when(
        account.create(
          userId: anyNamed('userId'),
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(AppwriteException('server exploded', 500));

      await repo.signupWithEmail(
        email: 'new@test.com',
        password: 'hunter2hunter2',
      );

      expect(repo.sessionState.error, isA<AuthFailureUnknown>());
    });
  });

  group('OAuth', () {
    test('loginWithGoogle opens a Google session', () async {
      when(
        account.createOAuth2Session(provider: anyNamed('provider')),
      ).thenAnswer((_) async {});

      await repo.loginWithGoogle().catchError((_) {});

      verify(
        account.createOAuth2Session(provider: OAuthProvider.google),
      ).called(1);
    });

    test('loginWithGithub opens a GitHub session', () async {
      when(
        account.createOAuth2Session(provider: anyNamed('provider')),
      ).thenAnswer((_) async {});

      await repo.loginWithGithub().catchError((_) {});

      verify(
        account.createOAuth2Session(provider: OAuthProvider.github),
      ).called(1);
    });
  });

  group('completePasswordRecovery', () {
    test('forwards the reset to Appwrite', () async {
      when(
        account.updateRecovery(
          userId: anyNamed('userId'),
          secret: anyNamed('secret'),
          password: anyNamed('password'),
        ),
      ).thenAnswer(
        (_) async => Token(
          $id: 't1',
          $createdAt: DateTime.now().toIso8601String(),
          userId: 'u1',
          secret: '',
          expire: DateTime.now().toIso8601String(),
          phrase: '',
        ),
      );

      await repo.completePasswordRecovery(
        userId: 'u1',
        secret: 'sec',
        newPassword: 'brandnewpass',
      );

      verify(
        account.updateRecovery(
          userId: 'u1',
          secret: 'sec',
          password: 'brandnewpass',
        ),
      ).called(1);
    });

    test('an expired link maps to an AuthFailure', () async {
      when(
        account.updateRecovery(
          userId: anyNamed('userId'),
          secret: anyNamed('secret'),
          password: anyNamed('password'),
        ),
      ).thenThrow(AppwriteException('expired', 401));

      await expectLater(
        repo.completePasswordRecovery(
          userId: 'u1',
          secret: 'stale',
          newPassword: 'brandnewpass',
        ),
        throwsA(isA<AuthFailure>()),
      );
    });
  });

  group('sendEmailOTP', () {
    test('stores the otp id in prefs and passes it to the function', () async {
      stubPrefs({'existing': 'kept'});
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => execution(body: 'sent'));

      final result = await repo.sendEmailOTP(email: 'someone@test.com');

      // The id is derived from the address with the domain stripped.
      expect(result.otpId, endsWith('someone'));
      expect(result.responseBody, 'sent');

      final prefs =
          verify(
                account.updatePrefs(prefs: captureAnyNamed('prefs')),
              ).captured.single
              as Map;
      expect(prefs['otp_ID'], result.otpId);
      expect(prefs['existing'], 'kept', reason: 'other prefs must survive');

      final body = json.decode(bodyOf(sendOtpFunctionID)) as Map;
      expect(body['email'], 'someone@test.com');
      expect(body['otpID'], result.otpId);
    });

    // The caller inspects the body itself, so a failed send is reported
    // rather than thrown.
    test('a failed execution still returns the body to the caller', () async {
      stubPrefs();
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => execution(
          status: ExecutionStatus.failed,
          code: 500,
          body: 'mailer down',
        ),
      );

      final result = await repo.sendEmailOTP(email: 'someone@test.com');

      expect(result.responseBody, 'mailer down');
    });
  });

  group('verifyOtp', () {
    test('sends the stored otp id with the code the user typed', () async {
      stubPrefs({'otp_ID': 'stored-otp'});
      final exec = execution();
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => exec);

      final result = await repo.verifyOtp(
        email: 'someone@test.com',
        userOtp: '123456',
      );

      expect(result.execution, same(exec));
      expect(result.verificationId, endsWith('someone'));

      final body = json.decode(bodyOf(verifyOtpFunctionID)) as Map;
      expect(body['otpID'], 'stored-otp');
      expect(body['userOTP'], '123456');
      expect(body['verify_ID'], result.verificationId);
    });

    test('survives prefs with no otp id stored', () async {
      stubPrefs();
      when(
        functions.createExecution(
          functionId: anyNamed('functionId'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => execution());

      await repo.verifyOtp(email: 'someone@test.com', userOtp: '123456');

      expect(
        (json.decode(bodyOf(verifyOtpFunctionID)) as Map)['otpID'],
        isNull,
      );
    });
  });

  group('checkVerificationStatus', () {
    test('reads the status off the verification row', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer(
        (_) async => buildRow(
          id: 'v1',
          tableId: verificationTableID,
          databaseId: databaseId,
          data: const {'status': 'verified'},
        ),
      );

      expect(
        await repo.checkVerificationStatus(verificationId: 'v1'),
        'verified',
      );
      verify(
        tables.getRow(
          databaseId: databaseId,
          tableId: verificationTableID,
          rowId: 'v1',
        ),
      ).called(1);
    });

    test('is null while the row carries no status yet', () async {
      when(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer(
        (_) async => buildRow(
          id: 'v1',
          tableId: verificationTableID,
          databaseId: databaseId,
          data: const {},
        ),
      );

      expect(await repo.checkVerificationStatus(verificationId: 'v1'), isNull);
    });
  });

  test('markUserVerified sends the uid to the verify function', () async {
    when(
      functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => execution());

    await repo.markUserVerified(uid: 'u1');

    expect(json.decode(bodyOf(verifyUserFunctionID)), {'userID': 'u1'});
  });

  test('updateEmail reports the execution status back', () async {
    when(
      functions.createExecution(
        functionId: anyNamed('functionId'),
        body: anyNamed('body'),
      ),
    ).thenAnswer((_) async => execution(status: ExecutionStatus.completed));

    final status = await repo.updateEmail(uid: 'u1', newEmail: 'new@test.com');

    expect(status, ExecutionStatus.completed.name);
    expect(json.decode(bodyOf(updateEmailFunctionID)), {
      'User_ID': 'u1',
      'email': 'new@test.com',
    });
  });
}
