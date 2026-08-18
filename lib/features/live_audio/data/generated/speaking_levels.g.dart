// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../speaking_levels.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpeakingLevels)
final speakingLevelsProvider = SpeakingLevelsProvider._();

final class SpeakingLevelsProvider
    extends $NotifierProvider<SpeakingLevels, Map<String, double>> {
  SpeakingLevelsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakingLevelsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakingLevelsHash();

  @$internal
  @override
  SpeakingLevels create() => SpeakingLevels();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double>>(value),
    );
  }
}

String _$speakingLevelsHash() => r'49592c074c09eaeab0619f29718c3cfccb2140a9';

abstract class _$SpeakingLevels extends $Notifier<Map<String, double>> {
  Map<String, double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<String, double>, Map<String, double>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, double>, Map<String, double>>,
              Map<String, double>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(speakingLevel)
final speakingLevelProvider = SpeakingLevelFamily._();

final class SpeakingLevelProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  SpeakingLevelProvider._({
    required SpeakingLevelFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'speakingLevelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$speakingLevelHash();

  @override
  String toString() {
    return r'speakingLevelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    final argument = this.argument as String;
    return speakingLevel(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SpeakingLevelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$speakingLevelHash() => r'08923609bf3340cf24c2cbc6686f267ec128faae';

final class SpeakingLevelFamily extends $Family
    with $FunctionalFamilyOverride<double, String> {
  SpeakingLevelFamily._()
    : super(
        retry: null,
        name: r'speakingLevelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SpeakingLevelProvider call(String uid) =>
      SpeakingLevelProvider._(argument: uid, from: this);

  @override
  String toString() => r'speakingLevelProvider';
}
