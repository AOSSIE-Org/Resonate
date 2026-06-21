import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/features/profile/data/repositories/profile_repository.dart';
import 'package:resonate/features/profile/model/change_email_state.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';

import 'profile_repository_test.mocks.dart';

Row _storyRow(String id, String title, String category, String creatorId) =>
    Row(
      $id: id,
      $tableId: storyTableId,
      $databaseId: storyDatabaseId,
      $createdAt: DateTime(2024).toIso8601String(),
      $updatedAt: DateTime(2024).toIso8601String(),
      $permissions: const ['any'],
      $sequence: 0,
      data: {
        'title': title,
        'description': 'Description of $title',
        'category': category,
        'coverImgUrl': 'http://cover/$id',
        'creatorId': creatorId,
        'creatorName': 'Creator',
        'creatorImgUrl': 'http://img/$id',
        'likes': 10,
        'tintColor': '0000FF',
        'playDuration': 120,
      },
    );

final _userRowWithFollowers = Row(
  $id: 'id1',
  $tableId: usersTableID,
  $databaseId: userDatabaseID,
  $createdAt: DateTime(2024).toIso8601String(),
  $updatedAt: DateTime(2024).toIso8601String(),
  $permissions: const ['any'],
  $sequence: 0,
  data: {
    'username': 'testuser1',
    'followers': [
      {
        'followerUserId': 'id2',
        'followerUsername': 'testu2',
        'followerName': 'Test User 2',
        'followerFCMToken': 'testToken2',
        'followerProfileImageUrl': 'http://img/2',
        'followerRating': 5,
        '\$id': 'doc2',
      },
      {
        'followerUserId': 'id3',
        'followerUsername': 'testu3',
        'followerName': 'Test User 3',
        'followerFCMToken': 'testToken3',
        'followerProfileImageUrl': 'http://img/3',
        'followerRating': 5,
        '\$id': 'doc3',
      },
    ],
  },
);

Row _genericRow() => Row(
      $id: 'x',
      $tableId: 't',
      $databaseId: 'd',
      $createdAt: DateTime(2024).toIso8601String(),
      $updatedAt: DateTime(2024).toIso8601String(),
      $permissions: const ['any'],
      $sequence: 0,
      data: const {},
    );

User _user() => User(
      $id: 'u1',
      name: 'Test User',
      email: 'test@test.com',
      emailVerification: true,
      prefs: Preferences(data: const {}),
      $createdAt: DateTime(2024).toIso8601String(),
      $updatedAt: DateTime(2024).toIso8601String(),
      accessedAt: DateTime(2024).toIso8601String(),
      registration: DateTime(2024).toIso8601String(),
      phone: '',
      phoneVerification: false,
      mfa: false,
      passwordUpdate: DateTime(2024).toIso8601String(),
      status: true,
      labels: const [],
      hash: 'Argon2',
      targets: const [],
      hashOptions: const {},
    );

@GenerateMocks([TablesDB, Storage, Account, FirebaseMessaging])
void main() {
  late MockTablesDB tables;
  late MockStorage storage;
  late MockAccount account;
  late MockFirebaseMessaging messaging;
  late ProfileRepository repo;

  setUp(() {
    tables = MockTablesDB();
    storage = MockStorage();
    account = MockAccount();
    messaging = MockFirebaseMessaging();
    repo = ProfileRepository(
      tables: tables,
      storage: storage,
      account: account,
      messaging: messaging,
    );
  });

  group('rowsToStories', () {
    test('maps row fields onto the Story model', () {
      final stories = repo.rowsToStories([
        _storyRow('doc1', 'Story 1', 'comedy', 'id1'),
        _storyRow('doc2', 'Story 2', 'thriller', 'id2'),
      ]);
      expect(stories.length, 2);
      expect(stories[0].title, 'Story 1');
      expect(stories[0].storyId, 'doc1');
      expect(stories[0].category, StoryCategory.comedy);
      expect(stories[1].category, StoryCategory.thriller);
      expect(stories[0].likesCount, 10);
      expect(stories[0].tintColor, const Color(0xff0000FF));
      expect(stories[0].userIsCreator, false);
    });
  });

  group('fetchCreatedStories', () {
    test('queries by creatorId and maps the rows', () async {
      when(
        tables.listRows(
          databaseId: storyDatabaseId,
          tableId: storyTableId,
          queries: [Query.equal('creatorId', 'id1')],
        ),
      ).thenAnswer(
        (_) async =>
            RowList(total: 1, rows: [_storyRow('doc1', 'Story 1', 'comedy', 'id1')]),
      );

      final stories = await repo.fetchCreatedStories('id1');
      expect(stories.length, 1);
      expect(stories[0].storyId, 'doc1');
    });

    test('returns empty on AppwriteException', () async {
      when(
        tables.listRows(
          databaseId: storyDatabaseId,
          tableId: storyTableId,
          queries: [Query.equal('creatorId', 'id1')],
        ),
      ).thenThrow(AppwriteException('nope'));

      expect(await repo.fetchCreatedStories('id1'), isEmpty);
    });
  });

  group('fetchLikedStories', () {
    test('resolves the liked story rows', () async {
      final likeRow = Row(
        $id: 'like1',
        $tableId: likeTableId,
        $databaseId: storyDatabaseId,
        $createdAt: DateTime(2024).toIso8601String(),
        $updatedAt: DateTime(2024).toIso8601String(),
        $permissions: const ['any'],
        $sequence: 0,
        data: const {'storyId': 'doc1'},
      );
      when(
        tables.listRows(
          databaseId: storyDatabaseId,
          tableId: likeTableId,
          queries: [Query.equal('uId', 'id1')],
        ),
      ).thenAnswer((_) async => RowList(total: 1, rows: [likeRow]));
      when(
        tables.getRow(
          databaseId: storyDatabaseId,
          tableId: storyTableId,
          rowId: 'doc1',
        ),
      ).thenAnswer((_) async => _storyRow('doc1', 'Story 1', 'comedy', 'id1'));

      final stories = await repo.fetchLikedStories('id1');
      expect(stories.length, 1);
      expect(stories[0].storyId, 'doc1');
    });

    test('skips liked stories whose lookup fails', () async {
      Row likeRow(String storyId) => Row(
            $id: 'like-$storyId',
            $tableId: likeTableId,
            $databaseId: storyDatabaseId,
            $createdAt: DateTime(2024).toIso8601String(),
            $updatedAt: DateTime(2024).toIso8601String(),
            $permissions: const ['any'],
            $sequence: 0,
            data: {'storyId': storyId},
          );
      when(
        tables.listRows(
          databaseId: storyDatabaseId,
          tableId: likeTableId,
          queries: [Query.equal('uId', 'id1')],
        ),
      ).thenAnswer(
        (_) async => RowList(total: 2, rows: [likeRow('doc1'), likeRow('gone')]),
      );
      when(
        tables.getRow(
          databaseId: storyDatabaseId,
          tableId: storyTableId,
          rowId: 'doc1',
        ),
      ).thenAnswer((_) async => _storyRow('doc1', 'Story 1', 'comedy', 'id1'));
      when(
        tables.getRow(
          databaseId: storyDatabaseId,
          tableId: storyTableId,
          rowId: 'gone',
        ),
      ).thenThrow(AppwriteException('not found', 404));

      final stories = await repo.fetchLikedStories('id1');
      expect(stories.length, 1);
      expect(stories[0].storyId, 'doc1');
    });
  });

  group('fetchFollowers', () {
    test('parses the followers relation', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'id1',
          queries: [Query.select(['*', 'followers.*'])],
        ),
      ).thenAnswer((_) async => _userRowWithFollowers);

      final followers = await repo.fetchFollowers('id1');
      expect(followers.length, 2);
      expect(followers[0].name, 'Test User 2');
      expect(followers[0].docId, 'doc2');
      expect(followers[1].uid, 'id3');
    });

    test('returns [] when the lookup throws', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'id1',
          queries: [Query.select(['*', 'followers.*'])],
        ),
      ).thenThrow(AppwriteException('boom'));

      expect(await repo.fetchFollowers('id1'), isEmpty);
    });
  });

  group('follow / unfollow', () {
    final follower = FollowerUserModel(
      docId: 'fdoc1',
      uid: 'id2',
      username: 'testu2',
      profileImageUrl: 'http://img/2',
      name: 'Test User 2',
      fcmToken: 'testToken2',
      followingUserId: 'id1',
      followerRating: 5,
    );

    test('followCreator creates the follower row', () async {
      when(
        tables.createRow(
          databaseId: userDatabaseID,
          tableId: followersTableID,
          rowId: 'fdoc1',
          data: follower.toJson(),
        ),
      ).thenAnswer((_) async => _genericRow());

      await repo.followCreator(follower);
      verify(
        tables.createRow(
          databaseId: userDatabaseID,
          tableId: followersTableID,
          rowId: 'fdoc1',
          data: follower.toJson(),
        ),
      ).called(1);
    });

    test('unfollowCreator deletes the follower row', () async {
      when(
        tables.deleteRow(
          databaseId: userDatabaseID,
          tableId: followersTableID,
          rowId: 'fdoc1',
        ),
      ).thenAnswer((_) async => '');

      await repo.unfollowCreator('fdoc1');
      verify(
        tables.deleteRow(
          databaseId: userDatabaseID,
          tableId: followersTableID,
          rowId: 'fdoc1',
        ),
      ).called(1);
    });
  });

  group('isUsernameAvailable', () {
    test('returns true without a lookup when it matches currentUsername',
        () async {
      expect(
        await repo.isUsernameAvailable('me', currentUsername: 'me'),
        true,
      );
      verifyNever(
        tables.getRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      );
    });

    test('returns false when the username row exists', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          rowId: 'taken',
        ),
      ).thenAnswer((_) async => _genericRow());
      expect(await repo.isUsernameAvailable('taken'), false);
    });

    test('returns true when the lookup throws (row not found)', () async {
      when(
        tables.getRow(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          rowId: 'free',
        ),
      ).thenThrow(AppwriteException('not found', 404));
      expect(await repo.isUsernameAvailable('free'), true);
    });
  });

  group('isEmailAvailable', () {
    test('true when no rows, false when some exist', () async {
      when(
        tables.listRows(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          queries: [Query.equal('email', 'free@test.com')],
        ),
      ).thenAnswer((_) async => RowList(total: 0, rows: const []));
      when(
        tables.listRows(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          queries: [Query.equal('email', 'taken@test.com')],
        ),
      ).thenAnswer((_) async => RowList(total: 1, rows: [_genericRow()]));

      expect(await repo.isEmailAvailable('free@test.com'), true);
      expect(await repo.isEmailAvailable('taken@test.com'), false);
    });
  });

  group('changeEmailInAuth', () {
    test('maps invalid credentials to ChangeEmailFailure', () async {
      when(account.updateEmail(email: 'e', password: 'p')).thenThrow(
        AppwriteException('bad', 401, userInvalidCredentials),
      );
      expect(
        () => repo.changeEmailInAuth(email: 'e', password: 'p'),
        throwsA(ChangeEmailFailure.invalidCredentials),
      );
    });

    test('maps argument-invalid to passwordTooShort', () async {
      when(account.updateEmail(email: 'e', password: 'p')).thenThrow(
        AppwriteException('bad', 400, generalArgumentInvalid),
      );
      expect(
        () => repo.changeEmailInAuth(email: 'e', password: 'p'),
        throwsA(ChangeEmailFailure.passwordTooShort),
      );
    });

    test('completes on success', () async {
      when(account.updateEmail(email: 'e', password: 'p'))
          .thenAnswer((_) async => _user());
      await repo.changeEmailInAuth(email: 'e', password: 'p');
      verify(account.updateEmail(email: 'e', password: 'p')).called(1);
    });
  });

  group('changeEmailInDatabases', () {
    test('updates the user row and the username row', () async {
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => _genericRow());

      await repo.changeEmailInDatabases(
        uid: 'u1',
        username: 'TestUser',
        email: 'new@test.com',
      );

      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'u1',
          data: {'email': 'new@test.com'},
        ),
      ).called(1);
      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          rowId: 'TestUser',
          data: {'email': 'new@test.com'},
        ),
      ).called(1);
    });
  });

  group('changeUsername', () {
    test('creates the new row, deletes the old, updates the user', () async {
      when(
        tables.createRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => _genericRow());
      when(
        tables.deleteRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
        ),
      ).thenAnswer((_) async => '');
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => _genericRow());

      await repo.changeUsername(
        uid: 'u1',
        email: 'test@test.com',
        oldUsername: 'old',
        newUsername: 'new',
      );

      verify(
        tables.createRow(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          rowId: 'new',
          data: {'email': 'test@test.com'},
        ),
      ).called(1);
      verify(
        tables.deleteRow(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          rowId: 'old',
        ),
      ).called(1);
      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'u1',
          data: {'username': 'new'},
        ),
      ).called(1);
    });
  });

  group('updateDisplayName', () {
    test('updates the account name and the user row', () async {
      when(account.updateName(name: 'New Name'))
          .thenAnswer((_) async => _user());
      when(
        tables.updateRow(
          databaseId: anyNamed('databaseId'),
          tableId: anyNamed('tableId'),
          rowId: anyNamed('rowId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async => _genericRow());

      await repo.updateDisplayName(uid: 'u1', name: 'New Name');

      verify(account.updateName(name: 'New Name')).called(1);
      verify(
        tables.updateRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: 'u1',
          data: {'name': 'New Name'},
        ),
      ).called(1);
    });
  });

  group('uploadProfileImage', () {
    test('uploads the file and builds the view url', () async {
      when(
        storage.createFile(
          bucketId: anyNamed('bucketId'),
          fileId: anyNamed('fileId'),
          file: anyNamed('file'),
        ),
      ).thenAnswer(
        (_) async => File(
          $id: 'newfileid',
          bucketId: userProfileImageBucketId,
          $createdAt: DateTime(2024).toIso8601String(),
          $updatedAt: DateTime(2024).toIso8601String(),
          $permissions: const ['any'],
          name: 'x.jpeg',
          signature: 'sig',
          mimeType: 'image/jpeg',
          sizeOriginal: 100,
          chunksTotal: 1,
          chunksUploaded: 1,
        ),
      );

      final result = await repo.uploadProfileImage(
        uid: 'u1',
        email: 'test@test.com',
        imagePath: 'local.jpg',
      );

      expect(result.id, startsWith('u1'));
      expect(result.url, contains('newfileid'));
      expect(result.url, contains(userProfileImageBucketId));
    });
  });
}
