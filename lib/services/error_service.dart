import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/error_type.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

/// A centralized service for handling errors consistently across the app.
///
/// Provides:
/// - Consistent user feedback via snackbars
/// - Accessibility announcements for screen readers
/// - Categorized error logging
/// - User-friendly message mapping for common errors
///
/// Example usage:
/// ```dart
/// try {
///   await someOperation();
/// } catch (e) {
///   ErrorService.handle(e, context: 'Creating room');
/// }
/// ```
class ErrorService {
  /// Handles an error with consistent logging, user feedback, and accessibility.
  ///
  /// [error] - The caught exception or error object
  /// [context] - Optional description of what operation failed (for logging)
  /// [userMessage] - Optional custom message to show to the user
  /// [showSnackbar] - Whether to display a snackbar (default: true)
  /// [announce] - Whether to announce for accessibility (default: true)
  /// [errorType] - Optional error category for specific handling
  static void handle(
    dynamic error, {
    String? context,
    String? userMessage,
    bool showSnackbar = true,
    bool announce = true,
    ErrorType? errorType,
  }) {
    // Determine error type if not provided
    final type = errorType ?? _categorizeError(error);

    // Log the error with context
    final logMessage =
        context != null ? 'Error in $context: $error' : 'Error: $error';
    log(logMessage, name: 'ErrorService');

    // Get user-friendly message
    final message = userMessage ?? getUserFriendlyMessage(error, type);

    // Show snackbar if requested
    if (showSnackbar && Get.context != null) {
      final title = _getTitleForErrorType(type);
      customSnackbar(title, message, LogType.error);
    }

    // Announce for accessibility if requested
    if (announce && Get.context != null) {
      SemanticsService.announce(message, TextDirection.ltr);
    }

    // Future: Add crash reporting here (e.g., Firebase Crashlytics)
    // FirebaseCrashlytics.instance.recordError(error, stackTrace);
  }

  /// Handles an error silently (logging only, no user feedback).
  ///
  /// Use this for non-critical errors that shouldn't interrupt the user.
  static void handleSilently(dynamic error, {String? context}) {
    handle(
      error,
      context: context,
      showSnackbar: false,
      announce: false,
    );
  }

  /// Returns a user-friendly message for the given error.
  ///
  /// Maps common error types to localized, understandable messages.
  static String getUserFriendlyMessage(dynamic error, [ErrorType? type]) {
    final context = Get.context;
    final errorType = type ?? _categorizeError(error);
    final localizations = context != null ? AppLocalizations.of(context) : null;

    // Handle Appwrite-specific errors
    if (error is AppwriteException) {
      return _getAppwriteErrorMessage(error, context);
    }

    // Handle by error type
    switch (errorType) {
      case ErrorType.network:
        return localizations?.networkError ??
            'Please check your internet connection and try again.';

      case ErrorType.authentication:
        return localizations?.authenticationError ??
            'Authentication failed. Please try again.';

      case ErrorType.storage:
        return localizations?.storageError ??
            'Failed to save or load data. Please try again.';

      case ErrorType.database:
        return localizations?.databaseError ??
            'Failed to access data. Please try again.';

      case ErrorType.validation:
        return localizations?.validationError ??
            'Please check your input and try again.';

      case ErrorType.general:
      default:
        return localizations?.generalError ??
            'Something went wrong. Please try again.';
    }
  }

  /// Categorizes an error into an [ErrorType] based on its type and message.
  static ErrorType _categorizeError(dynamic error) {
    if (error is AppwriteException) {
      return _categorizeAppwriteError(error);
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') ||
        errorString.contains('socket') ||
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return ErrorType.network;
    }

    if (errorString.contains('auth') ||
        errorString.contains('credential') ||
        errorString.contains('password') ||
        errorString.contains('login')) {
      return ErrorType.authentication;
    }

    if (errorString.contains('storage') ||
        errorString.contains('file') ||
        errorString.contains('upload')) {
      return ErrorType.storage;
    }

    return ErrorType.general;
  }

  /// Categorizes Appwrite-specific errors.
  static ErrorType _categorizeAppwriteError(AppwriteException error) {
    final type = error.type ?? '';
    final code = error.code ?? 0;

    // Authentication errors
    if (type.contains('user_') ||
        type.contains('session_') ||
        code == 401 ||
        code == 403) {
      return ErrorType.authentication;
    }

    // Database/document errors
    if (type.contains('document_') || type.contains('database_')) {
      return ErrorType.database;
    }

    // Storage errors
    if (type.contains('storage_') || type.contains('file_')) {
      return ErrorType.storage;
    }

    // Validation errors
    if (type.contains('general_argument_invalid') || code == 400) {
      return ErrorType.validation;
    }

    // Network errors
    if (code == 0 || code == 503 || code == 504) {
      return ErrorType.network;
    }

    return ErrorType.general;
  }

  /// Returns user-friendly messages for common Appwrite errors.
  static String _getAppwriteErrorMessage(
    AppwriteException error,
    BuildContext? context,
  ) {
    final type = error.type ?? '';
    final localizations = context != null ? AppLocalizations.of(context) : null;

    // Authentication errors
    if (type == 'user_invalid_credentials') {
      return localizations?.incorrectEmailOrPassword ??
          'Incorrect email or password.';
    }

    if (type == 'user_already_exists') {
      return localizations?.userAlreadyExists ??
          'An account with this email already exists.';
    }

    if (type == 'user_not_found') {
      return localizations?.userNotFound ?? 'User not found.';
    }

    if (type == 'general_argument_invalid') {
      return localizations?.invalidInput ??
          'Invalid input. Please check and try again.';
    }

    if (type == 'document_not_found') {
      return localizations?.dataNotFound ??
          'The requested data was not found.';
    }

    // Default: return the Appwrite message or a generic message
    return error.message ??
        localizations?.generalError ??
        'Something went wrong. Please try again.';
  }

  /// Returns an appropriate title for error snackbars based on error type.
  static String _getTitleForErrorType(ErrorType type) {
    final context = Get.context;
    final localizations = context != null ? AppLocalizations.of(context) : null;

    switch (type) {
      case ErrorType.network:
        return localizations?.connectionError ?? 'Connection Error';

      case ErrorType.authentication:
        return localizations?.authError ?? 'Authentication Error';

      case ErrorType.validation:
        return localizations?.invalidInput ?? 'Invalid Input';

      case ErrorType.storage:
      case ErrorType.database:
      case ErrorType.general:
      default:
        return localizations?.error ?? 'Error';
    }
  }
}
