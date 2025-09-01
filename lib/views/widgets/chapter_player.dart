import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:resonate/controllers/chapter_player_controller.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/views/screens/create_story_screen.dart';

class ChapterPlayer extends StatelessWidget {
  final Chapter chapter;
  final double progress;
  ChapterPlayer({super.key, required this.chapter, required this.progress});

  final ChapterPlayerController controller = Get.find();

  //currentPage
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              chapter.tintColor.withOpacity(progress < 0.75 ? 0.8 : 1),
              chapter.tintColor.withOpacity(progress < 0.75 ? 0.3 : 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 30 - (progress * 100) < 20 ? 20 : 30 - (progress * 100),
              left: progress < 0.45 ? 100 + (progress * 100) : 30,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                height: progress > 0.65 ? 50 : 200 - (2 * (progress * 100)),
                width: progress > 0.65 ? 50 : 200 - (2 * (progress * 100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    chapter.coverImageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: progress > 0.65 ? 25 : 250 - (2.5 * (progress * 100)),
              left: 100,
              right: 100,
              child: Text(
                chapter.title,
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color:
                      Theme.of(context).brightness == Brightness.dark ||
                          (ThemeData.estimateBrightnessForColor(
                                    chapter.tintColor,
                                  ) ==
                                  Brightness.dark &&
                              progress > 0.75)
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
            // Play Controls and Progress Bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: progress > 0.65 ? 70 : 300 - (3 * (progress * 100)),
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    Obx(
                      () => Slider(
                        value: controller.sliderProgress.value,
                        onChanged: (value) {
                          controller.sliderProgress.value = value;
                        },
                        onChangeEnd: (double value) {
                          controller.lyricProgress.value = value.toInt();

                          controller.audioPlayer?.seek(
                            Duration(milliseconds: value.toInt()),
                          );
                        },
                        min: 0,
                        max:
                            controller.chapterDuration.inMilliseconds
                                .toDouble() +
                            1000,

                        activeColor: Colors.white,
                        // activeColor: widget.chapter.tintColor,
                        inactiveColor: Colors.grey.shade300,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: progress > 0.70 ? 0 : 1,
                          child: Obx(
                            () => Text(
                              "${formatPlayDuration(controller.sliderProgress.value.toInt())} ${AppLocalizations.of(context)!.lengthMinutes}",
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity: progress > 0.70 ? 0 : 1,
                          child: Text(
                            "${formatPlayDuration(chapter.playDuration)} ${AppLocalizations.of(context)!.lengthMinutes}",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 350 - (3.3 * (progress * 100)) < 200
                  ? 200
                  : 350 - (3.3 * (progress * 100)),
              left: 175,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: progress > 0.45 ? 0 : 1,
                child: Obx(
                  () => IconButton(
                    iconSize: 34,
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: progress > 0.45
                        ? null
                        : () {
                            if (controller.isPlaying.value) {
                              controller.audioPlayer?.pause();
                            } else {
                              controller.audioPlayer?.resume();
                            }
                          },
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 320,
              child: AnimatedOpacity(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 200),
                opacity: progress > 0.45 ? 1 : 0,
                child: Obx(
                  () => IconButton(
                    iconSize: 34,
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: progress > 0.45
                        ? () {
                            if (controller.isPlaying.value) {
                              controller.audioPlayer?.pause();
                            } else {
                              controller.audioPlayer?.resume();
                            }
                          }
                        : null,
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            //const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
