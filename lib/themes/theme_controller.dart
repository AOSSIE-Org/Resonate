import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/themes/theme_enum.dart';


class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'theme';

  Rx<String> currentTheme = Themes.classic.name.obs;

//hahahha
  @override
  void onInit() {
    super.onInit();
    currentTheme.value = getCurrentTheme;
  }

  String get getCurrentTheme => _box.read(_key) ?? currentTheme.value;


  void updateTheme(String theme){
    currentTheme.value = theme;
  }


  void setTheme(String newTheme) {
    _box.write(_key, newTheme);
    updateTheme(newTheme);
  }
}
