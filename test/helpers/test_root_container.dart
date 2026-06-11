import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/auth/data/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';

// Reusable AuthUser for tests.
AuthUser fakeAuthUser({
  String uid = '123',
  String email = 'test@test.com',
  String displayName = 'Test User',
  String? userName = 'TestUser',
  String? profileImageUrl = 'https://example.com/image.jpg',
  String? profileImageID = 'image123',
  bool isProfileComplete = true,
  bool isEmailVerified = true,
  double ratingTotal = 5,
  int ratingCount = 1,
}) =>
    AuthUser(
      uid: uid,
      email: email,
      displayName: displayName,
      userName: userName,
      profileImageUrl: profileImageUrl,
      profileImageID: profileImageID,
      isProfileComplete: isProfileComplete,
      isEmailVerified: isEmailVerified,
      ratingTotal: ratingTotal,
      ratingCount: ratingCount,
    );

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.state);

  AuthState state;
  int loadCount = 0;
  int loginCount = 0;
  int signupCount = 0;
  int logoutCount = 0;
  int addTokenCount = 0;
  int removeTokenCount = 0;

  @override
  Future<AuthState> loadCurrentUser() async {
    loadCount++;
    return state;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    loginCount++;
  }

  @override
  Future<void> signup({required String email, required String password}) async {
    signupCount++;
  }

  @override
  Future<void> logout() async {
    logoutCount++;
  }

  @override
  Future<void> loginWithGoogle() async {}

  @override
  Future<void> loginWithGithub() async {}

  @override
  Future<void> addRegistrationToken({required String uid}) async {
    addTokenCount++;
  }

  @override
  Future<void> removeRegistrationToken({required String uid}) async {
    removeTokenCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(
        '${invocation.memberName} not stubbed in FakeAuthRepository',
      );
}

Future<ProviderContainer> installTestRootContainer({
  AuthState authState = const AuthState.unauthenticated(),
  Account? account,
  TablesDB? tables,
  Client? client,
  Storage? storage,
  Functions? functions,
  Realtime? realtime,
  FirebaseMessaging? messaging,
  FakeAuthRepository? authRepository,
}) async {
  final fakeRepo = authRepository ?? FakeAuthRepository(authState);

  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(fakeRepo),
      if (account != null) appwriteAccountProvider.overrideWithValue(account),
      if (tables != null) appwriteTablesProvider.overrideWithValue(tables),
      if (client != null) appwriteClientProvider.overrideWithValue(client),
      if (storage != null) appwriteStorageProvider.overrideWithValue(storage),
      if (functions != null)
        appwriteFunctionsProvider.overrideWithValue(functions),
      if (realtime != null)
        appwriteRealtimeProvider.overrideWithValue(realtime),
      if (messaging != null)
        firebaseMessagingProvider.overrideWithValue(messaging),
    ],
  );
  setRootContainerForTesting(container);
  await container.read(authProvider.future);
  addTearDown(container.dispose);
  return container;
}
