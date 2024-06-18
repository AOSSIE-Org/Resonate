import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:resonate/firebase_options.dart';
import 'package:resonate/new_themes/new_theme.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/themes/themes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'controllers/new_theme_screen_controller.dart';
import 'models/themes_model.dart';
import 'themes/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    UiSizes.init(context);
    final themeController = Get.put(ThemeController());


    final newThemeController = Get.put(NewThemeController());


    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Resonate',
        theme: NewTheme.getTheme(newThemeController.themeModel.value),
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
