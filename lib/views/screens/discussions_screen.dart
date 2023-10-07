import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({Key? key}) : super(key: key);

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_300,
              child: SvgPicture.asset(
                AppImages.timerImage,
              ),
            ),
            SizedBox(
              height: UiSizes.height_60,
            ),
            Text(
              "Coming Soon",
              style: TextStyle(
                  fontSize: UiSizes.size_25, fontFamily: 'Montserrat'),
            ),
          ],
        ),
      ),
    );
  }
}
