import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:resonate/controllers/upcomming_rooms_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateRoomScreen extends StatelessWidget {
  final TabViewController tabViewController = Get.find<TabViewController>();
  final CreateRoomController createRoomController =
      Get.put<CreateRoomController>(CreateRoomController());
  final UpcomingRoomsController upcomingRoomsController =
      Get.put<UpcomingRoomsController>(UpcomingRoomsController());

  CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BoxDecoration kTextFieldDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.secondary.withAlpha((255 * 0.8).round()),
          const Color.fromARGB(255, 139, 134, 134),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        const BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 3),
          blurRadius: 6,
        ),
        BoxShadow(
          color: Colors.white.withAlpha((255 * 0.3).round()),
          offset: const Offset(-2, -2),
          blurRadius: 3,
          spreadRadius: 1,
        ),
      ],
    );

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        tabViewController.setIndex(0);
      },
      child: GetBuilder<CreateRoomController>(
        builder: (controller) => Obx(
          () => Stack(
            children: [
              GestureDetector(
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
                          SizedBox(height: UiSizes.height_24_6),
                          Text(
                            "Create New Room",
                            style: TextStyle(
                              fontSize: Get.textScaleFactor * 35,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SizedBox(height: UiSizes.height_24_6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Obx(
                                () => GestureDetector(
                                  onTap: () =>
                                      controller.isScheduled.value = false,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(
                                        vertical: UiSizes.height_10,
                                        horizontal: UiSizes.width_20),
                                    decoration: BoxDecoration(
                                      color: controller.isScheduled.value
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha((255 * 0.5).round())
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      'Live',
                                      style: TextStyle(
                                          fontSize: UiSizes.size_14,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? controller.isScheduled.value
                                                  ? Colors.black
                                                  : Colors.white
                                              : Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Obx(
                                () => GestureDetector(
                                  onTap: () =>
                                      controller.isScheduled.value = true,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(
                                        vertical: UiSizes.height_10,
                                        horizontal: UiSizes.width_20),
                                    decoration: BoxDecoration(
                                      color: controller.isScheduled.value
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      'Scheduled',
                                      style: TextStyle(
                                          fontSize: UiSizes.size_14,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? controller.isScheduled.value
                                                  ? Colors.white
                                                  : Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: UiSizes.height_24_6),
                          Obx(
                            () => controller.isScheduled.value
                                ? SizedBox(
                                    height: UiSizes.height_66,
                                    child: TextFormField(
                                      style:
                                          TextStyle(fontSize: UiSizes.size_14),
                                      validator: (value) => value!.isNotEmpty
                                          ? null
                                          : "Please Enter Scheduled Date-Time",
                                      readOnly: true,
                                      controller: upcomingRoomsController
                                          .dateTimeController,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.calendar_month,
                                          size: UiSizes.size_23,
                                        ),
                                        labelText: "Schedule Date Time",
                                        labelStyle: TextStyle(
                                            fontSize: UiSizes.size_14),
                                        suffix: GestureDetector(
                                          onTap: () async {
                                            await upcomingRoomsController
                                                .chooseDateTime();
                                          },
                                          child: const Icon(Icons.date_range),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          Obx(
                            () => controller.isScheduled.value
                                ? SizedBox(height: UiSizes.height_33)
                                : const SizedBox(),
                          ),
                          Container(
                            decoration: kTextFieldDecoration,
                            child: TextFormField(
                              controller: controller.nameController,
                              style: TextStyle(fontSize: UiSizes.size_25),
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              minLines: 1,
                              maxLines: 13,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (value.length <= 30) {
                                    return null;
                                  } else {
                                    return "Name can't be longer than 30 chars";
                                  }
                                }
                                return "Name is required";
                              },
                              decoration: InputDecoration(
                                hintText: "Give a great name..",
                                prefixIcon: Icon(Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary), // Icon decoration
                                filled: false,
                                border: InputBorder
                                    .none, // No border as it's managed by decoration
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          SizedBox(height: UiSizes.height_33),
                          Container(
                            decoration: kTextFieldDecoration,
                            child: TextFieldTags(
                              textfieldTagsController:
                                  controller.tagsController,
                              initialTags: const ['sample-tag'],
                              textSeparators: const [' ', ','],
                              letterCase: LetterCase.normal,
                              validator: (tag) {
                                return controller.validateTag(tag);
                              },
                              inputFieldBuilder: (context, inputFieldValues) {
                                return TextField(
                                  style: TextStyle(fontSize: UiSizes.size_20),
                                  controller:
                                      inputFieldValues.textEditingController,
                                  focusNode: inputFieldValues.focusNode,
                                  decoration: InputDecoration(
                                    hintText: inputFieldValues.tags.isNotEmpty
                                        ? null
                                        : "Enter tags",
                                    filled: false,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.all(16),
                                    errorText: inputFieldValues.error,
                                    prefixIconConstraints: BoxConstraints(
                                        maxWidth: UiSizes.width_304),
                                    prefixIcon: inputFieldValues.tags.isNotEmpty
                                        ? SingleChildScrollView(
                                            controller: inputFieldValues
                                                .tagScrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                                children: inputFieldValues.tags
                                                    .map((tag) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(
                                                        UiSizes.size_20),
                                                  ),
                                                  color: Colors.black54,
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        UiSizes.width_5),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        UiSizes.width_10,
                                                    vertical: UiSizes.height_5),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '#$tag',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: UiSizes
                                                              .size_18),
                                                    ),
                                                    SizedBox(
                                                        width: UiSizes.width_4),
                                                    InkWell(
                                                      child: Icon(
                                                        Icons.cancel,
                                                        size: UiSizes.size_18,
                                                        color: Colors.red
                                                            .withAlpha((255 *
                                                            0.7).round()),
                                                      ),
                                                      onTap: () {
                                                        inputFieldValues
                                                            .onTagRemoved(tag);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              );
                                            }).toList() as List<Widget>),
                                          )
                                        : null,
                                  ),
                                  onChanged: inputFieldValues.onTagChanged,
                                  onSubmitted: inputFieldValues.onTagSubmitted,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: UiSizes.height_33),
                          Container(
                            decoration: kTextFieldDecoration,
                            child: TextFormField(
                              controller: controller.descriptionController,
                              style: TextStyle(fontSize: UiSizes.size_20),
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              maxLines: 10,
                              validator: (value) {
                                if (value!.isNotEmpty && value.length > 500) {
                                  return "Can't be longer than 500 chars";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: "Room Description (optional)",
                                filled: false,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              controller.isLoading.value
                  ? BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Theme.of(context).colorScheme.primary,
                          size: Get.pixelRatio * 50,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
