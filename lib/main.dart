import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initAppLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was in cold state (terminated)
    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      log('getInitialAppLink: $appLink');
      openAppLink(appLink);
    }

    // Handle link when app is in warm state (front or background)
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      log('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    log("Open Link Called");
    log(uri.pathSegments.last);
    //_navigatorKey.currentState?.pushNamed(AppRoutes.profile);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.defaultDialog(title: uri.pathSegments.last);
    });
  }

  @override
  void initState() {
    super.initState();
    initAppLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: _navigatorKey,
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
            color: AppColor.yellowColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            iconColor: AppColor.yellowColor,
            floatingLabelStyle: TextStyle(color: AppColor.yellowColor),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColor.yellowColor, width: 0.0048*Get.width),
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
                  side: BorderSide(width: 0.0024*Get.width, color: Colors.grey[800]!)),
              minimumSize:  Size.fromHeight(0.054*Get.height), // NEW
            ),
          )),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
