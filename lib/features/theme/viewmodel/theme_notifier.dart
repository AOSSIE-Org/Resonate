import 'package:resonate/core/providers/get_storage_provider.dart';
import 'package:resonate/features/theme/model/theme_enums.dart';
import 'package:resonate/utils/constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/theme_notifier.g.dart';

const _themeStorageKey = 'theme';


String _placeholderIdFor(String themeName) {
  switch (themeName) {
    case 'amber':
      return amberUserProfileImagePlaceholderID;
    case 'vintage':
      return vintageUserProfileImagePlaceholderID;
    case 'time':
      return timeUserProfileImagePlaceholderID;
    case 'classic':
      return classicUserProfileImagePlaceholderID;
    case 'forest':
      return forestUserProfileImagePlaceholderID;
    case 'cream':
      return creamUserProfileImagePlaceholderID;
    default:
      return creamUserProfileImagePlaceholderID;
  }
}

@Riverpod(keepAlive: true)
class AppTheme extends _$AppTheme {
  @override
  String build() {
    final box = ref.watch(getStorageBoxProvider);
    return box.read<String>(_themeStorageKey) ?? Themes.classic.name;
  }

  void setTheme(String themeName) {
    ref.read(getStorageBoxProvider).write(_themeStorageKey, themeName);
    state = themeName;
  }
}

@Riverpod(keepAlive: true)
String userProfileImagePlaceholderUrl(Ref ref) {
  final themeName = ref.watch(appThemeProvider);
  final placeholderId = _placeholderIdFor(themeName);
  return "http://$baseDomain/v1/storage/buckets/$userProfileImageBucketId/files/$placeholderId/view?project=resonate&mode=admin";
}
