import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/view/widgets/story_list_tile.dart';
import 'package:resonate/features/stories/viewmodel/category_stories_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/utils/ui_sizes.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key, required this.category});

  final StoryCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(categoryStoriesProvider(category));
    final label = capitalizeFirstLetter(category.name);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(label),
      ),
      body: storiesAsync.when(
        loading: () => Center(
          child: SizedBox(
            height: UiSizes.height_200,
            width: UiSizes.width_200,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotate,
              colors: [colorScheme.primary],
            ),
          ),
        ),
        error: (e, _) => _empty(context, label),
        data: (stories) => stories.isNotEmpty
            ? Padding(
                padding: EdgeInsets.only(top: UiSizes.height_20),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: true,
                  itemCount: stories.length,
                  itemBuilder: (context, index) =>
                      StoryListTile(story: stories[index]),
                ),
              )
            : _empty(context, label),
      ),
    );
  }

  Widget _empty(BuildContext context, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: UiSizes.height_140),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            height: UiSizes.height_200,
            width: UiSizes.width_200,
            AppImages.emptyBoxImage,
          ),
          SizedBox(height: UiSizes.height_20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: UiSizes.width_30),
            child: Text(
              AppLocalizations.of(context)!.noStoriesInCategory(label),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
