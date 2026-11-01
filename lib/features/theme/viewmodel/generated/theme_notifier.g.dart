// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../theme_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppTheme)
final appThemeProvider = AppThemeProvider._();

final class AppThemeProvider extends $NotifierProvider<AppTheme, Themes> {
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
  Override overrideWithValue(Themes value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Themes>(value),
    );
  }
}

String _$appThemeHash() => r'073797184596b9098b1e2c2c8e2524a7c72f268d';

abstract class _$AppTheme extends $Notifier<Themes> {
  Themes build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Themes, Themes>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Themes, Themes>,
              Themes,
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
    r'b838baa88309d28dc61d146d8c90221c78295d59';
