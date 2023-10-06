import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class ApiService {

  final Functions functions = Functions(AppwriteService.getClient());

  Future<Map<String, dynamic>> createRoom(
      String roomName, String roomDescription, String adminUid, List<String> roomTags) async {
    final data = {
      "name": roomName,
      "description": roomDescription,
      "adminUid": adminUid,
      "tags": roomTags,
    };

    try {
      final response = await functions.createExecution(functionId: createRoomServiceId, data: json.encode(data));

      if (response.statusCode == 200) {
        log(response.response);
        
        final Map<String, dynamic> responseData = jsonDecode(response.response);

        return responseData;
      } else {
        throw Exception('${response.statusCode}: ${response.response}');
      }
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }

  Future<Map<String, dynamic>> joinRoom(String roomName, String uid) async {
    final data = {
      "roomName": roomName,
      "uid": uid,
    };

    try {
      final response = await functions.createExecution(functionId: joinRoomServiceId, data: json.encode(data));

      if (response.statusCode == 200) {
        log(response.response);

        final Map<String, dynamic> responseData = jsonDecode(response.response);

        return responseData;
      } else {
        throw Exception('${response.statusCode}: ${response.response}');
      }
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }

  Future<Map<String, dynamic>> deleteRoom(String appwriteRoomDocId, String token) async {
    final data = {
      "appwriteRoomDocId": appwriteRoomDocId,
      "token": token,
    };

    try {
      final response = await functions.createExecution(functionId: deleteRoomServiceId, data: json.encode(data));

      if (response.statusCode == 200) {
        log(response.response);

        final Map<String, dynamic> responseData = jsonDecode(response.response);

        return responseData;
      } else {
        throw Exception('${response.statusCode}: ${response.response}');
      }
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }
}
