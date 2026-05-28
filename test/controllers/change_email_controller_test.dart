import 'package:appwrite/appwrite.dart' hide Locale;
import 'package:appwrite/models.dart' hide Locale;
import 'package:flutter/material.dart' hide Row;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/change_email_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/constants.dart';

import '../helpers/test_root_container.dart';
import '../helpers/test_root_container.mocks.dart';

void main() {
  late MockTablesDB mockTablesDB;
  late MockAccount mockAccount;
  late MockFunctions mockFunctions;
  late MockFirebaseMessaging mockMessaging;
  late ChangeEmailController controller;

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

  setUp(() async {
    mockTablesDB = MockTablesDB();
    mockAccount = MockAccount();
    mockFunctions = MockFunctions();
    mockMessaging = MockFirebaseMessaging();
    when(mockMessaging.getToken()).thenAnswer((_) async => null);
    when(mockAccount.get()).thenAnswer((_) async => mockUser);
    when(mockTablesDB.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: anyNamed('rowId'),
      queries: anyNamed('queries'),
    )).thenAnswer((_) async => buildRow(
          id: '123',
          tableId: usersTableID,
          databaseId: userDatabaseID,
          data: {
            'username': 'TestUser',
            'profileImageUrl': 'https://example.com/p.jpg',
            'profileImageID': 'p1',
            'ratingTotal': 5,
            'ratingCount': 1,
            'followers': const [],
            'userReports': const [],
          },
        ));

    await installTestRootContainer(
      account: mockAccount,
      tables: mockTablesDB,
      functions: mockFunctions,
      messaging: mockMessaging,
    );

    controller = ChangeEmailController(
      tables: mockTablesDB,
      account: mockAccount,
    );

    when(
      mockTablesDB.listRows(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        queries: [Query.equal('email', 'test2@test.com')],
      ),
    ).thenAnswer((_) async => RowList(total: 0, rows: []));

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
      mockAccount.updateEmail(
        email: 'test2@test.com',
        password: 'anyPassword',
      ),
    ).thenAnswer((_) async => mockUser);
  });

  test('isEmailAvailable returns true when no matching row exists', () async {
    final result = await controller.isEmailAvailable('test2@test.com');
    expect(result, true);
  });

  testWidgets(
    'changeEmailInDatabases updates both rows and refreshes auth',
    (tester) async {
      await tester.pumpWidget(GetMaterialApp(home: Container()));
      await tester.pumpAndSettle();
      clearInteractions(mockAccount);
      final result = await controller.changeEmailInDatabases(
        'test2@test.com',
        tester.element(find.byType(Container)),
      );

      verify(
        mockTablesDB.updateRow(
          databaseId: userDatabaseID,
          tableId: usersTableID,
          rowId: '123',
          data: {'email': 'test2@test.com'},
        ),
      ).called(1);
      verify(
        mockTablesDB.updateRow(
          databaseId: userDatabaseID,
          tableId: usernameTableID,
          rowId: 'TestUser',
          data: {'email': 'test2@test.com'},
        ),
      ).called(1);
      expect(result, true);
      // refresh() should call loadCurrentUser → account.get() exactly once.
      verify(mockAccount.get()).called(1);
    },
  );

  testWidgets('changeEmailInAuth calls account.updateEmail', (tester) async {
    await tester.pumpWidget(GetMaterialApp(home: Container()));
    await tester.pumpAndSettle();
    final result = await controller.changeEmailInAuth(
      'test2@test.com',
      'anyPassword',
      tester.element(find.byType(Container)),
    );
    expect(result, true);
    verify(
      mockAccount.updateEmail(email: 'test2@test.com', password: 'anyPassword'),
    ).called(1);
  });

  testWidgets('changeEmail runs the full happy path', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('hi')],
        home: Scaffold(
          body: Form(
            key: controller.changeEmailFormKey,
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await controller.changeEmail(context);
                },
                child: const Text('Test'),
              ),
            ),
          ),
        ),
      ),
    );
    controller.passwordController.text = 'anyPassword';
    controller.emailController.text = 'test2@test.com';
    await tester.tap(find.text('Test'));
    await tester.pumpAndSettle();
    verify(
      mockAccount.updateEmail(email: 'test2@test.com', password: 'anyPassword'),
    ).called(1);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    verify(
      mockTablesDB.updateRow(
        databaseId: userDatabaseID,
        tableId: usernameTableID,
        rowId: 'TestUser',
        data: {'email': 'test2@test.com'},
      ),
    ).called(1);
    expect(controller.isLoading.value, false);
  });
}
