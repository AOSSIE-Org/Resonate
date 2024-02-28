//import required packages
import 'package:flutter/material.dart';
import 'package:resonate/utils/ui_sizes.dart';

//AuthButtonWidget is a custom button that returns an elevated button.
class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget(
      {super.key,
      required this.onPressed,
      required this.logoPath,
      required this.authText});

  final Function() onPressed; //the callback function
  final String logoPath; //path to the image which will be displayed befor text
  final String authText; //Text to be displayed inside the button

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      //styleForm keeps all the other properties of the ElevatedButton same
      //except for the backgroundColor
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffFFFFE0),
      ),
      //function callback when the button is pressed
      onPressed: onPressed,
      //widgets that will be displayed inside the button
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //the image will be displayed from the logoPath specified while using the Widget
          SizedBox(
            height: UiSizes.height_30,
            width: UiSizes.width_30,
            child: Image.asset(logoPath),
          ),
          //Just a seperation
          SizedBox(
            width: UiSizes.width_10,
          ),
          //Text that will be displayed alongside the image.
          Text(
            authText,
            style: TextStyle(
              color: Colors.black54,
              fontSize: UiSizes.size_17,
            ),
          ),
        ],
      ),
    );
  }
}
