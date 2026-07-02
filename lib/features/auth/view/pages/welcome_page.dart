import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resonate/features/auth/view/widgets/welcome_dialog.dart';
import 'package:resonate/features/auth/viewmodel/auth_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_20,
          horizontal: UiSizes.width_30,
        ),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(
                  'assets/svg/resonate_logo_white.svg',
                  semanticsLabel: AppLocalizations.of(context)!.resonateLogo,
                  height: UiSizes.height_110,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: UiSizes.height_10),
                Text(
                  AppLocalizations.of(context)!.title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: UiSizes.size_28,
                  ),
                ),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.resonateTagline,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        context: context,
                        builder: welcomeAuthDialog,
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.signInWithEmail),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: UiSizes.height_20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: UiSizes.width_20,
                          ),
                          child: const Divider(),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.or,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: UiSizes.width_20,
                          ),
                          child: const Divider(),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.continueWith,
                  style: TextStyle(
                    fontSize: UiSizes.size_20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: UiSizes.height_20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _OAuthButton(
                      tooltip:
                          AppLocalizations.of(context)!.continueWithGoogle,
                      icon: FontAwesomeIcons.google,
                      onPressed: () =>
                          ref.read(authProvider.notifier).loginWithGoogle(),
                    ),
                    SizedBox(width: UiSizes.width_20),
                    _OAuthButton(
                      tooltip:
                          AppLocalizations.of(context)!.continueWithGitHub,
                      icon: FontAwesomeIcons.github,
                      onPressed: () =>
                          ref.read(authProvider.notifier).loginWithGithub(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OAuthButton extends StatelessWidget {
  const _OAuthButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // Literal on purpose: 50×50 square with no close UiSizes.size_ token
      // (width_/height_ tokens scale differently per axis and would distort it).
      height: 50,
      width: 50,
      child: IconButton(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        icon: FaIcon(icon),
      ),
    );
  }
}
