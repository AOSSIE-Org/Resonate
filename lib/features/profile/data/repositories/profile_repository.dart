import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:resonate/core/providers/appwrite_providers.dart';
import 'package:resonate/core/providers/firebase_providers.dart';
import 'package:resonate/features/profile/model/change_email_state.dart';
import 'package:resonate/features/stories/data/story_row_mapper.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) => ProfileRepository(
  tables: ref.watch(appwriteTablesProvider),
  storage: ref.watch(appwriteStorageProvider),
  account: ref.watch(appwriteAccountProvider),
  messaging: ref.watch(firebaseMessagingProvider),
);

class ProfileRepository {
  ProfileRepository({
    required TablesDB tables,
    required Storage storage,
    required Account account,
    required FirebaseMessaging messaging,
  }) : _tables = tables,
       _storage = storage,
       _account = account,
       _messaging = messaging;

  final TablesDB _tables;
  final Storage _storage;
  final Account _account;
  final FirebaseMessaging _messaging;

  // Profile viewing
  Future<List<Story>> fetchCreatedStories(String creatorId) async {
    List<Row> rows = [];
    try {
      rows = await _tables
          .listRows(
            databaseId: storyDatabaseId,
            tableId: storyTableId,
            queries: [Query.equal('creatorId', creatorId)],
          )
          .then((value) => value.rows);
    } on AppwriteException catch (e) {
      log('Failed to fetch user created stories: ${e.message}');
    }
    return rowsToStories(rows);
  }

  Future<List<Story>> fetchLikedStories(String creatorId) async {
    try {
      final likeRows = await _tables
          .listRows(
            databaseId: storyDatabaseId,
            tableId: likeTableId,
            queries: [Query.equal('uId', creatorId)],
          )
          .then((value) => value.rows);

      final storyRows = <Row>[];
      for (final like in likeRows) {
        try {
          storyRows.add(
            await _tables.getRow(
              databaseId: storyDatabaseId,
              tableId: storyTableId,
              rowId: like.data['storyId'],
            ),
          );
        } on AppwriteException catch (e) {
          log('Skipping liked story ${like.data['storyId']}: ${e.message}');
        }
      }
      return rowsToStories(storyRows);
    } on AppwriteException catch (e) {
      log('Failed to fetch liked stories: ${e.message}');
      return [];
    }
  }

  Future<List<FollowerUserModel>> fetchFollowers(String userId) async {
    try {
      final userRow = await _tables.getRow(
        databaseId: userDatabaseID,
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

  Future<String?> getFcmToken() => _messaging.getToken();

  Future<void> followCreator(FollowerUserModel follower) async {
    await _tables.createRow(
      databaseId: userDatabaseID,
      tableId: followersTableID,
      rowId: follower.docId,
      data: follower.toJson(),
    );
  }

  Future<void> unfollowCreator(String followerDocumentId) async {
    await _tables.deleteRow(
      databaseId: userDatabaseID,
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
        databaseId: userDatabaseID,
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
      databaseId: userDatabaseID,
      tableId: usernameTableID,
      rowId: username,
      data: {'email': email},
    );
  }

  Future<void> deleteUsernameRow(String username) async {
    await _tables.deleteRow(
      databaseId: userDatabaseID,
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
      databaseId: userDatabaseID,
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
      databaseId: userDatabaseID,
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
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      data: {'profileImageUrl': url, 'profileImageID': id},
    );
  }

  Future<void> clearProfileImageRow(String uid) async {
    await _tables.updateRow(
      databaseId: userDatabaseID,
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
  }) async {
    await _tables.createRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      data: {
        'name': name,
        'username': username,
        'profileImageUrl': profileImageUrl,
        'dob': dob,
        'email': email,
        'profileImageID': profileImageID,
      },
    );
  }

  Future<void> markProfileComplete() async {
    await _account.updatePrefs(prefs: {'isUserProfileComplete': true});
  }

  // Change email
  Future<bool> isEmailAvailable(String email) async {
    final docs = await _tables.listRows(
      databaseId: userDatabaseID,
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
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: uid,
      data: {'email': email},
    );
    await _tables.updateRow(
      databaseId: userDatabaseID,
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
        databaseId: userDatabaseID,
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
        databaseId: userDatabaseID,
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
