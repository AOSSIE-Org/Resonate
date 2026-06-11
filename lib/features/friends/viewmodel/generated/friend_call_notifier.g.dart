// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friend_call_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendCallNotifier)
final friendCallProvider = FriendCallNotifierProvider._();

final class FriendCallNotifierProvider
    extends $NotifierProvider<FriendCallNotifier, FriendCallState> {
  FriendCallNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendCallProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendCallNotifierHash();

  @$internal
  @override
  FriendCallNotifier create() => FriendCallNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendCallState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendCallState>(value),
    );
  }
}

String _$friendCallNotifierHash() =>
    r'f22fa343c849b2961e04c4e9957c4b594c08be78';

abstract class _$FriendCallNotifier extends $Notifier<FriendCallState> {
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
