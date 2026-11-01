import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/achievements/data/services/activity_recorder.dart';
import 'package:resonate/features/achievements/model/known_badge.dart';
import 'package:resonate/features/achievements/view/widgets/badge_visuals.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/widgets/snackbar.dart';
import 'package:resonate/utils/enums/log_type.dart';

// Wraps the whole app: badges are earned mid-room, never on the sheet.
class BadgeCelebration extends ConsumerStatefulWidget {
  const BadgeCelebration({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<BadgeCelebration> createState() => _BadgeCelebrationState();
}

class _BadgeCelebrationState extends ConsumerState<BadgeCelebration> {
  StreamSubscription<List<String>>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = ref
        .read(activityRecorderProvider.notifier)
        .badgesEarned
        .listen(_announce);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _announce(List<String> badgeIds) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    for (final badgeId in badgeIds) {
      final badge = KnownBadge.fromId(badgeId);
      if (badge == null) continue;
      customSnackbar(
        l10n.badgeUnlocked,
        l10n.badgeUnlockedMessage(badge.label(l10n)),
        LogType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
