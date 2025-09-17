import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/auth_state_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/room_app_bar.dart';
import 'package:resonate/views/widgets/room_header.dart';

import 'package:resonate/l10n/app_localizations.dart';
import '../../controllers/pair_chat_controller.dart';

class PairChatScreen extends StatelessWidget {
  final AuthStateController authStateController =
      Get.find<AuthStateController>();
  final PairChatController controller = Get.find<PairChatController>();
  final ThemeController themeController = Get.find<ThemeController>();

  PairChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentBrightness = Theme.of(context).brightness;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const RoomAppBar(),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_10,
                  horizontal: UiSizes.width_20,
                ),
                child: Column(
                  children: [
                    RoomHeader(
                      roomName: AppLocalizations.of(context)!.title,
                      roomDescription: AppLocalizations.of(
                        context,
                      )!.roomDescription,
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildUserInfoRow(
                          controller.isAnonymous.value
                              ? themeController.userProfileImagePlaceholderUrl
                              : authStateController.profileImageUrl!,
                          controller.isAnonymous.value
                              ? AppLocalizations.of(context)!.user1
                              : authStateController.userName!,
                        ),
                        SizedBox(height: UiSizes.height_20),
                        _buildUserInfoRow(
                          controller.isAnonymous.value
                              ? themeController.userProfileImagePlaceholderUrl
                              : controller.pairProfileImageUrl!,
                          controller.isAnonymous.value
                              ? AppLocalizations.of(context)!.user2
                              : controller.pairUsername!,
                        ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                  ],
                ),
              ),
              const Spacer(),
              _buildBottomControlPanel(currentBrightness, context),
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

  Widget _buildBottomControlPanel(
    Brightness currentBrightness,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
      color: currentBrightness == Brightness.light
          ? Theme.of(context).colorScheme.primary
          : Colors.black,
      height: UiSizes.height_131,
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: controller.isMicOn.value ? Icons.mic : Icons.mic_off,
              label: AppLocalizations.of(context)!.mute,
              onPressed: controller.toggleMic,
              backgroundColor: controller.isMicOn.value
                  ? _getControlButtonBackgroundColor(currentBrightness)
                  : Theme.of(context).colorScheme.primary,
              heroTag: "mic",
            ),
            _buildControlButton(
              icon: Icons.volume_up,
              label: AppLocalizations.of(context)!.speakerLabel,
              onPressed: controller.toggleLoudSpeaker,
              backgroundColor: controller.isLoudSpeakerOn.value
                  ? Theme.of(context).colorScheme.primary
                  : _getControlButtonBackgroundColor(currentBrightness),
              heroTag: "speaker",
            ),
            _buildControlButton(
              icon: Icons.cancel_outlined,
              label: AppLocalizations.of(context)!.end,
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
        ? Colors.white.withValues(alpha: 0.5)
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
        Text(label, style: TextStyle(fontSize: UiSizes.height_14)),
      ],
    );
  }
}
