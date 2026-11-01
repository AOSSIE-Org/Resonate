import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:resonate/features/achievements/view/widgets/badge_mark.dart';
import 'package:resonate/features/achievements/view/widgets/badge_pill.dart';
import 'package:resonate/features/profile/data/user_avatars.dart';
import 'package:resonate/features/profile/data/user_profile_summaries.dart';
import 'package:resonate/features/theme/viewmodel/theme_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';


Future<void> showUserProfileCard(
  BuildContext context, {
  required String uid,
  required String name,
  required String avatarUrl,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.54),
    builder: (_) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: UserProfileCard(uid: uid, name: name, avatarUrl: avatarUrl),
    ),
  );
}

class UserProfileCard extends ConsumerWidget {
  const UserProfileCard({
    super.key,
    required this.uid,
    required this.name,
    required this.avatarUrl,
  });

  final String uid;
  final String name;
  final String avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final summary = ref.watch(userProfileSummaryProvider(uid)).value;
    final radius = UiSizes.size_56;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: UiSizes.width_25),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                // Leaves the top half of the avatar hanging over the card.
                margin: EdgeInsets.only(top: radius),
                padding: EdgeInsets.fromLTRB(
                  UiSizes.width_20,
                  radius + UiSizes.height_12,
                  UiSizes.width_20,
                  UiSizes.height_26,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      summary?.name.isNotEmpty == true ? summary!.name : name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: UiSizes.size_26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: UiSizes.height_26,
                      child: Text(
                        summary == null ? '' : '@${summary.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: UiSizes.size_16,
                        ),
                      ),
                    ),
                    SizedBox(height: UiSizes.height_10),
                    BadgePillRow(uid: uid),
                    SizedBox(height: UiSizes.height_20),
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            value: summary == null
                                ? _unknown
                                : _compactCount(context, summary.followerCount),
                            label: l10n.followers,
                          ),
                        ),
                        SizedBox(width: UiSizes.width_10),
                        Expanded(
                          child: _StatTile(
                            value: summary == null
                                ? _unknown
                                : summary.rating.toStringAsFixed(1),
                            label: l10n.stars,
                            trailing: Icon(
                              Icons.star,
                              size: UiSizes.size_20,
                              color: scheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _GlowAvatar(uid: uid, avatarUrl: avatarUrl, radius: radius),
              Positioned(
                top: radius + UiSizes.height_4,
                right: UiSizes.width_4,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  iconSize: UiSizes.size_24,
                  color: scheme.onSurfaceVariant,
                  tooltip: l10n.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const String _unknown = '—';

String _compactCount(BuildContext context, int value) {
  final locale = Localizations.localeOf(context).toString();
  return NumberFormat.compact(
    locale: NumberFormat.localeExists(locale) ? locale : 'en',
  ).format(value);
}

class _GlowAvatar extends ConsumerWidget {
  const _GlowAvatar({
    required this.uid,
    required this.avatarUrl,
    required this.radius,
  });

  final String uid;
  final String avatarUrl;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final best = bestAvatarUrl(ref, uid: uid, stored: avatarUrl);
    final url = best.isEmpty
        ? ref.watch(userProfileImagePlaceholderUrlProvider)
        : best;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.4),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: scheme.primary,
            child: CircleAvatar(
              radius: radius - UiSizes.size_8 / 2,
              backgroundColor: scheme.surfaceContainerHighest,
              foregroundImage: NetworkImage(url),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: BadgeMark(uid: uid, size: UiSizes.size_28),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label, this.trailing});

  final String value;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_8,
        vertical: UiSizes.height_14,
      ),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: UiSizes.size_24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: UiSizes.height_2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.onSurfaceVariant,
              fontSize: UiSizes.size_12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
