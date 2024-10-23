import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:resonate/models/chapter.dart';

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
  int currentPage = 0;
  int lyricProgress = 0;
  double sliderProgress = 0;
  bool isPlaying = false;
  AudioPlayer? audioPlayer;
  late Duration chapterDuration;
  late LyricsReaderModel lyricModel;
  UINetease lyricUI = UINetease();

  @override
  void initState() {
    super.initState();
    chapterDuration = getChapterDurationFromString(widget.chapter.playDuration);
    lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(widget.chapter.lyrics)
        .getModel();
  }

  Duration getChapterDurationFromString(String songLength) {
    List<String> parts = songLength.split(':');
    int minutes = int.parse(parts[0]);
    int seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
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
                    widget.chapter.tintColor.withOpacity(0.8),
                    widget.chapter.tintColor.withOpacity(0.3)
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
                            color: widget.chapter.tintColor.computeLuminance() <
                                    0.5
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
                              color: widget.chapter.tintColor.withOpacity(0.5),
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
                      Text(
                        widget.chapter.title,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Inter',
                            ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Redesigned Progress Bar
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
                        max: chapterDuration.inMilliseconds.toDouble(),
                        activeColor: widget.chapter.tintColor,
                        inactiveColor: Colors.grey.shade300,
                      ),
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${formatDuration(sliderProgress)} min"),
                              Text("${widget.chapter.playDuration} min"),
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
                                  if (audioPlayer == null) {
                                    audioPlayer = AudioPlayer()
                                      ..play(UrlSource(
                                          widget.chapter.audioFileUrl));
                                    setState(() {
                                      isPlaying = true;
                                    });

                                    audioPlayer?.onPositionChanged
                                        .listen((Duration event) {
                                      setState(() {
                                        sliderProgress =
                                            event.inMilliseconds.toDouble();
                                        lyricProgress = event.inMilliseconds;
                                      });
                                    });

                                    audioPlayer?.onPlayerStateChanged
                                        .listen((PlayerState state) {
                                      setState(() {
                                        isPlaying =
                                            state == PlayerState.playing;
                                      });
                                    });
                                  } else {
                                    audioPlayer?.resume();
                                  }
                                }
                              },
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow)),
                        ],
                      ),

                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(106, 40, 39, 39),
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

// Helper function to format Duration into minutes:seconds format
String formatDuration(double milliseconds) {
  double totalSeconds = milliseconds / 1000; // Convert milliseconds to seconds
  int minutes = (totalSeconds / 60).floor();
  int remainingSeconds = (totalSeconds % 60).floor();

  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String secondsStr = twoDigits(remainingSeconds);

  return "$minutes:$secondsStr";
}
