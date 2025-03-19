import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/themes/theme_enum.dart';
import 'package:resonate/utils/constants.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'theme';

  Rx<String> currentTheme = Themes.classic.name.obs;
  Rx<String> currentThemePlaceHolder = classicUserProfileImagePlaceholderID.obs;

//hahahha
  @override
  void onInit() {
    super.onInit();
    currentTheme.value = getCurrentTheme;
    updateUserProfileImagePlaceholderUrlOnTheme();
    log(userProfileImagePlaceholderUrl);
  }

  String get getCurrentTheme => _box.read(_key) ?? currentTheme.value;

  String get userProfileImagePlaceholderUrl =>
      "http://$baseDomain/v1/storage/buckets/$userProfileImageBucketId/files/$currentThemePlaceHolder/view?project=resonate&mode=admin";

  void updateTheme(String theme) {
    currentTheme.value = theme;
  }

  void updateUserProfileImagePlaceholderUrlOnTheme() {
    log(currentThemePlaceHolder.value);
    switch (currentTheme.value) {
      case "amber":
        currentThemePlaceHolder.value = amberUserProfileImagePlaceholderID;
        break;
      case "vintage":
        currentThemePlaceHolder.value = vintageUserProfileImagePlaceholderID;
        break;
      case "time":
        currentThemePlaceHolder.value = timeUserProfileImagePlaceholderID;
        break;
      case "classic":
        currentThemePlaceHolder.value = classicUserProfileImagePlaceholderID;
        break;
      case "forest":
        currentThemePlaceHolder.value = forestUserProfileImagePlaceholderID;
        break;
      case "cream":
        currentThemePlaceHolder.value = creamUserProfileImagePlaceholderID;
        break;
      default:
        currentThemePlaceHolder.value = creamUserProfileImagePlaceholderID;
    }

    log(currentThemePlaceHolder.value);
  }

  void setTheme(String newTheme) {
    _box.write(_key, newTheme);
    updateTheme(newTheme);
    updateUserProfileImagePlaceholderUrlOnTheme();
  }
}
