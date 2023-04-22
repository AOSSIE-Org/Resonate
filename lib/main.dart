import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resonate/bindings/authentication_binding.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/views/screens/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColor.bgBlackColor,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          primaryColorDark: AppColor.yellowColor,
          accentColor: Colors.white,
          backgroundColor: AppColor.bgBlackColor,
          errorColor: const Color(0xFDFF0000),
        ),
        fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
        iconTheme: Get.theme.iconTheme.copyWith(
          color: AppColor.yellowColor,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: AppColor.yellowColor,
          floatingLabelStyle: TextStyle(color: AppColor.yellowColor),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColor.yellowColor, width: 2),
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
            ),
            minimumSize: const Size.fromHeight(45), // NEW
          ),
        )
      ),
      home: const LoginScreen(),
      initialBinding: AuthenticationBinding(),
      getPages: AppPages.pages,
    );
  }
}
