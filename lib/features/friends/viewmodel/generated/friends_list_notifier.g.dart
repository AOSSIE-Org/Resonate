// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friends_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FriendsList)
final friendsListProvider = FriendsListProvider._();

final class FriendsListProvider
    extends $NotifierProvider<FriendsList, FriendRowsState> {
  FriendsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'friendsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$friendsListHash();

  @$internal
  @override
  FriendsList create() => FriendsList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FriendRowsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FriendRowsState>(value),
    );
  }
}

String _$friendsListHash() => r'152cc50967bf8bbea9896205919a17f1843616f6';

abstract class _$FriendsList extends $Notifier<FriendRowsState> {
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
