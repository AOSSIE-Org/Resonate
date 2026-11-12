// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_profile_summaries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userProfileSummary)
final userProfileSummaryProvider = UserProfileSummaryFamily._();

final class UserProfileSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserProfileSummary>,
          UserProfileSummary,
          FutureOr<UserProfileSummary>
        >
    with
        $FutureModifier<UserProfileSummary>,
        $FutureProvider<UserProfileSummary> {
  UserProfileSummaryProvider._({
    required UserProfileSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userProfileSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userProfileSummaryHash();

  @override
  String toString() {
    return r'userProfileSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserProfileSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UserProfileSummary> create(Ref ref) {
    final argument = this.argument as String;
    return userProfileSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userProfileSummaryHash() =>
    r'171139c28646d1fc9ed3677f332c5ec8e68adca9';

final class UserProfileSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserProfileSummary>, String> {
  UserProfileSummaryFamily._()
    : super(
        retry: null,
        name: r'userProfileSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserProfileSummaryProvider call(String uid) =>
      UserProfileSummaryProvider._(argument: uid, from: this);

  @override
  String toString() => r'userProfileSummaryProvider';
}
