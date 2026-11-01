import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/auth/data/current_user.dart';
import 'package:resonate/features/friends/model/friend_call_model.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/features/live_audio/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/friends/view/widgets/call_participant_tile.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/features/miniplayer/data/session_presented.dart';
import 'package:resonate/shared/widgets/session_app_bar.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class FriendCallPage extends ConsumerStatefulWidget {
  const FriendCallPage({super.key});

  @override
  ConsumerState<FriendCallPage> createState() => _FriendCallPageState();
}

class _FriendCallPageState extends ConsumerState<FriendCallPage> {
  late final SessionPresented _presence;

  @override
  void initState() {
    super.initState();
    _presence = ref.read(sessionPresentedProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // While this page is up the miniplayer stands down.
      if (mounted) _presence.enter();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _presence.exit());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(friendCallCoordinatorProvider);
    final notifier = ref.read(friendCallCoordinatorProvider.notifier);
    final call = callState.activeCall;
    if (call == null) return const Scaffold(body: SizedBox.shrink());

    final sides = call.sidesFor(ref.watch(currentUserProvider)?.uid);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Dismissible(
          key: const ValueKey('friend-call'),
          direction: DismissDirection.down,
          resizeDuration: null,
          dismissThresholds: const {DismissDirection.down: 0.2},
          onDismissed: (_) => Navigator.of(context).pop(),
          child: SafeArea(
            child: Column(
              children: [
                const SessionAppBar(),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    UiSizes.width_20,
                    UiSizes.height_10,
                    UiSizes.width_20,
                    UiSizes.height_20,
                  ),
                  child: SessionHeader(
                    centered: true,
                    title: AppLocalizations.of(context)!.title,
                    description: AppLocalizations.of(context)!.roomDescription,
                  ),
                ),
                Expanded(
                  child: _CallStage(remote: sides.remote, local: sides.local),
                ),
                Center(
                  child: SessionControlBar(
                    controls: [
                      SessionControl(
                        SessionControlKind.leave,
                        onTap: () => notifier.endCall(),
                      ),
                      SessionControl(
                        SessionControlKind.mic,
                        active: callState.isMicOn,
                        onTap: notifier.toggleMic,
                      ),
                      SessionControl(
                        SessionControlKind.audioDevice,
                        onTap: () => showAudioDeviceSelector(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// The other party fills the stage; we sit in the corner tile.
class _CallStage extends StatelessWidget {
  const _CallStage({required this.remote, required this.local});

  final CallSide remote;
  final CallSide local;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
      child: Stack(
        children: [
          Positioned.fill(
            child: CallParticipantTile(
              uid: remote.uid,
              name: remote.name,
              imageUrl: remote.imageUrl,
            ),
          ),
          Positioned(
            right: UiSizes.width_8,
            bottom: UiSizes.height_8,
            child: SizedBox(
              width: UiSizes.width_140,
              child: CallParticipantTile(
                uid: local.uid,
                // Our own tile reads "You"; the row's name is on the big card.
                name: AppLocalizations.of(context)!.you,
                imageUrl: local.imageUrl,
                compact: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
