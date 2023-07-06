import 'dart:developer';

import 'package:resonate/services/api/api_service.dart';


class RoomService {
  static ApiService apiService = ApiService();

  static Future<void> joinLiveKitRoom(String livekitUri, String roomToken) async {
    //TODO: Use Livekit SDK to intialize a room object
  }

  static Future createRoom({required String roomName, required String roomDescription, required List<String> roomTags}) async {
    //TODO: Use api service to create a new room and use the received token to call joinLiveKitRoom method
  }

  static Future deleteRoom({required roomName}) async {
    //TODO: Use api service to delete the room (only admins)
  }

  static Future joinRoom({required roomName, required description}) async {
    //TODO: Use api service to generate token and pass it to joinLiveKitRoom method
  }

  static Future leaveRoom({required roomName}) async {
    //TODO: delete the user's document from participants collection and decrement total_participants
  }
}