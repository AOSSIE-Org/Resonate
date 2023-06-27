import 'dart:convert';
import 'dart:developer';

import 'package:resonate/utils/constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = resonateApiUrl;

  Future<dynamic> createRoom(
      String roomName, String roomDescription, String adminUsername, List<String> roomTags) async {
    final url = Uri.parse('$baseUrl/room/create-room');
    final headers = {'Content-Type': 'application/json'};
    final data = {"name": roomName, "description": roomDescription, "admin_username": adminUsername, "tags": roomTags};
    final body = jsonEncode(data);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      log(response.body);
    } else {
      throw Exception('ERROR: ${response.statusCode}}');
    }
  }

  Future<dynamic> joinRoom(String roomName, String userName) async{
    final url = Uri.parse('$baseUrl/room/join-room');
    final headers = {'Content-Type': 'application/json'};
    final data = {"room_nane": roomName, "username": userName};
    final body = jsonEncode(data);

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      log(response.body);
    } else {
      throw Exception('ERROR: ${response.statusCode}}');
    }
  }

  Future<dynamic> deleteRoom(String appwriteRoomDocId, String token) async{
    final url = Uri.parse('$baseUrl/room/delete-room');
    final headers = {'Content-Type': 'application/json'};
    final data = {"appwriteRoomDocId": appwriteRoomDocId, "token": token};
    final body = jsonEncode(data);

    final response = await http.delete(url, headers: headers, body: body);

    if (response.statusCode == 200){
      log(response.body);
    }else{
      throw Exception('ERROR: ${response.statusCode}');
    }
  }
}
