// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../upcoming_rooms_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpcomingRoomsNotifier)
final upcomingRoomsProvider = UpcomingRoomsNotifierProvider._();

final class UpcomingRoomsNotifierProvider
    extends
        $AsyncNotifierProvider<
          UpcomingRoomsNotifier,
          List<AppwriteUpcomingRoom>
        > {
  UpcomingRoomsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingRoomsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingRoomsNotifierHash();

  @$internal
  @override
  UpcomingRoomsNotifier create() => UpcomingRoomsNotifier();
}

String _$upcomingRoomsNotifierHash() =>
    r'856b5b330c3b3a3269f4eb7f237f6b09cbfe3a19';

abstract class _$UpcomingRoomsNotifier
    extends $AsyncNotifier<List<AppwriteUpcomingRoom>> {
  FutureOr<List<AppwriteUpcomingRoom>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AppwriteUpcomingRoom>>,
              List<AppwriteUpcomingRoom>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AppwriteUpcomingRoom>>,
                List<AppwriteUpcomingRoom>
              >,
              AsyncValue<List<AppwriteUpcomingRoom>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
