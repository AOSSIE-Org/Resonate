import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:resonate/firebase_options.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/themes/theme.dart';
import 'package:resonate/themes/theme_list.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'themes/theme_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();
  Get.put(AboutAppScreenController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    UiSizes.init(context);
    final themeController = Get.put(ThemeController());

    return Obx(
      () => GetMaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('hi')],
        debugShowCheckedModeBanner: false,
        title: 'Resonate',
        theme: ThemeModes.setLightTheme(
          ThemeList.getThemeModel(themeController.currentTheme.value),
        ),
        darkTheme: ThemeModes.setDarkTheme(
          ThemeList.getThemeModel(themeController.currentTheme.value),
        ),
        themeMode: ThemeList.getThemeModel(
          themeController.currentTheme.value,
        ).themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
