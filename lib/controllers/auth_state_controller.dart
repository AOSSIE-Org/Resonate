//import required packages
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/controllers/discussions_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import '../routes/app_routes.dart';

//AuthStateController is responsible for managing the authentication state of the application, handling user login, signup, logout.
class AuthStateController extends GetxController {
  //client is an instance of Client class provided by appwrite package
  //it is responsible for connecting to AppWrite server.
  Client client = AppwriteService.getClient();
  //fetch the databases from Appwrite server
  final Databases databases = AppwriteService.getDatabases();
  //reactive bool for checking the initialization of AuthStateController.
  var isInitializing = false.obs;
  //FirebaseMessaging is provided by firebase_messaging package
  //This is used for handling push notifications.
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //create an instance of Account class provided by appwrite package
  late final Account account;
  //variables storing information about the users
  late String? uid;
  late String? profileImageID;
  late String? displayName;
  late String? email;
  late String? profileImageUrl;
  late String? userName;
  late bool? isUserProfileComplete;
  late bool? isEmailVerified;
  late User appwriteUser;
  //FlutterLocalNotificationsPlugin is provided by flutter_local_notifications package and is used to display notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  //initializeLocalNotifications() method is used to initialize local notifications using flutter_local_notifications package
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
    String name = notificationResponse.payload!;
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

  //onInit() is called when controller is loaded into memory
  //When the AuthStateController is initialized first the Firebase messaging, local notifications, and user profile are set up.
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

  //getLoginState is a getter which checks weather user is logged in or not
  Future<bool> get getLoginState async {
    try {
      appwriteUser = await account.get();
      return true;
    } catch (e) {
      return false;
    }
  }

  //setUserProfileData() is a method that fetches information of the user from the Appwrite server
  Future<void> setUserProfileData() async {
    isInitializing.value =
        true; //mark the AuthStateController isInitializing property to true
    try {
      appwriteUser = await account
          .get(); //use the get() function from AppWrite class to fetch user info
      displayName = appwriteUser.name;
      email = appwriteUser.email;
      isEmailVerified = appwriteUser.emailVerification;
      uid = appwriteUser.$id;
      isUserProfileComplete =
          appwriteUser.prefs.data["isUserProfileComplete"] ?? false;
      if (isUserProfileComplete == true) {
        //get the document associated with the user from AppWrite db using getDocument() function
        //values associated with the db files are stored in lib\utils\constants.dart.
        Document userDataDoc = await databases.getDocument(
            databaseId: userDatabaseID,
            collectionId: usersCollectionID,
            documentId: appwriteUser
                .$id); //access the document associated with user by using the uid of user
        profileImageUrl = userDataDoc.data["profileImageUrl"];
        profileImageID = userDataDoc.data["profileImageID"];
        userName = userDataDoc.data["username"] ?? "unavailable";
      }
      update(); //update function is used to notify GetBuilder that the data stored in reactive variables is updated(not required by ObX or GetX)
    } catch (e) {
      log(e.toString());
    } finally {
      isInitializing.value =
          false; //after the user data is set mark the AuthStateController isInitializing property to false
    }
  }

  //getAppwriteToken() is used for creating an appwrite token required for working with AppWrite server
  Future<String> getAppwriteToken() async {
    Jwt authToken = await account.createJWT();
    log(authToken.toString());
    return authToken.jwt;
  }

  //check weather the user is logged in or not and navigate to a specific route
  Future<void> isUserLoggedIn() async {
    try {
      await setUserProfileData();
      //if the user profile is incomplete navigate to onboarding sccreen
      if (isUserProfileComplete == false) {
        Get.offNamed(AppRoutes.onBoarding);
      } else {
        //else Navigate to tabview
        Get.offNamed(AppRoutes.tabview);
      }
    } catch (e) {
      bool? landingScreenShown = GetStorage().read(
          "landingScreenShown"); // landingScreenShown is the boolean value that is used to check wether to show the user the onboarding screen or not on the first launch of the app.
      landingScreenShown ==
              null //if the landingScreenShown value if null go to login else show landing screen
          ? Get.offNamed(AppRoutes.landing)
          : Get.offNamed(AppRoutes.login);
    }
  }

  //login() method provides login functionality
  Future<void> login(String email, String password) async {
    //Account class of appwrite package provides createEmailSession() method
    //that allows users to login using their email and password
    await account.createEmailSession(email: email, password: password);
    await isUserLoggedIn();
    await addRegistrationTokentoSubscribedDiscussions();
  }

  //addRegistrationTokentoSubscribedDiscussions() method add the token associated with user
  //to subscribed discussions
  Future<void> addRegistrationTokentoSubscribedDiscussions() async {
    //first get the FCM token for device on which user is logged in
    //getToken() is provided by firebase_messaging package
    final fcmToken = await messaging.getToken();
    //find the discussions that the user is subscribed to.
    List<Document> subscribedDiscussions = await databases.listDocuments(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        queries: [
          Query.equal("userID", [uid]) //if  value of uid is equal to "userID"
        ]).then((value) =>
        value.documents); //then add the document to subscribedDiscussions

    //add token to each document in subscribedDiscussions
    subscribedDiscussions.forEach((subscribtion) {
      List<dynamic> registrationTokens =
          subscribtion.data['registrationTokens'];
      registrationTokens.add(fcmToken!);
      //update the databasse after adding token
      databases.updateDocument(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          documentId: subscribtion.$id,
          data: {"registrationTokens": registrationTokens});
    });
  }

  //removeRegistrationTokenfromSubscribedDiscussions() method removes the token associated with user
  //from subscribed discussions
  Future<void> removeRegistrationTokenfromSubscribedDiscussions() async {
    //first get the FCM token for device on which user is logged in
    //getToken() is provided by firebase_messaging package
    final fcmToken = await messaging.getToken();
    //find the discussions that the user is subscribed to.
    List<Document> subscribedDiscussions = await databases.listDocuments(
        databaseId: "6522fcf27a1bbc4238df",
        collectionId: "6522fd267db6fdad3392",
        queries: [
          Query.equal("userID", [uid]) //if  value of uid is equal to "userID"
        ]).then((value) =>
        value.documents); //then add the document to subscribedDiscussions

    //remove token from each document in subscribedDiscussions
    subscribedDiscussions.forEach((subscribtion) {
      List<dynamic> registrationTokens =
          subscribtion.data['registrationTokens'];
      registrationTokens.remove(fcmToken!);

      //update the databasse after removing token
      databases.updateDocument(
          databaseId: '6522fcf27a1bbc4238df',
          collectionId: '6522fd267db6fdad3392',
          documentId: subscribtion.$id,
          data: {"registrationTokens": registrationTokens});
    });
  }

  //login() method provides signup functionality
  Future<void> signup(String email, String password) async {
    //use the create() method from Account class of appwrite package
    //create() method allows users to create an account using email and password
    //ID class is also provided by appwrite package that creates a unique id for each user
    await account.create(userId: ID.unique(), email: email, password: password);
    //after the account has been created create a new login session.
    await account.createEmailSession(email: email, password: password);
    //call setUserProfileData() to fetch user data
    await setUserProfileData();
  }

  //implement loginWithGoogle functionality
  Future<void> loginWithGoogle() async {
    //usse google as auth provider to create auth session using createOAuth2Session() method of Account class
    await account.createOAuth2Session(provider: 'google');
    await isUserLoggedIn();
  }

//implement loginWithGithub functionality
  Future<void> loginWithGithub() async {
    //usse github as auth provider to create auth session using createOAuth2Session() method of Account class
    await account.createOAuth2Session(provider: 'github');
    await isUserLoggedIn();
  }

  //logout function is used to provide logout functionality
  Future<void> logout() async {
    //show a defaulDialog taht confirms weather user wants to logout
    Get.defaultDialog(
      title: "Are you sure?",
      middleText: "You are logging out of Resonate",
      textConfirm: "Yes",
      buttonColor: Colors.amber,
      confirmTextColor: Colors.white,
      textCancel: "No",
      cancelTextColor: Colors.amber,
      contentPadding: EdgeInsets.all(UiSizes.size_15),
      //if button with "Yes" is pressed then
      //delete the current session
      //remove the token from discussions subscribed by user.
      onConfirm: () async {
        await account.deleteSession(sessionId: 'current');
        await removeRegistrationTokenfromSubscribedDiscussions();
        //Navigate to Login screen and remove all other routes from app's stack
        Get.offAllNamed(AppRoutes.login);
      },
    );
  }
}
