import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/screens/create_story_screen.dart';

class ChapterPlayScreen extends StatefulWidget {
  final Chapter chapter; // Passing the selected chapter

  const ChapterPlayScreen({
    super.key,
    required this.chapter,
  });

  @override
  ChapterPlayScreenState createState() => ChapterPlayScreenState();
}

class ChapterPlayScreenState extends State<ChapterPlayScreen> {
  late int currentPage;
  late int lyricProgress;
  late double sliderProgress;
  late bool isPlaying;
  AudioPlayer? audioPlayer;
  late Duration chapterDuration;
  late LyricsReaderModel lyricModel;
  late UINetease lyricUI;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool themeIsDark = Theme.of(context).brightness == Brightness.dark;
    lyricUI = UINetease(
        highlightColor: themeIsDark ? Colors.white : Colors.black,
        playingMainTextStyle: TextStyle(
            fontSize: UiSizes.size_20,
            fontWeight: FontWeight.bold,
            color: themeIsDark
                ? const Color.fromARGB(255, 223, 222, 222)
                : Colors.grey[600]),
        otherMainTextStyle: TextStyle(
            fontSize: UiSizes.size_18,
            color: themeIsDark
                ? const Color.fromARGB(255, 223, 222, 222)
                : Colors.grey[600]));
  }

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    lyricProgress = 0;
    sliderProgress = 0;
    isPlaying = false;
    chapterDuration = Duration(milliseconds: widget.chapter.playDuration);
    lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(widget.chapter.lyrics)
        .getModel();
    if (audioPlayer == null) {
      audioPlayer = AudioPlayer()..setSourceUrl(widget.chapter.audioFileUrl);
      audioPlayer?.setReleaseMode(ReleaseMode.stop);
      audioPlayer?.onPositionChanged.listen((Duration event) {
        setState(() {
          log(event.inMilliseconds.toDouble().toString());
          sliderProgress = event.inMilliseconds.toDouble();
          lyricProgress = event.inMilliseconds;
        });
      });

      audioPlayer?.onPlayerStateChanged.listen((PlayerState state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer?.release();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.65,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.chapter.tintColor.withAlpha((255 * 0.8).round()),
                    widget.chapter.tintColor.withAlpha((255 * 0.3).round())
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  // Chapter Cover Image Screen
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.chapter.coverImageUrl,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.chapter.title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Lyrics Screen
                  LyricsReader(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    model: lyricModel,
                    position: lyricProgress,
                    lyricUi: lyricUI,
                    playing: isPlaying,
                    size: Size(double.infinity,
                        MediaQuery.of(context).size.height * 65),
                    emptyBuilder: () => Center(
                      child: Text(
                        "No lyrics",
                        style: UINetease().getOtherMainTextStyle(),
                      ),
                    ),
                    selectLineBuilder: (progress, confirm) {
                      return Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                confirm.call();
                                setState(() {
                                  audioPlayer
                                      ?.seek(Duration(milliseconds: progress));
                                });
                              },
                              icon: Icon(Icons.play_arrow,
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary),
                              height: 1,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                2, // Number of pages in the PageView
                (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == index
                        ? widget.chapter.tintColor
                        : Colors.grey.shade400,
                    boxShadow: currentPage == index
                        ? [
                            BoxShadow(
                              color: widget.chapter.tintColor.withAlpha((255 * 0.5).round()),
                              blurRadius: 4,
                            ),
                          ]
                        : [],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Play Controls and Progress Bar
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // added a second extra to cover up the error of the meta data library
                      Slider(
                        value: sliderProgress,
                        onChanged: (value) {
                          setState(() {
                            sliderProgress = value;
                          });
                        },
                        onChangeEnd: (double value) {
                          setState(() {
                            lyricProgress = value.toInt();
                          });
                          audioPlayer
                              ?.seek(Duration(milliseconds: value.toInt()));
                        },
                        min: 0,
                        max: chapterDuration.inMilliseconds.toDouble() + 1000,
                        activeColor: widget.chapter.tintColor,
                        inactiveColor: Colors.grey.shade300,
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "${formatPlayDuration(sliderProgress.toInt())} min"),
                              Text(
                                  "${formatPlayDuration(widget.chapter.playDuration)} min"),
                            ],
                          ),
                          IconButton(
                              iconSize: 34,
                              style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                if (isPlaying) {
                                  audioPlayer?.pause();
                                } else {
                                  audioPlayer?.resume();
                                }
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              )),
                        ],
                      ),

                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromARGB(106, 40, 39, 39)
                              : const Color.fromARGB(193, 232, 230, 230),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                    fontStyle: FontStyle.normal,
                                    fontFamily: 'Inter',
                                  ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                widget.chapter.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Inter',
                                    ),
                              ),
                            ),
                            const SizedBox(height: 5)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20)
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
