import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/themes/theme_enum.dart';


class ThemeController extends GetxController {
  final _box = GetStorage();
  final _themeKey = 'theme';
  final _favoritesKey = 'favoriteThemes';

  Rx<String> currentTheme = Themes.classic.name.obs;
   RxList<String> favoriteThemes = <String>[].obs;

//hahahha
  @override
  void onInit() {
    super.onInit();
    final storedTheme = _box.read(_themeKey);

    // Validate stored theme
  currentTheme.value = Themes.values.any((theme) => theme.name == storedTheme)
      ? storedTheme
      : Themes.classic.name;

      // Initialize favorites
    favoriteThemes.value = _box.read<List<String>>(_favoritesKey)?.where(
          (theme) => Themes.values.any((t) => t.name == theme),
        ).toList() ?? [];
  }

  void toggleFavorite(String themeName) {
    if (favoriteThemes.contains(themeName)) {
      favoriteThemes.remove(themeName);
    } else {
      favoriteThemes.add(themeName);
    }
    _box.write(_favoritesKey, favoriteThemes.toList());
  }

  void updateTheme(String theme){
    currentTheme.value = theme;
  }


  void setTheme(String newTheme) {
    if (Themes.values.any((theme) => theme.name == newTheme)) {
      _box.write(_themeKey, newTheme);
      updateTheme(newTheme);
    }
  }
}
