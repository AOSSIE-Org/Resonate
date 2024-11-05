import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/views/screens/create_chapter_screen.dart';
import 'package:resonate/views/screens/create_story_screen.dart';

class AddNewChapterScreen extends StatefulWidget {
  final String storyName;
  final String storyId;
  final List<Chapter> currentChapters;

  const AddNewChapterScreen(
      {super.key,
      required this.storyName,
      required this.currentChapters,
      required this.storyId});

  @override
  AddNewChapterScreenState createState() => AddNewChapterScreenState();
}

class AddNewChapterScreenState extends State<AddNewChapterScreen> {
  List<Chapter> newChapters = [];

  void _onChapterCreated(Chapter chapter) {
    setState(() {
      newChapters.add(chapter);
    });
  }

  final exploreStoryController =
      Get.put<ExploreStoryController>(ExploreStoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('Add New Chapters to ${widget.storyName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Chapters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.currentChapters.length,
                itemBuilder: (context, index) {
                  final chapter = widget.currentChapters[index];
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          chapter.coverImageUrl,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(chapter.title),
                      subtitle: Text(
                        chapter.description.length > 30
                            ? '${chapter.description.substring(0, 30)}...'
                            : chapter.description,
                      ),
                      trailing: Text(formatPlayDuration(chapter.playDuration)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'New Chapters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: newChapters.length,
                itemBuilder: (context, index) {
                  final chapter = newChapters[index];
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: chapter.coverImageUrl.startsWith('/')
                            ? Image.file(
                                File(chapter.coverImageUrl),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                chapter.coverImageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                      ),
                      title: Text(chapter.title),
                      subtitle: Text(
                        chapter.description.length > 30
                            ? '${chapter.description.substring(0, 30)}...'
                            : chapter.description,
                      ),
                      trailing: Text(formatPlayDuration(chapter.playDuration)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: SizedBox(
          height: 130,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateChapterScreen(
                        onChapterCreated: _onChapterCreated,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (newChapters.isNotEmpty) {
                      await exploreStoryController.pushChaptersToStory(
                          newChapters, widget.storyId);
                      await exploreStoryController
                          .updateStoriesPlayDurationLength(
                              [...widget.currentChapters, ...newChapters],
                              widget.storyId);
                      await exploreStoryController.fetchUserCreatedStories();
                      Navigator.pop(Get.context!);
                      Navigator.pop(Get.context!);
                    }
                  },
                  child: const Text("Push New Chapters"))
            ],
          ),
        ),
      ),
    );
  }
}
