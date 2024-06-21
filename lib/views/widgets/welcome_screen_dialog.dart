import 'package:flutter/material.dart';
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
          padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
          child: Text(
            "Sign in with email",
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
                Get.offNamed(AppRoutes.newLoginScreen);
              },
              child: Container(
                color: Colors.transparent,
                height: UiSizes.height_40,
                padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "I already have an account",
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
            Container(
              color: Colors.transparent,
              height: UiSizes.height_40,
              padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create new account",
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
          ],
        ),


      ],
    ),
  );
}
