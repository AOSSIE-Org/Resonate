import 'package:flutter/material.dart';

enum Themes { classic, vintage, forest, cream, amber, time }

// Icons w.r.t their Themes
enum ThemeIcons {
  classic('classic', Icons.diamond),
  vintage('vintage', Icons.temple_buddhist_rounded),
  forest('forest', Icons.forest),
  cream('cream', Icons.nights_stay),
  amber('amber', Icons.local_fire_department),
  time('time', Icons.access_time_outlined);

  final String theme;
  final IconData icon;
  const ThemeIcons(this.theme, this.icon);
}
  