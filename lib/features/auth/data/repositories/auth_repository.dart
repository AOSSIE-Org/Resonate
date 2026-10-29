import 'dart:async';
import 'dart:convert';
import 'package:resonate/utils/dev_log.dart' as developer;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:random_string/random_string.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/shared/model/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final repo = AuthRepository(
    account: ref.watch(appwriteAccountProvider),
    tables: ref.watch(appwriteTablesProvider),
    functions: ref.watch(appwriteFunctionsProvider),
  );
  ref.onDispose(repo.dispose);
  return repo;
}

@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession {
  @override
  Future<AuthState> build() {
    final repo = ref.watch(authRepositoryProvider);
    final sub = repo.sessionStateChanges.listen((next) => state = next);
    ref.onDispose(sub.cancel);
    return repo.ensureSessionLoaded();
  }
}

class AuthRepository {
  AuthRepository({
    required Account account,
    required TablesDB tables,
    required Functions functions,
  }) : _account = account,
       _tables = tables,
       _functions = functions;

  final Account _account;
  final TablesDB _tables;
  final Functions _functions;

  final StreamController<AsyncValue<AuthState>> _sessionStateController =
      StreamController<AsyncValue<AuthState>>.broadcast(sync: true);
  AsyncValue<AuthState> _sessionState = const AsyncValue.loading();
  Future<AuthState>? _initialLoad;

  AsyncValue<AuthState> get sessionState => _sessionState;
  Stream<AsyncValue<AuthState>> get sessionStateChanges =>
      _sessionStateController.stream;

  void _setSessionState(AsyncValue<AuthState> next) {
    _sessionState = next;
    _sessionStateController.add(next);
  }

  Future<AuthState> ensureSessionLoaded() {
    if (_sessionState case AsyncData(:final value)) {
      return Future.value(value);
    }
    return _initialLoad ??= () async {
      final next = await loadCurrentUser();
      _setSessionState(AsyncData(next));
      return next;
    }();
  }

  Future<void> refresh() async {
    _setSessionState(const AsyncValue.loading());
    _setSessionState(await AsyncValue.guard(loadCurrentUser));
  }

  void dispose() {
    _sessionStateController.close();
  }

  Future<AuthState> loadCurrentUser() async {
    final appwrite_models.User user;
    try {
      user = await _account.get();
    } catch (_) {
      return const AuthState.unauthenticated();
    }

    final isProfileComplete =
        (user.prefs.data['isUserProfileComplete'] as bool?) ?? false;

    if (!isProfileComplete) {
      return AuthState.needsOnboarding(
        AuthUser(
          uid: user.$id,
          email: user.email,
          displayName: user.name,
          isEmailVerified: user.emailVerification,
          isProfileComplete: false,
        ),
      );
    }

    try {
      final row = await _tables.getRow(
        databaseId: databaseId,
        tableId: usersTableID,
        rowId: user.$id,
        queries: [
          Query.select(['*', 'followers.*', 'userReports.*']),
        ],
      );

      final followers = <FollowerUserModel>[];
      for (final e in (row.data['followers'] as List<dynamic>? ?? const [])) {
        try {
          followers.add(FollowerUserModel.fromJson(e as Map<String, dynamic>));
        } catch (err, st) {
          developer.log(
            'loadCurrentUser: skipping malformed follower row',
            error: err,
            stackTrace: st,
          );
        }
      }
      final reportsCount =
          (row.data['userReports'] as List<dynamic>? ?? const []).length;

      final authUser = AuthUser(
        uid: user.$id,
        email: user.email,
        displayName: user.name,
        isEmailVerified: user.emailVerification,
        isProfileComplete: true,
        profileImageUrl: row.data['profileImageUrl'] as String?,
        profileImageID: row.data['profileImageID'] as String?,
        userName: (row.data['username'] as String?) ?? 'unavailable',
        ratingTotal: (row.data['ratingTotal'] as num?)?.toDouble() ?? 5,
        ratingCount: (row.data['ratingCount'] as int?) ?? 1,
        followers: followers,
        reportsCount: reportsCount,
      );

      if (reportsCount > 5) return AuthState.blocked(authUser);
      return AuthState.authenticated(authUser);
    } catch (e, st) {
      developer.log(
        'loadCurrentUser: account ok but profile-row fetch failed',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) => _mutateSession(() async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  });

  Future<void> signupWithEmail({
    required String email,
    required String password,
  }) => _mutateSession(() async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  });

  Future<void> loginWithGoogle() => _mutateSession(
    () => _account.createOAuth2Session(provider: OAuthProvider.google),
  );

  Future<void> loginWithGithub() => _mutateSession(
    () => _account.createOAuth2Session(provider: OAuthProvider.github),
  );

  Future<void> logout() async {
    _setSessionState(const AsyncValue.loading());
    _setSessionState(
      await AsyncValue.guard(() async {
        await _account.deleteSession(sessionId: 'current');
        return const AuthState.unauthenticated();
      }),
    );
  }

  Future<void> _mutateSession(Future<void> Function() mutate) async {
    _setSessionState(const AsyncValue.loading());
    _setSessionState(
      await AsyncValue.guard(() async {
        await mutate();
        return await loadCurrentUser();
      }),
    );
  }

  // Password recovery

  Future<void> sendPasswordRecovery({
    required String email,
    required String redirectUrl,
  }) async {
    try {
      await _account.createRecovery(email: email, url: redirectUrl);
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> completePasswordRecovery({
    required String userId,
    required String secret,
    required String newPassword,
  }) async {
    try {
      await _account.updateRecovery(
        userId: userId,
        secret: secret,
        password: newPassword,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  // OTP / email verification

  Future<({String otpId, String responseBody})> sendEmailOTP({
    required String email,
  }) async {
    var otpId = randomNumeric(10) + email;
    otpId = otpId.split('@')[0];
    final existing = await _account.getPrefs();
    await _account.updatePrefs(prefs: {...existing.data, 'otp_ID': otpId});

    final response = await _functions.createExecution(
      functionId: sendOtpFunctionID,
      body: json.encode({'email': email, 'otpID': otpId}),
    );
    if (response.status != ExecutionStatus.completed ||
        response.responseStatusCode >= 400) {
      developer.log(
        'sendEmailOTP: function did not complete cleanly '
        '(status=${response.status.value}, code=${response.responseStatusCode})',
        error: 'errors=${response.errors}\nlogs=${response.logs}',
      );
    }

    return (otpId: otpId, responseBody: response.responseBody);
  }

  Future<({String verificationId, appwrite_models.Execution execution})>
  verifyOtp({required String email, required String userOtp}) async {
    var verificationId = randomNumeric(10) + email;
    verificationId = verificationId.split('@')[0];

    final prefs = await _account.getPrefs();
    final otpId = prefs.data['otp_ID'] as String?;

    final execution = await _functions.createExecution(
      functionId: verifyOtpFunctionID,
      body: json.encode({
        'otpID': otpId,
        'userOTP': userOtp,
        'verify_ID': verificationId,
      }),
    );

    return (verificationId: verificationId, execution: execution);
  }

  Future<String?> checkVerificationStatus({
    required String verificationId,
  }) async {
    final doc = await _tables.getRow(
      databaseId: databaseId,
      tableId: verificationTableID,
      rowId: verificationId,
    );
    return doc.data['status'] as String?;
  }

  Future<void> markUserVerified({required String uid}) async {
    await _functions.createExecution(
      functionId: verifyUserFunctionID,
      body: json.encode({'userID': uid}),
    );
  }

  Future<String> updateEmail({
    required String uid,
    required String newEmail,
  }) async {
    final result = await _functions.createExecution(
      functionId: updateEmailFunctionID,
      body: json.encode({'User_ID': uid, 'email': newEmail}),
    );
    return result.status.name;
  }

  // Error mapping

  AuthFailure _mapException(AppwriteException e) {
    if (e.type == userInvalidCredentials) {
      return const AuthFailure.invalidCredentials();
    }
    if (e.type == 'user_already_exists') {
      return const AuthFailure.userAlreadyExists();
    }
    if (e.type == generalArgumentInvalid &&
        (e.message?.toLowerCase().contains('password') ?? false)) {
      return const AuthFailure.passwordTooShort();
    }
    return AuthFailure.unknown(e.message ?? e.toString());
  }
}
