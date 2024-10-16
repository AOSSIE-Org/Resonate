import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/views/widgets/category_card.dart';
import 'package:resonate/views/widgets/filtered_list_tile.dart';
import 'package:resonate/views/widgets/no_match_view.dart';
import 'package:resonate/views/widgets/story_card.dart';
import 'package:resonate/views/widgets/story_list_tile.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const ExplorePageBody(),
    );
  }
}

class ExplorePageBody extends StatefulWidget {
  const ExplorePageBody({
    super.key,
  });

  @override
  State<ExplorePageBody> createState() => _ExplorePageBodyState();
}

class _ExplorePageBodyState extends State<ExplorePageBody> {
  final exploreStoryController =
      Get.put<ExploreStoryController>(ExploreStoryController());

  final textEditingController = TextEditingController();
  List<Story> filteredList = [];
  bool isSearching = false;
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = textEditingController.text;

    // Update the state based on the search query
    setState(() {
      if (query.isEmpty) {
        isSearching = false;
        filteredList.clear();
      } else {
        isSearching = true;
        filteredList = exploreStoryController.recommendedStories
            .where((story) =>
                story.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            controller: textEditingController,
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
          textEditingController.text.isEmpty
              ? ExplorePageContent(
                  exploreStoryController: exploreStoryController,
                )
              : SearchResultContent(
                  filteredList: dummyStories,
                ),
        ],
      ),
    );
  }
}

class ExplorePageContent extends StatelessWidget {
  const ExplorePageContent({
    super.key,
    required this.exploreStoryController,
  });

  final ExploreStoryController exploreStoryController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          child: exploreStoryController.recommendedStories.isNotEmpty
              ? ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount:
                      exploreStoryController.recommendedStories.length > 4
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
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        height: 200, width: 200, 'assets/images/emtpy_box.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("No stories exist to present")
                  ],
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
          width: double.infinity,
          child: exploreStoryController.recommendedStories.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  primary: true,
                  itemCount:
                      exploreStoryController.recommendedStories.length > 4
                          ? exploreStoryController.recommendedStories.length - 4
                          : exploreStoryController.recommendedStories.length,
                  itemBuilder: (context, index) {
                    final int storyIndex =
                        exploreStoryController.recommendedStories.length > 4
                            ? index + 4
                            : index;
                    return StoryListTile(
                      story:
                          exploreStoryController.recommendedStories[storyIndex],
                    );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        height: 200, width: 200, 'assets/images/emtpy_box.png'),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("No stories exist to present")
                  ],
                ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
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

class SearchResultContent extends StatelessWidget {
  const SearchResultContent({
    super.key,
    required this.filteredList,
  });

  final List<Story> filteredList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          filteredList.isEmpty
              ? const NoMatchView()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * .8,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final story = filteredList[index];
                      return FilteredListTile(
                        story: story,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

final List<Story> dummyStories = [
  Story(
    "The Enchanted Forest",
    "story_001",
    "A magical journey through a forest filled with mystical creatures.",
    true,
    StoryCategory.comedy,
    "assets/images/cover_image_2.jpg",
    "user_001",
    "Alice Wonder",
    "assets/images/cover_image_2.jpg",
    DateTime.now().subtract(const Duration(days: 10)),
    120,
    true,
    '50 mins',
    const Color(0xFF76C7C0),
    [
      Chapter(
        "chapter_001",
        "Chapter 1: The Awakening",
        "assets/images/cover_image_1.jpg",
        "The journey begins as the protagonist wakes up in an unfamiliar forest.",
        '''
(Verse 1)
In the silence of the dawn, I rise,
Eyes wide open, to a world disguised.
The trees whisper secrets in the breeze,
A forest strange, but full of peace.

(Chorus)
Awaken, I am found,
In the stillness of the ground,
A journey calls, I can't deny,
Through the forest, 'neath the sky.

(Verse 2)
Footsteps soft on paths untread,
Through fields unknown, by dreams I’m led.
The leaves, they shimmer, in the morning light,
Guiding me towards the coming fight.

(Chorus)
Awaken, I am found,
In the stillness of the ground,
A journey calls, I can't deny,
Through the forest, 'neath the sky.

(Bridge)
The shadows fall, but I stand tall,
No fear to face, no time to stall.
A voice within me, starts to sing,
This is my time, my awakening.

(Chorus)
Awaken, I am found,
In the stillness of the ground,
A journey calls, I can't deny,
Through the forest, 'neath the sky.
''',
        "assets/images/cover_image_1.jpg",
        "15:00",
        const Color(0xFF76C7C0),
      ),
      Chapter(
        "chapter_002",
        "Chapter 2: Into the Unknown",
        "assets/images/cover_image_1.jpg",
        "The protagonist ventures deeper, encountering strange creatures.",
        "Lyrics of Into the Unknown",
        "assets/images/cover_image_1.jpg",
        "20:00",
        const Color(0xFF76C7C0),
      ),
      Chapter(
        "chapter_003",
        "Chapter 3: The Mystic River",
        "assets/images/cover_image_1.jpg",
        "The story unfolds at a river filled with magical properties.",
        "Lyrics of The Mystic River",
        "assets/images/cover_image_1.jpg",
        "10:00",
        const Color(0xFF76C7C0),
      ),
    ],
  ),
  Story(
    "Lost in Time",
    "story_002",
    "A time travel adventure that explores different eras of history.",
    false,
    StoryCategory.comedy,
    "assets/images/cover_image_1.jpg",
    "user_002",
    "Bob Chronos",
    "assets/images/cover_image_1.jpg",
    DateTime.now().subtract(const Duration(days: 30)),
    200,
    false,
    '50 mins',
    const Color(0xFFB39DDB),
    [
      Chapter(
        "chapter_004",
        "Chapter 1: The Time Machine",
        "assets/images/cover_image_1.jpg",
        "The protagonist builds a time machine and takes the first leap.",
        "Lyrics of The Time Machine",
        "assets/images/cover_image_1.jpg",
        "20:00",
        const Color(0xFFB39DDB),
      ),
      Chapter(
        "chapter_005",
        "Chapter 2: The Ancient World",
        "assets/images/cover_image_1.jpg",
        "Exploring the wonders and dangers of ancient history.",
        "Lyrics of The Ancient World",
        "assets/images/cover_image_1.jpg",
        "15:00",
        const Color(0xFFB39DDB),
      ),
      Chapter(
        "chapter_006",
        "Chapter 3: Future Shock",
        "assets/images/cover_image_1.jpg",
        "A glimpse into a dystopian future with startling revelations.",
        "Lyrics of Future Shock",
        "assets/images/cover_image_1.jpg",
        "25:00",
        const Color(0xFFB39DDB),
      ),
    ],
  ),
  Story(
    "The Silent Ocean",
    "story_003",
    "A deep-sea exploration that unveils secrets buried underwater.",
    true,
    StoryCategory.comedy,
    "assets/images/cover_image_1.jpg",
    "user_003",
    "Catherine Wave",
    "assets/images/cover_image_1.jpg",
    DateTime.now().subtract(const Duration(days: 5)),
    85,
    true,
    '50 mins',
    const Color(0xFF42A5F5),
    [
      Chapter(
        "chapter_007",
        "Chapter 1: The Descent",
        "assets/images/cover_image_1.jpg",
        "Diving into the deep ocean, discovering unusual marine life.",
        "Lyrics of The Descent",
        "assets/images/cover_image_1.jpg",
        "18:00",
        const Color(0xFF42A5F5),
      ),
      Chapter(
        "chapter_008",
        "Chapter 2: Underwater Ruins",
        "assets/images/cover_image_1.jpg",
        "Unveiling ancient ruins that hint at a lost civilization.",
        "Lyrics of Underwater Ruins",
        "assets/images/cover_image_1.jpg",
        "12:00",
        const Color(0xFF42A5F5),
      ),
      Chapter(
        "chapter_009",
        "Chapter 3: The Abyss",
        "assets/images/cover_image_1.jpg",
        "Exploring the abyssal depths where secrets and danger lurk.",
        "Lyrics of The Abyss",
        "assets/images/cover_image_1.jpg",
        "20:00",
        const Color(0xFF42A5F5),
      ),
    ],
  ),
];
