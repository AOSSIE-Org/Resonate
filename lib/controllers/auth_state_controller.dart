import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import '../routes/app_routes.dart';

class AuthStateController extends GetxController {
  Client client = AppwriteService.getClient();
  final Databases databases = AppwriteService.getDatabases();
  var isInitializing = false.obs;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late final Account account = AppwriteService.getAccount();
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

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    String name = notificationResponse.payload!;
    UpcomingRoomsController upcomingRoomsController =
        Get.find<UpcomingRoomsController>();
    int index = upcomingRoomsController.upcomingRooms
        .indexWhere((upcomingRoom) => upcomingRoom.name == name);

    upcomingRoomsController.upcomingRoomScrollController.value =
        ScrollController(initialScrollOffset: UiSizes.height_170 * index);

    final TabViewController tabViewController = Get.find<TabViewController>();
    tabViewController.setIndex(1);
    await Get.to(TabViewScreen());
  }

  @override
  void onInit() async {
    super.onInit();
    await setUserProfileData();

    // ask for settings permissions
    // NotificationSettings settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

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
        RegExp exp = RegExp(r'The room (\w+) will Start Soon');
        RegExpMatch? matches = exp.firstMatch(message.notification!.body!);
        String discussionName = matches!.group(1)!;

        // send local notification
        await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            notificationDetails,
            payload: discussionName);
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
      log("here before getting account");
      appwriteUser = await account.get();
      log("ran get account success fully");
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
          : Get.offNamed(AppRoutes.welcomeScreen);
    }
  }

  Future<void> login(String email, String password) async {
    await account.createEmailPasswordSession(email: email, password: password);
    await isUserLoggedIn();
    await addRegistrationTokentoSubscribedandCreatedUpcomingRooms();
  }

  Future<void> addRegistrationTokentoSubscribedandCreatedUpcomingRooms() async {
    final fcmToken = await messaging.getToken();

    //subscribed Upcoming Rooms
    List<Document> subscribedUpcomingRooms = await databases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        queries: [
          Query.equal("userID", [uid])
        ]).then((value) => value.documents);
    for (var subscription in subscribedUpcomingRooms) {
      List<dynamic> registrationTokens =
          subscription.data['registrationTokens'];
      registrationTokens.add(fcmToken!);
      databases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: subscription.$id,
          data: {"registrationTokens": registrationTokens});
    }

    //created Upcoming Rooms
    List<Document> createdUpcomingRooms = await databases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        queries: [
          Query.equal("creatorUid", [uid])
        ]).then((value) => value.documents);
    for (var upcomingRoom in createdUpcomingRooms) {
      List<dynamic> creatorFcmTokens =
          upcomingRoom.data['creator_fcm_tokens'];
      creatorFcmTokens.add(fcmToken!);
      databases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          documentId: upcomingRoom.$id,
          data: {"creator_fcm_tokens": creatorFcmTokens});
    }
  }

  Future<void> removeRegistrationTokenFromSubscribedUpcomingRooms() async {
    final fcmToken = await messaging.getToken();

    //subscribed Upcoming Rooms
    List<Document> subscribedUpcomingRooms = await databases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        queries: [
          Query.equal("userID", [uid])
        ]).then((value) => value.documents);
    for (var subscription in subscribedUpcomingRooms) {
      List<dynamic> registrationTokens =
          subscription.data['registrationTokens'];
      registrationTokens.remove(fcmToken!);
      databases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          documentId: subscription.$id,
          data: {"registrationTokens": registrationTokens});
    }


    //created Upcoming Rooms
    List<Document> createdUpcomingRooms = await databases.listDocuments(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        queries: [
          Query.equal("creatorUid", [uid])
        ]).then((value) => value.documents);
    for (var upcomingRoom in createdUpcomingRooms) {
      List<dynamic> creatorFcmTokens =
          upcomingRoom.data['creator_fcm_tokens'];
      creatorFcmTokens.remove(fcmToken!);
      databases.updateDocument(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          documentId: upcomingRoom.$id,
          data: {"creator_fcm_tokens": creatorFcmTokens});
    }
  }

  Future<void> signup(String email, String password) async {
    log("About to create");
    await account.create(userId: ID.unique(), email: email, password: password);
    log("Created");
    await account.createEmailPasswordSession(email: email, password: password);
    await setUserProfileData();
  }

  Future<void> loginWithGoogle() async {
    await account.createOAuth2Session(provider: OAuthProvider.google);
    await isUserLoggedIn();
  }

  Future<void> loginWithGithub() async {
    await account.createOAuth2Session(provider: OAuthProvider.github);
    await isUserLoggedIn();
  }

  Future<void> logout(BuildContext context) async {
    Get.defaultDialog(
      title: "Are you sure?",
      middleText: "You are logging out of Resonate.",
      textConfirm: "Yes",
      backgroundColor: Theme.of(context).colorScheme.surface,
      buttonColor: Theme.of(context).colorScheme.primary,
      confirmTextColor: Theme.of(context).colorScheme.onPrimary,
      textCancel: "No",
      cancelTextColor: Theme.of(context).colorScheme.primary,
      titlePadding: EdgeInsets.only(top: UiSizes.height_15),
      contentPadding: EdgeInsets.symmetric(
        vertical: UiSizes.height_20,
        horizontal: UiSizes.width_20,
      ),
      onConfirm: () async {
        await account.deleteSession(sessionId: 'current');
        await removeRegistrationTokenFromSubscribedUpcomingRooms();
        Get.offAllNamed(AppRoutes.welcomeScreen);
      },
    );
  }
}
