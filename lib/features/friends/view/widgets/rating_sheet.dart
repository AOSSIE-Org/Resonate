import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/friends/viewmodel/pair_chat_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RatingSheet extends ConsumerWidget {
  const RatingSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pairRating =
        ref.watch(pairChatProvider.select((s) => s.pairRating));
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
              customFilledIcon: Icons.star,
              customHalfFilledIcon: Icons.star_half,
              customEmptyIcon: Icons.star_border_outlined,
              displayRatingValue: true,
              initialRating: 2.5,
              minRating: 0.0,
              maxRating: 5.0,
              interactiveTooltips: true,
              filledIcon: Icons.star,
              halfFilledIcon: Icons.star_half,
              emptyIcon: Icons.star_border_outlined,
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await ref.read(pairChatProvider.notifier).submitRating();
                navigator.pop();
              },
              child: Text(l10n.submit),
            ),
          ],
        ),
      ),
    );
  }
}
