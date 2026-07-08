import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class UserBlockedPage extends StatelessWidget {
  const UserBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.noConnectionImage,
            height: UiSizes.size_200,
            width: UiSizes.size_200,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: UiSizes.height_30),
          Text(
            AppLocalizations.of(context)!.userBlockedFromResonate,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: UiSizes.size_15, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
