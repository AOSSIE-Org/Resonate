import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/constants.dart';

class ContributeScreen extends StatelessWidget {
  const ContributeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contribute"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: UiSizes.height_20,
          horizontal: UiSizes.width_20,
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Uri url = Uri.parse(githubRepoUrl);
                try {
                  launchUrl(url);
                } catch (e) {
                  log("Error launching URL: ${e.toString()}");
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_20,
                  horizontal: UiSizes.width_20,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Source code on GitHub',
                      style: TextStyle(
                        fontSize: UiSizes.size_16,
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: UiSizes.height_40,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: UiSizes.height_20,
                horizontal: UiSizes.width_20,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Join Community",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: UiSizes.height_20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.telegram_rounded,
                          size: UiSizes.size_40,
                        ),
                        tooltip: "Join telegram channel",
                      ),
                      IconButton(
                        onPressed: () {
                          Uri url = Uri.parse(discordRepoUrl);
                          try {
                            launchUrl(url);
                          } catch (e) {
                            log("Error launching URL: ${e.toString()}");
                          }
                        },
                        icon: Icon(
                          Icons.discord,
                          size: UiSizes.size_40,
                        ),
                        tooltip: "Join discord server",
                      )
                    ],
                  ),
                  SizedBox(
                    height: UiSizes.height_20,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "By joining community you can Clear your doubts, Suggest for new features, Report issues you faced and More.",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
