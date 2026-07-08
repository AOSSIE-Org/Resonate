// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../create_story_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateStory)
final createStoryProvider = CreateStoryProvider._();

final class CreateStoryProvider extends $NotifierProvider<CreateStory, void> {
  CreateStoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createStoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createStoryHash();

  @$internal
  @override
  CreateStory create() => CreateStory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$createStoryHash() => r'e94acbcd8d4e84b803b027a195b61442eb71ecf7';

abstract class _$CreateStory extends $Notifier<void> {
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
