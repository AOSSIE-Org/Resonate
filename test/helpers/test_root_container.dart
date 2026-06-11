import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:resonate/core/container.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/auth/data/auth_repository.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/rooms/model/livekit_state.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/viewmodel/livekit_notifier.dart';
import 'package:resonate/utils/enums/room_state.dart';

// Mocks shared across every notifier/repo test in the suite. Generated to
// `test_root_container.mocks.dart` by `dart run build_runner build`.
@GenerateMocks([
  Account,
  TablesDB,
  Realtime,
  Functions,
  RealtimeSubscription,
  FirebaseMessaging,
  Execution,
])
//
// ─── Data builders ──────────────────────────────────────────────────────────
//

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

AppwriteRoom fakeAppwriteRoom({
  String id = 'room-1',
  String name = 'Test Room',
  String description = 'A room for testing',
  int totalParticipants = 1,
  List<String> tags = const ['test'],
  List<String> memberAvatarUrls = const [],
  bool isUserAdmin = true,
  List<String> reportedUsers = const [],
  String? myDocId,
}) =>
    AppwriteRoom(
      id: id,
      name: name,
      description: description,
      totalParticipants: totalParticipants,
      tags: tags,
      memberAvatarUrls: memberAvatarUrls,
      state: RoomState.live,
      isUserAdmin: isUserAdmin,
      reportedUsers: reportedUsers,
      myDocId: myDocId,
    );

AppwriteUpcomingRoom fakeUpcomingRoom({
  String id = 'upcoming-1',
  String name = 'Test Upcoming',
  bool isTime = false,
  DateTime? scheduledDateTime,
  String description = 'A scheduled room',
  int totalSubscriberCount = 0,
  List<String> tags = const ['test'],
  List<String> subscribersAvatarUrls = const [],
  bool userIsCreator = true,
  bool hasUserSubscribed = false,
}) =>
    AppwriteUpcomingRoom(
      id: id,
      name: name,
      isTime: isTime,
      scheduledDateTime: scheduledDateTime ?? DateTime.now(),
      description: description,
      totalSubscriberCount: totalSubscriberCount,
      tags: tags,
      subscribersAvatarUrls: subscribersAvatarUrls,
      userIsCreator: userIsCreator,
      hasUserSubscribed: hasUserSubscribed,
    );

Participant fakeParticipant({
  String uid = 'p-1',
  String email = 'p@test.com',
  String name = 'Person',
  String dpUrl = 'https://example.com/dp.jpg',
  bool isAdmin = false,
  bool isMicOn = false,
  bool isModerator = false,
  bool isSpeaker = false,
  bool hasRequestedToBeSpeaker = false,
}) =>
    Participant(
      uid: uid,
      email: email,
      name: name,
      dpUrl: dpUrl,
      isAdmin: isAdmin,
      isMicOn: isMicOn,
      isModerator: isModerator,
      isSpeaker: isSpeaker,
      hasRequestedToBeSpeaker: hasRequestedToBeSpeaker,
    );

/// Stubs the `flutter_secure_storage` method channel so writes/reads succeed
/// in unit tests (the plugin normally calls into native code). Call from a
/// `setUp()` in any test where the code path touches secure storage.
void stubFlutterSecureStorageChannel() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (call) async => null,
  );
}

/// Convenience builder for fake Appwrite [Row]s in tests.
Row buildRow({
  required String id,
  required Map<String, dynamic> data,
  String tableId = 'test-table',
  String databaseId = 'test-db',
}) =>
    Row(
      $id: id,
      $sequence: 0,
      $tableId: tableId,
      $databaseId: databaseId,
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $permissions: const [],
      data: data,
    );

//
// ─── In-memory SDK stand-ins ────────────────────────────────────────────────
//

/// In-memory implementation of [GetStorage] used by `UpcomingRoomsNotifier`
/// to track which upcoming rooms the user has hidden.
class FakeGetStorage implements GetStorage {
  final Map<String, dynamic> _data = {};

  @override
  T? read<T>(String key) => _data[key] as T?;

  @override
  Future<void> write(String key, dynamic value) async {
    _data[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _data.remove(key);
  }

  @override
  Future<void> erase() async {
    _data.clear();
  }

  @override
  bool hasData(String key) => _data.containsKey(key);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
        '${invocation.memberName} not stubbed in FakeGetStorage',
      );
}

/// Stub LiveKit notifier that never touches the network.
class FakeLiveKitNotifier extends LiveKitNotifier {
  @override
  LiveKitState build() => const LiveKitState();

  @override
  Future<bool> connect({
    required String liveKitUri,
    required String roomToken,
    bool isLiveChapter = false,
  }) async {
    state = const LiveKitState(hasSession: true, isConnected: true);
    return true;
  }

  @override
  Future<void> disconnect() async {
    state = const LiveKitState();
  }

  @override
  Future<void> setMicrophoneEnabled(bool enabled) async {}

  @override
  Future<void> setRecording(bool recording) async {
    state = state.copyWith(isRecording: recording);
  }
}

/// Stub auth notifier — used by tests that just need an auth context but
/// don't want to wire up the full Appwrite SDK to make `loadCurrentUser()`
/// return what they want.
class _StubAuthNotifier extends AuthNotifier {
  _StubAuthNotifier(this._initial);
  final AuthState _initial;

  @override
  Future<AuthState> build() async => _initial;
}

/// Reusable fake [AuthRepository] with counters. Used by the auth view and
/// profile tests where the goal is to drive auth state without spinning up
/// the full Appwrite SDK. Newer tests prefer the real `AuthRepository` with
/// mocked SDK — both patterns are supported.
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
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
        '${invocation.memberName} not stubbed in FakeAuthRepository',
      );
}

//
// ─── installTestRootContainer ───────────────────────────────────────────────
//

/// Installs the global `rootContainer` for tests. Pass mocked Appwrite SDK
/// objects via the named params; they back the *real* repositories.
///
/// Three ways to provide auth context:
///  - [authRepository]: explicit fake repo (legacy auth/profile tests).
///  - [authState]: overrides `authProvider` directly via [_StubAuthNotifier].
///  - [account]: real `AuthRepository` runs against your mocked `Account`/
///    `TablesDB`, suitable for tests that want to verify `loadCurrentUser`
///    was called.
Future<ProviderContainer> installTestRootContainer({
  AuthState? authState,
  Account? account,
  TablesDB? tables,
  Client? client,
  Storage? storage,
  Functions? functions,
  Realtime? realtime,
  FirebaseMessaging? messaging,
  FakeAuthRepository? authRepository,
  GetStorage? getStorageBox,
}) async {
  final container = ProviderContainer(
    overrides: [
      if (authRepository != null)
        authRepositoryProvider.overrideWithValue(authRepository),
      if (authRepository == null && authState != null)
        authProvider.overrideWith(() => _StubAuthNotifier(authState)),
      if (getStorageBox != null)
        getStorageBoxProvider.overrideWithValue(getStorageBox),
      liveKitProvider.overrideWith(FakeLiveKitNotifier.new),
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
  // Warm authProvider when any of the auth-providing inputs is supplied.
  if (authRepository != null || authState != null || account != null) {
    await container.read(authProvider.future);
  }
  addTearDown(container.dispose);
  return container;
}
