import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class ApiService {
  static const _functionTimeoutDuration = Duration(seconds: 30);
  
  final Functions _functions = Functions(AppwriteService.getClient());

  /// Executes an Appwrite function and safely parses the response.
  Future<Map<String, dynamic>> _executeFunction({
    required String functionId,
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _functions
          .createExecution(
            functionId: functionId,
            body: jsonEncode(payload),
          )
          .timeout(_functionTimeoutDuration);

      final int statusCode = response.responseStatusCode;
      final String responseBody = response.responseBody;

      if (statusCode != 200) {
        throw Exception(
          'Appwrite function failed (status: $statusCode): $responseBody',
        );
      }

      return _decodeResponse(responseBody);
    } on TimeoutException {
      throw Exception(
        'Appwrite function timed out after ${_functionTimeoutDuration.inSeconds} seconds.',
      );
    } on AppwriteException catch (e) {
      throw Exception(
        'AppwriteException: ${e.message ?? 'Unknown Appwrite error'}',
      );
    } catch (e) {
      throw Exception(
        'Unexpected error during function execution: $e',
      );
    }
  }

  /// Safely decodes JSON and guarantees a Map<String, dynamic>.
  Map<String, dynamic> _decodeResponse(String body) {
    if (body.isEmpty) {
      throw Exception(
        'Empty response body from Appwrite function.',
      );
    }

    try {
      final Object? decoded = jsonDecode(body);

      if (decoded is! Map) {
        throw Exception(
          'Unexpected response format: expected JSON object.',
        );
      }

      return Map<String, dynamic>.from(decoded);
    } on FormatException {
      throw Exception(
        'Invalid JSON response from Appwrite function.',
      );
    } catch (e) {
      throw Exception(
        'Failed to parse response: $e',
      );
    }
  }

  Future<Map<String, dynamic>> createRoom(
    String roomName,
    String roomDescription,
    String adminUid,
    List<String> roomTags,
  ) {
    return _executeFunction(
      functionId: createRoomServiceId,
      payload: {
        'name': roomName,
        'description': roomDescription,
        'adminUid': adminUid,
        'tags': roomTags,
      },
    );
  }

  Future<Map<String, dynamic>> joinRoom(
    String roomName,
    String uid,
  ) {
    return _executeFunction(
      functionId: joinRoomServiceId,
      payload: {
        'roomName': roomName,
        'uid': uid,
      },
    );
  }

  Future<Map<String, dynamic>> deleteRoom(
    String appwriteRoomDocId,
    String token,
  ) {
    return _executeFunction(
      functionId: deleteRoomServiceId,
      payload: {
        'appwriteRoomDocId': appwriteRoomDocId,
        'token': token,
      },
    );
  }

  Future<Map<String, dynamic>> createLiveChapterRoom(
    String appwriteRoomId,
    String adminUid,
  ) {
    return _executeFunction(
      functionId: createLiveChapterRoomFunctionId,
      payload: {
        'adminUid': adminUid,
        'appwriteRoomId': appwriteRoomId,
      },
    );
  }

  Future<Map<String, dynamic>> deleteLiveChapterRoom(
    String appwriteRoomDocId,
    String token,
  ) {
    return _executeFunction(
      functionId: deleteLiveChapterRoomFunctionId,
      payload: {
        'appwriteRoomDocId': appwriteRoomDocId,
        'token': token,
      },
    );
  }
}