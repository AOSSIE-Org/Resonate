import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/bindings/authentication_binding.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/views/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      initialBinding: AuthenticationBinding(),
      getPages: AppPages.pages,
    );
  }
}