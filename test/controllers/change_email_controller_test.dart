import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:appwrite/models.dart'  hide Locale;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide Row;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/change_email_controller.dart';
import 'package:resonate/utils/constants.dart';

import 'change_email_controller_test.mocks.dart';

@GenerateMocks([TablesDB, Account, Client, FirebaseMessaging])
void main() {
  MockTablesDB mockTablesDB = MockTablesDB();
  MockAccount mockAccount = MockAccount();
  MockClient mockClient = MockClient();
  MockFirebaseMessaging mockMessaging = MockFirebaseMessaging();
  AuthStateController authStateController = AuthStateController(
    account: mockAccount,
    tables: mockTablesDB,
    client: mockClient,
    messaging: mockMessaging,
  );

  ChangeEmailController changeEmailController = ChangeEmailController(
    account: mockAccount,
    tables: mockTablesDB,
    authStateController: authStateController,
  );
  final User mockUser = User(
    $id: '123',
    name: 'Test User',
    email: 'test2@test.com',
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
    when(
      mockTablesDB.listRows(
        databaseId: userDatabaseID,
        tableId: usernameCollectionID,
        queries: [Query.equal('email', 'test2@test.com')],
      ),
    ).thenAnswer((_) => Future.value(RowList(total: 0, rows: [])));
    when(mockAccount.get()).thenAnswer((_) => Future.value(mockUser));

    when(
      mockTablesDB.getRow(
        databaseId: userDatabaseID,
        tableId: usersCollectionID,
        rowId: '123',
      ),
    ).thenAnswer(
      (_) => Future.value(
        Row(
          $id: mockUserDocument.$id,
          $tableId: mockUserDocument.$collectionId,
          $databaseId: mockUserDocument.$databaseId,
          $createdAt: mockUserDocument.$createdAt,
          $updatedAt: mockUserDocument.$updatedAt,
          $permissions: mockUserDocument.$permissions,
          $sequence: mockUserDocument.$sequence,
          data: Map<String, dynamic>.from(mockUserDocument.data),
        ),
      ),
    );
    when(
      mockTablesDB.updateRow(
        databaseId: anyNamed('databaseId'),
        tableId: anyNamed('tableId'),
        rowId: anyNamed('rowId'),
        data: anyNamed('data'),
      ),
    ).thenAnswer((invocation) async {
      return Row(
        $id: invocation.namedArguments[#rowId] as String,
        $tableId: invocation.namedArguments[#tableId] as String,
        $databaseId: invocation.namedArguments[#databaseId] as String,
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
        $permissions: ['any'],
        $sequence: 0,
        data: Map<String, dynamic>.from(
          invocation.namedArguments[#data] as Map,
        ),
      );
    });
    when(
      mockAccount.updateEmail(email: 'test2@test.com', password: "anyPassword"),
    ).thenAnswer((_) => Future.value(mockUser));
  });
  test('test isEmailAvailable', () async {
    final result = await changeEmailController.isEmailAvailable(
      'test2@test.com',
    );
    expect(result, true);
  });

  testWidgets('test changeEmailInDatabases', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    await tester.pumpAndSettle();
    await authStateController.setUserProfileData();
    final result = await changeEmailController.changeEmailInDatabases(
      'test2@test.com',
      tester.element(find.byType(Container)),
    );
    verify(
      mockTablesDB.updateRow(
        databaseId: userDatabaseID,
        tableId: usersCollectionID,
        rowId: '123',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);
    verify(
      mockTablesDB.updateRow(
        databaseId: userDatabaseID,
        tableId: usernameCollectionID,
        rowId: 'TestUser',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);
    expect(authStateController.email, 'test2@test.com');
    expect(result, true);
  });

  testWidgets('test changeEmailInAuth', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    await tester.pumpAndSettle();
    final result = await changeEmailController.changeEmailInAuth(
      'test2@test.com',
      'anyPassword',
      tester.element(find.byType(Container)),
    );
    expect(result, true);
    verify(
      mockAccount.updateEmail(email: 'test2@test.com', password: "anyPassword"),
    ).called(1);
  });

  testWidgets('test changeEmail functionality', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    final context = tester.element(find.byType(Container));
    changeEmailController.passwordController.text = 'anyPassword';
    changeEmailController.emailController.text = 'test2@test.com';
    await authStateController.setUserProfileData();
    final authResult = await changeEmailController.changeEmailInAuth(
      'test2@test.com',
      'anyPassword',
      context,
    );
    verify(
      mockAccount.updateEmail(email: 'test2@test.com', password: "anyPassword"),
    ).called(1);
    expect(authResult, true);
    final dbResult = await changeEmailController.changeEmailInDatabases(
      'test2@test.com',
      context,
    );
    verify(
      mockTablesDB.updateRow(
        databaseId: userDatabaseID,
        tableId: usersCollectionID,
        rowId: '123',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);
    verify(
      mockTablesDB.updateRow(
        databaseId: userDatabaseID,
        tableId: usernameCollectionID,
        rowId: 'TestUser',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);

    expect(dbResult, true);
    expect(authStateController.email, 'test2@test.com');
  });
}
