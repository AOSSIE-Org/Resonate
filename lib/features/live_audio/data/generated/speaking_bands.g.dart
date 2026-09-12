// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../speaking_bands.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpeakingSpectrum)
final speakingSpectrumProvider = SpeakingSpectrumProvider._();

final class SpeakingSpectrumProvider
    extends $NotifierProvider<SpeakingSpectrum, Map<String, List<double>>> {
  SpeakingSpectrumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakingSpectrumProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakingSpectrumHash();

  @$internal
  @override
  SpeakingSpectrum create() => SpeakingSpectrum();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<double>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<double>>>(value),
    );
  }
}

String _$speakingSpectrumHash() => r'ed214ab99a1c2e89b742a95dceebf3eb630a6e7a';

abstract class _$SpeakingSpectrum extends $Notifier<Map<String, List<double>>> {
  Map<String, List<double>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, List<double>>, Map<String, List<double>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, List<double>>, Map<String, List<double>>>,
              Map<String, List<double>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(speakingBands)
final speakingBandsProvider = SpeakingBandsFamily._();

final class SpeakingBandsProvider
    extends $FunctionalProvider<List<double>, List<double>, List<double>>
    with $Provider<List<double>> {
  SpeakingBandsProvider._({
    required SpeakingBandsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'speakingBandsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speakingBandsHash();

  @override
  String toString() {
    return r'speakingBandsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<double>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<double> create(Ref ref) {
    final argument = this.argument as String;
    return speakingBands(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<double>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpeakingBandsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speakingBandsHash() => r'a3bec5d6d483d136e510b19aebf013812addff6f';

final class SpeakingBandsFamily extends $Family
    with $FunctionalFamilyOverride<List<double>, String> {
  SpeakingBandsFamily._()
    : super(
        retry: null,
        name: r'speakingBandsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpeakingBandsProvider call(String uid) =>
      SpeakingBandsProvider._(argument: uid, from: this);

  @override
  String toString() => r'speakingBandsProvider';
}
