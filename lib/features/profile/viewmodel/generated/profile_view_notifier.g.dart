// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_view_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProfileView)
final profileViewProvider = ProfileViewFamily._();

final class ProfileViewProvider
    extends $AsyncNotifierProvider<ProfileView, ProfileViewData> {
  ProfileViewProvider._({
    required ProfileViewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'profileViewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$profileViewHash();

  @override
  String toString() {
    return r'profileViewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ProfileView create() => ProfileView();

  @override
  bool operator ==(Object other) {
    return other is ProfileViewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$profileViewHash() => r'01aedde272801aa4b21bc14701b109babb5692b2';

final class ProfileViewFamily extends $Family
    with
        $ClassFamilyOverride<
          ProfileView,
          AsyncValue<ProfileViewData>,
          ProfileViewData,
          FutureOr<ProfileViewData>,
          String
        > {
  ProfileViewFamily._()
    : super(
        retry: null,
        name: r'profileViewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ProfileViewProvider call(String creatorId) =>
      ProfileViewProvider._(argument: creatorId, from: this);

  @override
  String toString() => r'profileViewProvider';
}

abstract class _$ProfileView extends $AsyncNotifier<ProfileViewData> {
  late final _$args = ref.$arg as String;
  String get creatorId => _$args;

  FutureOr<ProfileViewData> build(String creatorId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ProfileViewData>, ProfileViewData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ProfileViewData>, ProfileViewData>,
              AsyncValue<ProfileViewData>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
