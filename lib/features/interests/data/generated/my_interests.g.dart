// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../my_interests.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyInterests)
final myInterestsProvider = MyInterestsProvider._();

final class MyInterestsProvider
    extends $AsyncNotifierProvider<MyInterests, List<Interest>> {
  MyInterestsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myInterestsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myInterestsHash();

  @$internal
  @override
  MyInterests create() => MyInterests();
}

String _$myInterestsHash() => r'2be8584ac610d28ced299a1e44aa4b8613b41bbf';

abstract class _$MyInterests extends $AsyncNotifier<List<Interest>> {
  FutureOr<List<Interest>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Interest>>, List<Interest>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Interest>>, List<Interest>>,
              AsyncValue<List<Interest>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
