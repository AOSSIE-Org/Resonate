// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../miniplayer_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The live session in progress, or null when there is none.
///
/// Deliberately blind to whether the session's own screen is up: the host
/// decides when to draw the floating bar, while picture-in-picture needs the
/// session even when the user leaves the app straight from the room sheet.
///
/// Watching `roomSessionProvider` from here is deliberate: it is autoDispose
/// and the sheet used to be its only listener, so minimising would otherwise
/// tear down the participant subscription and leave mic state and kicks stale.

@ProviderFor(Miniplayer)
final miniplayerProvider = MiniplayerProvider._();

/// The live session in progress, or null when there is none.
///
/// Deliberately blind to whether the session's own screen is up: the host
/// decides when to draw the floating bar, while picture-in-picture needs the
/// session even when the user leaves the app straight from the room sheet.
///
/// Watching `roomSessionProvider` from here is deliberate: it is autoDispose
/// and the sheet used to be its only listener, so minimising would otherwise
/// tear down the participant subscription and leave mic state and kicks stale.
final class MiniplayerProvider
    extends $NotifierProvider<Miniplayer, MiniplayerSession?> {
  /// The live session in progress, or null when there is none.
  ///
  /// Deliberately blind to whether the session's own screen is up: the host
  /// decides when to draw the floating bar, while picture-in-picture needs the
  /// session even when the user leaves the app straight from the room sheet.
  ///
  /// Watching `roomSessionProvider` from here is deliberate: it is autoDispose
  /// and the sheet used to be its only listener, so minimising would otherwise
  /// tear down the participant subscription and leave mic state and kicks stale.
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

/// The live session in progress, or null when there is none.
///
/// Deliberately blind to whether the session's own screen is up: the host
/// decides when to draw the floating bar, while picture-in-picture needs the
/// session even when the user leaves the app straight from the room sheet.
///
/// Watching `roomSessionProvider` from here is deliberate: it is autoDispose
/// and the sheet used to be its only listener, so minimising would otherwise
/// tear down the participant subscription and leave mic state and kicks stale.

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
