import 'package:animated_rating_stars_v2/animated_rating_stars_v2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/data/pair_chat_session.dart';
import 'package:resonate/features/rooms/model/user_report_model.dart';
import 'package:resonate/features/rooms/view/widgets/report_widget.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/shared/widgets/snackbar.dart';

class RatingSheet extends ConsumerWidget {
  const RatingSheet({super.key});

  // The pair chat can be anonymous, so reports are the only moderation lever
  // once it ends. Keep the details field short (200 chars) here.
  Future<void> _reportPartner(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final partnerName = ref.read(pairChatProvider).pairUsername ?? l10n.user2;
    final draft = await showDialog<ReportDraft>(
      context: context,
      builder: (_) => ReportWidget(
        participantName: partnerName,
        participantId: ref.read(pairChatProvider).partnerUid ?? '',
        maxLength: 200,
      ),
    );
    if (draft == null) return;
    var filed = true;
    try {
      await ref.read(pairChatProvider.notifier).reportPartner(draft);
    } catch (e) {
      filed = false;
    }
    customSnackbar(
      filed ? l10n.success : l10n.error,
      filed ? l10n.reportSubmitted : l10n.reportFailed,
      filed ? LogType.success : LogType.error,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairRating = ref.watch(pairChatProvider.select((s) => s.pairRating));
    // Anonymous pairings expose no profile, so an after-the-fact report is only way to flag abuse.
    final canReport = ref.watch(
      pairChatProvider.select((s) => s.isAnonymous && s.partnerUid != null),
    );
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      height: UiSizes.height_246,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(UiSizes.size_20),
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              l10n.rateYourExperience,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Rating: ${pairRating.toStringAsFixed(1)}/5.0'),
            AnimatedRatingStars(
              onChanged: (double rating) {
                ref.read(pairChatProvider.notifier).setPairRating(rating);
              },

              displayRatingValue: true,
              initialRating: 2.5,
              minRating: 0.0,
              maxRating: 5.0,
              interactiveTooltips: true,
              filledIcon: Icons.star,
              halfFilledIcon: Icons.star_half,
              emptyIcon: Icons.star_border_outlined,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (canReport)
                  Flexible(
                    child: TextButton.icon(
                      onPressed: () => _reportPartner(context, ref),
                      icon: const Icon(Icons.flag_outlined),
                      label: Text(
                        l10n.reportParticipant,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                if (canReport) SizedBox(width: UiSizes.width_10),
                ElevatedButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    try {
                      await ref.read(pairChatProvider.notifier).submitRating();
                    } catch (e) {
                      customSnackbar(l10n.error, e.toString(), LogType.error);
                    } finally {
                      navigator.pop();
                    }
                  },
                  child: Text(l10n.submit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
