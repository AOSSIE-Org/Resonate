import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:resonate/features/achievements/view/widgets/badge_mark.dart';
import 'package:resonate/features/rooms/model/appwrite_room.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/features/rooms/model/participant.dart';
import 'package:resonate/features/rooms/data/services/room_session.dart';
import 'package:resonate/shared/widgets/speaking_avatar.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/features/rooms/view/widgets/report_widget.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';

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
    this.featured = false,
  });

  final AppwriteRoom room;
  final Participant participant;

  final bool featured;

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
            title: Expanded(
              child: Text(
                item.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: UiSizes.size_14),
              ),
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

  Future<void> _reportAndMaybeKick(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final draft = await showDialog<ReportDraft>(
      context: context,
      builder: (_) => ReportWidget(
        participantName: participant.name,
        participantId: participant.uid,
      ),
    );
    if (draft == null) return;

    final filed = await ref
        .read(roomSessionProvider(room).notifier)
        .reportAndKick(room, participant, report: draft);
    customSnackbar(
      filed ? l10n.success : l10n.error,
      filed ? l10n.reportSubmitted : l10n.reportFailed,
      filed ? LogType.success : LogType.error,
    );
  }

  List<FocusedMenuItem> _menuItems(
    BuildContext context,
    WidgetRef ref,
    Participant me,
  ) {
    if ((!me.isAdmin && !me.isModerator) || participant.isAdmin) return [];
    final notifier = ref.read(roomSessionProvider(room).notifier);

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
            () =>
                notifier.setRole(room, participant, ParticipantRole.moderator),
          ),
          if (participant.hasRequestedToBeSpeaker)
            _FocusedMenuItemData(
              AppLocalizations.of(context)!.addSpeaker,
              () =>
                  notifier.setRole(room, participant, ParticipantRole.speaker),
            ),
          if (participant.isSpeaker)
            _FocusedMenuItemData(
              AppLocalizations.of(context)!.makeListener,
              () =>
                  notifier.setRole(room, participant, ParticipantRole.listener),
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
    final me = ref.watch(roomSessionProvider(room)).value?.me;
    if (me == null) return const SizedBox.shrink();

    final avatarUrl = participant.dpUrl.isEmpty
        ? ref.watch(userProfileImagePlaceholderUrlProvider)
        : participant.dpUrl;

    final canOpenMenu =
        (me.isAdmin || (me.isModerator && !participant.isModerator)) &&
        !participant.isAdmin;

    return FocusedMenuHolder(
      onPressed: () {},
      menuItemExtent: MediaQuery.textScalerOf(context).scale(UiSizes.height_45),
      menuWidth: MediaQuery.sizeOf(context).width * 0.62,
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
      child: featured
          ? _featuredCard(context, avatarUrl)
          : _gridCard(context, avatarUrl),
    );
  }

  Widget _featuredCard(BuildContext context, String avatarUrl) {
    return _Card(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_25,
        vertical: UiSizes.height_26,
      ),
      child: Row(
        children: [
          _avatar(
            context,
            avatarUrl,
            radius: UiSizes.size_65,
            badgeSize: UiSizes.size_30,
          ),
          SizedBox(width: UiSizes.width_16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  participant.name.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: UiSizes.size_30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _userRole(context),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: UiSizes.size_20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The square tile used for speakers and listeners in the participant grid.
  Widget _gridCard(BuildContext context, String avatarUrl) {
    return _Card(
      padding: EdgeInsets.symmetric(
        vertical: UiSizes.height_15,
        horizontal: UiSizes.width_4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _avatar(
            context,
            avatarUrl,
            radius: UiSizes.size_26,
            badgeSize: UiSizes.size_18,
          ),
          SizedBox(height: UiSizes.height_8),
          Text(
            participant.name.split(' ').first,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: UiSizes.size_18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            _userRole(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: UiSizes.size_15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar(
    BuildContext context,
    String avatarUrl, {
    required double radius,
    required double badgeSize,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SpeakingAvatar(
          uid: participant.uid,
          radius: radius,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: CircleAvatar(
              radius: radius - UiSizes.width_2,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest,
              foregroundImage: NetworkImage(avatarUrl),
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          child: BadgeMark(uid: participant.uid, size: badgeSize),
        ),
        if (participant.isSpeaker)
          Positioned(
            right: 0,
            bottom: 0,
            child: _MicDot(isMicOn: participant.isMicOn, size: badgeSize),
          ),
        if (participant.hasRequestedToBeSpeaker)
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.waving_hand_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: badgeSize,
            ),
          ),
      ],
    );
  }
}

// Shared surface for both participant card shapes.
class _Card extends StatelessWidget {
  const _Card({required this.padding, required this.child});

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(UiSizes.width_16),
      ),
      child: child,
    );
  }
}

// Mic state as a filled disc on the avatar: green live, red muted.
class _MicDot extends StatelessWidget {
  const _MicDot({required this.isMicOn, required this.size});

  final bool isMicOn;
  final double size;

  @override
  Widget build(BuildContext context) {
    final statusColors = ActivityStatusColors.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isMicOn
            ? statusColors.online
            : Theme.of(context).colorScheme.error,
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: UiSizes.width_1_5,
        ),
      ),
      child: Center(
        child: Icon(
          isMicOn ? Icons.mic : Icons.mic_off,
          size: size * 0.6,
          color: statusColors.onStatus,
        ),
      ),
    );
  }
}
