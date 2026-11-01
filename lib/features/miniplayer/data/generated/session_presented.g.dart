// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../session_presented.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SessionPresented)
final sessionPresentedProvider = SessionPresentedProvider._();

final class SessionPresentedProvider
    extends $NotifierProvider<SessionPresented, bool> {
  SessionPresentedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionPresentedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionPresentedHash();

  @$internal
  @override
  SessionPresented create() => SessionPresented();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sessionPresentedHash() => r'3832a8cbb9a4bdd2b1cb8423183d23b53720f24d';

abstract class _$SessionPresented extends $Notifier<bool> {
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
