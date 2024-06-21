import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/new_themes/theme_enum.dart';


class NewThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'theme';

  @override
  void onInit() {
    super.onInit();

    currentTheme.value = getCurrentTheme;
  }

  Rx<String> currentTheme = NewThemes.vintage.name.obs;


  String get getCurrentTheme => _box.read(_key) ?? currentTheme.value;


  void updateTheme(String theme){
    currentTheme.value = theme;
  }


  void setTheme(String newTheme) {
    _box.write(_key, newTheme);
    updateTheme(newTheme);
  }


}
