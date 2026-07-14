import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/auth/data/repositories/auth_repository.dart';
import 'package:resonate/features/auth/data/services/callkit_service.dart';
import 'package:resonate/features/auth/model/auth_state.dart';
import 'package:resonate/features/auth/model/auth_user.dart';
import 'package:resonate/features/friends/model/friends_model.dart';
import 'package:resonate/utils/enums/friend_request_status.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/appwrite_upcoming_room.dart';
import 'package:resonate/features/rooms/model/livekit_state.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/data/services/livekit_controller.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/model/live_chapter_attendees_model.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/models/resonate_user.dart';
import 'package:resonate/utils/enums/room_state.dart';
import 'package:resonate/utils/enums/story_category.dart';

@GenerateMocks([
  Account,
  TablesDB,
  Storage,
  Realtime,
  Functions,
  RealtimeSubscription,
  FirebaseMessaging,
  Execution,
])
// Data builders
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
}) => AuthUser(
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
}) => AppwriteRoom(
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
}) => AppwriteUpcomingRoom(
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
}) => Participant(
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

FriendsModel fakeFriendsModel({
  String senderId = 'sender-1',
  String recieverId = 'reciever-1',
  String senderName = 'Sender',
  String recieverName = 'Reciever',
  String senderUsername = 'sender',
  String recieverUsername = 'reciever',
  String senderProfileImgUrl = 'https://example.com/s.jpg',
  String recieverProfileImgUrl = 'https://example.com/r.jpg',
  String? senderFCMToken = 'sender-token',
  String? recieverFCMToken = 'reciever-token',
  FriendRequestStatus requestStatus = FriendRequestStatus.sent,
  String? requestSentByUserId,
  double? senderRating = 4.0,
  double? recieverRating = 3.5,
  String docId = 'friend-doc-1',
}) => FriendsModel(
  senderId: senderId,
  recieverId: recieverId,
  senderName: senderName,
  recieverName: recieverName,
  senderUsername: senderUsername,
  recieverUsername: recieverUsername,
  senderProfileImgUrl: senderProfileImgUrl,
  recieverProfileImgUrl: recieverProfileImgUrl,
  senderFCMToken: senderFCMToken,
  recieverFCMToken: recieverFCMToken,
  requestStatus: requestStatus,
  requestSentByUserId: requestSentByUserId ?? senderId,
  senderRating: senderRating,
  recieverRating: recieverRating,
  docId: docId,
);

Story fakeStory({
  String storyId = 'story-1',
  String title = 'Test Story',
  String description = 'A story for testing',
  bool userIsCreator = false,
  StoryCategory category = StoryCategory.drama,
  String coverImageUrl = 'https://example.com/cover.jpg',
  String creatorId = 'creator-1',
  String creatorName = 'Creator',
  String creatorImgUrl = 'https://example.com/avatar.jpg',
  DateTime? creationDate,
  int likesCount = 0,
  bool isLikedByCurrentUser = false,
  int playDuration = 1000,
}) => Story(
  storyId: storyId,
  title: title,
  description: description,
  userIsCreator: userIsCreator,
  category: category,
  coverImageUrl: coverImageUrl,
  creatorId: creatorId,
  creatorName: creatorName,
  creatorImgUrl: creatorImgUrl,
  creationDate: creationDate ?? DateTime(2024, 1, 1),
  likesCount: likesCount,
  isLikedByCurrentUser: isLikedByCurrentUser,
  playDuration: playDuration,
  tintColor: const Color(0xffcbc6c6),
);

Chapter fakeChapter({
  String chapterId = 'chapter-1',
  String title = 'Chapter One',
  String coverImageUrl = 'https://example.com/chapter.jpg',
  String description = 'A chapter for testing',
  String lyrics = '',
  String audioFileUrl = 'https://example.com/audio.mp3',
  int playDuration = 500,
}) => Chapter(
  chapterId: chapterId,
  title: title,
  coverImageUrl: coverImageUrl,
  description: description,
  lyrics: lyrics,
  audioFileUrl: audioFileUrl,
  playDuration: playDuration,
  tintColor: const Color(0xffcbc6c6),
);

LiveChapterAttendeesModel fakeLiveChapterAttendees({
  String liveChapterId = 'room-1',
  List<LiveChapterAttendee> users = const [],
  List<String>? userIds = const [],
}) => LiveChapterAttendeesModel(
  liveChapterId: liveChapterId,
  users: users,
  userIds: userIds,
);

LiveChapterModel fakeLiveChapterModel({
  String id = 'room-1',
  String? livekitRoomId,
  String authorUid = 'author-1',
  String authorProfileImageUrl = 'https://example.com/a.jpg',
  String authorName = 'Author',
  String chapterTitle = 'Live Chapter',
  String chapterDescription = 'Live description',
  String storyId = 'story-1',
  List<String> followersFCMToken = const [],
  LiveChapterAttendeesModel? attendees,
}) => LiveChapterModel(
  livekitRoomId: livekitRoomId ?? id,
  authorUid: authorUid,
  authorProfileImageUrl: authorProfileImageUrl,
  authorName: authorName,
  chapterTitle: chapterTitle,
  chapterDescription: chapterDescription,
  storyId: storyId,
  followersFCMToken: followersFCMToken,
  attendees: attendees,
  id: id,
);

ResonateUser fakeResonateUser({
  String uid = 'user-1',
  String userName = 'testuser',
  String name = 'Test User',
  String profileImageUrl = 'https://example.com/u.jpg',
  String? email,
  double userRating = 4.5,
}) => ResonateUser(
  uid: uid,
  userName: userName,
  name: name,
  profileImageUrl: profileImageUrl,
  email: email,
  userRating: userRating,
);

void stubFlutterSecureStorageChannel() {
  TestWidgetsFlutterBinding.ensureInitialized();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (call) async => null,
      );
}

Row buildRow({
  required String id,
  required Map<String, dynamic> data,
  String tableId = 'test-table',
  String databaseId = 'test-db',
}) => Row(
  $id: id,
  $sequence: 0,
  $tableId: tableId,
  $databaseId: databaseId,
  $createdAt: DateTime.now().toIso8601String(),
  $updatedAt: DateTime.now().toIso8601String(),
  $permissions: const [],
  data: data,
);

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

class FakeLiveKitController extends LiveKitController {
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
  Future<void> setSpeakerphoneOn(bool enabled) async {}

  @override
  Future<void> setRecording(bool recording) async {
    state = state.copyWith(isRecording: recording);
  }
}

class FakeCallKitService extends CallKitService {
  int showIncomingCallCount = 0;
  int endAllCallsCount = 0;

  @override
  void start({
    required Future<void> Function(Map<String, dynamic> extra) onAccept,
    required Future<void> Function(Map<String, dynamic> extra) onDecline,
  }) {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> showIncomingCall(RemoteMessage message) async {
    showIncomingCallCount++;
  }

  @override
  Future<void> endAllCalls() async {
    endAllCallsCount++;
  }
}

// Stateful, like the real AuthRepository: the seeded [state] is what every
// load/mutation resolves the session to, and [sessionStateChanges] mirrors it
// so authSessionProvider / currentUserProvider / the router all observe it.
// Deterministic by construction — refresh() re-yields the seeded state with no
// network, so tests that trigger refresh() (e.g. pair-chat submitRating) can't
// go flaky the way the old half-stubbed auth path could.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.state);

  AuthState state;
  int loadCount = 0;
  int loginCount = 0;
  int signupCount = 0;
  int logoutCount = 0;
  int addTokenCount = 0;
  int removeTokenCount = 0;

  final StreamController<AsyncValue<AuthState>> _sessionStateController =
      StreamController<AsyncValue<AuthState>>.broadcast(sync: true);
  AsyncValue<AuthState> _sessionState = const AsyncValue.loading();
  Future<AuthState>? _initialLoad;

  @override
  AsyncValue<AuthState> get sessionState => _sessionState;

  @override
  Stream<AsyncValue<AuthState>> get sessionStateChanges =>
      _sessionStateController.stream;

  void _setSessionState(AsyncValue<AuthState> next) {
    _sessionState = next;
    _sessionStateController.add(next);
  }

  @override
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

  @override
  Future<void> refresh() async {
    _setSessionState(const AsyncValue.loading());
    _setSessionState(AsyncData(await loadCurrentUser()));
  }

  @override
  Future<AuthState> loadCurrentUser() async {
    loadCount++;
    return state;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    loginCount++;
    _setSessionState(AsyncData(state));
  }

  @override
  Future<void> signup({required String email, required String password}) async {
    signupCount++;
    _setSessionState(AsyncData(state));
  }

  @override
  Future<void> logout() async {
    logoutCount++;
    _setSessionState(const AsyncData(AuthState.unauthenticated()));
  }

  @override
  Future<void> loginWithGoogle() async {
    _setSessionState(AsyncData(state));
  }

  @override
  Future<void> loginWithGithub() async {
    _setSessionState(AsyncData(state));
  }

  @override
  Future<void> addRegistrationToken({required String uid}) async {
    addTokenCount++;
  }

  @override
  Future<void> removeRegistrationToken({required String uid}) async {
    removeTokenCount++;
  }

  @override
  void dispose() {
    _sessionStateController.close();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} not stubbed in FakeAuthRepository',
  );
}

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
  CallKitService? callKit,
}) async {
  final container = ProviderContainer(
    overrides: [
      if (authRepository != null)
        authRepositoryProvider.overrideWithValue(authRepository),
      // Session state is stubbed at its source of truth — the repository — so
      // authSessionProvider, currentUserProvider, the router, and refresh()
      // all observe the same deterministic fake with no network involved.
      if (authRepository == null && authState != null)
        authRepositoryProvider.overrideWithValue(FakeAuthRepository(authState)),
      if (getStorageBox != null)
        getStorageBoxProvider.overrideWithValue(getStorageBox),
      liveKitControllerProvider.overrideWith(FakeLiveKitController.new),
      callKitServiceProvider.overrideWithValue(callKit ?? FakeCallKitService()),
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
  if (authRepository != null || authState != null || account != null) {
    // Warm the session so synchronous ref.read(...) sees loaded state.
    await container.read(authSessionProvider.future);
  }
  addTearDown(container.dispose);
  return container;
}
