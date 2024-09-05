import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/authentication_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/new_themes/theme_screen.dart';
import 'package:resonate/views/new_widgets/welcome_screen_dialog.dart';

class NewWelcomeScreen extends StatelessWidget {
  var controller = Get.find<AuthenticationController>();
  NewWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  "assets/svg/resonate_logo_white.svg",
                  semanticsLabel: "Resonate Logo",
                  height: UiSizes.height_110,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(
                  height: UiSizes.height_10,
                ),
                Text(
                  "Resonate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: UiSizes.size_28,
                  ),
                ),
              ],
            ),
            Text('"Enter a world of limitless\nconversations."',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
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
                        builder: (context) => welcomeScreenDialog(context),
                      );
                    },
                    child: const Text(
                      "Sign in with Email",
                    ),
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
                        "Or",
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
                  "Continue with",
                  style: TextStyle(
                    fontSize: UiSizes.size_20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: UiSizes.height_20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        tooltip: "Continue with Google",
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () async {
                          await controller.loginWithGoogle();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: UiSizes.width_20,
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        tooltip: "Continue with GitHub",
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.github,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
