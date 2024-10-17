import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/views/screens/create_chapter_screen.dart';

class AddNewChapterScreen extends StatefulWidget {
  final String storyName;
  final List<Chapter> currentChapters;

  const AddNewChapterScreen({
    super.key,
    required this.storyName,
    required this.currentChapters,
  });

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
                      leading: chapter.coverImageUrl.isNotEmpty
                          ? Image.file(
                              File(chapter.coverImageUrl),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 50),
                      title: Text(chapter.title),
                      subtitle: Text(
                        chapter.description.length > 30
                            ? '${chapter.description.substring(0, 30)}...'
                            : chapter.description,
                      ),
                      trailing: Text(chapter.playDuration),
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
                      leading: chapter.coverImageUrl.isNotEmpty
                          ? Image.file(
                              File(chapter.coverImageUrl),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 50),
                      title: Text(chapter.title),
                      subtitle: Text(
                        chapter.description.length > 30
                            ? '${chapter.description.substring(0, 30)}...'
                            : chapter.description,
                      ),
                      trailing: Text(chapter.playDuration),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: FloatingActionButton(
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
        ),
      ),
    );
  }
}
