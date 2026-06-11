// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../edit_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditProfile)
final editProfileProvider = EditProfileProvider._();

final class EditProfileProvider
    extends $NotifierProvider<EditProfile, EditProfileState> {
  EditProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editProfileHash();

  @$internal
  @override
  EditProfile create() => EditProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditProfileState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditProfileState>(value),
    );
  }
}

String _$editProfileHash() => r'07022c879cd877802852c1898f373ad64ec82a0f';

abstract class _$EditProfile extends $Notifier<EditProfileState> {
  EditProfileState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EditProfileState, EditProfileState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EditProfileState, EditProfileState>,
              EditProfileState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
