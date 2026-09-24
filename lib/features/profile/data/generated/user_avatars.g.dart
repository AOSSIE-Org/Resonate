// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_avatars.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The avatar a user has *now*, read from their user row.
///
/// Friend rows and call rows carry a copy of the URL taken when they were
/// written, and nothing refreshes it — so a picture changed (or an endpoint
/// moved) after the friendship was made never reaches those screens. Rooms
/// already re-read the user row per participant; this is the same thing for
/// everywhere else.

@ProviderFor(userAvatarUrl)
final userAvatarUrlProvider = UserAvatarUrlFamily._();

/// The avatar a user has *now*, read from their user row.
///
/// Friend rows and call rows carry a copy of the URL taken when they were
/// written, and nothing refreshes it — so a picture changed (or an endpoint
/// moved) after the friendship was made never reaches those screens. Rooms
/// already re-read the user row per participant; this is the same thing for
/// everywhere else.

final class UserAvatarUrlProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The avatar a user has *now*, read from their user row.
  ///
  /// Friend rows and call rows carry a copy of the URL taken when they were
  /// written, and nothing refreshes it — so a picture changed (or an endpoint
  /// moved) after the friendship was made never reaches those screens. Rooms
  /// already re-read the user row per participant; this is the same thing for
  /// everywhere else.
  UserAvatarUrlProvider._({
    required UserAvatarUrlFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userAvatarUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userAvatarUrlHash();

  @override
  String toString() {
    return r'userAvatarUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as String;
    return userAvatarUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAvatarUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userAvatarUrlHash() => r'61b547f052a54a6a2792fa91e5d907b3aed2172f';

/// The avatar a user has *now*, read from their user row.
///
/// Friend rows and call rows carry a copy of the URL taken when they were
/// written, and nothing refreshes it — so a picture changed (or an endpoint
/// moved) after the friendship was made never reaches those screens. Rooms
/// already re-read the user row per participant; this is the same thing for
/// everywhere else.

final class UserAvatarUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, String> {
  UserAvatarUrlFamily._()
    : super(
        retry: null,
        name: r'userAvatarUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The avatar a user has *now*, read from their user row.
  ///
  /// Friend rows and call rows carry a copy of the URL taken when they were
  /// written, and nothing refreshes it — so a picture changed (or an endpoint
  /// moved) after the friendship was made never reaches those screens. Rooms
  /// already re-read the user row per participant; this is the same thing for
  /// everywhere else.

  UserAvatarUrlProvider call(String uid) =>
      UserAvatarUrlProvider._(argument: uid, from: this);

  @override
  String toString() => r'userAvatarUrlProvider';
}
