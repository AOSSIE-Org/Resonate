import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  bool? landingScreenShown = GetStorage().read("landingScreenShown");
  log('initval ${landingScreenShown}');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Resonate',
      theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bgBlackColor,
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.dark,
            primarySwatch: AppColor.yellowMaterialColor,
            accentColor: Colors.white,
            backgroundColor: AppColor.bgBlackColor,
            errorColor: const Color(0xFDFF0000),
          ),
          fontFamily:
              GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
          iconTheme: Get.theme.iconTheme.copyWith(
            size: UiSizes.size_24,
            color: AppColor.yellowColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            iconColor: AppColor.yellowColor,
            floatingLabelStyle: TextStyle(
                color: AppColor.yellowColor, fontSize: UiSizes.size_14),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColor.yellowColor, width: UiSizes.width_2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60),
            ),
            suffixIconColor: AppColor.yellowColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.yellowColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(UiSizes.size_12), // <-- Radius
                  side: BorderSide(
                      width: UiSizes.width_1, color: Colors.grey[800]!)),
              minimumSize: Size.fromHeight(UiSizes.height_45), // NEW
            ),
          )),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
