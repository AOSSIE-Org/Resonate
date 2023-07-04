// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$RoomApi extends RoomApi {
  _$RoomApi([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = RoomApi;

  @override
  Future<Response<dynamic>> createRoom(Map<String, dynamic> data) {
    final Uri $url = Uri.parse('/room/create-room');
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> joinRoom(Map<String, dynamic> data) {
    final Uri $url = Uri.parse('/room/join-room');
    final $body = data;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteRoom(Map<String, dynamic> data) {
    final Uri $url = Uri.parse('/room/delete-room');
    final $body = data;
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
