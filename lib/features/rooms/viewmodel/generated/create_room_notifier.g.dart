// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_room_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateRoomNotifier)
final createRoomProvider = CreateRoomNotifierProvider._();

final class CreateRoomNotifierProvider
    extends $NotifierProvider<CreateRoomNotifier, bool> {
  CreateRoomNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createRoomProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createRoomNotifierHash();

  @$internal
  @override
  CreateRoomNotifier create() => CreateRoomNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$createRoomNotifierHash() =>
    r'56e1b3fdda5466998682742e7e469134f92ccb7a';

abstract class _$CreateRoomNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
