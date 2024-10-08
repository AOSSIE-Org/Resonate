import 'package:flutter/material.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.name, required this.color});
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: color,
          ),
        ),
        Positioned(
          left: 14,
          top: 14,
          child: Text(
            capitalizeFirstLetter(name),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.9,
                ),
          ),
        ),
      ],
    );
  }
}
