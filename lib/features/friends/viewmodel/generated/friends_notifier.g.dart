// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friends_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendsNotifier)
final friendsProvider = FriendsNotifierProvider._();

final class FriendsNotifierProvider
    extends $AsyncNotifierProvider<FriendsNotifier, FriendsState> {
  FriendsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsNotifierHash();

  @$internal
  @override
  FriendsNotifier create() => FriendsNotifier();
}

String _$friendsNotifierHash() => r'f10e46546879d14f8fa930dad99c6c553ccfb18c';

abstract class _$FriendsNotifier extends $AsyncNotifier<FriendsState> {
  FutureOr<FriendsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FriendsState>, FriendsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FriendsState>, FriendsState>,
              AsyncValue<FriendsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
