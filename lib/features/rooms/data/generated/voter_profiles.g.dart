// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../voter_profiles.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VoterProfiles)
final voterProfilesProvider = VoterProfilesFamily._();

final class VoterProfilesProvider
    extends $NotifierProvider<VoterProfiles, Map<String, VoterProfile>> {
  VoterProfilesProvider._({
    required VoterProfilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'voterProfilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$voterProfilesHash();

  @override
  String toString() {
    return r'voterProfilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VoterProfiles create() => VoterProfiles();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, VoterProfile> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, VoterProfile>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VoterProfilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$voterProfilesHash() => r'00bcd25f20665ac24ada91edb5f9bffea2c15185';

final class VoterProfilesFamily extends $Family
    with
        $ClassFamilyOverride<
          VoterProfiles,
          Map<String, VoterProfile>,
          Map<String, VoterProfile>,
          Map<String, VoterProfile>,
          String
        > {
  VoterProfilesFamily._()
    : super(
        retry: null,
        name: r'voterProfilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VoterProfilesProvider call(String roomId) =>
      VoterProfilesProvider._(argument: roomId, from: this);

  @override
  String toString() => r'voterProfilesProvider';
}

abstract class _$VoterProfiles extends $Notifier<Map<String, VoterProfile>> {
  late final _$args = ref.$arg as String;
  String get roomId => _$args;

  Map<String, VoterProfile> build(String roomId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, VoterProfile>, Map<String, VoterProfile>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, VoterProfile>, Map<String, VoterProfile>>,
              Map<String, VoterProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
