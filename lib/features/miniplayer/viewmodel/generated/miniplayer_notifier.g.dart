// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../miniplayer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Miniplayer)
final miniplayerProvider = MiniplayerProvider._();

final class MiniplayerProvider
    extends $NotifierProvider<Miniplayer, MiniplayerSession?> {
  MiniplayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miniplayerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miniplayerHash();

  @$internal
  @override
  Miniplayer create() => Miniplayer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiniplayerSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiniplayerSession?>(value),
    );
  }
}

String _$miniplayerHash() => r'd206d2b13d8fcc31f4520c2c1d6211461e0a423d';

abstract class _$Miniplayer extends $Notifier<MiniplayerSession?> {
  MiniplayerSession? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MiniplayerSession?, MiniplayerSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MiniplayerSession?, MiniplayerSession?>,
              MiniplayerSession?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
