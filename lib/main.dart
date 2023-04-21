import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/bindings/authentication_binding.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/views/screens/login_screen.dart';

import 'firebase_options.dart';

void main() async{
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
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: AppColor.bgBlackColor
      ),
      home: const LoginScreen(),
      initialBinding: AuthenticationBinding(),
      getPages: AppPages.pages,
    );
  }
}