import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/controllers/discussions_controller.dart';
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

  // initializes FlutterLocalNotifications Plugin provides cross-platform to display local notifications.
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /*
  - Sets up Android notification settings.
  - Registers callback to handle Notification taps(onDidRecieveNotificationResponse)
  - Enables overall notification capability.
  */
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

  /*Code Explaination of onDidReceiveNotificationResponse.
    The below method handles the logic of tapping on a notification
    1.Extract the discussion name from the notification payload.
    2.Fetch the index of the discussion that is obtained after tapping on notification.
    3.Lookup the matching discussion in the controller's list.
    4.Make the ScrollController to get initialized to that offset.
    5.Update tab Controller to switch to discussions tab.
    6.Navigate user to the tabs screen.
   */

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    String name = notificationResponse
        .payload!; //fetching the payload(custom key value pairs).

    DiscussionsController discussionsController =
        Get.find<DiscussionsController>();

    int index = discussionsController.discussions
        .indexWhere((discussion) => discussion.data["name"] == name);

    discussionsController.discussionScrollController.value =
        ScrollController(initialScrollOffset: UiSizes.height_170 * index);

    final TabViewController tabViewController = Get.find<TabViewController>();
    tabViewController.setIndex(1);
    await Get.to(TabViewScreen());
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

  /*
  In the below method,
    it Fetches and sets the user Profile info from Appwrite ,
    and later updates the widgets. 
   */
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

  /*
    In this below method (getAppwriteToken)
    1.Call createJWT() on the account object
    2.This returns a JWT class containing the signed token.
    3.We return just the raw JWT string portion.
   */
  Future<String> getAppwriteToken() async {
    Jwt authToken = await account.createJWT();
    log(authToken.toString());
    return authToken.jwt;
  }

  /*
    In the below method(isUserLoggedIn)
    - all we are trying to know is whether the userProfile is successfully setup or not.
    - If yes then route the ui to tabView.
    - If no then route the ui to onBoarding.
    - If error, check if its a first launch
    - On first launch, show landing page.
    - Otherwise redirect to login screen.
   */
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
    final fcmToken = await messaging.getToken();
    List<Document> subscribedDiscussions = await databases.listDocuments(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        queries: [
          Query.equal("userID", [uid])
        ]).then((value) => value.documents);
    subscribedDiscussions.forEach((subscribtion) {
      List<dynamic> registrationTokens =
          subscribtion.data['registrationTokens'];
      registrationTokens.add(fcmToken!);
      databases.updateDocument(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          documentId: subscribtion.$id,
          data: {"registrationTokens": registrationTokens});
    });
  }

/*
  1. Get the current FCM token for the user's device.
  2. Fetch the list of subscribed Discussion from appwrite collection.
  3. Loop through subscribed discussion.
  4. Get the list of tokens and remove current user's token.
  5. Update the discusion.

  Result: This keeps each discussion's tokens list uptodate as user 
  subscribe/unsubscribe over time.
 */
  Future<void> removeRegistrationTokenfromSubscribedDiscussions() async {
    final fcmToken = await messaging.getToken();
    List<Document> subscribedDiscussions = await databases.listDocuments(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        queries: [
          Query.equal("userID", [uid])
        ]).then((value) => value.documents);
    subscribedDiscussions.forEach((subscribtion) {
      List<dynamic> registrationTokens =
          subscribtion.data['registrationTokens'];
      registrationTokens.remove(fcmToken!);
      databases.updateDocument(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          documentId: subscribtion.$id,
          data: {"registrationTokens": registrationTokens});
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

  //Displays dialog box for confirming the logout decision of user.
  //Then it performs the corresponding task.
  Future<void> logout() async {
    Get.defaultDialog(
      title: "Are you sure?",
      middleText: "You are logging out of Resonate",
      textConfirm: "Yes",
      buttonColor: Colors.amber,
      confirmTextColor: Colors.white,
      textCancel: "No",
      cancelTextColor: Colors.amber,
      contentPadding: EdgeInsets.all(UiSizes.size_15),
      onConfirm: () async {
        await account.deleteSession(sessionId: 'current');
        await removeRegistrationTokenfromSubscribedDiscussions();
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}
