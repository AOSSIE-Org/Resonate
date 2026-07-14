import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/viewmodel/single_room_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/report_widget.dart';

class _FocusedMenuItemData {
  _FocusedMenuItemData(this.text, this.action);
  final String text;
  final VoidCallback action;
}

class ParticipantBlock extends ConsumerWidget {
  const ParticipantBlock({
    super.key,
    required this.room,
    required this.participant,
  });

  final AppwriteRoom room;
  final Participant participant;

  String _userRole(BuildContext context) {
    if (participant.isAdmin) return AppLocalizations.of(context)!.admin;
    if (participant.isModerator) return AppLocalizations.of(context)!.moderator;
    if (participant.isSpeaker) return AppLocalizations.of(context)!.speaker;
    return AppLocalizations.of(context)!.listener;
  }

  List<FocusedMenuItem> _makeItems(
    BuildContext context,
    List<_FocusedMenuItemData> items,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return items
        .map(
          (item) => FocusedMenuItem(
            title: Text(
              item.text,
              style: TextStyle(fontSize: UiSizes.size_14),
            ),
            trailingIcon: Icon(
              Icons.remove_circle_outline,
              color: colorScheme.error,
              size: UiSizes.size_18,
            ),
            onPressed: item.action,
            backgroundColor: colorScheme.surface,
          ),
        )
        .toList();
  }

  Future<void> _reportAndMaybeKick(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final didSubmit = await showDialog<bool>(
      context: context,
      builder: (_) => ReportWidget(
        participantName: participant.name,
        participantId: participant.uid,
      ),
    );
    if (didSubmit == true) {
      await ref
          .read(singleRoomProvider(room).notifier)
          .reportAndKick(room, participant);
    }
  }

  List<FocusedMenuItem> _menuItems(
    BuildContext context,
    WidgetRef ref,
    Participant me,
  ) {
    if ((!me.isAdmin && !me.isModerator) || participant.isAdmin) return [];
    final notifier = ref.read(singleRoomProvider(room).notifier);

    if (me.isAdmin) {
      if (participant.isModerator) {
        return _makeItems(context, [
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.removeModerator,
            () => notifier.setRole(room, participant, ParticipantRole.listener),
          ),
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.kickOut,
            () => notifier.kickOutParticipant(room, participant),
          ),
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.reportParticipant,
            () => _reportAndMaybeKick(context, ref),
          ),
        ]);
      } else {
        return _makeItems(context, [
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.addModerator,
            () => notifier.setRole(room, participant, ParticipantRole.moderator),
          ),
          if (participant.hasRequestedToBeSpeaker)
            _FocusedMenuItemData(
              AppLocalizations.of(context)!.addSpeaker,
              () => notifier.setRole(room, participant, ParticipantRole.speaker),
            ),
          if (participant.isSpeaker)
            _FocusedMenuItemData(
              AppLocalizations.of(context)!.makeListener,
              () => notifier.setRole(room, participant, ParticipantRole.listener),
            ),
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.kickOut,
            () => notifier.kickOutParticipant(room, participant),
          ),
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.reportParticipant,
            () => _reportAndMaybeKick(context, ref),
          ),
        ]);
      }
    }

    if (me.isModerator) {
      if (participant.isModerator) return [];
      return _makeItems(context, [
        if (participant.hasRequestedToBeSpeaker)
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.addSpeaker,
            () => notifier.setRole(room, participant, ParticipantRole.speaker),
          ),
        if (participant.isSpeaker)
          _FocusedMenuItemData(
            AppLocalizations.of(context)!.makeListener,
            () => notifier.setRole(room, participant, ParticipantRole.listener),
          ),
        _FocusedMenuItemData(
          AppLocalizations.of(context)!.kickOut,
          () => notifier.kickOutParticipant(room, participant),
        ),
        _FocusedMenuItemData(
          AppLocalizations.of(context)!.reportParticipant,
          () => _reportAndMaybeKick(context, ref),
        ),
      ]);
    }

    return [];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(singleRoomProvider(room)).value?.me;
    if (me == null) return const SizedBox.shrink();

    final canOpenMenu = (me.isAdmin ||
            (me.isModerator && !participant.isModerator)) &&
        !participant.isAdmin;

    return FocusedMenuHolder(
      onPressed: () {},
      menuItemExtent: UiSizes.width_45,
      menuWidth: UiSizes.width_200 * 1.05,
      menuBoxDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: UiSizes.width_1,
        ),
      ),
      duration: const Duration(milliseconds: 100),
      animateMenuItems: true,
      blurBackgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withValues(alpha: 0.54),
      menuItems: _menuItems(context, ref, me),
      openWithTap: canOpenMenu,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_2,
          horizontal: UiSizes.width_2,
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            CircleAvatar(
              radius: UiSizes.size_32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                backgroundImage: NetworkImage(participant.dpUrl),
                radius: UiSizes.size_30,
                child: participant.hasRequestedToBeSpeaker
                    ? Stack(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Icon(
                              Icons.waving_hand_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: UiSizes.size_20,
                            ),
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (participant.isSpeaker)
                    Icon(
                      participant.isMicOn ? Icons.mic : Icons.mic_off,
                      color: participant.isMicOn
                          ? Colors.lightGreen
                          : Colors.red,
                      size: UiSizes.size_16,
                    ),
                  Text(
                    participant.name.split(' ').first,
                    style: TextStyle(fontSize: UiSizes.size_16),
                  ),
                ],
              ),
            ),
            Text(
              _userRole(context),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: UiSizes.size_14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
