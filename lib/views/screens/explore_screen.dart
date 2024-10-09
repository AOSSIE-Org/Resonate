import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/views/widgets/category_card.dart';
import 'package:resonate/views/widgets/story_list_tile.dart';
import 'package:resonate/views/widgets/story_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ExplorePageBody(),
    );
  }
}

class ExplorePageBody extends StatelessWidget {
  ExplorePageBody({
    super.key,
  });

      final exploreStoryController = Get.find<ExploreStoryController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 15,
              ),
              border: const OutlineInputBorder(
                gapPadding: 4,
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.secondary,
              filled: true,
              hintText: 'What do you want to listen to?',
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Inter',
                  ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Categories',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 330,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: StoryCategory.values.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.68,
              ),
              itemBuilder: (context, index) {
                return CategoryCard(
                  name: StoryCategory.values[index].name,
                  color: categoryColorList[index],
                );
              },
            ),
          ),
          Text(
            'Stories',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          SizedBox(
            height: 300,
            width: double.infinity,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: exploreStoryController.recommendedStories.length > 4
                  ? 4
                  : exploreStoryController.recommendedStories.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 300,
                  margin: const EdgeInsets.all(
                    10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: StoryCard(
                    story: exploreStoryController.recommendedStories[index],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Text(
            'Some Suggestions',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Inter',
                ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: true,
              itemCount: exploreStoryController.recommendedStories.length > 4
                  ? exploreStoryController.recommendedStories.length - 4
                  : exploreStoryController.recommendedStories.length,
              itemBuilder: (context, index) {
                final int storyIndex =
                    exploreStoryController.recommendedStories.length > 4
                        ? index + 4
                        : index;
                return StoryListTile(
                  story: exploreStoryController.recommendedStories[storyIndex],
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

final List<Color> categoryColorList = [
  const Color.fromARGB(255, 237, 29, 154),
  const Color.fromARGB(255, 21, 178, 136),
  const Color.fromARGB(255, 142, 16, 238),
  const Color.fromARGB(255, 38, 83, 215),
  const Color.fromARGB(255, 140, 204, 37),
  const Color.fromARGB(255, 218, 83, 83),
];
