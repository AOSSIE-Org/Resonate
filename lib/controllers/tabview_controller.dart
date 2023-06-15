import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:resonate/utils/colors.dart';

class TabViewController extends GetxController {
  RxInt _selectedIndex = 0.obs;
  getIndex() => _selectedIndex.value;
  setIndex(index) => _selectedIndex.value = index;

  void openRoomSheet() {
    showModalBottomSheet(
        context: Get.context!,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    height: 7,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: Get.height*0.015,),
                Row(children: [
                  Text("For the love of open source ♥", style: TextStyle(fontSize: 20, color: Colors.amber),),
                  Spacer(),
                  FaIcon(
                    FontAwesomeIcons.ellipsis,
                    color: Colors.amber,
                  ),
                ],
                ),
                SizedBox(height: Get.height*0.001,),
                Text("Open Source · Flutter", style:TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w100, color: Colors.white)),
                SizedBox(height: Get.height*0.008,),
                Text("This is a simple description of the room. You can feature a participant or talk about an event.", style: TextStyle(color: Colors.white70),),
                SizedBox(height: Get.height*0.008,),
                Divider(thickness: 2,),
                Expanded(child: Container(color: Colors.red,),),
                Divider(),
                Container(
                  height: Get.height*0.1,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40,
                            width: 125,
                            decoration: BoxDecoration(
                              gradient: AppColor.gradientBg,
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                            child: Center(child: Text("Leave Room", style: TextStyle(color: Colors.black87),)),
                          ),
                          Spacer(),
                          FloatingActionButton.small(onPressed: (){}, backgroundColor: AppColor.yellowColor,child: Icon(Icons.mic, color: Colors.black87,),),
                        ],
                      ),
                      SizedBox(height: Get.height*0.035,)
                    ],
                  ),
                )
              ],
            ),
          );
        },
        useSafeArea: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: AppColor.bgBlackColor,
        isScrollControlled: true,
        enableDrag: true,
    isDismissible: false);
  }
}
