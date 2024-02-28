import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/themes/theme_controller.dart';
import 'package:resonate/utils/ui_sizes.dart';

class ColorSelectionWidget extends StatelessWidget {
  final ThemeController themeController;

  // Predefined list of colors
  final List<Color> predefinedColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.purple,
  ];

  ColorSelectionWidget({super.key, required this.themeController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: UiSizes.height_76,
      child: Card(
          margin: EdgeInsets.symmetric(
              vertical: UiSizes.height_10, horizontal: UiSizes.width_25),
          child: Row(
            children: [
              SizedBox(
                width: 12,
              ),
              Icon(Icons.color_lens),
              SizedBox(
                width: 12,
              ),
              Text("App Color"),
              Spacer(),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: predefinedColors.length,
                itemBuilder: (context, index) {
                  final color = predefinedColors[index];
                  return InkWell(
                    onTap: () {
                      themeController.changePrimaryColor(color);
                    },
                    child: Container(
                      margin: EdgeInsets.all(2),
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: color),
                      width: 30,
                      height: 30,
                    ),
                  );
                },
              ),
              SizedBox(
                width: 20,
              ),
            ],
          )),
    );
  }
}
