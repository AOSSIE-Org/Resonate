import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/utils/constants.dart';

import 'auth_state_controller_test.mocks.dart';

@GenerateMocks([
  Account,
  Databases,
  Storage,
  Functions,
  Client,
  User,
  FirebaseMessaging,
  Session,
])
void main() {
  Get.testMode = true;
  TestWidgetsFlutterBinding.ensureInitialized();
  final MockAccount mockAccount = MockAccount();
  final MockDatabases mockDatabases = MockDatabases();
  final MockClient mockClient = MockClient();
  final MockFirebaseMessaging mockFirebaseMessaging = MockFirebaseMessaging();
  final AuthStateController authStateController = AuthStateController(
    account: mockAccount,
    databases: mockDatabases,
    client: mockClient,
    messaging: mockFirebaseMessaging,
  );

  final List<Document> mockSubscribedUserDocuments = [
    Document(
      $id: 'subUserDoc1',
      $collectionId: upcomingRoomsCollectionId,
      $databaseId: subscribedUserCollectionId,
      $permissions: ['any'],
      data: {
        'userID': '123',
        'userProfileUrl': 'https://example.com/user1.jpg',
        'upcomingRoomId': 'room1',
        'registrationTokens': ["token1", "token2", 'mockToken'],
      },
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $sequence: 0,
    ),
    Document(
      $id: 'subUserDoc2',
      $collectionId: upcomingRoomsCollectionId,
      $databaseId: subscribedUserCollectionId,
      $permissions: ['any'],
      data: {
        'userID': '123',
        'userProfileUrl': 'https://example.com/user2.jpg',
        'upcomingRoomId': 'room2',
        'registrationTokens': ["token1", "token2", 'mockToken'],
      },
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $sequence: 1,
    ),
  ];
  final List<Document> mockUpcomingRoomsDocuments = [
    Document(
      $id: 'room1',
      $collectionId: upcomingRoomsCollectionId,
      $databaseId: upcomingRoomsDatabaseId,
      $permissions: ['any'],
      data: {
        'isTime': false,
        'description': 'Description for room 1',
        'name': 'Upcoming Room 1',
        'creatorUid': '123',
        'scheduledDateTime': DateTime.now()
            .add(Duration(days: 1))
            .toIso8601String(),
        'tags': ['tag1', 'tag2'],
        'creator_fcm_tokens': ['token1', 'token2', 'mockToken'],
      },
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $sequence: 0,
    ),
    Document(
      $id: 'room2',
      $collectionId: upcomingRoomsCollectionId,
      $databaseId: upcomingRoomsDatabaseId,
      $permissions: ['any'],
      data: {
        'isTime': true,
        'description': 'Description for room 2',
        'name': 'Upcoming Room 2',
        'creatorUid': '123',
        'scheduledDateTime': DateTime.now().toIso8601String(),
        'tags': ['tag3', 'tag4'],
        'creator_fcm_tokens': ['token1', 'token2', 'mockToken'],
      },
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
      $sequence: 1,
    ),
  ];
  final User mockUser = User(
    $id: '123',
    name: 'Test User',
    email: 'test@test.com',
    emailVerification: true,
    prefs: Preferences(data: {'isUserProfileComplete': true}),
    $createdAt: DateTime.now().toIso8601String(),
    $updatedAt: DateTime.now().toIso8601String(),
    accessedAt: DateTime.now().toIso8601String(),
    registration: DateTime.now().toIso8601String(),
    phone: '1234567890',
    phoneVerification: false,
    mfa: false,
    passwordUpdate: DateTime.now().toIso8601String(),
    status: true,
    password: 'password',
    labels: [],
    hash: 'Argon2',
    targets: [],
    hashOptions: {},
  );
  final Document mockUserDocument = Document(
    $collectionId: usersCollectionID,
    $createdAt: DateTime.now().toIso8601String(),
    $databaseId: userDatabaseID,
    $id: '123',
    $updatedAt: DateTime.now().toIso8601String(),
    $permissions: ['any'],
    data: {
      'profileImageUrl': 'https://example.com/image.jpg',
      'username': 'TestUser',
      'profileImageID': 'image123',
      'ratingTotal': 5,
      'ratingCount': 1,
    },
    $sequence: 0,
  );

  setUp(() {
    when(mockAccount.get()).thenAnswer((_) => Future.value(mockUser));

    when(
      mockDatabases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: '123',
      ),
    ).thenAnswer((_) => Future.value(mockUserDocument));
    when(
      mockFirebaseMessaging.getToken(),
    ).thenAnswer((_) => Future.value('mockToken'));
    when(
      mockDatabases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        queries: [
          Query.equal("userID", ['123']),
        ],
      ),
    ).thenAnswer(
      (_) => Future.value(
        DocumentList(total: 2, documents: mockSubscribedUserDocuments),
      ),
    );
    when(
      mockDatabases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        queries: [Query.equal("creatorUid", "123")],
      ),
    ).thenAnswer(
      (_) => Future.value(
        DocumentList(total: 2, documents: mockUpcomingRoomsDocuments),
      ),
    );
    when(
      mockDatabases.updateDocument(
        databaseId: anyNamed('databaseId'),
        collectionId: anyNamed('collectionId'),
        documentId: anyNamed('documentId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((invocation) async {
      return Document(
        $id: invocation.namedArguments[#documentId] as String,
        $collectionId: invocation.namedArguments[#collectionId] as String,
        $databaseId: invocation.namedArguments[#databaseId] as String,
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
        $permissions: ['any'],
        data: Map<String, dynamic>.from(
          invocation.namedArguments[#data] as Map,
        ),
        $sequence: 0,
      );
    });

    when(
      mockAccount.create(
        userId: anyNamed('userId'),
        email: 'test@test.com',
        password: 'anyPassword',
      ),
    ).thenAnswer((_) => Future.value(mockUser));

    when(
      mockAccount.createEmailPasswordSession(
        email: 'test@test.com',
        password: 'anyPassword',
      ),
    ).thenAnswer((_) => Future.value(MockSession()));
  });

  test('test setUserProfileData', () async {
    await authStateController.setUserProfileData();

    expect(authStateController.displayName, 'Test User');
    expect(authStateController.email, 'test@test.com');
    expect(authStateController.isEmailVerified, true);
    expect(authStateController.uid, '123');
    expect(authStateController.isUserProfileComplete, true);
    expect(
      authStateController.profileImageUrl,
      'https://example.com/image.jpg',
    );
    expect(authStateController.profileImageID, 'image123');
    expect(authStateController.ratingCount, 1);
    expect(authStateController.ratingTotal, 5.0);
    expect(authStateController.userName, 'TestUser');
    expect(authStateController.reportsCount, 0);
  });

  test('test getLoginState', () async {
    final loginState = await authStateController.getLoginState;
    expect(loginState, true);
  });

  test(
    'test addRegistrationTokentoSubscribedandCreatedUpcomingRooms',
    () async {
      await authStateController.setUserProfileData();
      await authStateController
          .addRegistrationTokentoSubscribedandCreatedUpcomingRooms();
      verify(
        mockDatabases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: 'subUserDoc1',
          data: {
            'registrationTokens': [
              'token1',
              'token2',
              'mockToken',
              'mockToken',
            ],
          },
        ),
      ).called(1);
      verify(
        mockDatabases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: 'subUserDoc2',
          data: {
            'registrationTokens': [
              'token1',
              'token2',
              'mockToken',
              'mockToken',
            ],
          },
        ),
      ).called(1);
      verify(
        mockDatabases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          documentId: 'room1',
          data: {
            'creator_fcm_tokens': [
              'token1',
              'token2',
              'mockToken',
              'mockToken',
            ],
          },
        ),
      ).called(1);
      verify(
        mockDatabases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          documentId: 'room2',
          data: {
            'creator_fcm_tokens': [
              'token1',
              'token2',
              'mockToken',
              'mockToken',
            ],
          },
        ),
      ).called(1);
    },
  );
  test('test removeRegistrationTokenFromSubscribedUpcomingRooms', () async {
    await authStateController.setUserProfileData();
    await authStateController
        .removeRegistrationTokenFromSubscribedUpcomingRooms();
    verify(
      mockDatabases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: 'subUserDoc1',
        data: {
          'registrationTokens': ['token1', 'token2', 'mockToken'],
        },
      ),
    ).called(1);
    verify(
      mockDatabases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: 'subUserDoc2',
        data: {
          'registrationTokens': ['token1', 'token2', 'mockToken'],
        },
      ),
    ).called(1);
    verify(
      mockDatabases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        documentId: 'room1',
        data: {
          'creator_fcm_tokens': ['token1', 'token2', 'mockToken'],
        },
      ),
    ).called(1);
    verify(
      mockDatabases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        documentId: 'room2',
        data: {
          'creator_fcm_tokens': ['token1', 'token2', 'mockToken'],
        },
      ),
    ).called(1);
  });

  test('test signup', () async {
    authStateController.signup('test@test.com', 'anyPassword');
    expect(authStateController.email, 'test@test.com');
  });

  test('test Email Validator', () {
    expect('test'.isValidEmail(), false);
    expect('test@test.com'.isValidEmail(), true);
    expect('test@.com'.isValidEmail(), false);
    expect('test@com'.isValidEmail(), false);
    expect('test@com.'.isValidEmail(), false);
    expect('test@.com.'.isValidEmail(), false);
  });
  test('test Password Validator', () {
    expect('Password123'.isValidPassword(), true);
    expect('password123'.isValidPassword(), false);
    expect('PASSWORD123'.isValidPassword(), false);
    expect('Pass1'.isValidPassword(), false);
    expect('Password'.isValidPassword(), false);
  });

  test('test Same Password Validator', () {
    expect('Password'.isSamePassword('Password'), true);
    expect('Password'.isSamePassword('password'), false);
  });
}
