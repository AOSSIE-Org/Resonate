// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../my_stats.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MyStats)
final myStatsProvider = MyStatsProvider._();

final class MyStatsProvider extends $AsyncNotifierProvider<MyStats, UserStats> {
  MyStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myStatsHash();

  @$internal
  @override
  MyStats create() => MyStats();
}

String _$myStatsHash() => r'd0255cbc4329677ebf7ef9b58e001d4e5869254c';

abstract class _$MyStats extends $AsyncNotifier<UserStats> {
  FutureOr<UserStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserStats>, UserStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserStats>, UserStats>,
              AsyncValue<UserStats>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
