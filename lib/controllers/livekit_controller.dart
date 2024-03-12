//import required packages
import 'dart:developer';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/single_room_controller.dart';

//LiveKitController defines methods which allows the user to join liveKit room with the help of livekit_client package
//LiveKit is a platform that allows integation of realtime audio and video features into flutter app
class LiveKitController extends GetxController{
  late final Room liveKitRoom;  //instance of Room class proivded by the livekit_client package
  late final EventsListener<RoomEvent> listener; //create a Listener that will listen to the changes in RoomEvent also provided by livekit_client package
  final String liveKitUri; //Url to the LiveKit room
  final String roomToken; //the unique token of the LiveKit room

  LiveKitController({required this.liveKitUri, required this.roomToken});

  @override
  void onInit() async{
    //call joinLiveKitRoom() method that allows to connect to a LiveKit room
    await joinLiveKitRoom(liveKitUri: liveKitUri, roomToken: roomToken);
    //ad listener which listens to the LiveKit room changes
    liveKitRoom.addListener(onRoomDidUpdate);
    setUpListeners();
    super.onInit();
  }

  @override
  void onClose() async {
    (() async {
      //remove listeners when controlller is removed from the memory
      liveKitRoom.removeListener(onRoomDidUpdate);
      await listener.dispose();
      await liveKitRoom.dispose();
    })();
    super.onClose();
  }

  //joinLiveKitRoom() method connects to the LiveKit servers that allows user to join LiveKit room
  //joinLiveKitRoom() method takes a livekit room url and a room token unique to the room
  Future<void> joinLiveKitRoom({required String liveKitUri, required String roomToken}) async {
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

  //setUpListeners() method listens to the EventChanges of a RoomEvent
  void setUpListeners() => listener
    ..on<RoomDisconnectedEvent>((event) async { //listen to the changes on disconnection of a room
      if (event.reason != null) {
        log('Room disconnected: reason => ${event.reason}');
      }
      WidgetsBindingCompatible.instance
          ?.addPostFrameCallback((timeStamp) {
            if (Get.isRegistered<SingleRoomController>()){
              Get.find<SingleRoomController>().leaveRoom(); //find SingleRoomController from memory and call leaveRoom() to leave the room
            }
            else if (Get.isRegistered<PairChatController>()){
              Get.find<PairChatController>().endChat(); // //find PairChatController from memory and call endChat() to end the chat
            }
      });
    })
    ..on<RoomRecordingStatusChanged>((event) {
      //context.showRecordingStatusChangedDialog(event.activeRecording);
    });

}