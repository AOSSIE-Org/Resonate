import 'dart:developer';
import 'dart:async';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/single_room_controller.dart';

class LiveKitController extends GetxController{
  late final Room liveKitRoom;
  late final EventsListener<RoomEvent> listener;
  final String liveKitUri;
  final String roomToken;

  static const maxReconnectionAttempts = 3;
  static const reconnectDelay = Duration(seconds: 2);
  var reconnectAttempts = 0;
  Timer? reconnectTimer;
  final isConnected = false.obs;

  LiveKitController({required this.liveKitUri, required this.roomToken});

  @override
  void onInit() async{
    await connectToRoom();
    liveKitRoom.addListener(onRoomDidUpdate);
    setUpListeners();
    super.onInit();
  }

  @override
  void onClose() async {
    reconnectTimer?.cancel();
    (() async {
      liveKitRoom.removeListener(onRoomDidUpdate);
      await listener.dispose();
      await liveKitRoom.dispose();
    })();
    super.onClose();
  }

  Future<bool> connectToRoom() async {
    try {
      liveKitRoom = Room();
      listener = liveKitRoom.createListener();

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
      
      isConnected.value = true;
      reconnectAttempts = 0;
      return true;
    } catch (error) {
      log('Connection failed: $error');
      return false;
    }
  }

  Future<void> handleDisconnection() async {
    isConnected.value = false;
    
    if (reconnectAttempts < maxReconnectionAttempts) {
      reconnectAttempts++;
      log('Attempting to reconnect: Attempt $reconnectAttempts of $maxReconnectionAttempts');
      
      reconnectTimer?.cancel();
      reconnectTimer = Timer(reconnectDelay, () async {
        final success = await connectToRoom();
        
        if (!success && reconnectAttempts < maxReconnectionAttempts) {
          await handleDisconnection();
        } else if (!success) {
          log('Failed to reconnect after $maxReconnectionAttempts attempts');
          Get.snackbar(
            'Connection Lost',
            'Unable to reconnect to the room. Please try rejoining.',
            duration: const Duration(seconds: 5),
          );
        }
      });
    }
  }

  void onRoomDidUpdate() {
    //Callback which will be called on room update
  }

  void setUpListeners() => listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        log('Room disconnected: reason => ${event.reason}');
        await handleDisconnection();
        
        WidgetsBindingCompatible.instance
            ?.addPostFrameCallback((timeStamp) {
              if (Get.isRegistered<SingleRoomController>()){
                Get.find<SingleRoomController>().leaveRoom();
              }
              else if (Get.isRegistered<PairChatController>()){
                Get.find<PairChatController>().endChat();
              }
        });
      }
    })
    ..on<RoomConnectionStateChangedEvent>((event) {
      if (event.newState == ConnectionState.disconnected) {
        handleDisconnection();
      }
    })
    ..on<RoomRecordingStatusChanged>((event) {
      //context.showRecordingStatusChangedDialog(event.activeRecording);
    });

}
