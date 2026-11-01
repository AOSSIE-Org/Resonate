import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/pages/room_chat_page.dart';
import 'package:resonate/features/live_audio/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/rooms/view/widgets/participant_block.dart';
import 'package:resonate/shared/widgets/session_app_bar.dart';
import 'package:resonate/shared/widgets/session_control_bar.dart';
import 'package:resonate/shared/widgets/session_exit_dialog.dart';
import 'package:resonate/shared/widgets/session_stage.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/features/miniplayer/data/session_presented.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RoomPage extends ConsumerStatefulWidget {
  const RoomPage({
    super.key,
    required this.room,
    this.confirmLeaveOnOpen = false,
  });

  final AppwriteRoom room;

  final bool confirmLeaveOnOpen;

  @override
  ConsumerState<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends ConsumerState<RoomPage> {
  AppwriteRoom get room => widget.room;

  late final SessionPresented _presence;

  @override
  void initState() {
    super.initState();
    _presence = ref.read(sessionPresentedProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // While this sheet is up the miniplayer stands down.
      _presence.enter();
      if (widget.confirmLeaveOnOpen) _confirmAndLeave();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _presence.exit());
    super.dispose();
  }

  Future<void> _confirmAndLeave() async {
    final actionLabel = room.isUserAdmin
        ? AppLocalizations.of(context)!.delete
        : AppLocalizations.of(context)!.leave;
    final navigator = Navigator.of(context);
    final confirmed = await confirmSessionExit(context, actionLabel);
    if (!confirmed) return;
    unawaited(ref.read(roomLauncherProvider).leave(room));
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // If an admin kicks, or the host closes the room
    ref.listen(roomSessionProvider(room), (_, next) {
      final session = next.value;
      if (session == null || (!session.wasKicked && !session.roomEnded)) return;

      final navigator = Navigator.of(context);
      final l10n = AppLocalizations.of(context)!;
      if (session.roomEnded) {
        customSnackbar(l10n.roomEnded, l10n.roomEndedMessage, LogType.info);
      } else {
        customSnackbar(l10n.oops, l10n.removedFromRoom, LogType.warning);
      }
      if (navigator.canPop()) navigator.pop();
    });

    final asyncState = ref.watch(roomSessionProvider(room));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SessionAppBar(icon: Icons.arrow_back),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: SessionHeader(
              title: room.name,
              description: room.description,
              tags: room.tags,
            ),
          ),
          SizedBox(height: UiSizes.height_16),
          Expanded(
            child: asyncState.when(
              loading: () => Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Theme.of(context).colorScheme.primary,
                  size: MediaQuery.of(context).devicePixelRatio * 20,
                ),
              ),
              error: (e, _) =>
                  _RoomBody(room: room, state: null, onLeave: _confirmAndLeave),
              data: (state) => _RoomBody(
                room: room,
                state: state,
                onLeave: _confirmAndLeave,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomBody extends StatelessWidget {
  const _RoomBody({
    required this.room,
    required this.state,
    required this.onLeave,
  });

  final AppwriteRoom room;
  final SingleRoomState? state;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final participants = state?.participants ?? const <Participant>[];
    return SessionStage(
      featured: [
        for (final participant in participants)
          if (participant.isAdmin)
            ParticipantBlock(
              room: room,
              participant: participant,
              featured: true,
            ),
      ],
      tiles: [
        for (final participant in participants)
          if (!participant.isAdmin)
            ParticipantBlock(room: room, participant: participant),
      ],
      emptyState: SessionStageEmpty(
        message: AppLocalizations.of(context)!.noParticipantsYet,
      ),
      controls: _Footer(room: room, onLeave: onLeave),
    );
  }
}

class _Footer extends ConsumerWidget {
  const _Footer({required this.room, required this.onLeave});

  final AppwriteRoom room;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roomSessionProvider(room)).value;
    if (state == null) return const SizedBox.shrink();
    final notifier = ref.read(roomSessionProvider(room).notifier);

    return Align(
      alignment: Alignment.bottomCenter,
      child: SessionControlBar(
        controls: [
          SessionControl(SessionControlKind.leave, onTap: onLeave),
          SessionControl(
            SessionControlKind.mic,
            active: state.me.isMicOn,
            onTap: state.me.isSpeaker
                ? () => state.me.isMicOn
                      ? notifier.turnOffMic(room)
                      : notifier.turnOnMic(room)
                : null,
          ),
          SessionControl(
            SessionControlKind.raiseHand,
            active: state.me.hasRequestedToBeSpeaker,
            onTap: () => state.me.hasRequestedToBeSpeaker
                ? notifier.unRaiseHand(room)
                : notifier.raiseHand(room),
          ),
          SessionControl(
            SessionControlKind.audioDevice,
            onTap: () => showAudioDeviceSelector(context),
          ),
          SessionControl(
            SessionControlKind.chat,
            onTap: () => openLiveRoomChatSheet(context, room),
          ),
        ],
      ),
    );
  }
}

Future<void> openRoomSheet(
  BuildContext context,
  AppwriteRoom room, {
  bool confirmLeave = false,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => RoomPage(room: room, confirmLeaveOnOpen: confirmLeave),
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    ),
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: false,
  );
}
