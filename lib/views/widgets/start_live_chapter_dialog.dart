import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/live_chapter_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/story.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class StartLiveChapterDialog extends StatelessWidget {
  const StartLiveChapterDialog({super.key, required this.story});

  final Story story;
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Text(
                  AppLocalizations.of(context)!.startLiveChapter,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: nameController,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.chapterTitle,
                  ),
                ),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.description,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // Handle start live chapter logic here
                        String chapterName = nameController.text.trim();
                        String chapterDescription = descriptionController.text
                            .trim();
                        if (chapterName.isNotEmpty &&
                            chapterDescription.isNotEmpty) {
                          try {
                            await Get.put(
                              LiveChapterController(),
                            ).startLiveChapter(
                              ID.unique(),
                              chapterName,
                              chapterDescription,
                              story.storyId,
                            );
                          } catch (e) {
                            customSnackbar(
                              AppLocalizations.of(context)!.error,
                              e.toString(),
                              LogType.error,
                            );
                          }
                        } else {
                          customSnackbar(
                            AppLocalizations.of(context)!.error,
                            AppLocalizations.of(context)!.fillAllFields,
                            LogType.error,
                          );
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.start),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
