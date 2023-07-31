import 'dart:developer';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';

class LiveKitController extends GetxController{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> joinLiveKitRoom({required String liveKitUri, required String roomToken}) async {
    //
    try {

      //create new room
      final liveKitRoom = Room();

      // Create a Listener before connecting
      final listener = liveKitRoom.createListener();

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

}