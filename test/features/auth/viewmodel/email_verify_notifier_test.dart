import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/auth/viewmodel/email_verify_notifier.dart';

class _FakeRepo implements AuthRepository {
  AuthState state = const AuthState.unauthenticated();

  int sendOtpCount = 0;
  int verifyOtpCount = 0;
  int statusCheckCount = 0;
  int markVerifiedCount = 0;
  int updateEmailCount = 0;
  int loadCount = 0;

  String sendOtpBody = '{"message":"mail sent"}';
  String statusResult = 'true';

  @override
  Future<AuthState> loadCurrentUser() async {
    loadCount++;
    return state;
  }

  @override
  Future<({String otpId, String responseBody})> sendOtp({
    required String email,
  }) async {
    sendOtpCount++;
    return (otpId: 'otp_$email', responseBody: sendOtpBody);
  }

  @override
  Future<({String verificationId, Execution execution})> verifyOtp({
    required String email,
    required String userOtp,
  }) async {
    verifyOtpCount++;
    return (
      verificationId: 'vid_$email',
      // The notifier only reads verificationId.
      execution: Execution.fromMap({
        '\$id': 'e1',
        '\$createdAt': DateTime.now().toIso8601String(),
        '\$updatedAt': DateTime.now().toIso8601String(),
        '\$permissions': ['any'],
        'functionId': 'f',
        'deploymentId': 'd',
        'trigger': 'http',
        'status': 'completed',
        'requestMethod': 'POST',
        'requestPath': '/',
        'requestHeaders': [],
        'responseStatusCode': 200,
        'responseBody': '',
        'responseHeaders': [],
        'logs': '',
        'errors': '',
        'duration': 0.0,
      }),
    );
  }

  @override
  Future<String?> checkVerificationStatus({
    required String verificationId,
  }) async {
    statusCheckCount++;
    return statusResult;
  }

  @override
  Future<void> markUserVerified({required String uid}) async {
    markVerifiedCount++;
  }

  @override
  Future<String> updateEmail({
    required String uid,
    required String newEmail,
  }) async {
    updateEmailCount++;
    return 'completed';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} not stubbed');
}

void main() {
  group('EmailVerify', () {
    test('sendOtp returns sent=true on canonical success body', () async {
      final repo = _FakeRepo();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(emailVerifyProvider.notifier)
          .sendOtp(email: 'u@e.com');

      expect(result.sent, true);
      expect(repo.sendOtpCount, 1);
    });

    test('sendOtp returns sent=false on non-canonical body', () async {
      final repo = _FakeRepo()..sendOtpBody = '{"error":"nope"}';
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final result = await container
          .read(emailVerifyProvider.notifier)
          .sendOtp(email: 'u@e.com');

      expect(result.sent, false);
      expect(result.responseBody, '{"error":"nope"}');
    });

    test('verifyOtp stores the verification ID on state', () async {
      final repo = _FakeRepo();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(emailVerifyProvider.notifier)
          .verifyOtp(email: 'a@b.c', userOtp: '123456');

      expect(
        container.read(emailVerifyProvider).verificationId,
        'vid_a@b.c',
      );
      expect(repo.verifyOtpCount, 1);
    });

    test('checkVerificationStatus returns null when no verifyOtp ran first',
        () async {
      final repo = _FakeRepo();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final status = await container
          .read(emailVerifyProvider.notifier)
          .checkVerificationStatus();

      expect(status, isNull);
      expect(repo.statusCheckCount, 0);
    });

    test('checkVerificationStatus polls the repo after verifyOtp', () async {
      final repo = _FakeRepo();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(emailVerifyProvider.notifier)
          .verifyOtp(email: 'a@b.c', userOtp: '123456');
      final status = await container
          .read(emailVerifyProvider.notifier)
          .checkVerificationStatus();

      expect(status, 'true');
      expect(repo.statusCheckCount, 1);
    });

    test('markVerified calls repo + triggers auth refresh', () async {
      final repo = _FakeRepo()
        ..state = AuthState.authenticated(
          AuthUser(
            uid: 'u1',
            email: 'u@e.com',
            displayName: 'Test',
            isEmailVerified: false,
            isProfileComplete: true,
          ),
        );
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(authProvider.future);
      final loadsBefore = repo.loadCount;

      await container
          .read(emailVerifyProvider.notifier)
          .markVerified(uid: 'u1');

      expect(repo.markVerifiedCount, 1);
      // refresh() calls loadCurrentUser exactly once more.
      expect(repo.loadCount, loadsBefore + 1);
    });

    test('allowResend / blockSignup / allowSignup mutate flags', () {
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(_FakeRepo())],
      );
      addTearDown(container.dispose);
      final notifier = container.read(emailVerifyProvider.notifier);

      expect(container.read(emailVerifyProvider).canResend, false);
      notifier.allowResend();
      expect(container.read(emailVerifyProvider).canResend, true);

      expect(container.read(emailVerifyProvider).signupAllowed, true);
      notifier.blockSignup();
      expect(container.read(emailVerifyProvider).signupAllowed, false);
      notifier.allowSignup();
      expect(container.read(emailVerifyProvider).signupAllowed, true);
    });
  });
}
