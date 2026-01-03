import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart' hide Row;

import 'package:get/get.dart';

import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/livekit_controller.dart';
import 'package:resonate/controllers/room_chat_controller.dart';
import 'package:resonate/controllers/rooms_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/appwrite_room.dart';
import 'package:resonate/models/participant.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/screens/room_chat_screen.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';
import 'package:resonate/views/widgets/report_widget.dart';
import 'package:resonate/views/widgets/snackbar.dart';

import '../utils/constants.dart';

class SingleRoomController extends GetxController {
  AuthStateController auth = Get.find<AuthStateController>();
  final RoomsController roomsController = Get.put(RoomsController());
  RxBool isLoading = false.obs;
  late Rx<Participant> me = Participant(
    uid: auth.uid!,
    email: auth.email!,
    name: auth.userName!,
    dpUrl: auth.profileImageUrl!,
    isAdmin: appwriteRoom.isUserAdmin,
    isMicOn: false,
    isModerator: appwriteRoom.isUserAdmin,
    isSpeaker: appwriteRoom.isUserAdmin,
    hasRequestedToBeSpeaker: false,
  ).obs;
  Client client = AppwriteService.getClient();
  final AppwriteRoom appwriteRoom;
  final Realtime realtime = AppwriteService.getRealtime();
  final TablesDB tablesDB = AppwriteService.getTables();
  late final RealtimeSubscription? subscription;
  RxList<Rx<Participant>> participants = <Rx<Participant>>[].obs;

  SingleRoomController({required this.appwriteRoom});

  @override
  void onInit() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await getParticipants();
    getRealtimeStream();
    super.onInit();
  }

  @override
  void onClose() async {
    await subscription?.close();
    await Get.delete<LiveKitController>(force: true);
    Get.offAllNamed(AppRoutes.tabview);
    super.onClose();
  }

  Future<void> addParticipantDataToList(Row participant) async {
    Row userDataDoc = await tablesDB.getRow(
      databaseId: userDatabaseID,
      tableId: usersTableID,
      rowId: participant.data["uid"],
    );
    final p = Rx(
      Participant(
        uid: participant.data["uid"],
        email: userDataDoc.data["email"],
        name: userDataDoc.data["name"],
        dpUrl: userDataDoc.data["profileImageUrl"],
        isAdmin: participant.data["isAdmin"],
        isMicOn: participant.data["isMicOn"],
        isModerator: participant.data["isModerator"],
        isSpeaker: participant.data["isSpeaker"],
        hasRequestedToBeSpeaker:
            participant.data["hasRequestedToBeSpeaker"] ?? false,
      ),
    );
    participants.add(p);
  }

  Future<void> removeParticipantDataFromList(String uid) async {
    participants.removeWhere((p) => p.value.uid == uid);
    if (participants.isEmpty) {
      Get.delete<SingleRoomController>();
    }
  }

  Future<void> updateParticipantDataInList(Map<String, dynamic> payload) async {
    int toBeUpdatedIndex = participants.indexWhere(
      (p) => p.value.uid == payload["uid"],
    );
    participants[toBeUpdatedIndex].value.isModerator = payload["isModerator"];
    participants[toBeUpdatedIndex].value.hasRequestedToBeSpeaker =
        payload["hasRequestedToBeSpeaker"] ?? false;
    participants[toBeUpdatedIndex].value.isMicOn = payload["isMicOn"];
    participants[toBeUpdatedIndex].value.isSpeaker = payload["isSpeaker"];
    if (payload["uid"] == auth.uid &&
        !payload["isSpeaker"] &&
        me.value.isMicOn) {
      turnOffMic();
    }
    update();
  }

  Future<void> getParticipants() async {
    try {
      isLoading.value = true;
      participants.value = <Rx<Participant>>[];
      var participantCollectionRef = await tablesDB.listRows(
        databaseId: masterDatabaseId,
        tableId: participantsTableId,
        queries: [Query.equal('roomId', appwriteRoom.id)],
      );
      for (Row participant in participantCollectionRef.rows) {
        addParticipantDataToList(participant);
      }
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void getRealtimeStream() {
    String channel =
        'databases.$masterDatabaseId.tables.$participantsTableId.rows';
    subscription = realtime.subscribe([channel]);
    subscription?.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        String roomId = data.payload["roomId"];
        if (roomId == appwriteRoom.id) {
          // This event belongs to the room current user is part of
          String updatedUserId = data.payload["uid"];
          String docId = data.payload["\$id"];
          String action = data.events.first.substring(
            channel.length + 1 + docId.length + 1,
          );

          switch (action) {
            case 'create':
              {
                addParticipantDataToList(Row.fromMap(data.payload));
                sortParticipants();
                break;
              }
            case 'update':
              {
                // if the change is related to the current user
                if (updatedUserId == me.value.uid) {
                  me.value.isModerator = data.payload["isModerator"];
                  me.value.hasRequestedToBeSpeaker =
                      data.payload["hasRequestedToBeSpeaker"] ?? false;
                  me.value.isMicOn = data.payload["isMicOn"];
                  me.value.isSpeaker = data.payload["isSpeaker"];
                }
                updateParticipantDataInList(data.payload);
                sortParticipants();
                break;
              }
            case 'delete':
              {
                if (updatedUserId == me.value.uid) {
                  customSnackbar(
                    AppLocalizations.of(Get.context!)!.alert,
                    AppLocalizations.of(Get.context!)!.removedFromRoom,
                    LogType.warning,
                  );
                  await Get.delete<SingleRoomController>();
                } else {
                  removeParticipantDataFromList(data.payload["uid"]);
                  break;
                }
              }
          }
        }
        log(data.payload.toString());
      }
    });
  }

  void sortParticipants() {
    participants.sort((a, b) {
      // Sort by isAdmin (admins first, then non-admins)
      if (b.value.isAdmin && !a.value.isAdmin) return 1;
      if (!b.value.isAdmin && a.value.isAdmin) return -1;

      // If isAdmin is the same, sort by isModerator (moderators first, then non-moderators)
      if (b.value.isModerator && !a.value.isModerator) return 1;
      if (!b.value.isModerator && a.value.isModerator) return -1;

      // Continue sorting by isSpeaker, hasRequestedToBeSpeaker (true first, then false)
      if (b.value.isSpeaker && !a.value.isSpeaker) return 1;
      if (!b.value.isSpeaker && a.value.isSpeaker) return -1;

      if (b.value.hasRequestedToBeSpeaker && !a.value.hasRequestedToBeSpeaker) {
        return 1;
      }
      if (!b.value.hasRequestedToBeSpeaker && a.value.hasRequestedToBeSpeaker) {
        return -1;
      }

      return 0; // If all properties are equal (or if Listener), maintain the current order.
    });
  }

  Future<void> leaveRoom() async {
    loadingDialog(Get.context!);
    await subscription?.close();
    await RoomService.leaveRoom(roomId: appwriteRoom.id);
    Get.delete<SingleRoomController>();
  }

  Future<void> deleteRoom() async {
    try {
      isLoading.value = true;
      await RoomService.deleteRoom(roomId: appwriteRoom.id);
      await roomsController.getRooms();
      Get.delete<SingleRoomController>();
    } catch (e) {
      log(
        "Error in Delete Room Function (SingleRoomController): ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getParticipantDocId(Participant participant) async {
    var participantDocsRef = await tablesDB.listRows(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      queries: [
        Query.equal('roomId', appwriteRoom.id),
        Query.equal('uid', participant.uid),
      ],
    );
    return participantDocsRef.rows.first.$id;
  }

  Future<void> updateParticipantDoc(
    String participantDocId,
    Map<String, dynamic> data,
  ) async {
    await tablesDB.updateRow(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      rowId: participantDocId,
      data: data,
    );
  }

  Future<void> turnOnMic() async {
    await Get.find<LiveKitController>().liveKitRoom.localParticipant
        ?.setMicrophoneEnabled(true);
    await updateParticipantDoc(appwriteRoom.myDocId!, {"isMicOn": true});
    me.value.isMicOn = true;
  }

  Future<void> turnOffMic() async {
    await Get.find<LiveKitController>().liveKitRoom.localParticipant
        ?.setMicrophoneEnabled(false);
    await updateParticipantDoc(appwriteRoom.myDocId!, {"isMicOn": false});
    me.value.isMicOn = false;
  }

  Future<void> raiseHand() async {
    await updateParticipantDoc(appwriteRoom.myDocId!, {
      "hasRequestedToBeSpeaker": true,
    });
    me.value.hasRequestedToBeSpeaker = true;
  }

  Future<void> unRaiseHand() async {
    await updateParticipantDoc(appwriteRoom.myDocId!, {
      "hasRequestedToBeSpeaker": false,
    });
    me.value.hasRequestedToBeSpeaker = false;
  }

  Future<void> makeModerator(Participant participant) async {
    String participantDocId = await getParticipantDocId(participant);
    await updateParticipantDoc(participantDocId, {
      "isSpeaker": true,
      "hasRequestedToBeSpeaker": false,
      "isModerator": true,
    });
  }

  Future<void> removeModerator(Participant participant) async {
    String participantDocId = await getParticipantDocId(participant);
    await updateParticipantDoc(participantDocId, {
      "isSpeaker": false,
      "hasRequestedToBeSpeaker": false,
      "isModerator": false,
    });
  }

  Future<void> reportParticipant(Participant participant) async {
    final bool? didSubmit = await Get.dialog(
      ReportWidget(
        participantName: participant.name,
        participantId: participant.uid,
      ),
    );
    if (didSubmit == true) {
      try {
        await tablesDB.updateRow(
          databaseId: masterDatabaseId,
          tableId: roomsTableId,
          rowId: appwriteRoom.id,
          data: {
            "reportedUsers": [...appwriteRoom.reportedUsers, participant.uid],
          },
        );
        appwriteRoom.reportedUsers.add(participant.uid);
      } catch (e) {
        log(e.toString());
      }
      kickOutParticipant(participant);
    }
  }

  Future<void> makeSpeaker(Participant participant) async {
    String participantDocId = await getParticipantDocId(participant);
    await updateParticipantDoc(participantDocId, {
      "isSpeaker": true,
      "hasRequestedToBeSpeaker": false,
    });
  }

  Future<void> makeListener(Participant participant) async {
    String participantDocId = await getParticipantDocId(participant);
    await updateParticipantDoc(participantDocId, {
      "isSpeaker": false,
      "hasRequestedToBeSpeaker": false,
    });
  }

  Future<void> kickOutParticipant(Participant participant) async {
    String participantDocId = await getParticipantDocId(participant);
    await tablesDB.deleteRow(
      databaseId: masterDatabaseId,
      tableId: participantsTableId,
      rowId: participantDocId,
    );
  }

  void openChatSheet() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (ctx) {
        Get.put(RoomChatController(appwriteRoom: appwriteRoom));
        return RoomChatScreen();
      },
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
    );
  }
}
