// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../user_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userStats)
final userStatsProvider = UserStatsFamily._();

final class UserStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserStats>,
          UserStats,
          FutureOr<UserStats>
        >
    with $FutureModifier<UserStats>, $FutureProvider<UserStats> {
  UserStatsProvider._({
    required UserStatsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'userStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userStatsHash();

  @override
  String toString() {
    return r'userStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<UserStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserStats> create(Ref ref) {
    final argument = this.argument as String;
    return userStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UserStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userStatsHash() => r'93991a57a58407ed796d20661a06d5ce3949c10e';

final class UserStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<UserStats>, String> {
  UserStatsFamily._()
    : super(
        retry: null,
        name: r'userStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserStatsProvider call(String uid) =>
      UserStatsProvider._(argument: uid, from: this);

  @override
  String toString() => r'userStatsProvider';
}
