import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/models/story.dart';

class FakeProfileRepository implements ProfileRepository {
  // Configurable returns.
  List<Story> createdStories = const [];
  List<Story> likedStories = const [];
  List<FollowerUserModel> followers = const [];
  String? fcmToken = 'fake-token';
  bool usernameAvailableReturn = true;
  bool emailAvailableReturn = true;
  Object? changeEmailInAuthError;
  Object? changeEmailInDatabasesError;
  Object? createUsernameRowError;

  // Recorded calls.
  String? isUsernameAvailableArg;
  String? isUsernameAvailableCurrent;
  FollowerUserModel? followedFollower;
  String? unfollowedDocId;
  int getFcmTokenCount = 0;
  int deleteProfileImageCount = 0;
  String? deletedImageId;
  int uploadProfileImageCount = 0;
  ({String uid, String email, String imagePath})? uploadArgs;
  ({String uid, String url, String id})? updateProfileImageRowArgs;
  String? clearedImageRowUid;
  ({String uid, String email, String oldUsername, String newUsername})?
      changeUsernameArgs;
  ({String uid, String name})? updateDisplayNameArgs;
  ({String username, String email})? createUsernameRowArgs;
  String? updateAccountNameArg;
  String? createUserRowUid;
  Map<String, dynamic>? createUserRowData;
  int markProfileCompleteCount = 0;
  ({String email, String password})? changeEmailInAuthArgs;
  ({String uid, String username, String email})? changeEmailInDatabasesArgs;

  @override
  Future<List<Story>> fetchCreatedStories(String creatorId) async =>
      createdStories;

  @override
  Future<List<Story>> fetchLikedStories(String creatorId) async => likedStories;

  @override
  Future<List<FollowerUserModel>> fetchFollowers(String userId) async =>
      followers;

  @override
  Future<String?> getFcmToken() async {
    getFcmTokenCount++;
    return fcmToken;
  }

  @override
  Future<void> followCreator(FollowerUserModel follower) async {
    followedFollower = follower;
  }

  @override
  Future<void> unfollowCreator(String followerDocumentId) async {
    unfollowedDocId = followerDocumentId;
  }

  @override
  Future<bool> isUsernameAvailable(
    String username, {
    String? currentUsername,
  }) async {
    isUsernameAvailableArg = username;
    isUsernameAvailableCurrent = currentUsername;
    return usernameAvailableReturn;
  }

  @override
  Future<bool> isEmailAvailable(String email) async => emailAvailableReturn;

  @override
  Future<void> changeEmailInAuth({
    required String email,
    required String password,
  }) async {
    changeEmailInAuthArgs = (email: email, password: password);
    if (changeEmailInAuthError != null) throw changeEmailInAuthError!;
  }

  @override
  Future<void> changeEmailInDatabases({
    required String uid,
    required String username,
    required String email,
  }) async {
    changeEmailInDatabasesArgs = (uid: uid, username: username, email: email);
    if (changeEmailInDatabasesError != null) throw changeEmailInDatabasesError!;
  }

  @override
  Future<({String url, String id})> uploadProfileImage({
    required String uid,
    required String email,
    required String imagePath,
  }) async {
    uploadProfileImageCount++;
    uploadArgs = (uid: uid, email: email, imagePath: imagePath);
    return (url: 'https://img/$uid', id: 'imgid-$uid');
  }

  @override
  Future<void> deleteProfileImage(String fileId) async {
    deleteProfileImageCount++;
    deletedImageId = fileId;
  }

  @override
  Future<void> updateProfileImageRow({
    required String uid,
    required String url,
    required String id,
  }) async {
    updateProfileImageRowArgs = (uid: uid, url: url, id: id);
  }

  @override
  Future<void> clearProfileImageRow(String uid) async {
    clearedImageRowUid = uid;
  }

  @override
  Future<void> changeUsername({
    required String uid,
    required String email,
    required String oldUsername,
    required String newUsername,
  }) async {
    changeUsernameArgs = (
      uid: uid,
      email: email,
      oldUsername: oldUsername,
      newUsername: newUsername,
    );
  }

  @override
  Future<void> updateDisplayName({
    required String uid,
    required String name,
  }) async {
    updateDisplayNameArgs = (uid: uid, name: name);
  }

  @override
  Future<void> createUsernameRow({
    required String username,
    required String email,
  }) async {
    createUsernameRowArgs = (username: username, email: email);
    if (createUsernameRowError != null) throw createUsernameRowError!;
  }

  @override
  Future<void> updateAccountName(String name) async {
    updateAccountNameArg = name;
  }

  @override
  Future<void> createUserRow({
    required String uid,
    required String name,
    required String username,
    required String profileImageUrl,
    required String dob,
    required String email,
    String? profileImageID,
  }) async {
    createUserRowUid = uid;
    createUserRowData = {
      'name': name,
      'username': username,
      'profileImageUrl': profileImageUrl,
      'dob': dob,
      'email': email,
      'profileImageID': profileImageID,
    };
  }

  @override
  Future<void> markProfileComplete() async {
    markProfileCompleteCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
        '${invocation.memberName} not stubbed in FakeProfileRepository',
      );
}
