// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../story_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoryDetail)
final storyDetailProvider = StoryDetailFamily._();

final class StoryDetailProvider
    extends $AsyncNotifierProvider<StoryDetail, StoryDetailState> {
  StoryDetailProvider._({
    required StoryDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'storyDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storyDetailHash();

  @override
  String toString() {
    return r'storyDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StoryDetail create() => StoryDetail();

  @override
  bool operator ==(Object other) {
    return other is StoryDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storyDetailHash() => r'cc34f136856e95bf25bcc782aa332c6737f80025';

final class StoryDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          StoryDetail,
          AsyncValue<StoryDetailState>,
          StoryDetailState,
          FutureOr<StoryDetailState>,
          String
        > {
  StoryDetailFamily._()
    : super(
        retry: null,
        name: r'storyDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StoryDetailProvider call(String storyId) =>
      StoryDetailProvider._(argument: storyId, from: this);

  @override
  String toString() => r'storyDetailProvider';
}

abstract class _$StoryDetail extends $AsyncNotifier<StoryDetailState> {
  late final _$args = ref.$arg as String;
  String get storyId => _$args;

  FutureOr<StoryDetailState> build(String storyId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<StoryDetailState>, StoryDetailState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StoryDetailState>, StoryDetailState>,
              AsyncValue<StoryDetailState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
