import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resonate/utils/ui_sizes.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

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
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(
                width: UiSizes.width_20,
              ),
              FaIcon(
                icon,
                size: UiSizes.size_24,
              ),
              SizedBox(
                width: UiSizes.width_40,
              ),
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
