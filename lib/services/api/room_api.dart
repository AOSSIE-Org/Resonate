import 'package:chopper/chopper.dart';

import '../../utils/constants.dart';

part 'room_api.chopper.dart';

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
    final client = ChopperClient(
      baseUrl: Uri.parse(resonateApiUrl),
      services: [_$RoomApi()],
      converter: const JsonConverter(),
    );
    return _$RoomApi(client);
  }
}
