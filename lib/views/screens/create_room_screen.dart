import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/utils/colors.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateRoomScreen extends StatelessWidget {
  var _controller = TextfieldTagsController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
            children: [
              SizedBox(height: Get.height*0.02,),
              Text("Create New Room", style: TextStyle(fontSize: Get.textScaleFactor*35),),
              SizedBox(height: Get.height*0.03,),
              TextField(
                style: TextStyle(fontSize: 25),
                cursorColor: Colors.amber,
                minLines: 1,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Give a great name..",
                  filled: true,
                  fillColor: Color(0x15FFFFFF),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.yellowColor),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 2),
                      borderRadius: BorderRadius.circular(15)
                  ),
                ),
              ),
              SizedBox(height: Get.height*0.04,),
              TextFieldTags(
                textfieldTagsController: _controller,
                initialTags: const [
                  'sample-tag'
                ],
                textSeparators: const [' ', ','],
                letterCase: LetterCase.normal,
                validator: (String tag) {
                  //TODO Add validation
                  return null;
                },
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  return ((context, sc, tags, onTagDelete) {
                    return TextField(
                      controller: tec,
                      focusNode: fn,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0x15FFFFFF),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.yellowColor),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColor.yellowColor),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.amber, width: 2),
                            borderRadius: BorderRadius.circular(15)
                        ),
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
                                  decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                    color: Colors.black54,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        child: Text(
                                          '#$tag',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          //print("$tag selected");
                                        },
                                      ),
                                      const SizedBox(width: 4.0),
                                      InkWell(
                                        child: Icon(
                                          Icons.cancel,
                                          size: 14.0,
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
            ],
      ),
    );
  }
}
