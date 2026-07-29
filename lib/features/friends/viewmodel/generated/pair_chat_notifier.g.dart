// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../pair_chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PairChatNotifier)
final pairChatProvider = PairChatNotifierProvider._();

final class PairChatNotifierProvider
    extends $NotifierProvider<PairChatNotifier, PairChatState> {
  PairChatNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pairChatProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pairChatNotifierHash();

  @$internal
  @override
  PairChatNotifier create() => PairChatNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PairChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PairChatState>(value),
    );
  }
}

String _$pairChatNotifierHash() => r'8c850588d03b5395021326e6453ea8658fa5b2f0';

abstract class _$PairChatNotifier extends $Notifier<PairChatState> {
  PairChatState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PairChatState, PairChatState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PairChatState, PairChatState>,
              PairChatState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
