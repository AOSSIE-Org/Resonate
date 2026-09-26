// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_avatars.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userAvatarUrl)
final userAvatarUrlProvider = UserAvatarUrlFamily._();

final class UserAvatarUrlProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
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

  UserAvatarUrlProvider call(String uid) =>
      UserAvatarUrlProvider._(argument: uid, from: this);

  @override
  String toString() => r'userAvatarUrlProvider';
}
