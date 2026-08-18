import 'package:flutter/material.dart';
import 'package:resonate/features/theme/model/activity_status_colors.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/activity_status.dart';
import 'package:resonate/utils/ui_sizes.dart';


extension ActivityStatusPresentation on ActivityStatus {
  Color color(ActivityStatusColors colors) => switch (this) {
    ActivityStatus.online => colors.online,
    ActivityStatus.dnd => colors.dnd,
    ActivityStatus.inRoom => colors.inRoom,
    ActivityStatus.invisible => colors.invisible,
    ActivityStatus.offline => colors.offline,
  };

  bool get isHollow =>
      this == ActivityStatus.invisible || this == ActivityStatus.offline;

  IconData get icon => switch (this) {
    ActivityStatus.online => Icons.check_circle,
    ActivityStatus.dnd => Icons.do_not_disturb_on,
    ActivityStatus.inRoom => Icons.multitrack_audio,
    ActivityStatus.invisible => Icons.visibility_off,
    ActivityStatus.offline => Icons.circle_outlined,
  };

  String label(AppLocalizations l10n) => switch (this) {
    ActivityStatus.online => l10n.activityOnline,
    ActivityStatus.dnd => l10n.activityDnd,
    ActivityStatus.inRoom => l10n.activityInRoom,
    ActivityStatus.invisible => l10n.activityInvisible,
    ActivityStatus.offline => l10n.activityOffline,
  };

  String callBlockedMessage(AppLocalizations l10n, String username) =>
      switch (this) {
        ActivityStatus.dnd => l10n.callBlockedDnd(username),
        ActivityStatus.inRoom => l10n.callBlockedInRoom(username),
        _ => description(l10n),
      };

  String description(AppLocalizations l10n) => switch (this) {
    ActivityStatus.online => l10n.activityOnlineDescription,
    ActivityStatus.dnd => l10n.activityDndDescription,
    ActivityStatus.inRoom => l10n.activityInRoomDescription,
    ActivityStatus.invisible => l10n.activityInvisibleDescription,
    ActivityStatus.offline => l10n.activityOfflineDescription,
  };
}

class ActivityDot extends StatelessWidget {
  const ActivityDot({
    required this.status,
    this.size,
    this.borderColor,
    super.key,
  });

  final ActivityStatus status;
  final double? size;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final dotSize = size ?? UiSizes.size_12;
    final color = status.color(ActivityStatusColors.of(context));
    final border = borderColor ?? Theme.of(context).colorScheme.surface;

    return Semantics(
      label: status.label(AppLocalizations.of(context)!),
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: status.isHollow ? border : color,
          border: Border.all(color: border, width: UiSizes.width_2),
        ),
        child: status.isHollow
            ? Center(
                child: Container(
                  width: dotSize / 2,
                  height: dotSize / 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: UiSizes.width_2),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
