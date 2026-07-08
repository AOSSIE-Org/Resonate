import 'dart:convert';
import 'dart:developer' as developer;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:random_string/random_string.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/auth/model/auth_failure.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/auth_repository.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) => AuthRepository(
      account: ref.watch(appwriteAccountProvider),
      tables: ref.watch(appwriteTablesProvider),
      functions: ref.watch(appwriteFunctionsProvider),
      messaging: ref.watch(firebaseMessagingProvider),
    );


class AuthRepository {
  AuthRepository({
    required Account account,
    required TablesDB tables,
    required Functions functions,
    required FirebaseMessaging messaging,
  })  : _account = account,
        _tables = tables,
        _functions = functions,
        _messaging = messaging;

  final Account _account;
  final TablesDB _tables;
  final Functions _functions;
  final FirebaseMessaging _messaging;

  // Session
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
        databaseId: userDatabaseID,
        tableId: usersTableID,
        rowId: user.$id,
        queries: [
          Query.select(['*', 'followers.*', 'userReports.*']),
        ],
      );

      final followers = (row.data['followers'] as List<dynamic>? ?? const [])
          .map((e) => FollowerUserModel.fromJson(e as Map<String, dynamic>))
          .toList();
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
        'loadCurrentUser: account ok but profile-row fetch failed; '
        'keeping session alive with minimal user data',
        error: e,
        stackTrace: st,
      );
      return AuthState.authenticated(
        AuthUser(
          uid: user.$id,
          email: user.email,
          displayName: user.name,
          isEmailVerified: user.emailVerification,
          isProfileComplete: true,
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw _mapException(e);
    }
  }

  Future<void> signup({
    required String email,
    required String password,
  }) async {
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
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }

  Future<void> loginWithGoogle() async {
    await _account.createOAuth2Session(provider: OAuthProvider.google);
  }

  Future<void> loginWithGithub() async {
    await _account.createOAuth2Session(provider: OAuthProvider.github);
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

  Future<({String otpId, String responseBody})> sendOtp({
    required String email,
  }) async {
    var otpId = randomNumeric(10) + email;
    otpId = otpId.split('@')[0];
    await _account.updatePrefs(prefs: {'otp_ID': otpId});

    final response = await _functions.createExecution(
      functionId: sendOtpFunctionID,
      body: json.encode({'email': email, 'otpID': otpId}),
    );

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
      databaseId: emailVerificationDatabaseID,
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

  // FCM token management
  Future<void> addRegistrationToken({required String uid}) async {
    final fcmToken = await _messaging.getToken();
    if (fcmToken == null) return;
    await _mutateFcmTokens(uid: uid, fcmToken: fcmToken, add: true);
  }

  Future<void> removeRegistrationToken({required String uid}) async {
    final fcmToken = await _messaging.getToken();
    if (fcmToken == null) return;
    await _mutateFcmTokens(uid: uid, fcmToken: fcmToken, add: false);
  }

  Future<void> _mutateFcmTokens({
    required String uid,
    required String fcmToken,
    required bool add,
  }) async {
    Future<void> mutate({
      required String tableId,
      required String fieldName,
      required String queryField,
    }) async {
      final rows = await _tables.listRows(
        databaseId: upcomingRoomsDatabaseId,
        tableId: tableId,
        queries: [
          Query.equal(queryField, [uid]),
        ],
      );
      for (final row in rows.rows) {
        final existing = List<dynamic>.from(
          (row.data[fieldName] as List?) ?? const [],
        );
        if (add) {
          if (existing.contains(fcmToken)) continue; // already there
          existing.add(fcmToken);
        } else {
          if (!existing.contains(fcmToken)) continue; // nothing to remove
          existing.remove(fcmToken);
        }
        await _tables.updateRow(
          databaseId: upcomingRoomsDatabaseId,
          tableId: tableId,
          rowId: row.$id,
          data: {fieldName: existing},
        );
      }
    }

    await mutate(
      tableId: subscribedUserTableId,
      fieldName: 'registrationTokens',
      queryField: 'userID',
    );
    await mutate(
      tableId: upcomingRoomsTableId,
      fieldName: 'creator_fcm_tokens',
      queryField: 'creatorUid',
    );
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
