import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';

import '../../controllers/auth_state_controller.dart';
import '../../utils/colors.dart';

Future<dynamic> buildPairChatDialog() {
  return Get.defaultDialog(
      title: "Pair Chat",
      titleStyle: TextStyle(color: Colors.amber, fontSize: Get.pixelRatio * 10),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            Text(
              "Choose Identity",
              style: TextStyle(color: Colors.amber, fontSize: Get.pixelRatio * 6),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: true ? AppColor.yellowColor : AppColor.bgBlackColor,
                      ),
                      child: Text(
                        'Anonymous',
                        style: TextStyle(
                          color: true ? Colors.black : Colors.white,
                        ),
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
                        backgroundColor: false ? AppColor.yellowColor : AppColor.bgBlackColor,
                      ),
                      onPressed: () => {},
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          Get.find<AuthStateController>().displayName!,
                          style: TextStyle(
                            color: false ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Text(
              "Select Language",
              style: TextStyle(color: Colors.amber, fontSize: Get.pixelRatio * 6),
            ),
            LanguagePickerDropdown(
                initialValue: Languages.english,
                onValuePicked: (Language language) {
                  log(language.isoCode);
                }),
            const Divider(),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.people_outlined,
                color: Colors.black,
              ),
              onPressed: () => {
                //Add user request to appwrite requests collection
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.yellowColor,
              ),
              label: Text(
                "Quick Match",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 0.013 * Get.height + 0.026 * Get.width,
                ),
              ),
            ),
          ],
        ),
      ));
}
