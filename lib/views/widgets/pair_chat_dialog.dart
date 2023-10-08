import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';
import 'package:resonate/controllers/pair_chat_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

import '../../controllers/auth_state_controller.dart';
import '../../utils/colors.dart';

Future<dynamic> buildPairChatDialog() {
  PairChatController controller = Get.find<PairChatController>();
  return Get.defaultDialog(
      title: "Pair Chat",
      titleStyle: TextStyle(fontSize: Get.pixelRatio * 10),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: UiSizes.width_20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "Choose Identity",
              style:
                  TextStyle(fontSize: Get.pixelRatio * 6),
            ),
            SizedBox(
              height: UiSizes.height_10,
            ),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.isAnonymous.value = true;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isAnonymous.value
                              ? AppColor.yellowColor
                              : Colors.black26,
                            shadowColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent
                        ),
                        child: Text(
                          'Anonymous',
                          style: TextStyle(
                              color: controller.isAnonymous.value
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: UiSizes.size_14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !controller.isAnonymous.value
                              ? AppColor.yellowColor
                              : Colors.black26,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent
                        ),
                        onPressed: () {
                          controller.isAnonymous.value = false;
                        },
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            Get.find<AuthStateController>().displayName!,
                            style: TextStyle(
                                color: controller.isAnonymous.value
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: UiSizes.size_14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: UiSizes.height_10,
            ),
            const Divider(),
            Text(
              "Select Language",
              style: TextStyle(
                fontSize: Get.pixelRatio * 6,
              ),
            ),
            LanguagePickerDropdown(
                initialValue: Languages.english,
                onValuePicked: (Language language) {
                  log(language.isoCode);
                  controller.languageIso = language.isoCode;
                }),
            const Divider(),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.people_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                controller.quickMatch();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.yellowColor,
              ),
              label: Text(
                "Resonate",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: UiSizes.size_21_3,
                ),
              ),
            ),
          ],
        ),
      ));
}
