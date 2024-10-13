import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/utils/constants.dart';

class CreateChapterScreen extends StatefulWidget {
  final Function(Chapter) onChapterCreated;

  const CreateChapterScreen({super.key, required this.onChapterCreated});

  @override
  CreateChapterScreenState createState() => CreateChapterScreenState();
}

class CreateChapterScreenState extends State<CreateChapterScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  File? chapterCoverImage;
  File? audioFile; // For audio file
  File? lyricsFile; // For lyrics text file
  ExploreStoryController exploreStoryController =
      Get.find<ExploreStoryController>();

  Future<void> pickChapterCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        chapterCoverImage = File(selectedImage.path);
      });
    }
  }

  Future<void> pickAudioFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      setState(() {
        audioFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> pickLyricsFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      setState(() {
        lyricsFile = File(result.files.single.path!);
      });
    }
  }

  void createChapter() async {
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        audioFile == null) {
      // Show error if required fields are not filled
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill in all required fields.'),
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

    // Create a new chapter instance
    Chapter newChapter = await exploreStoryController.createChapter(
        titleController.text,
        aboutController.text,
        chapterCoverImage?.path ?? chapterCoverImagePlaceholderUrl,
        audioFile!.path,
        lyricsFile?.path ?? '');

    widget.onChapterCreated(newChapter);

    Navigator.pop(Get.context!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text('Create a Chapter'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Chapter Title *'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: aboutController,
                maxLength: 2000,
                decoration: const InputDecoration(
                    labelText: 'About *', counterText: ''),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: chapterCoverImage != null
                        ? Image.file(
                            chapterCoverImage!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          )
                        : Image.network(
                            chapterCoverImagePlaceholderUrl,
                            fit: BoxFit.cover,
                            height: 150,
                            width: 150,
                          ),
                  ),
                  GestureDetector(
                    onTap: pickChapterCoverImage,
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(84, 158, 158, 158)),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.upload_rounded,
                            size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: pickAudioFile,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Center(
                        child: Text(
                          audioFile != null
                              ? 'Audio file Selected: ${audioFile!.path.split('/').last}'
                              : 'Upload Audio File',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: pickLyricsFile,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      lyricsFile != null
                          ? 'Lyrics File Selected: ${lyricsFile!.path.split('/').last}'
                          : 'Upload Lyrics File',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: createChapter,
                child: const Text('Create Chapter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
