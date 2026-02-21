import 'dart:async';
import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/utils/constants.dart';

class ApiService {
  static const Duration _functionTimeoutDuration =
      Duration(seconds: 30);

  final Functions _functions =
      Functions(AppwriteService.getClient());

  Future<Map<String, dynamic>> _executeFunction({
    required String functionId,
    required Map<String, dynamic> payload,
  }) async {
    late final Execution response;

    try {
      response = await _functions
          .createExecution(
            functionId: functionId,
            body: jsonEncode(payload),
          )
          .timeout(_functionTimeoutDuration);
    } on TimeoutException {
      throw Exception(
        'Appwrite function timed out after ${_functionTimeoutDuration.inSeconds} seconds.',
      );
    } on AppwriteException catch (e) {
      throw Exception(
        'AppwriteException: ${e.message ?? 'Unknown Appwrite error'}',
      );
    }

    final int statusCode = response.responseStatusCode;
    final String responseBody = response.responseBody;

    if (statusCode != 200) {
      throw Exception(
        'Appwrite function failed (status: $statusCode): $responseBody',
      );
    }

    return _decodeResponse(responseBody);
  }

  Map<String, dynamic> _decodeResponse(String body) {
    if (body.isEmpty) {
      throw Exception(
        'Empty response body from Appwrite function.',
      );
    }

    final Object? decoded;

    try {
      decoded = jsonDecode(body);
    } on FormatException {
      throw Exception(
        'Invalid JSON response from Appwrite function.',
      );
    }

    if (decoded is! Map) {
      throw Exception(
        'Unexpected response format: expected JSON object.',
      );
    }

    return Map<String, dynamic>.from(decoded);
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