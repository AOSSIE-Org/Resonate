import 'package:flutter/material.dart';

@immutable
class ActivityStatusColors extends ThemeExtension<ActivityStatusColors> {
  const ActivityStatusColors({
    required this.online,
    required this.dnd,
    required this.inRoom,
    required this.invisible,
    required this.offline,
  });

  final Color online;
  final Color dnd;
  final Color inRoom;
  final Color invisible;
  final Color offline;

  static const ActivityStatusColors light = ActivityStatusColors(
    online: Color(0xFF3BA55D),
    dnd: Color(0xFFED4245),
    inRoom: Color(0xFFFAA81A),
    invisible: Color(0xFF80848E),
    offline: Color(0xFF80848E),
  );

  static const ActivityStatusColors dark = ActivityStatusColors(
    online: Color(0xFF43B581),
    dnd: Color(0xFFF04747),
    inRoom: Color(0xFFFAA61A),
    invisible: Color(0xFF949BA4),
    offline: Color(0xFF949BA4),
  );


  static ActivityStatusColors of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<ActivityStatusColors>() ??
        (theme.brightness == Brightness.dark ? dark : light);
  }

  @override
  ActivityStatusColors copyWith({
    Color? online,
    Color? dnd,
    Color? inRoom,
    Color? invisible,
    Color? offline,
  }) {
    return ActivityStatusColors(
      online: online ?? this.online,
      dnd: dnd ?? this.dnd,
      inRoom: inRoom ?? this.inRoom,
      invisible: invisible ?? this.invisible,
      offline: offline ?? this.offline,
    );
  }

  @override
  ActivityStatusColors lerp(
    covariant ThemeExtension<ActivityStatusColors>? other,
    double t,
  ) {
    if (other is! ActivityStatusColors) return this;
    return ActivityStatusColors(
      online: Color.lerp(online, other.online, t)!,
      dnd: Color.lerp(dnd, other.dnd, t)!,
      inRoom: Color.lerp(inRoom, other.inRoom, t)!,
      invisible: Color.lerp(invisible, other.invisible, t)!,
      offline: Color.lerp(offline, other.offline, t)!,
    );
  }
}
