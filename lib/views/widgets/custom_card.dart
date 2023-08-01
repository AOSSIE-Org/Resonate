import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  CustomCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.0921 * Get.height,
      child: Card(
        margin: EdgeInsets.symmetric(
            vertical: 0.0121 * Get.height, horizontal: 0.0608 * Get.width),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              SizedBox(
                width: 0.0486 * Get.width,
              ),
              FaIcon(
                icon,
                size: 0.0146 * Get.height + 0.029 * Get.width,
              ),
              SizedBox(
                width: 0.0972 * Get.width,
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 0.0085 * Get.height + 0.017 * Get.width),
              )
            ],
          ),
        ),
      ),
    );
  }
}
