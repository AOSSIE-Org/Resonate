import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/models/participant.dart';

import '../utils/constants.dart';

class SingleRoomController extends GetxController {
  RxBool isLoading = false.obs;
  Client client = Client();
  late final Realtime realtime;
  late final Databases databases;
  late final User user;
  late final RealtimeSubscription subscription;

  RxList participants = <Participant>[].obs;

  @override
  void onInit() async {
    super.onInit();
    client.setEndpoint(appwriteEndpoint).setProject(appwriteProjectId).setSelfSigned(status: true);
    realtime = Realtime(client);
    databases = Databases(client);
    await getParticipants();
    getRealtimeStream();
  }

  @override
  void dispose() {
    subscription.close();
    super.dispose();
  }

  Future<void> getParticipants() async{
    participants.value = [];
     DocumentList participantCollectionRef = await databases.listDocuments(databaseId: "649fe6acadb15f2b0f5c", collectionId: "participants");
     for (var participant in participantCollectionRef.documents){
       //TODO: Get participant info from user data and use it here to create Participant Object
     }
     update();
  }

  void getRealtimeStream() {
    //TODO: Make database ID dynamic
    subscription = realtime.subscribe(['databases.649fe6acadb15f2b0f5c.collections.participants.documents']);
    subscription.stream.listen((response) {
      log(response.toString());
    });
  }
}
