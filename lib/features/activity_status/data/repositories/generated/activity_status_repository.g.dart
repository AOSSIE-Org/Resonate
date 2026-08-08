// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../activity_status_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityStatusRepository)
final activityStatusRepositoryProvider = ActivityStatusRepositoryProvider._();

final class ActivityStatusRepositoryProvider
    extends
        $FunctionalProvider<
          ActivityStatusRepository,
          ActivityStatusRepository,
          ActivityStatusRepository
        >
    with $Provider<ActivityStatusRepository> {
  ActivityStatusRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityStatusRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityStatusRepositoryHash();

  @$internal
  @override
  $ProviderElement<ActivityStatusRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityStatusRepository create(Ref ref) {
    return activityStatusRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityStatusRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityStatusRepository>(value),
    );
  }
}

String _$activityStatusRepositoryHash() =>
    r'11f82dd04aaeca21e52db6bab91a019c98059ae4';
