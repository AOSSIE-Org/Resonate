// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../upcoming_rooms_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(upcomingRoomsRepository)
final upcomingRoomsRepositoryProvider = UpcomingRoomsRepositoryProvider._();

final class UpcomingRoomsRepositoryProvider
    extends
        $FunctionalProvider<
          UpcomingRoomsRepository,
          UpcomingRoomsRepository,
          UpcomingRoomsRepository
        >
    with $Provider<UpcomingRoomsRepository> {
  UpcomingRoomsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingRoomsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingRoomsRepositoryHash();

  @$internal
  @override
  $ProviderElement<UpcomingRoomsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpcomingRoomsRepository create(Ref ref) {
    return upcomingRoomsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpcomingRoomsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpcomingRoomsRepository>(value),
    );
  }
}

String _$upcomingRoomsRepositoryHash() =>
    r'43612b78945f87a341d0153960c104cfffba6e89';
