// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friend_requests_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendRequests)
final friendRequestsProvider = FriendRequestsProvider._();

final class FriendRequestsProvider
    extends $NotifierProvider<FriendRequests, FriendRowsState> {
  FriendRequestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendRequestsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendRequestsHash();

  @$internal
  @override
  FriendRequests create() => FriendRequests();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendRowsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendRowsState>(value),
    );
  }
}

String _$friendRequestsHash() => r'b86c2341856acb10cacf59d8c22d6ea076195b9d';

abstract class _$FriendRequests extends $Notifier<FriendRowsState> {
  FriendRowsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<FriendRowsState, FriendRowsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FriendRowsState, FriendRowsState>,
              FriendRowsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
