import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/network_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/ui_sizes.dart';

//NoConnectionDialog is a page that displays a connection problem and allows the user to retry connection
class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: Center(
          //SingleChildScrollView allows the page to be made scrollable(vertical scroll by default)
          child: SingleChildScrollView(
            //Contents of the page
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: UiSizes.height_24_6, horizontal: UiSizes.width_25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //display a svg from the specified path
                  SvgPicture.asset(
                    //path to images is specified in AppImages which can be found in lib\utils\app_images.dart
                    AppImages.noConnectionImage,
                    height: UiSizes.height_246,
                  ),
                  //Simple text to display that the user is not connected
                  Text(
                    "No Connection",
                    style: TextStyle(
                        fontSize: UiSizes.size_40,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber),
                  ),
                  Text(
                    "There is a connection error. Please check your internet and try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: UiSizes.size_16),
                  ),
                  //Seperation
                  SizedBox(
                    height: UiSizes.height_82,
                  ),
                  //an elevatd button which displays "Try Again"
                  ElevatedButton(
                    //when user presses the button Get looks for NetworkController and
                    //calls tryAgain() method specified in NetworkController
                    onPressed: () {
                      Get.find<NetworkController>().tryAgain();
                    },
                    child: Text(
                      "Try Again",
                      style: TextStyle(
                          color: Colors.black, fontSize: UiSizes.size_14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
