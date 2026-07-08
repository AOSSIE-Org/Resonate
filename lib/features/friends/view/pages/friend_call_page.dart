import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/view/widgets/call_control_panel.dart';
import 'package:resonate/features/friends/view/widgets/call_user_info_row.dart';
import 'package:resonate/features/friends/viewmodel/friend_call_notifier.dart';
import 'package:resonate/features/rooms/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/shared/widgets/session_header.dart';
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
                    SessionHeader(
                      title: AppLocalizations.of(context)!.title,
                      description: AppLocalizations.of(
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
                isMicOn: callState.isMicOn,
                isLoudSpeakerOn: callState.isLoudSpeakerOn,
                onToggleMic: notifier.toggleMic,
                onToggleLoudSpeaker: notifier.toggleLoudSpeaker,
                onAudioSettings: () => showAudioDeviceSelector(context),
                onEnd: () => notifier.endCall(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
