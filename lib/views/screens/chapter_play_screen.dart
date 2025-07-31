import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get/get.dart';
import 'package:resonate/controllers/chapter_player_controller.dart';
import 'package:resonate/models/chapter.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/chapter_player.dart';

class ChapterPlayScreen extends StatefulWidget {
  const ChapterPlayScreen({super.key, required this.chapter});
  final Chapter chapter;

  @override
  State<ChapterPlayScreen> createState() => _ChapterPlayScreenState();
}

class _ChapterPlayScreenState extends State<ChapterPlayScreen> {
  late UINetease lyricUI;
  final ChapterPlayerController controller = Get.find();

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

    controller.initialize(
      AudioPlayer()..setSourceUrl(widget.chapter.audioFileUrl),
      LyricsModelBuilder.create()
          .bindLyricToMain(widget.chapter.lyrics)
          .getModel(),
      Duration(milliseconds: widget.chapter.playDuration),
    );
  }

  @override
  void dispose() {
    Get.delete<ChapterPlayerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: ChapterPlayerHeaderDelegate(chapter: widget.chapter)),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(106, 40, 39, 39)
                        : const Color.fromARGB(193, 232, 230, 230),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(200)),
                            height: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(106, 40, 39, 39)
                                  : const Color.fromARGB(193, 232, 230, 230),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Obx(
                              () => LyricsReader(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                model: controller.lyricModel,
                                position: controller.lyricProgress.value,
                                lyricUi: lyricUI,
                                playing: controller.isPlaying.value,
                                size: const Size(double.infinity, 200),
                                emptyBuilder: () => Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.noLyrics,
                                    style: UINetease().getOtherMainTextStyle(),
                                  ),
                                ),
                                selectLineBuilder: (progress, confirm) {
                                  return Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            confirm.call();

                                            controller.audioPlayer?.seek(
                                                Duration(
                                                    milliseconds: progress));
                                          },
                                          icon: Icon(Icons.play_arrow,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          height: 1,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        // added a second extra to cover up the error of the meta data library

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? const Color.fromARGB(106, 40, 39, 39)
                                    : const Color.fromARGB(193, 232, 230, 230),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.aboutSection,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
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
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class ChapterPlayerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Chapter chapter;
  const ChapterPlayerHeaderDelegate({required this.chapter});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    return ChapterPlayer(
      chapter: chapter,
      progress: progress,
    );
  }

  @override
  double get maxExtent => 450;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
