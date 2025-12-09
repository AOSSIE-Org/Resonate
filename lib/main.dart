import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:resonate/firebase_options.dart';
import 'package:resonate/routes/app_pages.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/themes/theme.dart';
import 'package:resonate/themes/theme_list.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';
import 'themes/theme_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/controllers/about_app_screen_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data['type'] == 'incoming_call') {
    final params = CallKitParams(
      id: message.data['call_id'],
      nameCaller: message.data['caller_name'],
      avatar: message.data['caller_profile_image_url'],
      handle: message.data['caller_username'],
      type: 0, // 0 = audio, 1 = video
      duration: 30000, // ringing timeout
      extra: {
        "docData": jsonDecode(message.data['extra']),
        "livekit_room_id": message.data['livekit_room_id'],
        "call_id": message.data['call_id'],
      },
      appName: "Resonate",
      android: AndroidParams(isShowFullLockedScreen: true),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);
    log("Handling a background message: ${message.messageId}");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.testMode = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  Get.put(AboutAppScreenController());
  languageLocale =
      await FlutterSecureStorage().read(key: "languageLocale") ?? "en";
  final String? savedModel = await FlutterSecureStorage().read(
    key: "whisperModel",
  );
  currentWhisperModel.value = WhisperModel.values.firstWhere(
    (model) => model.modelName == (savedModel ?? "base"),
    orElse: () => WhisperModel.base,
  );
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
        locale: Locale(languageLocale),
        supportedLocales: AppLocalizations.supportedLocales,
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
