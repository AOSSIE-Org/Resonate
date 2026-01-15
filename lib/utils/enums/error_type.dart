/// Enum representing different categories of errors in the application.
///
/// Used by [ErrorService] to provide appropriate user-friendly messages
/// and handle errors consistently across the app.
enum ErrorType {
  /// Network-related errors (no internet, timeout, server unreachable)
  network,

  /// Authentication errors (invalid credentials, session expired)
  authentication,

  /// Storage/file errors (upload failed, file not found)
  storage,

  /// Database/Appwrite errors (document not found, permission denied)
  database,

  /// Validation errors (invalid input, form errors)
  validation,

  /// Unknown or general errors
  general,
}
