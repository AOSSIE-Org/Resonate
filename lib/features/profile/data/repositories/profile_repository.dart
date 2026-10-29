import 'dart:async';
import 'dart:convert';

import 'package:resonate/utils/dev_log.dart';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/profile/model/change_email_state.dart';
import 'package:resonate/features/profile/model/user_profile_summary.dart';
import 'package:resonate/features/shell/model/notification.dart';
import 'package:resonate/shared/model/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/notification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
  tables: ref.watch(appwriteTablesProvider),
  storage: ref.watch(appwriteStorageProvider),
  account: ref.watch(appwriteAccountProvider),
  functions: ref.watch(appwriteFunctionsProvider),
  realtime: ref.watch(appwriteRealtimeProvider),
);

class ProfileRepository {
  ProfileRepository({
    required TablesDB tables,
    required Storage storage,
    required Account account,
    required Functions functions,
    required Realtime realtime,
  }) : _tables = tables,
       _storage = storage,
       _account = account,
       _functions = functions,
       _realtime = realtime;

  final TablesDB _tables;
  final Storage _storage;
  final Account _account;
  final Functions _functions;
  final Realtime _realtime;

  Stream<void> followersChanged(String uid) {
    final channel = 'databases.$databaseId.tables.$followersTableID.rows';
    final subscription = _realtime.subscribe([channel]);
    final controller = StreamController<void>();
    final sub = subscription.stream.listen((event) {
      if (event.payload.isEmpty) return;
      if (event.payload['followedUid'] == uid) controller.add(null);
    });
    controller.onCancel = () async {
      await sub.cancel();
      await subscription.close();
    };
    return controller.stream;
  }

  // Profile viewing
  Future<List<FollowerUserModel>> fetchFollowers(String userId) async {
    try {
      final userRow = await _tables.getRow(
        databaseId: databaseId,
        tableId: usersTableID,
        rowId: userId,
        queries: [
          Query.select(['*', 'followers.*']),
        ],
      );

      return (userRow.data['followers'] as List<dynamic>? ?? const [])
          .map((doc) => FollowerUserModel.fromJson(doc as Map<String, dynamic>))
          .toList();
    } on AppwriteException catch (e) {
      log('Failed to fetch followers: ${e.message}');
      return [];
    }
  }

  Future<UserProfileSummary> fetchProfileSummary(String uid) async {
    final (row, followers) = await (
      _tables.getRow(
        databaseId: databaseId,
        tableId: usersTableID,
        rowId: uid,
        queries: [
          Query.select([
            'name',
            'username',
            'profileImageUrl',
            'ratingCount',
            'ratingTotal',
          ]),
        ],
      ),
      _followerCount(uid),
    ).wait;

    final data = row.data;
    final ratingCount = (data['ratingCount'] as num?)?.toInt() ?? 0;
    final ratingTotal = (data['ratingTotal'] as num?)?.toDouble() ?? 0;

    return UserProfileSummary(
      uid: uid,
      name: data['name'] as String? ?? '',
      username: data['username'] as String? ?? '',
      avatarUrl: data['profileImageUrl'] as String? ?? '',
      rating: ratingCount == 0 ? 0 : ratingTotal / ratingCount,
      followerCount: followers,
    );
  }

  Future<int> _followerCount(String uid) async {
    try {
      final result = await _tables.listRows(
        databaseId: databaseId,
        tableId: followersTableID,
        queries: [
          Query.equal('followedUid', uid),
          Query.select([r'$id']),
          Query.limit(1),
        ],
      );
      return result.total;
    } on AppwriteException catch (e) {
      log('Failed to count followers: ${e.message}');
      return 0;
    }
  }

 
  // For callers to build the follower rather than reaching for the Appwrite SDK
  String newFollowerDocumentId() => ID.unique();

  Future<void> followCreator(FollowerUserModel follower) async {
    await _tables.createRow(
      databaseId: databaseId,
      tableId: followersTableID,
      rowId: follower.docId,
      data: {
        ...follower.toJson(),
        'followedUid': ?follower.followingUserId,
      },
    );

    final followed = follower.followingUserId;
    if (followed == null || followed == follower.uid) return;
    try {
      await _functions.createExecution(
        functionId: sendSocialNotificationFunctionID,
        body: json.encode({
          'targetUid': followed,
          'payload': {
            'title': 'New follower',
            'body': '${follower.username} started following you',
          },
          'data': NotificationModel(
            notificationType: NotificationType.follow,
            initiatorUsername: follower.username,
            initiatorProfileImgUrl: follower.profileImageUrl,
            subject: follower.name,
            isTagInUpcomingRoom: false,
          ).toJson(),
        }),
      );
    } catch (e) {
      log('Failed to send follow notification: $e');
    }
  }

  Future<void> unfollowCreator(String followerDocumentId) async {
    await _tables.deleteRow(
      databaseId: databaseId,
      tableId: followersTableID,
      rowId: followerDocumentId,
    );
  }

  Future<bool> isUsernameAvailable(
    String username, {
    String? currentUsername,
  }) async {
    if (currentUsername != null && username.trim() == currentUsername.trim()) {
      return true;
    }
    try {
      await _tables.getRow(
        databaseId: databaseId,
        tableId: usernameTableID,
        rowId: username,
      );
      return false;
    } catch (e) {
      log(e.toString());
      return true;
    }
  }

  Future<void> createUsernameRow({
    required String username,
    required String email,
  }) async {
    await _tables.createRow(
      databaseId: databaseId,
      tableId: usernameTableID,
      rowId: username,
      data: {'email': email},
    );
  }

  Future<void> deleteUsernameRow(String username) async {
    await _tables.deleteRow(
      databaseId: databaseId,
      tableId: usernameTableID,
      rowId: username,
    );
  }

  Future<void> changeUsername({
    required String uid,
    required String email,
    required String oldUsername,
    required String newUsername,
  }) async {
    await createUsernameRow(username: newUsername, email: email);
    await deleteUsernameRow(oldUsername);
    await _tables.updateRow(
      databaseId: databaseId,
      tableId: usersTableID,
      rowId: uid,
      data: {'username': newUsername},
    );
  }

  Future<void> updateAccountName(String name) async {
    await _account.updateName(name: name);
  }

  Future<void> updateDisplayName({
    required String uid,
    required String name,
  }) async {
    await updateAccountName(name);
    await _tables.updateRow(
      databaseId: databaseId,
      tableId: usersTableID,
      rowId: uid,
      data: {'name': name},
    );
  }

  // Profile picture
  Future<({String url, String id})> uploadProfileImage({
    required String uid,
    required String email,
    required String imagePath,
  }) async {
    final id = uid + DateTime.now().millisecondsSinceEpoch.toString();
    final file = await _storage.createFile(
      bucketId: userProfileImageBucketId,
      fileId: id,
      file: InputFile.fromPath(path: imagePath, filename: '$email.jpeg'),
    );
    final url =
        '$appwriteEndpoint/storage/buckets/$userProfileImageBucketId/files/${file.$id}/view?project=$appwriteProjectId';
    return (url: url, id: id);
  }

  Future<void> deleteProfileImage(String fileId) async {
    try {
      await _storage.deleteFile(
        bucketId: userProfileImageBucketId,
        fileId: fileId,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateProfileImageRow({
    required String uid,
    required String url,
    required String id,
  }) async {
    await _tables.updateRow(
      databaseId: databaseId,
      tableId: usersTableID,
      rowId: uid,
      data: {'profileImageUrl': url, 'profileImageID': id},
    );
  }

  Future<void> clearProfileImageRow(String uid) async {
    await _tables.updateRow(
      databaseId: databaseId,
      tableId: usersTableID,
      rowId: uid,
      data: {'profileImageUrl': '', 'profileImageID': null},
    );
  }

  // Onboarding
  Future<void> createUserRow({
    required String uid,
    required String name,
    required String username,
    required String profileImageUrl,
    required String dob,
    required String email,
    String? profileImageID,
    List<Interest> interests = const [],
  }) async {
    await _tables.createRow(
      databaseId: databaseId,
      tableId: usersTableID,
      rowId: uid,
      data: {
        'name': name,
        'username': username,
        'profileImageUrl': profileImageUrl,
        'dob': dob,
        'email': email,
        'profileImageID': profileImageID,
        'interests': Interest.toWireList(interests),
      },
    );
  }

  Future<void> markProfileComplete() async {
    final existing = await _account.getPrefs();
    await _account.updatePrefs(
      prefs: {...existing.data, 'isUserProfileComplete': true},
    );
  }

  // Change email
  Future<bool> isEmailAvailable(String email) async {
    final docs = await _tables.listRows(
      databaseId: databaseId,
      tableId: usernameTableID,
      queries: [Query.equal('email', email)],
    );
    return docs.total == 0;
  }

  Future<void> changeEmailInAuth({
    required String email,
    required String password,
  }) async {
    try {
      await _account.updateEmail(email: email, password: password);
    } on AppwriteException catch (e) {
      throw _mapException(e);
    } catch (_) {
      throw ChangeEmailFailure.unknown;
    }
  }

  Future<void> changeEmailInDatabases({
    required String uid,
    required String username,
    required String email,
  }) async {
    await _tables.updateRow(
      databaseId: databaseId,
      tableId: usersTableID,
      rowId: uid,
      data: {'email': email},
    );
    await _tables.updateRow(
      databaseId: databaseId,
      tableId: usernameTableID,
      rowId: username,
      data: {'email': email},
    );
  }

  // Delete account
  Future<void> deleteProfilePicture(String profileImageID) async {
    try {
      await _storage.deleteFile(
        bucketId: userProfileImageBucketId,
        fileId: profileImageID,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUsersCollectionDocument(String uid) async {
    try {
      await _tables.deleteRow(
        databaseId: databaseId,
        tableId: usersTableID,
        rowId: uid,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUsernamesCollectionDocument(String username) async {
    try {
      await _tables.deleteRow(
        databaseId: databaseId,
        tableId: usernameTableID,
        rowId: username,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  ChangeEmailFailure _mapException(AppwriteException e) {
    return switch (e.type) {
      userInvalidCredentials => ChangeEmailFailure.invalidCredentials,
      generalArgumentInvalid => ChangeEmailFailure.passwordTooShort,
      _ => ChangeEmailFailure.unknown,
    };
  }
}
