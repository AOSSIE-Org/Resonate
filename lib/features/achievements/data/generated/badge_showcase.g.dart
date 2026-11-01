// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../badge_showcase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(statsOf)
final statsOfProvider = StatsOfFamily._();

final class StatsOfProvider
    extends $FunctionalProvider<UserStats?, UserStats?, UserStats?>
    with $Provider<UserStats?> {
  StatsOfProvider._({
    required StatsOfFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'statsOfProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$statsOfHash();

  @override
  String toString() {
    return r'statsOfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<UserStats?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserStats? create(Ref ref) {
    final argument = this.argument as String;
    return statsOf(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserStats? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserStats?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StatsOfProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$statsOfHash() => r'bbcd4a10f6436158c40f7554a0c59e01b73b6496';

final class StatsOfFamily extends $Family
    with $FunctionalFamilyOverride<UserStats?, String> {
  StatsOfFamily._()
    : super(
        retry: null,
        name: r'statsOfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  StatsOfProvider call(String uid) =>
      StatsOfProvider._(argument: uid, from: this);

  @override
  String toString() => r'statsOfProvider';
}

@ProviderFor(avatarBadge)
final avatarBadgeProvider = AvatarBadgeFamily._();

final class AvatarBadgeProvider
    extends $FunctionalProvider<KnownBadge?, KnownBadge?, KnownBadge?>
    with $Provider<KnownBadge?> {
  AvatarBadgeProvider._({
    required AvatarBadgeFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'avatarBadgeProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$avatarBadgeHash();

  @override
  String toString() {
    return r'avatarBadgeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<KnownBadge?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  KnownBadge? create(Ref ref) {
    final argument = this.argument as String;
    return avatarBadge(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnownBadge? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnownBadge?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AvatarBadgeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$avatarBadgeHash() => r'45289fb26babbf8f98e15f074067c10a99467fab';

final class AvatarBadgeFamily extends $Family
    with $FunctionalFamilyOverride<KnownBadge?, String> {
  AvatarBadgeFamily._()
    : super(
        retry: null,
        name: r'avatarBadgeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  AvatarBadgeProvider call(String uid) =>
      AvatarBadgeProvider._(argument: uid, from: this);

  @override
  String toString() => r'avatarBadgeProvider';
}

@ProviderFor(displayedBadges)
final displayedBadgesProvider = DisplayedBadgesFamily._();

final class DisplayedBadgesProvider
    extends
        $FunctionalProvider<
          List<KnownBadge>,
          List<KnownBadge>,
          List<KnownBadge>
        >
    with $Provider<List<KnownBadge>> {
  DisplayedBadgesProvider._({
    required DisplayedBadgesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'displayedBadgesProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$displayedBadgesHash();

  @override
  String toString() {
    return r'displayedBadgesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<KnownBadge>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<KnownBadge> create(Ref ref) {
    final argument = this.argument as String;
    return displayedBadges(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<KnownBadge> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<KnownBadge>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DisplayedBadgesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$displayedBadgesHash() => r'5eb4a4cb961d667998f0052b4cde225052ed557b';

final class DisplayedBadgesFamily extends $Family
    with $FunctionalFamilyOverride<List<KnownBadge>, String> {
  DisplayedBadgesFamily._()
    : super(
        retry: null,
        name: r'displayedBadgesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  DisplayedBadgesProvider call(String uid) =>
      DisplayedBadgesProvider._(argument: uid, from: this);

  @override
  String toString() => r'displayedBadgesProvider';
}
