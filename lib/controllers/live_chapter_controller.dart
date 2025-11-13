import 'dart:convert';
import 'dart:developer';
import 'dart:io' as io;

import 'package:appwrite/appwrite.dart';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/controllers/livekit_controller.dart';
import 'package:resonate/controllers/whisper_transcription_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/live_chapter_attendees_model.dart';
import 'package:resonate/models/live_chapter_model.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/services/appwrite_service.dart';
import 'package:resonate/services/room_service.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/views/screens/verify_chapter_details_screen.dart';
import 'package:resonate/views/widgets/loading_dialog.dart';

class LiveChapterController extends GetxController {
  Rx<LiveChapterModel?> liveChapterModel = Rx<LiveChapterModel?>(null);
  final Databases databases;
  final Realtime realtime;
  final Functions functions;
  final AuthStateController authStateController;
  RxBool isMicOn = false.obs;
  RealtimeSubscription? liveChapterAttendeesSubscription;

  LiveChapterController({
    Databases? databases,
    Realtime? realtime,
    Functions? functions,
    AuthStateController? authStateController,
  }) : databases = databases ?? AppwriteService.getDatabases(),
       realtime = realtime ?? AppwriteService.getRealtime(),
       functions = functions ?? AppwriteService.getFunctions(),
       authStateController =
           authStateController ?? Get.find<AuthStateController>();

  void listenForAttendeesAdded() async {
    String channel =
        "databases.$userDatabaseID.collections.$liveChapterAttendeesCollectionId.documents.${liveChapterModel.value!.id}";
    liveChapterAttendeesSubscription = realtime.subscribe([channel]);
    liveChapterAttendeesSubscription?.stream.listen((data) async {
      if (data.payload.isNotEmpty) {
        if (data.events.first.endsWith('.update')) {
          log("update detected");
          final newLiveChapterAttendees = LiveChapterAttendeesModel.fromJson(
            data.payload,
          );
          liveChapterModel.value = liveChapterModel.value!.copyWith(
            attendees: newLiveChapterAttendees,
          );
        }
        if (data.events.first.endsWith('.delete')) {
          log("delete detected");
          if (!isAdmin) {
            await liveChapterAttendeesSubscription?.close();
            await Get.delete<LiveKitController>(force: true);

            Get.offAllNamed(AppRoutes.tabview);
            Get.delete<LiveChapterController>();
          }
        }
      }
    });
  }

  Future<void> startLiveChapter(
    String roomId,
    String chapterTitle,
    String chapterDescription,
    String storyId,
    String storyName,
  ) async {
    try {
      final liveChapterData = LiveChapterModel(
        livekitRoomId: roomId,
        authorUid: authStateController.uid!,
        authorProfileImageUrl: authStateController.profileImageUrl!,
        authorName: authStateController.displayName!,
        chapterTitle: chapterTitle,
        chapterDescription: chapterDescription,
        storyId: storyId,
        followersFCMToken: authStateController.followerDocuments
            .map((e) => e.fcmToken)
            .toList(),
        attendees: LiveChapterAttendeesModel(
          liveChapterId: roomId,
          users: List.empty(),
          userIds: List.empty(),
        ),
        id: roomId,
      );
      await databases.createDocument(
        databaseId: storyDatabaseId,
        collectionId: liveChaptersCollectionId,
        documentId: roomId,
        data: liveChapterData.toJson(),
      );
      await databases.createDocument(
        databaseId: userDatabaseID,
        collectionId: liveChapterAttendeesCollectionId,
        documentId: roomId,
        data: liveChapterData.attendees!.toJson(),
      );
      await RoomService.createLiveChapterRoom(
        appwriteRoomId: liveChapterData.livekitRoomId,
        adminUid: authStateController.uid!,
      );
      liveChapterModel.value = liveChapterData;
      if (authStateController.followerDocuments.isNotEmpty) {
        log('Sending notification for created story');
        var body = json.encode({
          'creatorId': authStateController.uid,
          'payload': {
            'title': 'Live Chapter Starting!',
            'body':
                "${authStateController.displayName} is starting a Live Chapter in ${storyName}: ${liveChapterData.chapterTitle}. Tune In!",
          },
        });
        var results = await functions.createExecution(
          functionId: sendStoryNotificationFunctionID,
          body: body.toString(),
        );
        log(results.status.name);
      }
      listenForAttendeesAdded();
      Get.toNamed(AppRoutes.liveChapterScreen);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> joinLiveChapter(
    String roomId,

    LiveChapterModel liveChapterData,
  ) async {
    try {
      final newAttendeesModel = liveChapterData.attendees!.copyWith(
        userIds: [
          ...liveChapterData.attendees!.users.map(
            (element) => element["\$id"] as String,
          ),
          authStateController.uid!,
        ],
        users: [
          ...liveChapterData.attendees!.users,
          {
            "\$id": authStateController.uid!,
            "name": authStateController.displayName,
            "profileImageUrl": authStateController.profileImageUrl,
          },
        ],
      );
      log(newAttendeesModel.toJson().toString());

      await databases.updateDocument(
        databaseId: userDatabaseID,
        collectionId: liveChapterAttendeesCollectionId,
        documentId: roomId,
        data: newAttendeesModel.toJson(),
      );

      liveChapterModel.value = liveChapterData.copyWith(
        attendees: newAttendeesModel,
      );
      await RoomService.joinLiveChapterRoom(
        roomId: roomId,
        userId: authStateController.uid!,
      );
      listenForAttendeesAdded();
      Get.toNamed(AppRoutes.liveChapterScreen);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  bool checkUserIsAdmin(String uid) {
    if (liveChapterModel.value == null) return false;
    return liveChapterModel.value!.authorUid == uid;
  }

  bool get isAdmin {
    if (liveChapterModel.value == null) return false;
    return liveChapterModel.value!.authorUid == authStateController.uid!;
  }

  Future<void> turnOnMic() async {
    await Get.find<LiveKitController>().liveKitRoom.localParticipant
        ?.setMicrophoneEnabled(true);
    isMicOn.value = true;
  }

  Future<void> turnOffMic() async {
    await Get.find<LiveKitController>().liveKitRoom.localParticipant
        ?.setMicrophoneEnabled(false);
    isMicOn.value = false;
  }

  void startRecording() {
    Get.find<LiveKitController>().isRecording.value = true;
  }

  void stopRecording() {
    Get.find<LiveKitController>().isRecording.value = false;
  }

  Future<void> leaveRoom() async {
    loadingDialog(Get.context!);
    await liveChapterAttendeesSubscription?.close();
    final LiveChapterAttendeesModel updatedAttendees = liveChapterModel
        .value!
        .attendees!
        .copyWith(
          users: liveChapterModel.value!.attendees!.users
              .where((element) => element["\$id"] != authStateController.uid!)
              .toList(),
          userIds: liveChapterModel.value!.attendees!.userIds!
              .where((element) => element != authStateController.uid!)
              .toList(),
        );
    await databases.updateDocument(
      databaseId: userDatabaseID,
      collectionId: liveChapterAttendeesCollectionId,
      documentId: liveChapterModel.value!.id,
      data: updatedAttendees.toJson(),
    );
    await Get.delete<LiveKitController>(force: true);
    Get.delete<LiveChapterController>();
    Get.offAllNamed(AppRoutes.tabview);
  }

  Future<void> endLiveChapter() async {
    loadingDialog(Get.context!);

    try {
      Get.find<LiveKitController>().isRecording.value = false;
      try {
        await databases.deleteDocument(
          databaseId: storyDatabaseId,
          collectionId: liveChaptersCollectionId,
          documentId: liveChapterModel.value!.id,
        );
        await databases.deleteDocument(
          databaseId: userDatabaseID,
          collectionId: liveChapterAttendeesCollectionId,
          documentId: liveChapterModel.value!.id,
        );
      } catch (e) {
        log(e.toString());
      }
      final transcripController = WhisperTranscriptionController();
      final String lyrics = await transcripController.transcribeChapter(
        liveChapterModel.value!.livekitRoomId,
      );
      await RoomService.deleteLiveChapterRoom(
        roomId: liveChapterModel.value!.livekitRoomId,
      );

      await liveChapterAttendeesSubscription?.close();
      await Get.delete<LiveKitController>(force: true);
      Get.back();
      await Future.delayed(const Duration(milliseconds: 500));
      Get.to(() => VerifyChapterDetailsScreen(lyricsString: lyrics));
    } catch (e) {
      log(
        "Error in Delete Room Function (SingleRoomController): ${e.toString()}",
      );
      Get.back();
    }
  }

  Future<Chapter> createChapterFromLiveChapter(
    String coverImgPath,
    String audioFilePath,
    String lyricsString,
  ) async {
    final track = io.File(audioFilePath);
    final metadata = readMetadata(track);
    int playDuration = metadata.duration?.inMilliseconds ?? 0;

    Color primaryColor;

    if (!coverImgPath.contains('http')) {
      ColorScheme imageColorScheme = await ColorScheme.fromImageProvider(
        provider: FileImage(io.File(coverImgPath)),
      );

      primaryColor = imageColorScheme.primary;
    } else {
      primaryColor = const Color(0xffcbc6c6);
    }

    // coverImageUrl and audioFileUrl recieve paths while the chapter creation process
    // as cannot push files to storage to get URL unless user is final on creating a story

    return Chapter(
      liveChapterModel.value!.id,
      liveChapterModel.value!.chapterTitle,
      coverImgPath,
      liveChapterModel.value!.chapterDescription,
      lyricsString,
      audioFilePath,
      playDuration,
      primaryColor,
    );
  }
}
