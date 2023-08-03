import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Resonate',
      theme: ThemeData(
          scaffoldBackgroundColor: AppColor.bgBlackColor,
          colorScheme: ColorScheme.fromSwatch(
            brightness: Brightness.dark,
            primaryColorDark: AppColor.yellowColor,
            accentColor: Colors.white,
            backgroundColor: AppColor.bgBlackColor,
            errorColor: const Color(0xFDFF0000),
          ),
          fontFamily:
              GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
          iconTheme: Get.theme.iconTheme.copyWith(
            size: 0.0146 * Get.height + 0.02916 * Get.width,
            color: AppColor.yellowColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            iconColor: AppColor.yellowColor,
            floatingLabelStyle: TextStyle(
                color: AppColor.yellowColor,
                fontSize: 0.0085 * Get.height + 0.017 * Get.width),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: AppColor.yellowColor, width: 0.0048 * Get.width),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60),
            ),
            suffixIconColor: AppColor.yellowColor,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.yellowColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // <-- Radius
                  side: BorderSide(
                      width: 0.0024 * Get.width, color: Colors.grey[800]!)),
              minimumSize: Size.fromHeight(0.054 * Get.height), // NEW
            ),
          )),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
