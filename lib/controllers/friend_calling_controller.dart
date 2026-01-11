import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/audio_device_controller.dart';
import 'package:resonate/controllers/livekit_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/friend_call_model.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/friend_call_status.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class FriendCallingController extends GetxController {
  final Rx<FriendCallModel?> friendCallModel = Rx<FriendCallModel?>(null);

  final TablesDB tables;
  final Functions functions;
  final Realtime realtime;
  final RxBool isMicOn = false.obs;
  final RxBool isLoudSpeakerOn = true.obs;
  RealtimeSubscription? callSubscription;
  FriendCallingController({
    TablesDB? tables,
    Functions? functions,
    Realtime? realtime,
  }) : tables = tables ?? AppwriteService.getTables(),
       functions = functions ?? AppwriteService.getFunctions(),
       realtime = realtime ?? AppwriteService.getRealtime();

  Future<void> startCall(
    String callerName,
    String recieverName,
    String callerUsername,
    String recieverUsername,
    String callerUid,
    String recieverUid,
    String callerProfileImageUrl,
    String recieverProfileImageUrl,
    String livekitRoomId,
    String recieverFCMToken,
  ) async {
    final callModel = FriendCallModel(
      callerName: callerName,
      recieverName: recieverName,
      callerUsername: callerUsername,
      recieverUsername: recieverUsername,
      callerUid: callerUid,
      recieverUid: recieverUid,
      callerProfileImageUrl: callerProfileImageUrl,
      recieverProfileImageUrl: recieverProfileImageUrl,
      livekitRoomId: livekitRoomId,
      callStatus: FriendCallStatus.waiting,
      docId: ID.unique(),
    );
    await tables.createRow(
      databaseId: masterDatabaseId,
      tableId: friendCallsTableId,
      rowId: callModel.docId,
      data: callModel.toJson(),
    );

    final notificationData = {
      "recieverFCMToken": recieverFCMToken,
      "data": {
        "caller_name": callerName,
        "caller_username": callerUsername,
        "caller_profile_image_url": callerProfileImageUrl,
        "caller_uid": callerUid,

        "call_id": callModel.docId,
        "type": "incoming_call",
        "extra": jsonEncode(callModel.toJson()),
        "livekit_room_id": callModel.livekitRoomId,
      },
    };
    await functions.createExecution(
      functionId: startFriendCallFunctionID,
      body: jsonEncode(notificationData),
    );
    friendCallModel.value = callModel;
    listenToCallChanges();

    Get.toNamed(AppRoutes.ringingScreen);
  }

  Future<void> joinCall(dynamic roomId, String userId) async {
    await RoomService.joinLivekitPairChat(roomId: roomId, userId: userId);

    Get.toNamed(AppRoutes.friendCallScreen);
  }

  static Future<void> onCallRecieved(RemoteMessage message) async {
    log(message.data['extra']);
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
    if (!Get.testMode) {
      await FlutterCallkitIncoming.showCallkitIncoming(params);
    }
  }

  Future<void> onAnswerCall(Map<String, dynamic> extra) async {
    final callDoc = await tables.getRow(
      databaseId: masterDatabaseId,
      tableId: friendCallsTableId,
      rowId: extra['call_id'],
    );
    FriendCallModel callModel = FriendCallModel.fromJson(callDoc.data);
    log(callDoc.data.toString());
    log(callModel.toString());
    if (callModel.callStatus == FriendCallStatus.ended) {
      return;
    } else {
      callModel = callModel.copyWith(callStatus: FriendCallStatus.connected);
      await tables.updateRow(
        databaseId: masterDatabaseId,
        tableId: friendCallsTableId,
        rowId: callModel.docId,
        data: callModel.toJson(),
      );
      friendCallModel.value = callModel;
      if (callSubscription == null) {
        listenToCallChanges();
      }
      if (!Get.testMode) {
        await joinCall(callModel.livekitRoomId, callModel.recieverUid);
      }
    }
  }

  Future<void> onDeclinedCall(Map<String, dynamic> extra) async {
    final callDoc = await tables.getRow(
      databaseId: masterDatabaseId,
      tableId: friendCallsTableId,
      rowId: extra['call_id'],
    );
    FriendCallModel callModel = FriendCallModel.fromJson(callDoc.data);

    callModel = callModel.copyWith(callStatus: FriendCallStatus.declined);

    await tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: friendCallsTableId,
      rowId: callModel.docId,
      data: callModel.toJson(),
    );
    friendCallModel.value = callModel;
  }

  Future<void> onEndedCall(Map<String, dynamic> extra) async {
    final callDoc = await tables.getRow(
      databaseId: masterDatabaseId,
      tableId: friendCallsTableId,
      rowId: extra['call_id'],
    );

    FriendCallModel callModel = FriendCallModel.fromJson(callDoc.data);

    callModel = callModel.copyWith(callStatus: FriendCallStatus.ended);
    await tables.updateRow(
      databaseId: masterDatabaseId,
      tableId: friendCallsTableId,
      rowId: callModel.docId,
      data: callModel.toJson(),
    );
    friendCallModel.value = callModel;
    await Get.delete<LiveKitController>(force: true);
    await Get.delete<AudioDeviceController>(force: true);
    if (!Get.testMode) {
      FlutterCallkitIncoming.endAllCalls();
    }
    Get.offNamedUntil(AppRoutes.tabview, (route) => false);
  }

  void listenToCallChanges() async {
    String channel =
        'databases.$masterDatabaseId.tables.$friendCallsTableId.rows.${friendCallModel.value!.docId}';
    callSubscription = realtime.subscribe([channel]);
    callSubscription?.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        if (data.events.first.endsWith('.update')) {
          if (data.payload['callStatus'] == FriendCallStatus.connected.name) {
            friendCallModel.value = friendCallModel.value!.copyWith(
              callStatus: FriendCallStatus.connected,
            );
            if (!Get.testMode) {
              await joinCall(
                friendCallModel.value!.livekitRoomId,
                friendCallModel.value!.callerUid,
              );
            }
          }
          if (data.payload['callStatus'] == FriendCallStatus.ended.name) {
            if (!Get.testMode) {
              FlutterCallkitIncoming.endAllCalls();
            }
            friendCallModel.value = friendCallModel.value!.copyWith(
              callStatus: FriendCallStatus.ended,
            );
            await Get.delete<LiveKitController>(force: true);
            await Get.delete<AudioDeviceController>(force: true);
            Get.offNamedUntil(AppRoutes.tabview, (route) => false);
          }
          if (data.payload['callStatus'] == FriendCallStatus.declined.name) {
            await Get.delete<LiveKitController>(force: true);
            await Get.delete<AudioDeviceController>(force: true);
            if (!Get.testMode) {
              FlutterCallkitIncoming.endAllCalls();
            }
            friendCallModel.value = friendCallModel.value!.copyWith(
              callStatus: FriendCallStatus.declined,
            );
            customSnackbar(
              AppLocalizations.of(Get.context!)!.callDeclined,
              AppLocalizations.of(
                Get.context!,
              )!.callDeclinedTo(friendCallModel.value!.recieverName),
              LogType.info,
            );
            Get.offNamedUntil(AppRoutes.tabview, (route) => false);
          }
        }
      }
    });
  }

  void toggleMic() async {
    isMicOn.value = !isMicOn.value;
    if (!Get.testMode) {
      await Get.find<LiveKitController>().liveKitRoom.localParticipant
          ?.setMicrophoneEnabled(isMicOn.value);
    }
  }

  void toggleLoudSpeaker() {
    isLoudSpeakerOn.value = !isLoudSpeakerOn.value;
    if (!Get.testMode) {
      Hardware.instance.setSpeakerphoneOn(isLoudSpeakerOn.value);
    }
  }
}
