import 'package:get_storage/get_storage.dart';
import 'package:resonate/features/theme/model/theme_enums.dart';
import 'package:resonate/features/theme/model/theme_list.dart';
import 'package:resonate/features/theme/model/theme_model.dart';

const themeStorageKey = 'theme';

ThemeModel storedThemeModel() => ThemeList.getThemeModel(
  Themes.fromName(GetStorage().read<String>(themeStorageKey)).name,
);
