import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:resonate/firebase_options.dart';
import 'package:resonate/new_themes/new_theme.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/new_themes/theme_list.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'new_themes/new_theme_screen_controller.dart';
import 'themes/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);

  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    UiSizes.init(context);

    // This line is just for initialization of theme controller. This will prevent some breaking changes in old ui, until it gets fixed
    Get.put(ThemeController());

    final newThemeController = Get.put(NewThemeController());

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resonate',
        theme: NewTheme.setLightTheme(
          ThemeList.getThemeModel(
            newThemeController.currentTheme.value,
          ),
        ),
        darkTheme: NewTheme.setDarkTheme(
          ThemeList.getThemeModel(
            newThemeController.currentTheme.value,
          ),
        ),
        themeMode: ThemeList.getThemeModel(
          newThemeController.currentTheme.value,
        ).themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );

    // return Obx(
    //   () => GetMaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     title: 'Resonate',
    //     theme: NewTheme.classicLightTheme,
    //     // theme: Themes.getLightTheme(themeController.primaryColor.value),
    //     // darkTheme: Themes.getDarkTheme(themeController.primaryColor.value),
    //     darkTheme: Themes.getDarkTheme(themeController.primaryColor.value),
    //     themeMode: themeController.theme,
    //     initialRoute: AppRoutes.splash,
    //     getPages: AppPages.pages,
    //   ),
    // );
  }
}
