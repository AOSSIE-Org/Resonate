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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/features/shell/viewmodel/network_notifier.dart';
import 'package:resonate/features/theme/model/theme_list.dart';
import 'package:resonate/features/theme/model/theme_modes.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/features/settings/viewmodel/locale_notifier.dart';
import 'package:resonate/firebase_options.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/l10n/raj_intl.dart';
import 'package:resonate/routes/app_router.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';

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
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  languageLocale =
      await FlutterSecureStorage().read(key: "languageLocale") ?? "en";

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiSizes.init(context);
    ref.watch(networkProvider);
    final themeModel = ThemeList.getThemeModel(ref.watch(appThemeProvider));

    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizationsRaj.delegate,
      ],
      locale: ref.watch(appLocaleProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Resonate',
      theme: ThemeModes.setLightTheme(themeModel),
      darkTheme: ThemeModes.setDarkTheme(themeModel),
      themeMode: themeModel.themeMode,
    );
  }
}
