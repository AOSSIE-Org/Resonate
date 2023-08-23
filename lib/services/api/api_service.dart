import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:resonate/services/api/room_api.dart';

import '../../utils/constants.dart';

class ApiService {
  final String baseUrl = resonateApiUrl;
  final chopper = RoomApi.create();

  Future<Response<dynamic>> createRoom(
      String roomName, String roomDescription, String adminUid, List<String> roomTags) async {
    final data = {
      "name": roomName,
      "description": roomDescription,
      "adminUid": adminUid,
      "tags": roomTags,
    };

    try {
      final response = await chopper.createRoom(data);
      if (response.isSuccessful) {
        log(response.body.toString());
      } else {
        throw Exception('${response.statusCode}: ${response.error}');
      }

      return response;
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }

  Future<Response<dynamic>> joinRoom(String roomName, String uid) async {
    final data = {
      "roomName": roomName,
      "uid": uid,
    };

    try {
      final response = await chopper.joinRoom(data);

      if (response.isSuccessful) {
        log(response.body.toString());
      } else {
        throw Exception('${response.statusCode}: ${response.error}');
      }

      return response;
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }

  Future<Response<dynamic>> deleteRoom(String appwriteRoomDocId, String token) async {
    final data = {
      "appwriteRoomDocId": appwriteRoomDocId,
      "token": token,
    };

    try {
      final response = await chopper.deleteRoom(data);

      if (response.isSuccessful) {
        log(response.body.toString());
      } else {
        throw Exception('${response.statusCode}: ${response.error}');
      }

      return response;
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }
}
