import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/create_room_controller.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateRoomScreen extends StatelessWidget {
  final CreateRoomController createRoomController = Get.put<CreateRoomController>(CreateRoomController());

  OutlineInputBorder kEnabledTextFieldBorder =
      OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(15));

  OutlineInputBorder kFocusedTextFieldBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.amber, width: 2), borderRadius: BorderRadius.circular(15));

  CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateRoomController>(
        builder: (controller) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
                      style: const TextStyle(fontSize: 25),
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
                        fillColor: const Color(0x15FFFFFF),
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
                      validator: (String tag) => tag.isValidTag() ? null : "Invalid Tag",
                      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
                        return ((context, sc, tags, onTagDelete) {
                          return TextField(
                            style: const TextStyle(fontSize: 20),
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
                              prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.74),
                              prefixIcon: tags.isNotEmpty
                                  ? SingleChildScrollView(
                                      controller: sc,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: tags.map((String tag) {
                                        return Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            color: Colors.black54,
                                          ),
                                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                child: Text(
                                                  '#$tag',
                                                  style: const TextStyle(color: Colors.white, fontSize: 18),
                                                ),
                                                onTap: () {
                                                  //log("$tag selected");
                                                },
                                              ),
                                              const SizedBox(width: 4.0),
                                              InkWell(
                                                child: Icon(
                                                  Icons.cancel,
                                                  size: 18.0,
                                                  color: Colors.red.withOpacity(0.7),
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
                      style: const TextStyle(fontSize: 20),
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
                          focusedBorder: kFocusedTextFieldBorder),
                    ),
                  ],
                ),
              ),
            ));
  }
}
