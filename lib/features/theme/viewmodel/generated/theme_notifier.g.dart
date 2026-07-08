// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppTheme)
final appThemeProvider = AppThemeProvider._();

final class AppThemeProvider extends $NotifierProvider<AppTheme, String> {
  AppThemeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeHash();

  @$internal
  @override
  AppTheme create() => AppTheme();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$appThemeHash() => r'12739590458e85b90567dbb55c818558d5b9abf5';

abstract class _$AppTheme extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(userProfileImagePlaceholderUrl)
final userProfileImagePlaceholderUrlProvider =
    UserProfileImagePlaceholderUrlProvider._();

final class UserProfileImagePlaceholderUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  UserProfileImagePlaceholderUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileImagePlaceholderUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileImagePlaceholderUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return userProfileImagePlaceholderUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$userProfileImagePlaceholderUrlHash() =>
    r'226b2ec8d3cfcbd22a2a7374b998af17aada93b5';
