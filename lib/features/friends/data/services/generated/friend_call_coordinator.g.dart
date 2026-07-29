// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friend_call_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendCallCoordinator)
final friendCallCoordinatorProvider = FriendCallCoordinatorProvider._();

final class FriendCallCoordinatorProvider
    extends $NotifierProvider<FriendCallCoordinator, FriendCallState> {
  FriendCallCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendCallCoordinatorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendCallCoordinatorHash();

  @$internal
  @override
  FriendCallCoordinator create() => FriendCallCoordinator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendCallState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendCallState>(value),
    );
  }
}

String _$friendCallCoordinatorHash() =>
    r'440ecfd7c89fece81d88e06b53704bee2271dddd';

abstract class _$FriendCallCoordinator extends $Notifier<FriendCallState> {
  FriendCallState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FriendCallState, FriendCallState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FriendCallState, FriendCallState>,
              FriendCallState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
