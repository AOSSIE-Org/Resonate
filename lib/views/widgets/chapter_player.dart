import 'dart:math';
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
              chapter.tintColor.withAlpha(
                (progress < 0.75 ? 0.8 : 1) * 255 ~/ 1,
              ),
              chapter.tintColor.withAlpha(
                (progress < 0.75 ? 0.3 : 1) * 255 ~/ 1,
              ),
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
            
            // Sleep Timer
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 350 - (3.3 * (progress * 100)) < 200
                  ? 210
                  : 360 - (3.3 * (progress * 100)),
              left: 100,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: progress > 0.45 ? 0 : 1,
                child: Obx(
                  () => TextButton(
                    onPressed: progress > 0.45 
                      ? null 
                      : () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              double selectedMinutes = 15;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Sleep Timer",
                                          style: Theme.of(context).textTheme.titleLarge,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          "${selectedMinutes.toInt()} Minutes",
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Slider(
                                          value: selectedMinutes,
                                          min: 1,
                                          max: 480,
                                          divisions: 479,
                                          label: "${selectedMinutes.toInt()} min",
                                          onChanged: (value) {
                                            setState(() {
                                              selectedMinutes = value;
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            if (controller.sleepTimerRemaining.value != null)
                                              OutlinedButton(
                                                onPressed: () {
                                                  controller.cancelSleepTimer();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Turn Off"),
                                              ),
                                            FilledButton(
                                              onPressed: () {
                                                controller.startSleepTimer(selectedMinutes.toInt());
                                                Navigator.pop(context);
                                              },
                                              child: Text(controller.sleepTimerRemaining.value != null 
                                                  ? "Update Timer" 
                                                  : "Start Timer"
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        TextButton(
                                          onPressed: () {
                                             final remainingMs = controller.chapterDuration.inMilliseconds - controller.sliderProgress.value;
                                             final remainingMinutes = (remainingMs / 1000 / 60).ceil();
                                             controller.startSleepTimer(remainingMinutes);
                                             Navigator.pop(context);
                                          },
                                          child: const Text("End of Chapter"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                    style: TextButton.styleFrom(
                      backgroundColor: controller.sleepTimerRemaining.value != null 
                          ? Theme.of(context).primaryColor 
                          : Colors.black12,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.sleepTimerRemaining.value != null) ...[
                          Text(
                            "${(controller.sleepTimerRemaining.value! / 60).ceil()}m",
                             style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ] else ...[
                          Icon(
                            Icons.nights_stay,
                            size: 18,
                            color: Theme.of(context).brightness == Brightness.dark ||
                                      (ThemeData.estimateBrightnessForColor(
                                                chapter.tintColor,
                                              ) ==
                                              Brightness.dark)
                                  ? Colors.white
                                  : Colors.black87,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Playback Speed Control
            AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              top: 350 - (3.3 * (progress * 100)) < 200
                  ? 210
                  : 360 - (3.3 * (progress * 100)),
              left: 250,
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: progress > 0.45 ? 0 : 1,
                child: Obx(
                  () => TextButton(
                    onPressed: progress > 0.45 
                      ? null 
                      : () {
                          // Cycle speeds: 0.5 -> 0.75 -> 1.0 -> 1.25 -> 1.5 -> 2.0 -> 0.5
                          final current = controller.playbackSpeed.value;
                          final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
                          final nextIndex = (speeds.indexOf(current) + 1) % speeds.length;
                          controller.setPlaybackSpeed(speeds[nextIndex]);
                        },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black12,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "${controller.playbackSpeed.value}x",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark ||
                          (ThemeData.estimateBrightnessForColor(
                                    chapter.tintColor,
                                  ) ==
                                  Brightness.dark)
                          ? Colors.white
                          : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
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
