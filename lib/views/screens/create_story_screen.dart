import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'create_chapter_screen.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  _CreateStoryPageState createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final List<Chapter> chapters = [];
  StoryCategory selectedCategory = StoryCategory.dramma;
  File? coverImage; // To hold the selected image

  void createStory() {
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        chapters.isEmpty ||
        coverImage == null) {
      // Show error if required fields are not filled
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Please fill in all required fields, add at least one chapter, and select a cover image.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    // Create a new story instance
    final newStory = Story(
      titleController.text,
      'storyId_${DateTime.now().millisecondsSinceEpoch}',
      aboutController.text,
      true, // Assuming the user is the creator
      selectedCategory,
      coverImage!.path,
      'creatorId', // Placeholder for creator ID
      'Creator Name', // Placeholder for creator name
      'creatorImgUrl', // Placeholder for creator image URL
      DateTime.now(),
      0, // Initial likes count
      false, // Initial liked by current user
      Duration.zero, // Initial total duration
      Colors.white, // Default tint color
      chapters,
    );

    print(
        'Story Created: ${newStory.title}, ${newStory.description}, Chapters: ${newStory.chapters.length}');
  }

  void addChapter(Chapter chapter) {
    setState(() {
      chapters.add(chapter);
    });
  }

  Future<void> pickCoverImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        coverImage = File(selectedImage.path); // Update the cover image state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 22),
          child: Text('Create Your Story',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title *',
                  labelStyle: const TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Colors.blue)),
                ),
              ),
              const SizedBox(height: 15),

              // Category Dropdown
              DropdownButtonFormField<StoryCategory>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                items: StoryCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category
                          .toString()
                          .split('.')
                          .last
                          .capitalizeFirstOfEach(),
                      style: const TextStyle(color: Colors.blueGrey),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 15),

              // About Story Input
              TextField(
                controller: aboutController,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: 'About *',
                  labelStyle: const TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  counterText: '',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),

              // Cover Image Picker
              const Text('Upload Cover Image *',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickCoverImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: coverImage != null
                      ? Image.file(
                          coverImage!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Icon(Icons.upload_rounded,
                              size: 50, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 15),

              // Chapter List with Add Chapter Button
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Text(chapter.title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(chapter.description),
                      trailing: Text(chapter.playDuration),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateChapterScreen(onChapterCreated: addChapter),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Chapter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // button color
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Create Story Button
              Center(
                child: ElevatedButton(
                  onPressed: createStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Create Story'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of each word
extension StringCasingExtension on String {
  String capitalizeFirstOfEach() => this
      .split(' ')
      .map((str) => str.isNotEmpty
          ? str[0].toUpperCase() + str.substring(1).toLowerCase()
          : '')
      .join(' ');
}
