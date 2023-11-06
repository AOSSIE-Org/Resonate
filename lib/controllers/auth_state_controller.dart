import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import '../routes/app_routes.dart';

class AuthStateController extends GetxController {
  Client client = AppwriteService.getClient();
  final Databases databases = AppwriteService.getDatabases();
  var isInitializing = false.obs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late final Account account;
  late String? uid;
  late String? profileImageID;
  late String? displayName;
  late String? email;
  late String? profileImageUrl;
  late String? userName;
  late bool? isUserProfileComplete;
  late bool? isEmailVerified;
  late User appwriteUser;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Get.to(TabViewScreen());
    final TabViewController tabViewController = Get.find<TabViewController>();
    tabViewController.setIndex(1);
  }

  @override
  void onInit() async {
    super.onInit();

    account = Account(client);

    await setUserProfileData();

    // ask for settings permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await initializeLocalNotifications();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Listen to notitifcations in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null) {
        print('Notification Title: ${message.notification!.title}');
        print('Notification body: ${message.notification!.body}');

        // send local notification
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            notificationDetails,
            payload: 'item x');
      }
    });
  }

  Future<bool> get getLoginState async {
    try {
      appwriteUser = await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> setUserProfileData() async {
    isInitializing.value = true;
    try {
      appwriteUser = await account.get();
      displayName = appwriteUser.name;
      email = appwriteUser.email;
      isEmailVerified = appwriteUser.emailVerification;
      uid = appwriteUser.$id;
      isUserProfileComplete =
          appwriteUser.prefs.data["isUserProfileComplete"] ?? false;
      if (isUserProfileComplete == true) {
        Document userDataDoc = await databases.getDocument(
            databaseId: userDatabaseID,
            collectionId: usersCollectionID,
            documentId: appwriteUser.$id);
        profileImageUrl = userDataDoc.data["profileImageUrl"];
        profileImageID = userDataDoc.data["profileImageID"];
        userName = userDataDoc.data["username"] ?? "unavailable";
      }
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isInitializing.value = false;
    }
  }

  Future<String> getAppwriteToken() async {
    Jwt authToken = await account.createJWT();
    log(authToken.toString());
    return authToken.jwt;
  }

  Future<void> isUserLoggedIn() async {
    try {
      await setUserProfileData();
      if (isUserProfileComplete == false) {
        Get.offNamed(AppRoutes.onBoarding);
      } else {
        Get.offNamed(AppRoutes.tabview);
      }
    } catch (e) {
      bool? landingScreenShown = GetStorage().read(
          "landingScreenShown"); // landingScreenShown is the boolean value that is used to check wether to show the user the onboarding screen or not on the first launch of the app.
      landingScreenShown == null
          ? Get.offNamed(AppRoutes.landing)
          : Get.offNamed(AppRoutes.login);
    }
  }

  Future<void> login(String email, String password) async {
    await account.createEmailSession(email: email, password: password);
    await isUserLoggedIn();
    await addRegistrationTokentoSubscribedDiscussions();
  }

  Future<void> addRegistrationTokentoSubscribedDiscussions() async {
    print("fetching current subscribed discussions");
    final fcmToken = await messaging.getToken();
    List<Document> subscribedDiscussions = await databases.listDocuments(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        queries: [
          Query.equal("userID", [uid])
        ]).then((value) => value.documents);
    subscribedDiscussions.forEach((subscribtion) {
      print("getting current registration tokens of subscribed discussions");
      List<dynamic> registrationTokens =
          subscribtion.data['registrationTokens'];
      print(
          "adding current registration token to registration tokens of subscribed discussions");
      registrationTokens.add(fcmToken!);
      print(
          "updating new registration tokens list to the subscribed discussion");
      databases.updateDocument(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          documentId: subscribtion.$id,
          data: {"registrationTokens": registrationTokens});
      print(
          "successfully added current registration token to subscribed discussion's registration token list");
    });
  }

  Future<void> removeRegistrationTokenfromSubscribedDiscussions() async {
    final fcmToken = await messaging.getToken();
    print("fetching current subscribed discussions");
    List<Document> subscribedDiscussions = await databases.listDocuments(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        queries: [
          Query.equal("userID", [uid])
        ]).then((value) => value.documents);
    subscribedDiscussions.forEach((subscribtion) {
      print("getting current registration tokens of subscribed discussions");
      List<dynamic> registrationTokens =
          subscribtion.data['registrationTokens'];
      print(
          "removing current registration token from registration tokens of subscribed discussions");
      registrationTokens.remove(fcmToken!);
      print(
          "updating new registration tokens list to the subscribed discussion");
      databases.updateDocument(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          documentId: subscribtion.$id,
          data: {"registrationTokens": registrationTokens});
      print(
          "successfully removed current registration token from subscribed discussion's registration token list");
    });
  }

  Future<void> signup(String email, String password) async {
    await account.create(userId: ID.unique(), email: email, password: password);
    await account.createEmailSession(email: email, password: password);

    await setUserProfileData();
  }

  Future<void> loginWithGoogle() async {
    await account.createOAuth2Session(provider: 'google');
    await isUserLoggedIn();
  }

  Future<void> loginWithGithub() async {
    await account.createOAuth2Session(provider: 'github');
    await isUserLoggedIn();
  }

  Future<void> logout() async {
    Get.defaultDialog(
      title: "Are you sure?",
      middleText: "You are logging out of Resonate",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      textCancel: "No",
      contentPadding: EdgeInsets.all(UiSizes.size_15),
      onConfirm: () async {
        await account.deleteSession(sessionId: 'current');
        await removeRegistrationTokenfromSubscribedDiscussions();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}
