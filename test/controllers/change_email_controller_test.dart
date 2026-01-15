import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:appwrite/models.dart' hide Locale;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/change_email_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/constants.dart';

import 'change_email_controller_test.mocks.dart';

@GenerateMocks([Databases, Account, Client, FirebaseMessaging])
void main() {
  MockDatabases mockDatabases = MockDatabases();
  MockAccount mockAccount = MockAccount();
  MockClient mockClient = MockClient();
  MockFirebaseMessaging mockMessaging = MockFirebaseMessaging();
  AuthStateController authStateController = AuthStateController(
    account: mockAccount,
    databases: mockDatabases,
    client: mockClient,
    messaging: mockMessaging,
  );

  ChangeEmailController changeEmailController = ChangeEmailController(
    account: mockAccount,
    databases: mockDatabases,
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
      mockDatabases.listDocuments(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        queries: [Query.equal('email', 'test2@test.com')],
      ),
    ).thenAnswer((_) => Future.value(DocumentList(total: 0, documents: [])));
    when(mockAccount.get()).thenAnswer((_) => Future.value(mockUser));

    when(
      mockDatabases.getDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: '123',
      ),
    ).thenAnswer((_) => Future.value(mockUserDocument));
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
      mockDatabases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: usersCollectionID,
        documentId: '123',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);
    verify(
      mockDatabases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        documentId: 'TestUser',
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

  testWidgets('test changeEmail', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('hi')],
        home: Form(
          key: changeEmailController.changeEmailFormKey,
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                await changeEmailController.changeEmail(context);
              },
              child: Text("Test"),
            ),
          ),
        ),
      ),
    );

    changeEmailController.passwordController.text = 'anyPassword';
    changeEmailController.emailController.text = 'test2@test.com';
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    verify(
      mockAccount.updateEmail(email: 'test2@test.com', password: "anyPassword"),
    ).called(1);

    await tester.pumpAndSettle(const Duration(seconds: 4));

    verify(
      mockDatabases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: usernameCollectionID,
        documentId: 'TestUser',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);
    expect(authStateController.email, 'test2@test.com');
    expect(changeEmailController.isLoading.value, false);
  });
}
