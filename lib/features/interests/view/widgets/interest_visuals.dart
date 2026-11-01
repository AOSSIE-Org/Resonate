import 'package:flutter/material.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/l10n/app_localizations.dart';

extension InterestPresentation on Interest {
  IconData get icon => switch (this) {
    Interest.ai => Icons.psychology_rounded,
    Interest.music => Icons.music_note_rounded,
    Interest.fitness => Icons.fitness_center_rounded,
    Interest.anime => Icons.animation_rounded,
    Interest.gaming => Icons.sports_esports_rounded,
    Interest.technology => Icons.memory_rounded,
    Interest.movies => Icons.movie_rounded,
    Interest.books => Icons.menu_book_rounded,
    Interest.art => Icons.palette_rounded,
    Interest.travel => Icons.flight_takeoff_rounded,
    Interest.food => Icons.restaurant_rounded,
    Interest.sports => Icons.sports_basketball_rounded,
    Interest.business => Icons.business_center_rounded,
    Interest.science => Icons.science_rounded,
    Interest.comedy => Icons.theater_comedy_rounded,
    Interest.wellness => Icons.self_improvement_rounded,
  };

  String label(AppLocalizations l10n) => l10n.interestLabel(wire);
}
