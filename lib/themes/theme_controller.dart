import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/themes/theme_enum.dart';
import 'package:resonate/utils/constants.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'theme';

  final _themeKey = 'theme';
  final _favoritesKey = 'favoriteThemes';

  Rx<String> currentTheme = Themes.classic.name.obs;
  Rx<String> userProfileImagePlaceholderUrl =
      "http://$baseDomain/v1/storage/buckets/$userProfileImageBucketId/files/67012e19003d00f39e12/view?project=resonate&mode=admin"
          .obs;

//hahahha
  @override
  void onInit() {
    super.onInit();
    currentTheme.value = getCurrentTheme;
    updateuserProfileImagePlaceholderUrlOnTheme();
  }

  String get getCurrentTheme => _box.read(_key) ?? currentTheme.value;

  void updateTheme(String theme) {
    currentTheme.value = theme;
  }

  void updateuserProfileImagePlaceholderUrlOnTheme() {
    log(userProfileImagePlaceholderUrl.value);
    final String currentThemePlaceHolder;
    switch (currentTheme.value) {
      case "amber":
        currentThemePlaceHolder = amber;
        break;
      case "vintage":
        currentThemePlaceHolder = vintage;
        break;
      case "time":
        currentThemePlaceHolder = time;
        break;
      case "classic":
        currentThemePlaceHolder = classic;
        break;
      case "forest":
        currentThemePlaceHolder = forest;
        break;
      case "cream":
        currentThemePlaceHolder = cream;
        break;
      default:
        currentThemePlaceHolder = cream;
    }

    userProfileImagePlaceholderUrl.value =
        userProfileImagePlaceholderUrl.value.replaceRange(
      62,
      82,
      currentThemePlaceHolder,
    );
    log(userProfileImagePlaceholderUrl.value);
  }

  void setTheme(String newTheme) {
    _box.write(_key, newTheme);
    updateTheme(newTheme);
    updateuserProfileImagePlaceholderUrlOnTheme();
  }
}
