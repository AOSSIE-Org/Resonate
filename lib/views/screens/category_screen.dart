import 'package:flutter/material.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/views/widgets/category_card.dart';
import 'package:resonate/views/widgets/story_list_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        automaticallyImplyLeading: true, //back button for user experience
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Text(capitalizeFirstLetter(categoryName)),
      ),
      body: Obx(
        () => exploreStoryController.isLoadingCategoryPage.value
            ? Center(
                child: SizedBox(
                  height: 200.r,
                  width: 200.r,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: [Theme.of(context).colorScheme.primary],
                  ),
                ),
              )
            : exploreStoryController.openedCategotyStories.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
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
            : Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        height: 200.r,
                        width: 200.r,
                        AppImages.emptyBoxImage,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        AppLocalizations.of(context)!.noStoriesInCategory(
                          capitalizeFirstLetter(categoryName),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
