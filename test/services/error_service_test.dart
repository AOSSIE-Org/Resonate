import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:resonate/services/error_service.dart';
import 'package:resonate/utils/enums/error_type.dart';

void main() {
  setUpAll(() {
    // Initialize Flutter test binding
    TestWidgetsFlutterBinding.ensureInitialized();
    // Enable GetX test mode to avoid context-related issues
    Get.testMode = true;
  });

  group('ErrorService', () {
    group('getUserFriendlyMessage', () {
      test('returns network error message for network-related errors', () {
        final error = Exception('SocketException: Connection refused');
        final errorType = ErrorType.network;

        final message = ErrorService.getUserFriendlyMessage(error, errorType);

        expect(
          message,
          'Please check your internet connection and try again.',
        );
      });

      test('returns authentication error message for auth errors', () {
        final error = Exception('Invalid credentials');
        final errorType = ErrorType.authentication;

        final message = ErrorService.getUserFriendlyMessage(error, errorType);

        expect(message, 'Authentication failed. Please try again.');
      });

      test('returns storage error message for storage errors', () {
        final error = Exception('File upload failed');
        final errorType = ErrorType.storage;

        final message = ErrorService.getUserFriendlyMessage(error, errorType);

        expect(message, 'Failed to save or load data. Please try again.');
      });

      test('returns database error message for database errors', () {
        final error = Exception('Document not found');
        final errorType = ErrorType.database;

        final message = ErrorService.getUserFriendlyMessage(error, errorType);

        expect(message, 'Failed to access data. Please try again.');
      });

      test('returns validation error message for validation errors', () {
        final error = Exception('Invalid input');
        final errorType = ErrorType.validation;

        final message = ErrorService.getUserFriendlyMessage(error, errorType);

        expect(message, 'Please check your input and try again.');
      });

      test('returns general error message for unknown errors', () {
        final error = Exception('Unknown error');
        final errorType = ErrorType.general;

        final message = ErrorService.getUserFriendlyMessage(error, errorType);

        expect(message, 'Something went wrong. Please try again.');
      });
    });

    group('Appwrite error handling', () {
      test(
        'returns correct message for user_invalid_credentials error',
        () {
          final error = AppwriteException(
            'Invalid credentials',
            401,
            'user_invalid_credentials',
          );

          final message = ErrorService.getUserFriendlyMessage(error);

          expect(message, 'Incorrect email or password.');
        },
      );

      test('returns correct message for user_already_exists error', () {
        final error = AppwriteException(
          'User already exists',
          409,
          'user_already_exists',
        );

        final message = ErrorService.getUserFriendlyMessage(error);

        expect(message, 'An account with this email already exists.');
      });

      test('returns correct message for user_not_found error', () {
        final error = AppwriteException('User not found', 404, 'user_not_found');

        final message = ErrorService.getUserFriendlyMessage(error);

        expect(message, 'User not found.');
      });

      test('returns correct message for document_not_found error', () {
        final error = AppwriteException(
          'Document not found',
          404,
          'document_not_found',
        );

        final message = ErrorService.getUserFriendlyMessage(error);

        expect(message, 'The requested data was not found.');
      });

      test('returns correct message for general_argument_invalid error', () {
        final error = AppwriteException(
          'Invalid argument',
          400,
          'general_argument_invalid',
        );

        final message = ErrorService.getUserFriendlyMessage(error);

        expect(message, 'Invalid input. Please check and try again.');
      });

      test('returns Appwrite message for unknown Appwrite errors', () {
        final error = AppwriteException('Custom error message', 500, 'unknown');

        final message = ErrorService.getUserFriendlyMessage(error);

        expect(message, 'Custom error message');
      });
    });

    group('handle', () {
      testWidgets('logs error with context', (WidgetTester tester) async {
        // Build a minimal app to provide context
        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(body: Container()),
          ),
        );

        // This should not throw and should log the error
        ErrorService.handle(
          Exception('Test error'),
          context: 'test operation',
          showSnackbar: false,
          announce: false,
        );
      });

      testWidgets('handleSilently does not show snackbar', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(body: Container()),
          ),
        );

        // This should not throw and should not show a snackbar
        ErrorService.handleSilently(
          Exception('Silent error'),
          context: 'silent operation',
        );
      });
    });
  });
}
