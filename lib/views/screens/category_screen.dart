import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/views/widgets/category_card.dart';
import 'package:resonate/views/widgets/story_list_tile.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key, required this.categoryName});
  final String categoryName;

  final exploreStoryController = Get.put<ExploreStoryController>(
    ExploreStoryController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(capitalizeFirstLetter(categoryName)),
      ),
      body: Obx(
        () => exploreStoryController.isLoadingCategoryPage.value
            ? Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: [Theme.of(context).colorScheme.primary],
                  ),
                ),
              )
            : exploreStoryController.openedCategotyStories.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: true,
                  itemCount:
                      exploreStoryController.openedCategotyStories.length,
                  itemBuilder: (context, index) {
                    final int storyIndex = index;
                    return StoryListTile(
                      story: exploreStoryController
                          .openedCategotyStories[storyIndex],
                    );
                  },
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 150.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      height: 200,
                      width: 200,
                      AppImages.emptyBoxImage,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        AppLocalizations.of(context)!.noStoriesInCategory(
                          capitalizeFirstLetter(categoryName),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
