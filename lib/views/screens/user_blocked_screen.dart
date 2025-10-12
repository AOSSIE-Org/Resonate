import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/app_images.dart';

class UserBlockedScreen extends StatelessWidget {
  const UserBlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.noConnectionImage,
            height: 200,
            width: 200,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            AppLocalizations.of(context)!.userBlockedFromResonate,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
