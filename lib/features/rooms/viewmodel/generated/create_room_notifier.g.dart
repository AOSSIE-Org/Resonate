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
    r'7111745f5b5d4e4858c636c4b479136f0f7a7ab9';

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
