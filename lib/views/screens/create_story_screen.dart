import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/enums/story_category.dart';
import 'package:resonate/l10n/app_localizations.dart';
import '../../utils/ui_sizes.dart';
import 'create_chapter_screen.dart';

class CreateStoryPage extends StatefulWidget {
  const CreateStoryPage({super.key});

  @override
  CreateStoryPageState createState() => CreateStoryPageState();
}

class CreateStoryPageState extends State<CreateStoryPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final List<Chapter> chapters = [];
  StoryCategory selectedCategory = StoryCategory.drama;
  File? coverImage; // To hold the selected image
  final exploreStoryController = Get.find<ExploreStoryController>();

  void createStory() async {
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        chapters.isEmpty) {
      // Show error if required fields are not filled
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(
              AppLocalizations.of(context)!.fillAllRequiredFieldsAndChapter),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    int totalPlayDuration = chapters.fold(0, (sum, chapter) {
      return sum + chapter.playDuration;
    });

    // Create a new story instance
    await exploreStoryController.createStory(
        titleController.text,
        aboutController.text,
        selectedCategory,
        coverImage?.path ?? storyCoverImagePlaceholderUrl,
        totalPlayDuration,
        chapters);

    Navigator.pushNamed(Get.context!, AppRoutes.tabview);

    log('Story Created');
  }

  void addChapter(Chapter chapter) {
    setState(() {
      chapters.add(chapter);
    });
  }

  Future<void> pickCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        coverImage = File(selectedImage.path); // Update the cover image state
      });
    }
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
          automaticallyImplyLeading: false,
          title: Text(
            AppLocalizations.of(context)!.createYourStory,
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
                      labelText: AppLocalizations.of(context)!.titleRequired,
                      labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 127, 130, 131),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary)),
                      counterText: ''),
                  maxLength: 100,
                ),
                const SizedBox(height: 30),

                // Category Dropdown
                DropdownButtonFormField<StoryCategory>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.category,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                  ),
                  items: StoryCategory.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(
                        AppLocalizations.of(context)!
                            .storyCategory(category.toString().split('.').last),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 127, 130, 131)),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 30),

                // About Story Input
                TextField(
                  controller: aboutController,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.aboutRequired,
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 127, 130, 131)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary)),
                    counterText: '',
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: UiSizes.height_20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: coverImage != null
                              ? Image.file(
                                  coverImage!,
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: 150,
                                )
                              : Image.network(
                                  storyCoverImagePlaceholderUrl,
                                  fit: BoxFit.cover,
                                  height: 150,
                                  width: 150,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: UiSizes.width_10),
                    Expanded(
                      child: GestureDetector(
                        onTap: pickCoverImage,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          // width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(84, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4)
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.change_circle,
                                  size: 50, color: Colors.grey),
                              Text(
                                AppLocalizations.of(context)!.changeCoverImage,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

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
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          chapter.description,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing:
                            Text(formatPlayDuration(chapter.playDuration)),
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
                    label: Text(AppLocalizations.of(context)!.addChapter),
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
                    child: Text(AppLocalizations.of(context)!.createStory),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize the first letter of each word
extension StringCasingExtension on String {
  String capitalizeFirstOfEach() => split(' ')
      .map((str) => str.isNotEmpty
          ? str[0].toUpperCase() + str.substring(1).toLowerCase()
          : '')
      .join(' ');
}

String formatPlayDuration(int milliseconds) {
  int totalSeconds = (milliseconds / 1000).round();
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;

  return "$minutes:${seconds.toString().padLeft(2, '0')}";
}
