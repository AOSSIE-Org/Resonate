// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../badge_catalogue.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(badgeCatalogue)
final badgeCatalogueProvider = BadgeCatalogueProvider._();

final class BadgeCatalogueProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AchievementBadge>>,
          List<AchievementBadge>,
          FutureOr<List<AchievementBadge>>
        >
    with
        $FutureModifier<List<AchievementBadge>>,
        $FutureProvider<List<AchievementBadge>> {
  BadgeCatalogueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'badgeCatalogueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$badgeCatalogueHash();

  @$internal
  @override
  $FutureProviderElement<List<AchievementBadge>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AchievementBadge>> create(Ref ref) {
    return badgeCatalogue(ref);
  }
}

String _$badgeCatalogueHash() => r'a822a081d70d1e57c9c89852e9a8570befeb9a80';

@ProviderFor(badgeLadders)
final badgeLaddersProvider = BadgeLaddersProvider._();

final class BadgeLaddersProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<BadgeCategory, List<AchievementBadge>>>,
          Map<BadgeCategory, List<AchievementBadge>>,
          FutureOr<Map<BadgeCategory, List<AchievementBadge>>>
        >
    with
        $FutureModifier<Map<BadgeCategory, List<AchievementBadge>>>,
        $FutureProvider<Map<BadgeCategory, List<AchievementBadge>>> {
  BadgeLaddersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'badgeLaddersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$badgeLaddersHash();

  @$internal
  @override
  $FutureProviderElement<Map<BadgeCategory, List<AchievementBadge>>>
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<BadgeCategory, List<AchievementBadge>>> create(Ref ref) {
    return badgeLadders(ref);
  }
}

String _$badgeLaddersHash() => r'04639ce506e1e0ddbdf43173e3d2063448db9f7c';
