import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/discussions_controller.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/discussions_screen.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateRoomScreen extends StatelessWidget {
  final CreateRoomController createRoomController =
      Get.find<CreateRoomController>();

  final DiscussionsController discussionsController =
      Get.put<DiscussionsController>(DiscussionsController());

  OutlineInputBorder kEnabledTextFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.amber),
      borderRadius: BorderRadius.circular(15));

  OutlineInputBorder kFocusedTextFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber, width: UiSizes.width_2),
      borderRadius: BorderRadius.circular(15));

  CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateRoomController>(
      builder: (controller) => GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_25),
            child: Form(
              key: controller.createRoomFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: UiSizes.height_24_6,
                  ),
                  Text(
                    "Create New Room",
                    style: TextStyle(fontSize: Get.textScaleFactor * 35),
                  ),
                  SizedBox(
                    height: UiSizes.height_24_6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Obx(
                        () => TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: !controller.isScheduled.value
                                  ? const Color.fromARGB(53, 253, 212, 31)
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: !controller.isScheduled.value
                                          ? AppColor.yellowColor
                                          : Colors.transparent),
                                  borderRadius:
                                      BorderRadius.circular(UiSizes.size_15)),
                              textStyle: TextStyle(),
                            ),
                            onPressed: () {
                              controller.isScheduled.value = false;
                            },
                            child: Text(
                              'Start Now',
                              style: TextStyle(fontSize: UiSizes.size_14),
                            )),
                      ),
                      Obx(
                        () => TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: controller.isScheduled.value
                                  ? const Color.fromARGB(53, 253, 212, 31)
                                  : Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: !controller.isScheduled.value
                                          ? Colors.transparent
                                          : AppColor.yellowColor),
                                  borderRadius:
                                      BorderRadius.circular(UiSizes.size_15)),
                            ),
                            onPressed: () {
                              controller.isScheduled.value = true;
                            },
                            child: Text(
                              'Scheduled',
                              style: TextStyle(fontSize: UiSizes.size_14),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: UiSizes.height_24_6,
                  ),
                  Obx(
                    () => controller.isScheduled.value
                        ? SizedBox(
                            height: UiSizes.height_66,
                            child: TextFormField(
                              style: TextStyle(fontSize: UiSizes.size_14),
                              validator: (value) => value!.isNotEmpty
                                  ? null
                                  : "Please Enter Scheduled Date-Time",
                              readOnly: true,
                              controller:
                                  discussionsController.dateTimeController,
                              keyboardType: TextInputType.text,
                              autocorrect: false,
                              decoration: InputDecoration(
                                icon: Icon(
                                  Icons.calendar_month,
                                  size: UiSizes.size_23,
                                ),
                                labelText: "Schedule Date Time",
                                labelStyle:
                                    TextStyle(fontSize: UiSizes.size_14),
                                suffix: GestureDetector(
                                  onTap: () async {
                                    await discussionsController
                                        .chooseDateTime();
                                  },
                                  child: const Icon(Icons.date_range),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ),
                  Obx(
                    () => controller.isScheduled.value
                        ? SizedBox(
                            height: UiSizes.heigth_33,
                          )
                        : SizedBox(),
                  ),
                  TextFormField(
                    controller: controller.nameController,
                    style: TextStyle(fontSize: UiSizes.size_25),
                    cursorColor: Colors.amber,
                    minLines: 1,
                    maxLines: 13,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        if (value.length < 80) {
                          return null;
                        } else {
                          return "Name can't be longer than 80 chars";
                        }
                      }
                      return "Name is required";
                    },
                    decoration: InputDecoration(
                      hintText: "Give a great name..",
                      filled: true,
                      fillColor: const Color(0x15FFFFFF),
                      border: kEnabledTextFieldBorder,
                      enabledBorder: kEnabledTextFieldBorder,
                      focusedBorder: kFocusedTextFieldBorder,
                    ),
                  ),
                  SizedBox(
                    height: UiSizes.heigth_33,
                  ),
                  TextFieldTags(
                    textfieldTagsController: controller.tagsController,
                    initialTags: const ['sample-tag'],
                    textSeparators: const [' ', ','],
                    letterCase: LetterCase.normal,
                    validator: (String tag) =>
                        tag.isValidTag() ? null : "Invalid Tag",
                    inputfieldBuilder:
                        (context, tec, fn, error, onChanged, onSubmitted) {
                      return ((context, sc, tags, onTagDelete) {
                        return TextField(
                          style: TextStyle(fontSize: UiSizes.size_20),
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0x15FFFFFF),
                            isDense: true,
                            border: kEnabledTextFieldBorder,
                            enabledBorder: kEnabledTextFieldBorder,
                            focusedBorder: kFocusedTextFieldBorder,
                            hintText: "Enter tags",
                            errorText: error,
                            prefixIconConstraints:
                                BoxConstraints(maxWidth: UiSizes.width_304),
                            prefixIcon: tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller: sc,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: tags.map((String tag) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(UiSizes.size_20),
                                          ),
                                          color: Colors.black54,
                                        ),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: UiSizes.width_5),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: UiSizes.width_10,
                                            vertical: UiSizes.height_5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: UiSizes.size_18),
                                              ),
                                              onTap: () {
                                                //log("$tag selected");
                                              },
                                            ),
                                            SizedBox(width: UiSizes.width_4),
                                            InkWell(
                                              child: Icon(
                                                Icons.cancel,
                                                size: UiSizes.size_18,
                                                color:
                                                    Colors.red.withOpacity(0.7),
                                              ),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                  )
                                : null,
                          ),
                          onChanged: onChanged,
                          onSubmitted: onSubmitted,
                        );
                      });
                    },
                  ),
                  SizedBox(
                    height: UiSizes.heigth_33,
                  ),
                  TextFormField(
                    controller: controller.descriptionController,
                    style: TextStyle(fontSize: UiSizes.size_20),
                    cursorColor: Colors.amber,
                    maxLines: 10,
                    validator: (value) {
                      if (value!.isNotEmpty && value.length > 500) {
                        return "Can't be longer than 500 chars";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Room Description (optional)",
                      filled: true,
                      fillColor: const Color(0x15FFFFFF),
                      border: kEnabledTextFieldBorder,
                      enabledBorder: kEnabledTextFieldBorder,
                      focusedBorder: kFocusedTextFieldBorder,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
