import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/new_widgets/new_room_app_bar.dart';
import 'package:resonate/views/new_widgets/new_room_header.dart';

import '../../controllers/pair_chat_controller.dart';
import '../../utils/constants.dart';

class NewPairChatScreen extends StatelessWidget {
  final AuthStateController authStateController =
      Get.find<AuthStateController>();
  final PairChatController controller = Get.find<PairChatController>();
  final ThemeController themeController = Get.find<ThemeController>();

  NewPairChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const NewRoomAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_10,
                  horizontal: UiSizes.width_20,
                ),
                child: Column(
                  children: [
                    const NewRoomHeader(
                      roomName: 'Resonate',
                      roomDescription:
                          "Be polite and respect the other person's opinion. Avoid rude comments.",
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUserInfoRow(
                          controller.isAnonymous.value
                              ? userProfileImagePlaceholderUrl
                              : authStateController.profileImageUrl!,
                          controller.isAnonymous.value
                              ? "User1"
                              : authStateController.userName!,
                        ),
                        SizedBox(height: UiSizes.height_20),
                        _buildUserInfoRow(
                          controller.isAnonymous.value
                              ? userProfileImagePlaceholderUrl
                              : controller.pairProfileImageUrl!,
                          controller.isAnonymous.value
                              ? "User2"
                              : controller.pairUsername!,
                        ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                  ],
                ),
              ),
              const Spacer(),
              _buildBottomControlPanel(currentBrightness),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String imageUrl, String userName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: UiSizes.width_66,
        ),
        SizedBox(width: UiSizes.width_16),
        Container(
          alignment: Alignment.center,
          width: UiSizes.width_100,
          child: Text(
            userName,
            style: TextStyle(fontSize: UiSizes.size_16),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControlPanel(Brightness currentBrightness) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
      color: currentBrightness == Brightness.light
          ? themeController.primaryColor.value
          : Colors.black,
      height: UiSizes.height_131,
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: controller.isMicOn.value ? Icons.mic : Icons.mic_off,
              label: 'Mute',
              onPressed: controller.toggleMic,
              backgroundColor: controller.isMicOn.value
                  ? _getControlButtonBackgroundColor(currentBrightness)
                  : themeController.primaryColor.value,
              heroTag: "mic",
            ),
            _buildControlButton(
              icon: Icons.volume_up,
              label: 'Speaker',
              onPressed: controller.toggleLoudSpeaker,
              backgroundColor: controller.isLoudSpeakerOn.value
                  ? themeController.primaryColor.value
                  : _getControlButtonBackgroundColor(currentBrightness),
              heroTag: "speaker",
            ),
            _buildControlButton(
              icon: Icons.cancel_outlined,
              label: 'End',
              onPressed: () async {
                await controller.endChat();
              },
              backgroundColor: Colors.redAccent,
              heroTag: "end-chat",
            ),
          ],
        );
      }),
    );
  }

  Color _getControlButtonBackgroundColor(Brightness brightness) {
    return brightness == Brightness.light
        ? Colors.white.withOpacity(0.5)
        : Colors.white54;
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required String heroTag,
  }) {
    return Column(
      children: [
        SizedBox(
          height: UiSizes.height_56,
          width: UiSizes.width_56,
          child: FloatingActionButton(
            elevation: 0,
            heroTag: heroTag,
            onPressed: onPressed,
            backgroundColor: backgroundColor,
            child: Icon(icon, size: UiSizes.size_24),
          ),
        ),
        SizedBox(height: UiSizes.height_4),
        Text(
          label,
          style: TextStyle(fontSize: UiSizes.height_14),
        ),
      ],
    );
  }
}
