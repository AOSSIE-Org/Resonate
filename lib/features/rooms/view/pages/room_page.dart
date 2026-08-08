import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/single_room_state.dart';
import 'package:resonate/features/rooms/view/pages/room_chat_page.dart';
import 'package:resonate/features/live_audio/view/widgets/audio_selector_dialog.dart';
import 'package:resonate/features/rooms/view/widgets/participant_block.dart';
import 'package:resonate/shared/widgets/session_app_bar.dart';
import 'package:resonate/shared/widgets/session_header.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RoomPage extends ConsumerWidget {
  const RoomPage({super.key, required this.room});

  final AppwriteRoom room;

  String _formatTags() {
    if (room.tags.isEmpty) return '';
    return room.tags.join(' · ');
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If an admin kicks
    ref.listen(roomSessionProvider(room), (_, next) {
      if (next.value?.wasKicked ?? false) {
        final navigator = Navigator.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.removedFromRoom)),
        );
        if (navigator.canPop()) navigator.pop();
      }
    });

    final asyncState = ref.watch(roomSessionProvider(room));

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SessionAppBar(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
            child: SessionHeader(
              title: room.name,
              description: room.description,
              tags: _formatTags(),
            ),
          ),
          SizedBox(height: UiSizes.height_7),
          Expanded(
            child: asyncState.when(
              loading: () => Center(
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: Theme.of(context).colorScheme.primary,
                  size: MediaQuery.of(context).devicePixelRatio * 20,
                ),
              ),
              error: (e, _) => _RoomBody(
                room: room,
                state: null,
                onConfirm: _confirmLeaveOrDelete,
              ),
              data: (state) => _RoomBody(
                room: room,
                state: state,
                onConfirm: _confirmLeaveOrDelete,
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
    required this.onConfirm,
  });

  final AppwriteRoom room;
  final SingleRoomState? state;
  final Future<bool> Function(BuildContext, String) onConfirm;

  @override
  Widget build(BuildContext context) {
    final participants = state?.participants ?? const [];

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
        Padding(
          padding: EdgeInsets.all(UiSizes.width_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.participants,
                style: TextStyle(
                  fontSize: UiSizes.size_18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: UiSizes.height_10),
              Expanded(
                child: participants.isEmpty
                    ? _NoParticipantsView()
                    : GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: UiSizes.width_20,
                          mainAxisSpacing: UiSizes.height_5,
                          childAspectRatio: 2.5 / 3,
                        ),
                        itemCount: participants.length,
                        itemBuilder: (_, index) => ParticipantBlock(
                          room: room,
                          participant: participants[index],
                        ),
                      ),
              ),
            ],
          ),
        ),
        _Footer(room: room, onConfirm: onConfirm),
      ],
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

class _Footer extends ConsumerWidget {
  const _Footer({required this.room, required this.onConfirm});

  final AppwriteRoom room;
  final Future<bool> Function(BuildContext, String) onConfirm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(roomSessionProvider(room)).value;
    if (state == null) return const SizedBox.shrink();

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
            // Leave / delete
            ElevatedButton(
              onPressed: () async {
                final actionLabel = room.isUserAdmin
                    ? AppLocalizations.of(context)!.delete
                    : AppLocalizations.of(context)!.leave;
                final navigator = Navigator.of(context);
                final confirmed = await onConfirm(context, actionLabel);
                if (!confirmed) return;

                final notifier =
                    ref.read(roomSessionProvider(room).notifier);
                try {
                  if (room.isUserAdmin) {
                    await notifier.deleteRoom(room);
                  } else {
                    await notifier.leaveRoom(room);
                  }
                } finally {
                  // Always close the sheet, even if teardown throws.
                  if (navigator.canPop()) navigator.pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Icon(Icons.call_end, size: UiSizes.size_24),
            ),
            // Mic
            FloatingActionButton(
              onPressed: state.me.isSpeaker
                  ? () {
                      final notifier =
                          ref.read(roomSessionProvider(room).notifier);
                      if (state.me.isMicOn) {
                        notifier.turnOffMic(room);
                      } else {
                        notifier.turnOnMic(room);
                      }
                    }
                  : null,
              backgroundColor: !state.me.isSpeaker
                  ? Colors.grey
                  : (state.me.isMicOn ? Colors.lightGreen : Colors.redAccent),
              child: Icon(
                state.me.isMicOn ? Icons.mic : Icons.mic_off,
                color: Colors.black,
              ),
            ),
            // Raise hand
            FloatingActionButton(
              onPressed: () {
                final notifier = ref.read(roomSessionProvider(room).notifier);
                if (state.me.hasRequestedToBeSpeaker) {
                  notifier.unRaiseHand(room);
                } else {
                  notifier.raiseHand(room);
                }
              },
              backgroundColor: state.me.hasRequestedToBeSpeaker
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black54,
              child: Icon(
                state.me.hasRequestedToBeSpeaker
                    ? Icons.back_hand
                    : Icons.back_hand_outlined,
                color: state.me.hasRequestedToBeSpeaker
                    ? Colors.black
                    : Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white54,
              ),
            ),
            // Audio settings
            FloatingActionButton(
              onPressed: () => showAudioDeviceSelector(context),
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              child: const Icon(Icons.volume_up),
            ),
            // Chat
            FloatingActionButton(
              onPressed: () => openLiveRoomChatSheet(context, room),
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.chat, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openRoomSheet(BuildContext context, AppwriteRoom room) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => RoomPage(room: room),
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
    ),
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: false,
  );
}
