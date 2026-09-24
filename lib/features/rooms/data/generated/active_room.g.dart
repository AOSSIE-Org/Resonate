// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../active_room.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveRoom)
final activeRoomProvider = ActiveRoomProvider._();

final class ActiveRoomProvider
    extends $NotifierProvider<ActiveRoom, AppwriteRoom?> {
  ActiveRoomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeRoomProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRoomHash();

  @$internal
  @override
  ActiveRoom create() => ActiveRoom();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppwriteRoom? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppwriteRoom?>(value),
    );
  }
}

String _$activeRoomHash() => r'42a9d8d997edcaec4cabf7e3f1de3e1061aef3ab';

abstract class _$ActiveRoom extends $Notifier<AppwriteRoom?> {
  AppwriteRoom? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppwriteRoom?, AppwriteRoom?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppwriteRoom?, AppwriteRoom?>,
              AppwriteRoom?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
