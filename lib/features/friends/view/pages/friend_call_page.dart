import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/view/widgets/call_control_panel.dart';
import 'package:resonate/features/friends/view/widgets/call_user_info_row.dart';
import 'package:resonate/features/friends/viewmodel/friend_call_notifier.dart';
import 'package:resonate/features/rooms/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/rooms/view/widgets/room_header.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class FriendCallPage extends ConsumerWidget {
  const FriendCallPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callState = ref.watch(friendCallProvider);
    final notifier = ref.read(friendCallProvider.notifier);
    final call = callState.activeCall;
    if (call == null) return const Scaffold(body: SizedBox.shrink());

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
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
                        CallUserInfoRow(
                          imageUrl: call.callerProfileImageUrl,
                          userName: call.callerName,
                        ),
                        SizedBox(height: UiSizes.height_20),
                        CallUserInfoRow(
                          imageUrl: call.recieverProfileImageUrl,
                          userName: call.recieverName,
                        ),
                      ],
                    ),
                    SizedBox(height: UiSizes.height_24_6),
                  ],
                ),
              ),
              const Spacer(),
              CallControlPanel(
                buttons: [
                  CallControlButton(
                    icon: callState.isMicOn ? Icons.mic : Icons.mic_off,
                    label: AppLocalizations.of(context)!.mute,
                    onPressed: notifier.toggleMic,
                    backgroundColor: callState.isMicOn
                        ? CallControlPanel.inactiveButtonColor(context)
                        : Theme.of(context).colorScheme.primary,
                    heroTag: "mic",
                  ),
                  CallControlButton(
                    icon: Icons.volume_up,
                    label: AppLocalizations.of(context)!.speakerLabel,
                    onPressed: notifier.toggleLoudSpeaker,
                    backgroundColor: callState.isLoudSpeakerOn
                        ? Theme.of(context).colorScheme.primary
                        : CallControlPanel.inactiveButtonColor(context),
                    heroTag: "speaker",
                  ),
                  CallControlButton(
                    icon: Icons.settings_voice,
                    label: AppLocalizations.of(context)!.audioOptions,
                    onPressed: () => showAudioDeviceSelector(context),
                    backgroundColor:
                        CallControlPanel.inactiveButtonColor(context),
                    heroTag: "audio-settings",
                  ),
                  CallControlButton(
                    icon: Icons.cancel_outlined,
                    label: AppLocalizations.of(context)!.end,
                    onPressed: () => notifier.endCall(),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    heroTag: "end-chat",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
