import 'package:flutter/material.dart';
import 'package:resonate/models/category_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 70,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: categoryModel.color,
          ),
        ),
        Positioned(
          left: 14,
          top: 14,
          child: Text(
            categoryModel.name,
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
