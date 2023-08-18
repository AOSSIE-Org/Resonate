import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';

class PairChatController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAnonymous = true.obs;
  String languageIso = "en";

  Client client = Client();
  late final Realtime realtime;
  late final Databases databases;
  late final RealtimeSubscription? subscription;

  @override
  void onInit() async {
    client.setEndpoint(appwriteEndpoint).setProject(appwriteProjectId).setSelfSigned(status: true);
    realtime = Realtime(client);
    databases = Databases(client);
    super.onInit();
  }

  void quickMatch() async {
    String uid = Get.find<AuthStateController>().uid!;
    String channel = 'databases.$masterDatabaseId.collections.$activePairsCollectionId.documents';

    // Open realtime stream to check whether the request is paired
    subscription = realtime.subscribe([channel]);
    subscription?.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        String uid1 = data.payload["uid1"];
        String uid2 = data.payload["uid2"];

        // If the request was served and the user was paired
        if (uid1 == uid || uid2 == uid) {
          log(data.toString());
          String pairChatRoomId = data.payload["\$id"];
          await subscription?.close();
          Get.toNamed(AppRoutes.pairChat);
        }
      }
    });

    // Add request to pair-request collection
    await databases.createDocument(
        databaseId: masterDatabaseId,
        collectionId: pairRequestCollectionId,
        documentId: ID.unique(),
        data: {"languageIso": languageIso, "isAnonymous": isAnonymous.value, "uid": uid});

    // Go to pairing screen
    Get.toNamed(AppRoutes.pairing);
  }
}
