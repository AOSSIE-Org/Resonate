import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/views/screens/add_chapter_screen.dart';
import 'package:resonate/views/screens/chapter_play_screen.dart';
import 'package:resonate/views/widgets/chapter_list_tile.dart';

class StoryDetailsScreen extends StatelessWidget {
  final Story story;

  const StoryDetailsScreen({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    // Set the status bar color to match the story's tint color
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: story.tintColor.withOpacity(0.8),
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    story.tintColor.withOpacity(0.8),
                    story.tintColor.withOpacity(0.4),
                    story.tintColor.withOpacity(0.2),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Story Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                story.coverImageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (story.userIsCreator)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                    4,
                                  ),
                                  child: const Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(width: 16),
                        // Story Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Story Title
                              Text(
                                story.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
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
                                  Row(
                                    children: [
                                      const SizedBox(width: 4),
                                      Text(
                                        '${story.likesCount} Likes',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              fontSize: 20,
                                              fontStyle: FontStyle.normal,
                                              fontFamily: 'Inter',
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  // Duration
                                  Text(
                                    '${story.totalMin} min',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 20,
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
                                          fontSize: 20,
                                          fontStyle: FontStyle.normal,
                                          fontFamily: 'Inter',
                                        ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Aarush',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 20,
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
                    const SizedBox(height: 50),
                    Text(
                      'Uploaded on ${story.creationDate.toLocal().toString().split(' ')[0]}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Inter',
                          ),
                    ),
                  ],
                ),
              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'About',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontFamily: 'Inter',
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          story.description,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Inter',
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
                                color: Theme.of(context).colorScheme.onSurface,
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
                        itemCount: story.chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = story.chapters[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterPlayScreen(
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
                      if (story.userIsCreator) ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle delete story
                          },
                          child: const Text('Delete Story'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AddNewChapterScreen(
                                          storyName: story.title,
                                          currentChapters: story.chapters,
                                        )));
                          },
                          child: const Text('Add Chapter'),
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
    );
  }
}
