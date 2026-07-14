import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/theme/model/theme_enums.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/theme_notifier.g.dart';

const _themeStorageKey = 'theme';

String _placeholderIdFor(Themes theme) {
  switch (theme) {
    case Themes.amber:
      return amberUserProfileImagePlaceholderID;
    case Themes.vintage:
      return vintageUserProfileImagePlaceholderID;
    case Themes.time:
      return timeUserProfileImagePlaceholderID;
    case Themes.classic:
      return classicUserProfileImagePlaceholderID;
    case Themes.forest:
      return forestUserProfileImagePlaceholderID;
    case Themes.cream:
      return creamUserProfileImagePlaceholderID;
  }
}

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  Themes build() {
    final box = ref.watch(getStorageBoxProvider);
    return Themes.fromName(box.read<String>(_themeStorageKey));
  }

  void setTheme(Themes theme) {
    ref.read(getStorageBoxProvider).write(_themeStorageKey, theme.name);
    state = theme;
  }
}

@Riverpod(keepAlive: true)
String userProfileImagePlaceholderUrl(Ref ref) {
  final theme = ref.watch(appThemeProvider);
  final placeholderId = _placeholderIdFor(theme);
  return "http://$baseDomain/v1/storage/buckets/$userProfileImageBucketId/files/$placeholderId/view?project=resonate&mode=admin";
}
