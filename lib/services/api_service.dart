//import required packages
import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

//ApiService class is used to communicate with AppWrite
class ApiService {
  //Functions is provided by appwrite package
  //functions now holds the AppWrite client obtained from getClient() function defined in AppwriteService(lib\services\appwrite_service.dart)
  final Functions functions = Functions(AppwriteService.getClient());
  //create room function defines a data map containing information about the room to be created
  Future<Map<String, dynamic>> createRoom(String roomName,
      String roomDescription, String adminUid, List<String> roomTags) async {
    final data = {
      "name": roomName,
      "description": roomDescription,
      "adminUid": adminUid,
      "tags": roomTags,
    };
    //decode the data obtained from createExecution() method and return a data map called responseData
    //createExecution is one of the methods defined in Functions class provided by appwrite package.
    try {
      final response = await functions.createExecution(
          functionId: createRoomServiceId, data: json.encode(data));

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

  //joinRoom method has information about
  Future<Map<String, dynamic>> joinRoom(String roomName, String uid) async {
    final data = {
      "roomName": roomName,
      "uid": uid,
    };

    try {
      final response = await functions.createExecution(
          functionId: joinRoomServiceId, data: json.encode(data));

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

  //deleteRoom is used to delete the room from the Appwrite db.
  Future<Map<String, dynamic>> deleteRoom(
      String appwriteRoomDocId, String token) async {
    final data = {
      "appwriteRoomDocId": appwriteRoomDocId,
      "token": token,
    };

    try {
      final response = await functions.createExecution(
          functionId: deleteRoomServiceId, data: json.encode(data));

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
