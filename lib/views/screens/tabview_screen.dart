import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:resonate/controllers/tabview_controller.dart';
import 'package:resonate/views/screens/home_screen.dart';
import 'package:resonate/views/screens/profile_screen.dart';

import '../../utils/colors.dart';

class TabViewScreen extends StatelessWidget {

  TabViewController controller = Get.find<TabViewController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text("Resonate", style: TextStyle(color: Colors.black, fontSize: 26),),
        centerTitle: false,
        backgroundColor: Colors.amber,
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.exit_to_app_rounded, color: Colors.black87,))],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {  },
        backgroundColor: AppColor.yellowColor,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        backgroundColor: Colors.amber,
        activeColor: Colors.black,
        inactiveColor: Colors.black87,
        icons: [Icons.home_outlined, Icons.search, Icons.person_outline, Icons.settings],
        activeIndex: controller.getIndex(),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) => controller.setIndex(index),
      ),
      body: (controller.getIndex()==0) ? HomeScreen() : ProfileScreen(),
    ));
  }
}

