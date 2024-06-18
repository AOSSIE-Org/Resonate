import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resonate/new_themes/colors.dart';
import 'package:resonate/new_themes/new_theme.dart';
import 'package:resonate/utils/ui_sizes.dart';

class NewWelcomeScreen extends StatelessWidget {
  const NewWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_30,
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
                  height: UiSizes.height_110,
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
                ),
                SizedBox(
                  height: UiSizes.height_10,
                ),
                Text(
                  "Resonate",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: UiSizes.size_28
                  ),
                ),
              ],
            ),
            Text(
              '"Enter a world of limitless conversations."',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
            ),
            Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: UiSizes.height_10),
                      child: Text(
                        "Sign in with Email",
                        style: TextStyle(
                          fontSize: UiSizes.size_16,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: UiSizes.height_30),
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
                      Text("OR", style: Theme.of(context).textTheme.bodyLarge,),
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
                SizedBox(height: UiSizes.height_20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
                        onPressed: () {},
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: UiSizes.width_30,
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: IconButton(
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
