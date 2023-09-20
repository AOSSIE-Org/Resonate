import 'dart:async';

import 'package:chopper/chopper.dart' hide Get;
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:get/get.dart' hide Response;
import 'package:resonate/controllers/auth_state_controller.dart';

import '../../utils/constants.dart';

part 'room_api.chopper.dart';

class AuthInterceptor implements RequestInterceptor {
  @override
  FutureOr<Request> onRequest(Request request) async {
    final authToken = await Get.find<AuthStateController>().getAppwriteToken();
    final authHeaders = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };
    return request.copyWith(headers: {...request.headers, ...authHeaders});
  }
}

class RoomApiClient {
  static const String baseUrl = resonateApiUrl;
  static ChopperClient? _client;

  static ChopperClient get client {
    if (_client == null) {

      final interceptors = [
        AuthInterceptor(),
        // Add other interceptors if needed
      ];

      _client = ChopperClient(
        client: RetryClient(http.Client()),
        baseUrl: Uri.parse(baseUrl),
        services: [_$RoomApi()],
        converter: const JsonConverter(),
        interceptors: interceptors,
      );
    }

    return _client!;
  }
}

@ChopperApi(baseUrl: '/room')
abstract class RoomApi extends ChopperService {
  @Post(path: 'create-room')
  Future<Response<dynamic>> createRoom(
      @Body() Map<String, dynamic> data,
      );

  @Post(path: 'join-room')
  Future<Response<dynamic>> joinRoom(
      @Body() Map<String, dynamic> data,
      );

  @Delete(path: 'delete-room')
  Future<Response<dynamic>> deleteRoom(
      @Body() Map<String, dynamic> data,
      );

  static RoomApi create() {
    final client = RoomApiClient.client;
    return _$RoomApi(client);
  }
}
