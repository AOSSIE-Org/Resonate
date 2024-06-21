import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/new_themes/theme_enum.dart';


class NewThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'theme';

  @override
  void onInit() {
    super.onInit();

    currentTheme.value = theme;
  }

  String get theme => _box.read(_key) ?? NewThemes.vintage.name;

  Rx<String> currentTheme = NewThemes.vintage.name.obs;

  void updateTheme(String theme){
    currentTheme.value = theme;
  }


  void setTheme(String newTheme) {
    _box.write(_key, newTheme);
    updateTheme(newTheme);
  }


}
