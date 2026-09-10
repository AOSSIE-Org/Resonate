// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../interest_filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(InterestFilter)
final interestFilterProvider = InterestFilterProvider._();

final class InterestFilterProvider
    extends $NotifierProvider<InterestFilter, InterestFilterState> {
  InterestFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interestFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interestFilterHash();

  @$internal
  @override
  InterestFilter create() => InterestFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterestFilterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterestFilterState>(value),
    );
  }
}

String _$interestFilterHash() => r'd65ea146e0f84a115bb4d2db1b95fe706812c04a';

abstract class _$InterestFilter extends $Notifier<InterestFilterState> {
  InterestFilterState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InterestFilterState, InterestFilterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InterestFilterState, InterestFilterState>,
              InterestFilterState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
