import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/views/screens/add_chapter_screen.dart';
import 'package:resonate/views/screens/chapter_play_screen.dart';
import 'package:resonate/views/screens/create_story_screen.dart';
import 'package:resonate/views/widgets/chapter_list_tile.dart';
import 'package:resonate/views/widgets/like_button.dart';

class StoryScreen extends StatefulWidget {
  final Story story;
  const StoryScreen({super.key, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final exploreStoryController =
      Get.put<ExploreStoryController>(ExploreStoryController());

  @override
  void initState() {
    super.initState();
    exploreStoryController.fetchMoreDetailsForSelectedStory(widget.story);
  }

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to match the story's tint color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: widget.story.tintColor.withValues(alpha: 0.8),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: exploreStoryController.isLoadingStoryPage.value
              ? Center(
                  child: SizedBox(
                  height: 200,
                  width: 200,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballRotate,
                    colors: [Theme.of(context).colorScheme.primary],
                  ),
                ))
              : Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.story.tintColor.withValues(alpha: 0.8),
                            widget.story.tintColor.withValues(alpha: 0.6),
                            widget.story.tintColor.withValues(alpha: 0.4),
                            widget.story.tintColor.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Story Image
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, bottom: 15),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          widget.story.coverImageUrl,
                                          width: 120,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Obx(
                                      () => LikeButton(
                                        isLikedByUser: widget
                                            .story.isLikedByCurrentUser.value,
                                        tintColor: widget.story.tintColor,
                                        onLiked: (isFavorite) async {
                                          isFavorite
                                              ? await exploreStoryController
                                                  .likeStoryFromUserAccount(
                                                      widget.story)
                                              : await exploreStoryController
                                                  .unlikeStoryFromUserAccount(
                                                      widget.story);

                                          await exploreStoryController
                                              .updateLikesCountAndUserLikeStatus(
                                                  widget.story);
                                          await exploreStoryController
                                              .fetchUserLikedStories();
                                        },
                                      ),
                                    )
                                  ],
                                ),

                                const SizedBox(width: 16),
                                // Story Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Story Title
                                      Text(
                                        widget.story.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 35,
                                              overflow: TextOverflow.ellipsis,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: 'Inter',
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(
                                            () => Text(
                                              '${widget.story.likesCount} Likes',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    fontSize: 16,
                                                    fontStyle: FontStyle.normal,
                                                    fontFamily: 'Inter',
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          // Duration
                                          Text(
                                            '${formatPlayDuration(widget.story.playDuration)} min',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: 'Inter',
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Creator Info
                                      Row(
                                        children: [
                                          Text(
                                            'by',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: 'Inter',
                                                ),
                                          ),
                                          const SizedBox(width: 15),
                                          CircleAvatar(
                                            radius: 14,
                                            backgroundImage: NetworkImage(
                                                widget.story.coverImageUrl),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            widget.story.userIsCreator
                                                ? "You"
                                                : widget.story.creatorName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.normal,
                                                  fontFamily: 'Inter',
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Text(
                              'Created ${widget.story.creationDate.formatDateTime()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Inter',
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Chapters Section (Scrollable)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // About Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'About',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Inter',
                                      ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  widget.story.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Inter',
                                      ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              // Chapters Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Text(
                                  'Chapters',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Inter',
                                      ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.story.chapters.length,
                                itemBuilder: (context, index) {
                                  final chapter = widget.story.chapters[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChapterPlayScreen(
                                            chapter: chapter,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ChaperListTile(
                                      chapter: chapter,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 50),

                              if (widget.story.userIsCreator) ...[
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddNewChapterScreen(
                                                    storyName:
                                                        widget.story.title,
                                                    storyId:
                                                        widget.story.storyId,
                                                    currentChapters:
                                                        widget.story.chapters,
                                                  )));
                                    },
                                    child: const Text('Add Chapter'),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await exploreStoryController
                                          .deleteStory(widget.story);
                                      await exploreStoryController
                                          .fetchUserCreatedStories();
                                      if (widget
                                          .story.isLikedByCurrentUser.value) {
                                        await exploreStoryController
                                            .fetchUserLikedStories();
                                      }
                                      await exploreStoryController
                                          .fetchStoryRecommendation();
                                      Navigator.pop(Get.context!);
                                    },
                                    child: const Text(
                                      'Delete Story',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
