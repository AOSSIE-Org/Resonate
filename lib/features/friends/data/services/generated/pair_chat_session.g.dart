// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../pair_chat_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PairChat)
final pairChatProvider = PairChatProvider._();

final class PairChatProvider
    extends $NotifierProvider<PairChat, PairChatState> {
  PairChatProvider._()
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
  String debugGetCreateSourceHash() => _$pairChatHash();

  @$internal
  @override
  PairChat create() => PairChat();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PairChatState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PairChatState>(value),
    );
  }
}

String _$pairChatHash() => r'91c8fe72e9883c4a65d9f9a2c123509b86898df5';

abstract class _$PairChat extends $Notifier<PairChatState> {
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
