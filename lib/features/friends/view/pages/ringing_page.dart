import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/friends/data/services/friend_call_coordinator.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class RingingPage extends ConsumerWidget {
  const RingingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimaryColor = theme.colorScheme.onPrimary;
    final call = ref.watch(friendCallCoordinatorProvider).activeCall;
    if (call == null) return const Scaffold(body: SizedBox.shrink());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
          child: Column(
            children: [
              Text(
                "Calling ${call.recieverName}...",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: MediaQuery.of(context).devicePixelRatio * 6.5,
                ),
              ),
              SizedBox(height: UiSizes.height_5),
              Text(
                "Ringing...",
                style: TextStyle(
                  fontSize: UiSizes.size_14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              _buildLoadingIndicator(
                context,
                primaryColor,
                call.recieverProfileImageUrl,
              ),
              const Spacer(),
              _buildFooter(context, ref, primaryColor, onPrimaryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(
    BuildContext context,
    Color primaryColor,
    String profileImageUrl,
  ) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UiSizes.width_20,
            vertical: UiSizes.height_20,
          ),
          child: LoadingIndicator(
            indicatorType: Indicator.ballScaleMultiple,
            colors: [
              primaryColor.withValues(alpha: 0.2),
              primaryColor,
              primaryColor.withValues(alpha: 0.6),
            ],
            strokeWidth: UiSizes.width_2,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.05,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    BuildContext context,
    WidgetRef ref,
    Color primaryColor,
    Color onPrimaryColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.quickFact,
            style: TextStyle(
              color: primaryColor,
              fontSize: MediaQuery.of(context).devicePixelRatio * 6.5,
            ),
          ),
          Text(
            AppLocalizations.of(context)!.resonateOpenSourceProject,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: UiSizes.size_14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: UiSizes.height_15),
          ElevatedButton(
            onPressed: () => ref.read(friendCallCoordinatorProvider.notifier).endCall(),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: onPrimaryColor,
                fontSize: MediaQuery.of(context).devicePixelRatio * 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
