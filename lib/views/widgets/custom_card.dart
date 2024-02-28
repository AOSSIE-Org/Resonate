import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resonate/utils/ui_sizes.dart';

//CustomCard is a widget that creates a Card widget with modified properties
class CustomCard extends StatelessWidget {
  final String title; //the title of the card
  final IconData icon; //icon displayed on the card
  final VoidCallback
      onTap; //voidcallback onTap which will be executed when card is tapped

  const CustomCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UiSizes.height_76,
      child: Card(
        margin: EdgeInsets.symmetric(
            vertical: UiSizes.height_10, horizontal: UiSizes.width_25),
        //using InkWell to make card tappable and display a splash when user tapps
        child: InkWell(
          //execute the VoidCallback onTap(from parameter list) when the card is tapped.
          onTap: onTap,
          //Contents of the card
          child: Row(
            children: [
              //Seperation
              SizedBox(
                width: UiSizes.width_20,
              ),
              //FaIcon is provided by font_awesome_flutter package.
              FaIcon(
                icon,
                size: UiSizes.size_24,
              ),
              //Seperation
              SizedBox(
                width: UiSizes.width_40,
              ),
              //The title of the card
              Text(
                title,
                style: TextStyle(fontSize: UiSizes.size_14),
              )
            ],
          ),
        ),
      ),
    );
  }
}
