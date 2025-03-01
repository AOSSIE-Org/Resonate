import 'dart:developer';
import 'dart:async';

import 'package:get/get.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/controllers/single_room_controller.dart';

class LiveKitController extends GetxController {
  late final Room liveKitRoom;
  late final EventsListener<RoomEvent> listener;
  final String liveKitUri;
  final String roomToken;
  final int maxAttempts; // Configurable max retry attempts
  final Duration retryInterval; // Configurable retry delay
  var reconnectAttempts = 0;
  Timer? reconnectTimer;
  final isConnected = false.obs;

  LiveKitController({
    required this.liveKitUri,
    required this.roomToken,
    this.maxAttempts = 3, // Default value
    this.retryInterval = const Duration(seconds: 2), // Default value
  });

  @override
  void onInit() async {
    await connectToRoom(); // Initial connection with retries
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
    // Reset attempts for a fresh connection
    if (reconnectAttempts == 0) reconnectAttempts = 0;

    while (reconnectAttempts < maxAttempts) {
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
        reconnectAttempts = 0; // Reset on success
        log('Connected to room successfully');
        return true;
      } catch (error) {
        reconnectAttempts++;
        log('Connection attempt $reconnectAttempts/$maxAttempts failed: $error');

        if (reconnectAttempts < maxAttempts) {
          await Future.delayed(retryInterval); // Wait before retrying
        } else {
          log('Failed to connect after $maxAttempts attempts');
          Get.snackbar(
            'Connection Failed',
            'Unable to join the room. Please check your network and try again.',
            duration: const Duration(seconds: 5),
          );
          return false;
        }
      }
    }
    return false; // Fallback return (shouldn’t hit this due to loop logic)
  }

  Future<void> handleDisconnection() async {
    isConnected.value = false;

    if (reconnectAttempts < maxAttempts) {
      reconnectAttempts++;
      log('Attempting to reconnect: Attempt $reconnectAttempts of $maxAttempts');

      reconnectTimer?.cancel();
      reconnectTimer = Timer(retryInterval, () async {
        final success = await connectToRoom();

        if (!success && reconnectAttempts < maxAttempts) {
          await handleDisconnection();
        } else if (!success) {
          log('Failed to reconnect after $maxAttempts attempts');
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
    // Callback which will be called on room update
  }

  void setUpListeners() => listener
    ..on<RoomDisconnectedEvent>((event) async {
      if (event.reason != null) {
        log('Room disconnected: reason => ${event.reason}');
        await handleDisconnection();

        WidgetsBindingCompatible.instance?.addPostFrameCallback((timeStamp) {
          if (Get.isRegistered<SingleRoomController>()) {
            Get.find<SingleRoomController>().leaveRoom();
          } else if (Get.isRegistered<PairChatController>()) {
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
      // context.showRecordingStatusChangedDialog(event.activeRecording);
    });
}
