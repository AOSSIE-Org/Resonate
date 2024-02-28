import 'dart:developer';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/single_room_controller.dart';

class LiveKitController extends GetxController {
  late final Room liveKitRoom;
  late final EventsListener<RoomEvent> listener;
  final String liveKitUri;
  final String roomToken;

  LiveKitController({required this.liveKitUri, required this.roomToken});

  /*
    - In onInit() method, we try to create a new room and join it ,through roomtoken & liveKitURI.
    - Setting up necessary listeners .
   */
  @override
  void onInit() async {
    await joinLiveKitRoom(liveKitUri: liveKitUri, roomToken: roomToken);
    liveKitRoom.addListener(onRoomDidUpdate);
    setUpListeners();
    super.onInit();
  }

  /*
    In the onClose method ,all the resources that were allocated before are released
    to prevent resource exploitation and avoid memory leaks.
   */
  @override
  void onClose() async {
    (() async {
      liveKitRoom.removeListener(onRoomDidUpdate);
      await listener.dispose();
      await liveKitRoom.dispose();
    })();
    super.onClose();
  }

  Future<void> joinLiveKitRoom(
      {required String liveKitUri, required String roomToken}) async {
    //
    try {
      //create new room
      liveKitRoom = Room();

      // Create a Listener before connecting
      listener = liveKitRoom.createListener();

      // Try to connect to the room
      await liveKitRoom.connect(
        liveKitUri,
        roomToken,
        roomOptions: const RoomOptions(
          adaptiveStream: false,
          dynacast: false,
          defaultVideoPublishOptions: VideoPublishOptions(
            simulcast: false,
          ),
        ),
      );
    } catch (error) {
      log('Could not connect $error');
    }
  }

  void onRoomDidUpdate() {
    //Callback which will be called on room update
  }

  /*
  - This below method's purpose is to set up event listeners to handle specific
    events related to rooms, disconnections and recording status changes.
   */
  void setUpListeners() => listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        log('Room disconnected: reason => ${event.reason}');
      }

      /*
      Schedules a callback to run after the current frame completes.
      - Checks if Registered Controllers are :
        1.If SingleRoomController  is registered , calls [leaveRoom()] to initate proper
          room clean up.
        2.If PairChatController is registered, calls [endChat()] to handle chat termination.
       */
      WidgetsBindingCompatible.instance?.addPostFrameCallback((timeStamp) {
        if (Get.isRegistered<SingleRoomController>()) {
          Get.find<SingleRoomController>().leaveRoom();
        } else if (Get.isRegistered<PairChatController>()) {
          Get.find<PairChatController>().endChat();
        }
      });
    })
    ..on<RoomRecordingStatusChanged>((event) {
      //context.showRecordingStatusChangedDialog(event.activeRecording);
    });
}
