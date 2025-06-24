import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/ui_sizes.dart';

Widget welcomeScreenDialog(BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(
      vertical: UiSizes.height_20,
    ),
    width: double.maxFinite,
    height: UiSizes.height_246,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),          child: Text(
            AppLocalizations.of(context)!.signInWithEmail,
            style: TextStyle(
              fontSize: UiSizes.size_20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.offNamed(AppRoutes.loginScreen);
              },
              child: Container(
                color: Colors.transparent,
                height: UiSizes.height_40,
                padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [                    Text(
                      AppLocalizations.of(context)!.iAlreadyHaveAnAccount,
                      style: TextStyle(
                        fontSize: UiSizes.size_15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: UiSizes.height_20,
            ),
            GestureDetector(
              onTap: () {
                Get.offNamed(AppRoutes.signup);
              },
              child: Container(
                color: Colors.transparent,
                height: UiSizes.height_40,
                padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [                    Text(
                      AppLocalizations.of(context)!.createNewAccount,
                      style: TextStyle(
                        fontSize: UiSizes.size_15,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
