// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../welcome_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Welcome)
final welcomeProvider = WelcomeProvider._();

final class WelcomeProvider extends $NotifierProvider<Welcome, void> {
  WelcomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeHash();

  @$internal
  @override
  Welcome create() => Welcome();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$welcomeHash() => r'7c622c62ad109dbcde95f6e1410e06dc1c318e7a';

abstract class _$Welcome extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
