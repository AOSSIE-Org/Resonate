// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../interests_editor_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InterestsEditor)
final interestsEditorProvider = InterestsEditorProvider._();

final class InterestsEditorProvider
    extends $NotifierProvider<InterestsEditor, InterestsEditState> {
  InterestsEditorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestsEditorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestsEditorHash();

  @$internal
  @override
  InterestsEditor create() => InterestsEditor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterestsEditState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterestsEditState>(value),
    );
  }
}

String _$interestsEditorHash() => r'ac7ef69c1e72f6b2d29a41873d262eb6dfbd86d5';

abstract class _$InterestsEditor extends $Notifier<InterestsEditState> {
  InterestsEditState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InterestsEditState, InterestsEditState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InterestsEditState, InterestsEditState>,
              InterestsEditState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
