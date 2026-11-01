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
    this.glyph,
    this.glyphLabel,
    super.key,
  });

  final ActivityStatus status;
  final double? size;
  final Color? borderColor;

  // A badge worn on top of the dot; IconData keeps this presentation-only.
  final IconData? glyph;
  final String? glyphLabel;

  @override
  Widget build(BuildContext context) {
    final dotSize = size ?? UiSizes.size_12;
    final statusColors = ActivityStatusColors.of(context);
    final color = status.color(statusColors);
    final border = borderColor ?? Theme.of(context).colorScheme.surface;
    final label = status.label(AppLocalizations.of(context)!);
    final badgeGlyph = glyph;

    // A hollow ring with an icon in it reads as neither, so a badge fills the dot.
    final isHollow = status.isHollow && badgeGlyph == null;

    return Semantics(
      label: glyphLabel == null ? label : '$label, $glyphLabel',
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isHollow ? border : color,
          border: Border.all(color: border, width: UiSizes.width_2),
        ),
        child: _inner(dotSize, color, statusColors, isHollow, badgeGlyph),
      ),
    );
  }

  Widget? _inner(
    double dotSize,
    Color color,
    ActivityStatusColors statusColors,
    bool isHollow,
    IconData? badgeGlyph,
  ) {
    if (isHollow) {
      return Center(
        child: Container(
          width: dotSize / 2,
          height: dotSize / 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: UiSizes.width_2),
          ),
        ),
      );
    }
    if (badgeGlyph == null) return null;
    return Center(
      child: Icon(
        badgeGlyph,
        size: dotSize * 0.62,
        color: statusColors.onStatus,
      ),
    );
  }
}
