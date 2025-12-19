import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:resonate/controllers/live_chapter_controller.dart';
import 'package:resonate/controllers/livekit_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/live_chapter_attendee_block.dart';
import 'package:resonate/views/widgets/live_chapter_header.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class LiveChapterScreen extends StatefulWidget {
  const LiveChapterScreen({super.key});

  @override
  LiveChapterScreenState createState() => LiveChapterScreenState();
}

class LiveChapterScreenState extends State<LiveChapterScreen> {
  Future<dynamic> _deleteRoomDialog(String text, Function() onTap) async {
    return await Get.defaultDialog(
      title: AppLocalizations.of(context)!.areYouSure,
      buttonColor: Theme.of(context).colorScheme.primary,
      middleText: AppLocalizations.of(context)!.toRoomAction(text),
      cancelTextColor: Theme.of(context).colorScheme.primary,
      textConfirm: AppLocalizations.of(context)!.confirm,
      textCancel: AppLocalizations.of(context)!.cancel,
      onConfirm: onTap,
      onCancel: () => log(AppLocalizations.of(context)!.canceled),
    );
  }

  @override
  Widget build(BuildContext context) {
    LiveChapterController liveChapterController =
        Get.find<LiveChapterController>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LiveChapterHeader(
                chapterName:
                    liveChapterController.liveChapterModel.value!.chapterTitle,
                chapterDescription: liveChapterController
                    .liveChapterModel
                    .value!
                    .chapterDescription,
              ),
            ),
            SizedBox(height: UiSizes.height_7),
            Expanded(child: _buildParticipantsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsList() {
    return Obx(() {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(
                context,
              ).colorScheme.onSecondary.withValues(alpha: 0.15),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildParticipantsSection(
                  title: AppLocalizations.of(context)!.participants,
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      );
    });
  }

  Widget _buildParticipantsSection({required String title}) {
    final controller = Get.find<LiveChapterController>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: UiSizes.size_18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() {
            return SizedBox(
              height: double.maxFinite,
              width: 400,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: UiSizes.width_20,
                  mainAxisSpacing: UiSizes.height_5,
                  childAspectRatio: 2.5 / 3,
                ),
                itemCount:
                    (controller
                            .liveChapterModel
                            .value
                            ?.attendees
                            ?.users
                            .length ??
                        0) +
                    1,
                itemBuilder: (ctx, index) {
                  return LiveChapterAttendeeBlock(
                    user: index == 0
                        ? {
                            'profileImageUrl': controller
                                .liveChapterModel
                                .value
                                ?.authorProfileImageUrl,
                            'name':
                                controller.liveChapterModel.value?.authorName,
                            '\$id':
                                controller.liveChapterModel.value?.authorUid,
                          }
                        : controller
                                  .liveChapterModel
                                  .value
                                  ?.attendees
                                  ?.users[index - 1] ??
                              {},
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final controller = Get.find<LiveChapterController>();
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(24),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLeaveButton(),
            if (controller.isAdmin) ...[
              _buildMicButton(),
              _buildRecordButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveButton() {
    final controller = Get.find<LiveChapterController>();
    final LiveKitController liveKitController = Get.find<LiveKitController>();
    return ElevatedButton.icon(
      onPressed: () async {
        await _deleteRoomDialog(
          controller.isAdmin
              ? AppLocalizations.of(context)!.delete
              : AppLocalizations.of(context)!.leave,
          () async {
            if (controller.isAdmin) {
              if (liveKitController.isRecording.value == true) {
                await controller.endLiveChapter();
              } else {
                customSnackbar(
                  AppLocalizations.of(context)!.error,
                  AppLocalizations.of(context)!.noRecordingError,
                  LogType.error,
                );
              }
            } else {
              await controller.leaveRoom();
            }
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 241, 108, 98),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      icon: const Icon(Icons.exit_to_app),
      label: Text(AppLocalizations.of(context)!.leaveButton),
    );
  }

  Widget _buildRecordButton() {
    return Obx(() {
      bool isRecording = Get.find<LiveKitController>().isRecording.value;
      return FloatingActionButton(
        onPressed: () {
          if (isRecording) {
            customSnackbar(
              AppLocalizations.of(context)!.actionBlocked,
              AppLocalizations.of(context)!.cannotStopRecording,
              LogType.info,
            );
          } else {
            Get.find<LiveKitController>().isRecording.value = true;
          }
        },
        backgroundColor: isRecording ? Colors.red : Colors.green,
        child: Icon(
          isRecording ? Icons.stop_circle : Icons.radio_button_checked,
        ),
      );
    });
  }

  Widget _buildMicButton() {
    return Obx(() {
      {
        final controller = Get.find<LiveChapterController>();
        final bool isMicOn = controller.isMicOn.value;
        final bool isAdmin = controller.isAdmin;

        return FloatingActionButton(
          onPressed: () {
            if (isAdmin) {
              if (isMicOn) {
                controller.turnOffMic();
              } else {
                controller.turnOnMic();
              }
            }
          },
          backgroundColor: isMicOn ? Colors.lightGreen : Colors.redAccent,
          child: Icon(isMicOn ? Icons.mic : Icons.mic_off, color: Colors.black),
        );
      }
    });
  }
}
