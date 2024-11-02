import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/app_images.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/views/screens/profile_screen.dart';
import 'package:resonate/views/widgets/story_list_tile.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.categoryName});
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              // color: Colors.black,
              size: 36,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(categoryName),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16),
              child: InkWell(
                child: const CircleAvatar(
                  backgroundImage: AssetImage(
                    AppImages.userImage,
                  ),
                ),
                onTap: () {
                  Get.to(ProfileScreen());
                },
              ),
            ),
          ],
        ),
        body: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: true,
          itemCount: dummyComedyStories.length,
          itemBuilder: (context, index) {
            final int storyIndex = index;
            return StoryListTile(
              story: dummyComedyStories[storyIndex],
            );
          },
        ));
  }
}

final List<Story> dummyComedyStories = [
  Story(
    title: "The Laughing Detective",
    storyId: "comedy_001",
    description:
        "A detective with a knack for jokes solves crimes in the most humorous ways.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_001",
    creatorName: "John Comedy",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 10)),
    likesCount: 150,
    isLikedByCurrentUser: false,
    playDuration: 122200,
    tintColor: const Color(0xFFE0BBE4),
    chapters: [],
  ),
  Story(
    title: "Funny Business",
    storyId: "comedy_002",
    description:
        "Follow the hilarious misadventures of a start-up that tries too hard to be funny.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_002",
    creatorName: "Lily Laughs",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 5)),
    likesCount: 230,
    isLikedByCurrentUser: true,
    playDuration: 1222111,
    tintColor: const Color(0xFF98DDCA),
    chapters: [],
  ),
  Story(
    title: "Pranks & Giggles",
    storyId: "comedy_003",
    description:
        "A group of friends tries to out-prank each other with hilarious results.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_003",
    creatorName: "Jake Jester",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 15)),
    likesCount: 190,
    isLikedByCurrentUser: false,
    playDuration: 1222111,
    tintColor: const Color(0xFFA2D2FF),
    chapters: [],
  ),
  Story(
    title: "Laughter Therapy",
    storyId: "comedy_004",
    description:
        "A therapist uses comedy to help people overcome their fears in unexpected ways.",
    userIsCreator: true,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_004",
    creatorName: "Sara Smiles",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 20)),
    likesCount: 300,
    isLikedByCurrentUser: true,
    playDuration: 1222111,
    tintColor: const Color(0xFFFFC8DD),
    chapters: [],
  ),
  Story(
    title: "Comedy Gold",
    storyId: "comedy_005",
    description:
        "A look at the funniest comedians and their journeys in the world of laughter.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_005",
    creatorName: "Megan Mirth",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 25)),
    likesCount: 120,
    isLikedByCurrentUser: false,
    playDuration: 111122233,
    tintColor: const Color(0xFFFFD6A5),
    chapters: [],
  ),
  Story(
    title: "The Laughing Detective",
    storyId: "comedy_001",
    description:
        "A detective with a knack for jokes solves crimes in the most humorous ways.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_001",
    creatorName: "John Comedy",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 10)),
    likesCount: 150,
    isLikedByCurrentUser: false,
    playDuration: 12223333,
    tintColor: const Color(0xFFE0BBE4),
    chapters: [],
  ),
  Story(
    title: "Funny Business",
    storyId: "comedy_002",
    description:
        "Follow the hilarious misadventures of a start-up that tries too hard to be funny.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_002",
    creatorName: "Lily Laughs",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 5)),
    likesCount: 230,
    isLikedByCurrentUser: true,
    playDuration: 12233300,
    tintColor: const Color(0xFF98DDCA),
    chapters: [],
  ),
  Story(
    title: "Pranks & Giggles",
    storyId: "comedy_003",
    description:
        "A group of friends tries to out-prank each other with hilarious results.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_003",
    creatorName: "Jake Jester",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 15)),
    likesCount: 190,
    isLikedByCurrentUser: false,
    playDuration: 1223334,
    tintColor: const Color(0xFFA2D2FF),
    chapters: [],
  ),
  Story(
    title: "Laughter Therapy",
    storyId: "comedy_004",
    description:
        "A therapist uses comedy to help people overcome their fears in unexpected ways.",
    userIsCreator: true,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_004",
    creatorName: "Sara Smiles",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 20)),
    likesCount: 300,
    isLikedByCurrentUser: true,
    playDuration: 12223334,
    tintColor: const Color(0xFFFFC8DD),
    chapters: [],
  ),
  Story(
    title: "Comedy Gold",
    storyId: "comedy_005",
    description:
        "A look at the funniest comedians and their journeys in the world of laughter.",
    userIsCreator: false,
    category: StoryCategory.comedy,
    coverImageUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creatorId: "creator_005",
    creatorName: "Megan Mirth",
    creatorImgUrl:
        "https://images.template.net/2916/Toddlers-Story-Book-Cover-Template-2x.jpg",
    creationDate: DateTime.now().subtract(const Duration(days: 25)),
    likesCount: 120,
    isLikedByCurrentUser: false,
    playDuration: 122233444,
    tintColor: const Color(0xFFFFD6A5),
    chapters: [],
  ),
];
