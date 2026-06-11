import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/livekit_controller.dart';
import 'package:resonate/services/api_service.dart';
import 'package:resonate/utils/constants.dart';

// Legacy GetX-era helper still used by features that haven't been migrated

class RoomService {
  static ApiService apiService = ApiService();

  static Future<void> joinLiveKitRoom(
    String livekitUri,
    String roomToken, {
    bool isLiveChapter = false,
  }) async {
    Get.put(
      LiveKitController(
        liveKitUri: livekitUri,
        roomToken: roomToken,
        isLiveChapter: isLiveChapter,
      ),
      permanent: true,
    );
  }

  static Future<List<String>> createLiveChapterRoom({
    required String appwriteRoomId,
    required String adminUid,
  }) async {
    var response = await apiService.createLiveChapterRoom(
      appwriteRoomId,
      adminUid,
    );
    String appwriteRoomDocId = response["livekit_room"]["name"];
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    const storage = FlutterSecureStorage();
    await storage.write(key: "createdRoomAdminToken", value: livekitToken);
    await storage.write(key: "createdRoomLivekitUrl", value: livekitSocketUrl);

    await joinLiveKitRoom(livekitSocketUrl, livekitToken, isLiveChapter: true);

    return [appwriteRoomDocId];
  }

  static Future<void> joinLiveChapterRoom({
    required roomId,
    required String userId,
  }) async {
    var response = await apiService.joinRoom(roomId, userId);
    String livekitToken = response["access_token"];
    String livekitSocketUrl =
        response["livekit_socket_url"] == "wss://host.docker.internal:7880"
        ? localhostLivekitEndpoint
        : response["livekit_socket_url"];

    await joinLiveKitRoom(livekitSocketUrl, livekitToken, isLiveChapter: true);
  }

  static Future deleteLiveChapterRoom({required roomId}) async {
    const storage = FlutterSecureStorage();
    String? livekitToken = await storage.read(key: "createdRoomAdminToken");
    await apiService.deleteLiveChapterRoom(roomId, livekitToken!);
  }
}
