import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/participant.dart';

import '../utils/constants.dart';

class SingleRoomController extends GetxController {
  RxBool isLoading = false.obs;
  Client client = Client();
  final AppwriteRoom appwriteRoom;
  late final Realtime realtime;
  late final Databases databases;
  late final User user;
  late final RealtimeSubscription? subscription;
  RxList participants = <Participant>[].obs;

  SingleRoomController({required this.appwriteRoom});

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
  void onClose() {
    subscription?.close();
    super.onClose();
  }

  Future<void> getParticipants() async{
    try{
      isLoading.value = true;
      participants.value = <Participant>[];
      var participantCollectionRef = await databases.listDocuments(databaseId: masterDatabaseId, collectionId: participantsCollectionId,queries: [Query.equal('roomId', appwriteRoom.id)]);
      for (var participant in participantCollectionRef.documents){
        Document userDataDoc = await databases.getDocument(databaseId: userDatabaseID, collectionId: usersCollectionID, documentId: participant.data["uid"]);
        Participant p = Participant(email: userDataDoc.data["email"], name: userDataDoc.data["name"], dpUrl: userDataDoc.data["profileImageUrl"], isAdmin: participant.data["isAdmin"], isMicOn: participant.data["isAdmin"], isModerator: participant.data["isModerator"], isSpeaker: participant.data["isSpeaker"]);
        participants.add(p);
      }
      update();
    }catch(e){
      log(e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  void getRealtimeStream() {
    //TODO: Make database ID dynamic
    subscription = realtime.subscribe(['databases.$masterDatabaseId.collections.$participantsCollectionId.documents']);
    subscription?.stream.listen((response) {
      log(response.toString());
    });
  }
}
