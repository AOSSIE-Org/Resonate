import 'package:flutter/material.dart';
import 'package:resonate/constants/app_routes.dart';
import 'package:resonate/views/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;
  runApp(MaterialApp(home: const LoginPage(), routes: {
    loginPageRoute: (context) => const LoginPage(),
  }));
}
