import 'package:chopper/chopper.dart';

import '../../utils/constants.dart';

part 'room_api.chopper.dart';

class RoomApiClient {
  static const String baseUrl = resonateApiUrl;
  static ChopperClient? _client;

  static ChopperClient get client {
    if (_client == null) {
      final authHeaders = {
        'Authorization': 'Bearer YOUR_AUTH_TOKEN', //TODO: Update Auth token dynamically
        'Content-Type': 'application/json',
      };

      final interceptors = [
        HeadersInterceptor(authHeaders),
        // Add other interceptors if needed
      ];

      _client = ChopperClient(
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
