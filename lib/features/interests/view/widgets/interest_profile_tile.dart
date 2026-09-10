import 'package:flutter/material.dart';
import 'package:resonate/features/interests/model/interest.dart';
import 'package:resonate/features/interests/view/widgets/interest_visuals.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/shared/model/resonate_user.dart';
import 'package:resonate/shared/widgets/secondary_list_card.dart';
import 'package:resonate/utils/ui_sizes.dart';

class InterestProfileTile extends StatelessWidget {
  const InterestProfileTile({
    required this.user,
    this.highlight = const <Interest>{},
    super.key,
  });

  final ResonateUser user;
  final Set<Interest> highlight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final interests = Interest.fromWireList(user.interests);
    final shared = highlight.isEmpty
        ? interests
        : interests.where(highlight.contains).toList();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePage(creator: user, isCreatorProfile: true),
        ),
      ),
      child: SecondaryListCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_10),
          child: Row(
            children: [
              CircleAvatar(
                radius: UiSizes.width_25,
                backgroundColor: scheme.surface,
                backgroundImage: (user.profileImageUrl ?? '').isEmpty
                    ? null
                    : NetworkImage(user.profileImageUrl!),
                child: (user.profileImageUrl ?? '').isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              SizedBox(width: UiSizes.width_16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      user.userName ?? user.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w500,
                        fontSize: UiSizes.size_17,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '${l10n.user} · ${user.name ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: UiSizes.size_12,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (shared.isNotEmpty) ...[
                      SizedBox(height: UiSizes.height_8),
                      Wrap(
                        spacing: UiSizes.width_6,
                        runSpacing: UiSizes.height_4,
                        children: [
                          for (final interest in shared)
                            _InterestTag(interest: interest),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InterestTag extends StatelessWidget {
  const _InterestTag({required this.interest});

  final Interest interest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiSizes.width_8,
        vertical: UiSizes.height_2,
      ),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(UiSizes.width_10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(interest.icon, size: UiSizes.size_12, color: scheme.primary),
          SizedBox(width: UiSizes.width_4),
          Text(
            interest.label(AppLocalizations.of(context)!),
            style: TextStyle(
              color: scheme.primary,
              fontSize: UiSizes.size_12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
