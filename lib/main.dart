//Import the required packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:resonate/firebase_options.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/themes/themes.dart';
import 'package:get_storage/get_storage.dart';
import 'themes/theme_controller.dart';

//The starting point of any flutter app.
Future<void> main() async {
  //Make sure that an instance of WidgetsBinding is created which is necessary to initialize firebase.
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //This specifies the style to use for system overlays i.e status bar.
  //Here we have used the statusBarColor propety to make the status bar transparent.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  //GetStorage.init() is defined by get_storage package.
  //await keyword is used as init() is a Future. This makes sure that the async operations are completed before moving to next line of code.
  //GetStorage.init() is used to initialize storage driver
  await GetStorage.init();
  //as name suggests it is used to run the app which in this case is MyApp stateless widget.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //create themeControler and use Get.put() to create an instance of ThemeController defined in lib\themes\theme_controller.dart.
    //More info about ThemeController can be found in lib\themes\theme_controller.dart.
    final themeController = Get.put(ThemeController());
    //Instead of MaterialApp get state management provides GetMaterialApp which simplifies routing.
    return GetMaterialApp(
      //Remove the debug banner sshown at the top right
      debugShowCheckedModeBanner: false,
      //Specify the title of the app.
      title: 'Resonate',
      //Use Themes class defined in lib\themes\themes.dart to specify ThemeData used by theme and darkTheme
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      //ThemeMode theme is defined in ThemeController to get the system theme.
      themeMode: themeController.theme,
      //specify the initial route as splash which is defined in AppRoutes class in lib\routes\app_routes.dart
      initialRoute: AppRoutes.splash,
      //getPages is provided by GetMaterialApp which simplifies Navigation in flutter.
      //AppPages has a list of GetPages named "pages" which contains names of various pages used in app.
      getPages: AppPages.pages,
    );
  }
}
