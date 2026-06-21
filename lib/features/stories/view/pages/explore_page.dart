import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/view/widgets/category_card.dart';
import 'package:resonate/features/stories/view/widgets/filtered_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/story_card.dart';
import 'package:resonate/features/stories/view/widgets/story_list_tile.dart';
import 'package:resonate/features/stories/viewmodel/explore_stories_notifier.dart';
import 'package:resonate/features/stories/viewmodel/story_search_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/colors.dart';
import 'package:resonate/utils/debouncer.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/no_match_view.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final _debouncer = Debouncer(milliseconds: 500);
  bool _isSearching = false;
  bool _searchBarIsEmpty = true;

  void _onSearchChanged(String value) {
    setState(() {
      _searchBarIsEmpty = value.isEmpty;
      if (value.isNotEmpty) _isSearching = true;
    });
    if (value.isEmpty) {
      ref.read(storySearchProvider.notifier).clear();
      return;
    }
    _debouncer.run(() async {
      await ref.read(storySearchProvider.notifier).search(value);
      if (mounted) setState(() => _isSearching = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: UiSizes.width_16,
            right: UiSizes.width_16,
            top: UiSizes.height_30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: TextStyle(color: colorScheme.onSecondary),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: UiSizes.height_15,
                  ),
                  border: const OutlineInputBorder(
                    gapPadding: 4,
                    borderSide: BorderSide(style: BorderStyle.none, width: 0),
                  ),
                  fillColor: colorScheme.secondary,
                  filled: true,
                  hintText: l10n.whatDoYouWantToListenTo,
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: UiSizes.size_17,
                    fontFamily: 'Inter',
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: UiSizes.width_16),
                    child: Icon(
                      Icons.search,
                      color: colorScheme.onSecondary,
                      size: UiSizes.size_35,
                    ),
                  ),
                ),
              ),
              SizedBox(height: UiSizes.height_30),
              if (_searchBarIsEmpty)
                _ExploreContent()
              else
                _searchResults(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchResults(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_isSearching) {
      return Center(
        child: SizedBox(
          height: UiSizes.height_56,
          width: UiSizes.width_56,
          child: LoadingIndicator(
            indicatorType: Indicator.ballGridPulse,
            colors: [colorScheme.primary],
          ),
        ),
      );
    }

    final results = ref.watch(storySearchProvider);
    if (results.stories.isEmpty && results.users.isEmpty) {
      return const NoMatchView();
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * .8,
      width: double.infinity,
      child: ListView.builder(
        itemCount: results.stories.length + results.users.length,
        itemBuilder: (context, index) {
          if (index < results.stories.length) {
            return FilteredListTile(
              story: results.stories[index],
              isStory: true,
            );
          }
          final user = results.users[index - results.stories.length];
          return FilteredListTile(user: user, isStory: false);
        },
      ),
    );
  }
}

class _ExploreContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final storiesAsync = ref.watch(exploreStoriesProvider);

    final sectionHeader = Theme.of(context).textTheme.bodyLarge!.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w900,
      fontSize: UiSizes.size_20,
      fontFamily: 'Inter',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.categories, style: sectionHeader),
        SizedBox(height: UiSizes.height_10),
        // shrink-wrapped so the grid sizes to its content
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: StoryCategory.values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.68,
          ),
          itemBuilder: (context, index) {
            final category = StoryCategory.values[index];
            return CategoryCard(
              category: category,
              color: AppColor.categoryColorList[category.name.toLowerCase()]!,
            );
          },
        ),
        SizedBox(height: UiSizes.height_20),
        Text(l10n.stories, style: sectionHeader),
        SizedBox(height: UiSizes.height_10),
        storiesAsync.when(
          loading: () => _loader(context),
          error: (e, _) => _emptyStories(context),
          data: (stories) => stories.isEmpty
              ? _emptyStories(context)
              : _recommended(context, stories),
        ),
      ],
    );
  }

  Widget _recommended(BuildContext context, List<Story> stories) {
    final l10n = AppLocalizations.of(context)!;
    final topCount = stories.length > 4 ? 4 : stories.length;
    final rest = stories.length > 4 ? stories.sublist(4) : <Story>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: UiSizes.height_246,
          width: double.infinity,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: topCount,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.all(UiSizes.width_10),
              child: StoryCard(story: stories[index]),
            ),
          ),
        ),
        if (rest.isNotEmpty) ...[
          SizedBox(height: UiSizes.height_35),
          Text(
            l10n.someSuggestions,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: UiSizes.size_20,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: UiSizes.height_10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: rest.length,
            itemBuilder: (context, index) => StoryListTile(story: rest[index]),
          ),
        ],
        SizedBox(height: UiSizes.height_20),
      ],
    );
  }

  Widget _loader(BuildContext context) => Center(
    child: SizedBox(
      height: UiSizes.height_82,
      width: UiSizes.width_80,
      child: LoadingIndicator(
        indicatorType: Indicator.ballRotate,
        colors: [Theme.of(context).colorScheme.primary],
      ),
    ),
  );

  Widget _emptyStories(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        height: UiSizes.height_200,
        width: UiSizes.width_200,
        AppImages.emptyBoxImage,
      ),
      SizedBox(height: UiSizes.height_10),
      Text(AppLocalizations.of(context)!.noStoriesExist),
    ],
  );
}
