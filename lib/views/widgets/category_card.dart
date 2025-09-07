import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/views/screens/category_screen.dart';

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.name,
    required this.color,
    required this.exploreStoryController,
  });
  final String name;
  final Color color;
  final ExploreStoryController exploreStoryController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        exploreStoryController.fetchStoryByCategory(
          StoryCategory.values.byName(name),
        );
        Get.to(() => CategoryScreen(categoryName: name));
      },
      child: Stack(
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
              AppLocalizations.of(context)!.storyCategory(name),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 16.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
