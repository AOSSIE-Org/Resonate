// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../rooms_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomsNotifier)
final roomsProvider = RoomsNotifierProvider._();

final class RoomsNotifierProvider
    extends $AsyncNotifierProvider<RoomsNotifier, RoomsState> {
  RoomsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomsNotifierHash();

  @$internal
  @override
  RoomsNotifier create() => RoomsNotifier();
}

String _$roomsNotifierHash() => r'02510587aa770f134ba0779926f2269641c51ff8';

abstract class _$RoomsNotifier extends $AsyncNotifier<RoomsState> {
  FutureOr<RoomsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<RoomsState>, RoomsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RoomsState>, RoomsState>,
              AsyncValue<RoomsState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
