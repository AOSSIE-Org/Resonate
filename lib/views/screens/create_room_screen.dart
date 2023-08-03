import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateRoomScreen extends StatelessWidget {
  final CreateRoomController createRoomController =
      Get.put<CreateRoomController>(CreateRoomController());

  OutlineInputBorder kEnabledTextFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber),
      borderRadius: BorderRadius.circular(15));

  OutlineInputBorder kFocusedTextFieldBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber, width: 0.004861),
      borderRadius: BorderRadius.circular(15));

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateRoomController>(
        builder: (controller) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0.0607 * Get.width),
                child: Form(
                  key: controller.createRoomFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Text(
                        "Create New Room",
                        style: TextStyle(fontSize: Get.textScaleFactor * 35),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      TextFormField(
                        controller: controller.nameController,
                        style: TextStyle(
                            fontSize: 0.01521 * Get.height + 0.03 * Get.width),
                        cursorColor: Colors.amber,
                        minLines: 1,
                        maxLines: 3,
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
                          fillColor: Color(0x15FFFFFF),
                          border: kEnabledTextFieldBorder,
                          enabledBorder: kEnabledTextFieldBorder,
                          focusedBorder: kFocusedTextFieldBorder,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.04,
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
                              style: TextStyle(fontSize: 0.012*Get.height+0.024*Get.width),
                              controller: tec,
                              focusNode: fn,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0x15FFFFFF),
                                isDense: true,
                                border: kEnabledTextFieldBorder,
                                enabledBorder: kEnabledTextFieldBorder,
                                focusedBorder: kFocusedTextFieldBorder,
                                hintText: "Enter tags",
                                errorText: error,
                                prefixIconConstraints:
                                    BoxConstraints(maxWidth: Get.width * 0.74),
                                prefixIcon: tags.isNotEmpty
                                    ? SingleChildScrollView(
                                        controller: sc,
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                            children: tags.map((String tag) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20.0),
                                              ),
                                              color: Colors.black54,
                                            ),
                                            margin:  EdgeInsets.symmetric(
                                                horizontal: 0.012*Get.width),
                                            padding:  EdgeInsets.symmetric(
                                                horizontal: 0.0243*Get.width,
                                                vertical: 0.006*Get.height),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    '#$tag',
                                                    style:  TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 0.02187*Get.width+0.01095*Get.height),
                                                  ),
                                                  onTap: () {
                                                    //log("$tag selected");
                                                  },
                                                ),
                                                SizedBox(width: 0.0097*Get.width),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    size: 0.02187*Get.width+0.01095*Get.height,
                                                    color: Colors.red
                                                        .withOpacity(0.7),
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
                        height: Get.height * 0.04,
                      ),
                      TextFormField(
                        controller: controller.descriptionController,
                        style: TextStyle(fontSize: 0.012*Get.height+0.024*Get.width),
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
                            fillColor: Color(0x15FFFFFF),
                            border: kEnabledTextFieldBorder,
                            enabledBorder: kEnabledTextFieldBorder,
                            focusedBorder: kFocusedTextFieldBorder),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
