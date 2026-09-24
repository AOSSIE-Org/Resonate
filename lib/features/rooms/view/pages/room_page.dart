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
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/features/miniplayer/data/session_presented.dart';
import 'package:resonate/features/rooms/data/services/room_launcher.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/l10n/app_localizations.dart';
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

  Future<bool> _confirmLeaveOrDelete(
    BuildContext context,
    String actionLabel,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.areYouSure),
        content: Text(AppLocalizations.of(ctx)!.toRoomAction(actionLabel)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(ctx)!.confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _confirmAndLeave() async {
    final actionLabel = room.isUserAdmin
        ? AppLocalizations.of(context)!.delete
        : AppLocalizations.of(context)!.leave;
    final navigator = Navigator.of(context);
    final confirmed = await _confirmLeaveOrDelete(context, actionLabel);
    if (!confirmed) return;
    unawaited(ref.read(roomLauncherProvider).leave(room));
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    // If an admin kicks
    ref.listen(roomSessionProvider(room), (_, next) {
      if (next.value?.wasKicked ?? false) {
        final navigator = Navigator.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.removedFromRoom),
          ),
        );
        if (navigator.canPop()) navigator.pop();
      }
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
    final hosts = participants.where((p) => p.isAdmin).toList();
    final others = participants.where((p) => !p.isAdmin).toList();

    return Stack(
      children: [
        if (participants.isEmpty)
          _NoParticipantsView()
        else
          CustomScrollView(
            slivers: [
              for (final host in hosts)
                SliverPadding(
                  padding: sectionPadding,
                  sliver: SliverToBoxAdapter(
                    child: ParticipantBlock(
                      room: room,
                      participant: host,
                      featured: true,
                    ),
                  ),
                ),
              _ParticipantGrid(room: room, participants: others),
              // Clearance so the last row is not trapped under the controls.
              SliverToBoxAdapter(child: SizedBox(height: UiSizes.height_131)),
            ],
          ),
        _Footer(room: room, onLeave: onLeave),
      ],
    );
  }

  static EdgeInsets get sectionPadding => EdgeInsets.fromLTRB(
    UiSizes.width_16,
    0,
    UiSizes.width_16,
    UiSizes.height_10,
  );
}

class _ParticipantGrid extends StatelessWidget {
  const _ParticipantGrid({required this.room, required this.participants});

  final AppwriteRoom room;
  final List<Participant> participants;

  @override
  Widget build(BuildContext context) {
    if (participants.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 3.0);

    return SliverPadding(
      padding: _RoomBody.sectionPadding,
      sliver: SliverGrid.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: UiSizes.width_8,
          mainAxisSpacing: UiSizes.height_8,
          childAspectRatio: 0.79 / textScale,
        ),
        itemCount: participants.length,
        itemBuilder: (_, index) =>
            ParticipantBlock(room: room, participant: participants[index]),
      ),
    );
  }
}

class _NoParticipantsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: UiSizes.size_65,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: UiSizes.height_16),
          Text(
            'No participants yet',
            style: TextStyle(
              fontSize: UiSizes.size_16,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// One circular control in the floating room toolbar.
class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.background,
    required this.foreground,
    this.onTap,
    this.diameter,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  final double? diameter;

  @override
  Widget build(BuildContext context) {
    final diameter = this.diameter ?? UiSizes.width_56;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_5),
      child: Material(
        color: background,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: diameter,
            height: diameter,
            child: Center(
              child: Icon(icon, size: UiSizes.size_26, color: foreground),
            ),
          ),
        ),
      ),
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

    final scheme = Theme.of(context).colorScheme;
    final neutral = scheme.surfaceContainerHighest;
    final onNeutral = scheme.onSurface;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: UiSizes.height_16),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_10,
            vertical: UiSizes.height_10,
          ),
          decoration: BoxDecoration(
            color: scheme.secondary,
            borderRadius: BorderRadius.circular(UiSizes.width_56),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: UiSizes.width_10,
                offset: Offset(0, UiSizes.height_2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Leave / delete
              _RoundAction(
                icon: Icons.call_end,
                diameter: UiSizes.width_66,
                background: scheme.error,
                foreground: scheme.onError,
                onTap: onLeave,
              ),
              // Mic
              _RoundAction(
                icon: state.me.isMicOn ? Icons.mic : Icons.mic_off,
                background: state.me.isMicOn ? scheme.primary : neutral,
                foreground: state.me.isMicOn
                    ? scheme.onPrimary
                    : onNeutral.withValues(alpha: state.me.isSpeaker ? 1 : 0.4),
                onTap: state.me.isSpeaker
                    ? () {
                        final notifier = ref.read(
                          roomSessionProvider(room).notifier,
                        );
                        if (state.me.isMicOn) {
                          notifier.turnOffMic(room);
                        } else {
                          notifier.turnOnMic(room);
                        }
                      }
                    : null,
              ),
              // Raise hand
              _RoundAction(
                icon: state.me.hasRequestedToBeSpeaker
                    ? Icons.back_hand
                    : Icons.back_hand_outlined,
                background: state.me.hasRequestedToBeSpeaker
                    ? scheme.primary
                    : neutral,
                foreground: state.me.hasRequestedToBeSpeaker
                    ? scheme.onPrimary
                    : onNeutral,
                onTap: () {
                  final notifier = ref.read(roomSessionProvider(room).notifier);
                  if (state.me.hasRequestedToBeSpeaker) {
                    notifier.unRaiseHand(room);
                  } else {
                    notifier.raiseHand(room);
                  }
                },
              ),
              // Audio settings
              _RoundAction(
                icon: Icons.volume_up,
                background: neutral,
                foreground: onNeutral,
                onTap: () => showAudioDeviceSelector(context),
              ),
              // Chat
              _RoundAction(
                icon: Icons.chat,
                background: neutral,
                foreground: onNeutral,
                onTap: () => openLiveRoomChatSheet(context, room),
              ),
            ],
          ),
        ),
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
