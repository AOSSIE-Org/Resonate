import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' hide Theme;
import 'package:appwrite/models.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resonate/controllers/friend_calling_controller.dart';
import 'package:resonate/controllers/friends_controller.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/models/follower_user_model.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/tabview_screen.dart';
import '../routes/app_routes.dart';

import 'package:resonate/l10n/app_localizations.dart';

class AuthStateController extends GetxController {
  Client client;
  final Databases databases;
  var isInitializing = false.obs;
  FirebaseMessaging messaging;
  late final Account account;

  AuthStateController({
    Account? account,
    Databases? databases,
    Client? client,
    FirebaseMessaging? messaging,
  }) : client = client ?? AppwriteService.getClient(),
       account = account ?? AppwriteService.getAccount(),
       databases = databases ?? AppwriteService.getDatabases(),
       messaging = messaging ?? FirebaseMessaging.instance;
  late String? uid;
  late String? profileImageID;
  late String? displayName;
  late String? email;
  late String? profileImageUrl;
  late String? userName;
  late bool? isUserProfileComplete;
  late bool? isEmailVerified;
  late double ratingTotal;
  late int ratingCount;
  late User appwriteUser;
  late List<FollowerUserModel> followerDocuments;
  late int reportsCount;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
  static NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    String name = notificationResponse.payload!;
    UpcomingRoomsController upcomingRoomsController =
        Get.find<UpcomingRoomsController>();
    int index = upcomingRoomsController.upcomingRooms.indexWhere(
      (upcomingRoom) => upcomingRoom.name == name,
    );

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
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // Check if can use full screen intent
    if (!Get.testMode) {
      await FlutterCallkitIncoming.canUseFullScreenIntent();

      // Request full intent permission
      await FlutterCallkitIncoming.requestFullIntentPermission();
    }

    await initializeLocalNotifications();

    // Listen to notitifcations in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Got a message whilst in the foreground!');
      if (message.data['type'] == 'incoming_call') {
        log('saw incoming call');

        await FriendCallingController.onCallRecieved(message);
      }
      if (message.notification != null) {
        RegExp exp = RegExp(r'The room (\w+) will Start Soon');
        RegExpMatch? matches = exp.firstMatch(message.notification!.body!);

        if (matches != null) {
          String discussionName = matches.group(1)!;

          // send local notification
          await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            notificationDetails,
            payload: discussionName,
          );
        } else {
          await flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title,
            message.notification!.body,
            notificationDetails,
          );
        }
      }
    });
    if (!Get.testMode) {
      final friendCallingController = Get.put(
        FriendCallingController(),
        permanent: true,
      );
      FlutterCallkitIncoming.onEvent.listen((CallEvent? event) {
        if (event!.event == Event.actionCallAccept) {
          log(event.body['extra'].toString());

          friendCallingController.onAnswerCall(
            Map<String, dynamic>.from(event.body['extra']),
          );
        }
        if (event.event == Event.actionCallDecline) {
          friendCallingController.onDeclinedCall(
            Map<String, dynamic>.from(event.body['extra']),
          );
          FlutterCallkitIncoming.showMissCallNotification(CallKitParams());
        }
      });
    }
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
          documentId: appwriteUser.$id,
        );
        profileImageUrl = userDataDoc.data["profileImageUrl"];
        profileImageID = userDataDoc.data["profileImageID"];
        userName = userDataDoc.data["username"] ?? "unavailable";
        ratingTotal = userDataDoc.data["ratingTotal"].toDouble() ?? 5;
        ratingCount = userDataDoc.data["ratingCount"] ?? 1;
        followerDocuments =
            (userDataDoc.data["followers"] as List<dynamic>?)?.map((e) {
              return FollowerUserModel.fromJson(e);
            }).toList() ??
            [];
        reportsCount =
            (userDataDoc.data['userReports'] as List<dynamic>?)?.length ?? 0;
      }

      update();
      if (!Get.testMode) {
        Get.put(FriendsController(), permanent: true);
      }
    } catch (e) {
      log("Error originating from setUserProfileData$e");
    } finally {
      isInitializing.value = false;
    }
  }

  Future<void> isUserLoggedIn() async {
    try {
      await setUserProfileData();
      if (reportsCount > 5) {
        Get.offNamed(AppRoutes.userBlockedScreen);
        return;
      }
      if (isUserProfileComplete == false) {
        Get.offNamed(AppRoutes.onBoarding);
      } else {
        Get.offNamed(AppRoutes.tabview);
        final activeCalls = await FlutterCallkitIncoming.activeCalls();
        if (activeCalls.isNotEmpty) {
          final activeCall = activeCalls.last;
          await Get.find<FriendCallingController>().onAnswerCall(
            Map<String, dynamic>.from(activeCall['extra']),
          );
        }
      }
    } catch (e) {
      log("Error in isUserLoggedIn$e");
      bool? landingScreenShown = GetStorage().read(
        "landingScreenShown",
      ); // landingScreenShown is the boolean value that is used to check wether to show the user the onboarding screen or not on the first launch of the app.
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
    List<Document> subscribedUpcomingRooms = await databases
        .listDocuments(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          queries: [
            Query.equal("userID", [uid]),
          ],
        )
        .then((value) => value.documents);
    for (var subscription in subscribedUpcomingRooms) {
      List<dynamic> registrationTokens =
          subscription.data['registrationTokens'];
      registrationTokens.add(fcmToken!);
      databases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: subscription.$id,
        data: {"registrationTokens": registrationTokens},
      );
    }

    //created Upcoming Rooms
    List<Document> createdUpcomingRooms = await databases
        .listDocuments(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          queries: [
            Query.equal("creatorUid", [uid]),
          ],
        )
        .then((value) => value.documents);
    for (var upcomingRoom in createdUpcomingRooms) {
      List<dynamic> creatorFcmTokens = upcomingRoom.data['creator_fcm_tokens'];
      creatorFcmTokens.add(fcmToken!);
      databases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        documentId: upcomingRoom.$id,
        data: {"creator_fcm_tokens": creatorFcmTokens},
      );
    }
  }

  Future<void> removeRegistrationTokenFromSubscribedUpcomingRooms() async {
    final fcmToken = await messaging.getToken();

    //subscribed Upcoming Rooms
    List<Document> subscribedUpcomingRooms = await databases
        .listDocuments(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: subscribedUserCollectionId,
          queries: [
            Query.equal("userID", [uid]),
          ],
        )
        .then((value) => value.documents);
    for (var subscription in subscribedUpcomingRooms) {
      List<dynamic> registrationTokens =
          subscription.data['registrationTokens'];
      registrationTokens.remove(fcmToken!);
      databases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: subscribedUserCollectionId,
        documentId: subscription.$id,
        data: {"registrationTokens": registrationTokens},
      );
    }

    //created Upcoming Rooms
    List<Document> createdUpcomingRooms = await databases
        .listDocuments(
          databaseId: upcomingRoomsDatabaseId,
          collectionId: upcomingRoomsCollectionId,
          queries: [
            Query.equal("creatorUid", [uid]),
          ],
        )
        .then((value) => value.documents);
    for (var upcomingRoom in createdUpcomingRooms) {
      List<dynamic> creatorFcmTokens = upcomingRoom.data['creator_fcm_tokens'];
      creatorFcmTokens.remove(fcmToken!);
      databases.updateDocument(
        databaseId: upcomingRoomsDatabaseId,
        collectionId: upcomingRoomsCollectionId,
        documentId: upcomingRoom.$id,
        data: {"creator_fcm_tokens": creatorFcmTokens},
      );
    }
  }

  Future<void> signup(String email, String password) async {
    await account.create(userId: ID.unique(), email: email, password: password);
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
      title: AppLocalizations.of(context)!.areYouSure,
      middleText: AppLocalizations.of(context)!.loggingOut,
      textConfirm: AppLocalizations.of(context)!.yes,
      backgroundColor: Theme.of(context).colorScheme.surface,
      buttonColor: Theme.of(context).colorScheme.primary,
      confirmTextColor: Theme.of(context).colorScheme.onPrimary,
      textCancel: AppLocalizations.of(context)!.no,
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
