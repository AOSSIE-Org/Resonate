import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class ApiService {
  final Functions functions = Functions(AppwriteService.getClient());

  Future<Map<String, dynamic>> createRoom(
    String roomName,
    String roomDescription,
    String adminUid,
    List<String> roomTags,
  ) async {
    final data = {
      "name": roomName,
      "description": roomDescription,
      "adminUid": adminUid,
      "tags": roomTags,
    };

    try {
      final response = await functions.createExecution(
        functionId: createRoomServiceId,
        body: json.encode(data),
      );

      if (response.responseStatusCode == 200) {
        log(response.responseBody);

        final Map<String, dynamic> responseData = jsonDecode(
          response.responseBody,
        );

        return responseData;
      } else {
        throw Exception(
          '${response.responseStatusCode}: ${response.responseBody}',
        );
      }
    } on AppwriteException catch (error) {
      throw Exception('ERROR $error');
    }
  }

  Future<Map<String, dynamic>> joinRoom(String roomName, String uid) async {
    final data = {"roomName": roomName, "uid": uid};

    try {
      final response = await functions.createExecution(
        functionId: joinRoomServiceId,
        body: json.encode(data),
      );

      if (response.responseStatusCode == 200) {
        log(response.responseBody);

        final Map<String, dynamic> responseData = jsonDecode(
          response.responseBody,
        );

        return responseData;
      } else {
        throw Exception(
          '${response.responseStatusCode}: ${response.responseBody}',
        );
      }
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }

  Future<Map<String, dynamic>> deleteRoom(
    String appwriteRoomDocId,
    String token,
  ) async {
    final data = {"appwriteRoomDocId": appwriteRoomDocId, "token": token};

    try {
      final response = await functions.createExecution(
        functionId: deleteRoomServiceId,
        body: json.encode(data),
      );

      if (response.responseStatusCode == 200) {
        log(response.responseBody);

        final Map<String, dynamic> responseData = jsonDecode(
          response.responseBody,
        );

        return responseData;
      } else {
        throw Exception(
          '${response.responseStatusCode}: ${response.responseBody}',
        );
      }
    } catch (error) {
      throw Exception('ERROR $error');
    }
  }
}
