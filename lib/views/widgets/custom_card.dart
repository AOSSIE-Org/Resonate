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
      //Use Container instead of Card
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: UiSizes.height_10,
          horizontal: UiSizes.width_25,
        ),
        //Use Material to see splash effect of InkWell
        child: Material(
          color: const Color.fromARGB(255, 255, 250, 239),
          //specify the border radius to create a rounded edge
          borderRadius: BorderRadius.circular(15),
          elevation: 1,
          child: InkWell(
            //adjust the borderRadius of inkwell to match with material widet
            // to fix splash overlow issue.
            borderRadius: BorderRadius.circular(15),
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
      ),
    );
  }
}
