import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resonate/controllers/live_chapter_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resonate/controllers/explore_story_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/routes/app_routes.dart';
import 'package:resonate/utils/constants.dart';
import 'package:resonate/utils/ui_sizes.dart';

class VerifyChapterDetailsScreen extends StatefulWidget {
  const VerifyChapterDetailsScreen({super.key, required this.lyricsString});
  final String lyricsString;

  @override
  VerifyChapterDetailsScreenState createState() =>
      VerifyChapterDetailsScreenState();
}

class VerifyChapterDetailsScreenState
    extends State<VerifyChapterDetailsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController aboutController = TextEditingController();
  final TextEditingController lyricsController = TextEditingController();
  File? chapterCoverImage;
  File? audioFile; // For audio file

  ExploreStoryController exploreStoryController =
      Get.find<ExploreStoryController>();
  LiveChapterController liveChapterController =
      Get.find<LiveChapterController>();
  Future<void> pickChapterCoverImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage != null) {
      setState(() {
        chapterCoverImage = File(selectedImage.path);
      });
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadInitialData();
    });
  }

  Future<void> loadInitialData() async {
    final storagePath = await getApplicationDocumentsDirectory();
    final String audioFilePath =
        "${storagePath.path}/recordings/${liveChapterController.liveChapterModel.value!.livekitRoomId}.wav";
    audioFile = File(audioFilePath);
    titleController.text = liveChapterController
        .liveChapterModel
        .value!
        .chapterTitle; // Pre-fill title
    aboutController.text = liveChapterController
        .liveChapterModel
        .value!
        .chapterDescription; // Pre-fill description
    lyricsController.text = widget.lyricsString;
    setState(() {});
  }

  Future<void> viewOrEditLyrics() async {
    await Get.dialog(
      AlertDialog(
        title: Text(AppLocalizations.of(context)!.viewOrEditLyrics),
        content: TextField(
          controller: lyricsController,
          maxLines: 10,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppLocalizations.of(context)!.close),
          ),
        ],
      ),
    );
  }

  void createChapter() async {
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        audioFile == null) {
      // Show error if required fields are not filled
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text(AppLocalizations.of(context)!.fillAllRequiredFields),
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

    Chapter newChapter = await liveChapterController
        .createChapterFromLiveChapter(
          chapterCoverImage?.path ?? chapterCoverImagePlaceholderUrl,
          audioFile!.path,
          widget.lyricsString,
        );

    await exploreStoryController.pushChaptersToStory([
      newChapter,
    ], liveChapterController.liveChapterModel.value!.storyId);

    await exploreStoryController.updateStoriesPlayDurationLength([
      ...exploreStoryController.userCreatedStories
          .firstWhere(
            (story) =>
                story.storyId ==
                liveChapterController.liveChapterModel.value!.storyId,
          )
          .chapters,
      newChapter,
    ], liveChapterController.liveChapterModel.value!.storyId);
    await exploreStoryController.fetchUserCreatedStories();

    Get.offAllNamed(AppRoutes.tabview);
    Get.delete<LiveChapterController>();
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
          title: Text(AppLocalizations.of(context)!.verifyChapterDetails),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.chapterTitle,
                  counterText: '',
                ),
                maxLines: 1,
                maxLength: 20,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: aboutController,
                maxLength: 2000,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.aboutRequired,
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
                    ),
                  ),
                  SizedBox(width: UiSizes.width_10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: pickChapterCoverImage,
                        child: Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(84, 158, 158, 158),
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.change_circle,
                                size: 50,
                                color: Colors.grey,
                              ),
                              Text(
                                AppLocalizations.of(context)!.changeCoverImage,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
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
                            ? AppLocalizations.of(context)!.audioFileSelected(
                                audioFile!.path.split('/').last,
                              )
                            : AppLocalizations.of(context)!.uploadAudioFile,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: viewOrEditLyrics,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.viewOrEditLyrics,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: createChapter,
                child: Text(AppLocalizations.of(context)!.createChapter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
