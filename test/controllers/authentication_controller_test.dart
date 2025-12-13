import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';

import 'authentication_controller_test.mocks.dart';

@GenerateMocks([AuthStateController])
void main() {
  Get.testMode = true;
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthenticationController authController;
  late MockAuthStateController mockAuthStateController;

  setUp(() {
    mockAuthStateController = MockAuthStateController();
    Get.put<AuthStateController>(mockAuthStateController);
    authController = AuthenticationController();
    authController.authStateController = mockAuthStateController;
  });

  tearDown(() {
    Get.reset();
  });

  group('signup processing lock tests', () {
    test('signup returns false immediately when isLoading is already true',
        () async {
      // Arrange: Set isLoading to true to simulate an in-progress signup
      authController.isLoading.value = true;

      // Act: Try to call signup while already loading (context not needed for early return)
      final result = await authController.signup(_MockBuildContext());

      // Assert: Should return false without making any API call
      expect(result, false);
      verifyNever(mockAuthStateController.signup(any, any));
    });

    testWidgets('signup resets isLoading to false after successful completion',
        (WidgetTester tester) async {
      // Arrange
      authController.emailController.text = 'test@test.com';
      authController.passwordController.text = 'Password123';

      when(mockAuthStateController.signup(any, any)).thenAnswer((_) async {});

      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              testContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await authController.signup(testContext);

      // Assert
      expect(authController.isLoading.value, false);
    });

    testWidgets('signup resets isLoading to false after failure',
        (WidgetTester tester) async {
      // Arrange
      authController.emailController.text = 'test@test.com';
      authController.passwordController.text = 'Password123';

      when(mockAuthStateController.signup(any, any))
          .thenThrow(Exception('Signup failed'));

      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              testContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      await authController.signup(testContext);

      // Assert: isLoading should be reset even after failure
      expect(authController.isLoading.value, false);
    });

    testWidgets('signup returns true on successful signup',
        (WidgetTester tester) async {
      // Arrange
      authController.emailController.text = 'test@test.com';
      authController.passwordController.text = 'Password123';

      when(mockAuthStateController.signup(any, any)).thenAnswer((_) async {});

      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              testContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final result = await authController.signup(testContext);

      // Assert
      expect(result, true);
    });

    testWidgets('signup returns false on failed signup',
        (WidgetTester tester) async {
      // Arrange
      authController.emailController.text = 'test@test.com';
      authController.passwordController.text = 'Password123';

      when(mockAuthStateController.signup(any, any))
          .thenThrow(Exception('User already exists'));

      late BuildContext testContext;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              testContext = context;
              return const SizedBox();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Act
      final result = await authController.signup(testContext);

      // Assert
      expect(result, false);
    });
  });
}

/// Mock BuildContext for early return test (no localization needed)
class _MockBuildContext extends Mock implements BuildContext {}
