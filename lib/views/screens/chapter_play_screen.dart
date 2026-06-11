import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:flutter_lyric/flutter_lyric.dart';
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
  late LyricStyle lyricStyle;
  final ChapterPlayerController controller = Get.find();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bool themeIsDark = Theme.of(context).brightness == Brightness.dark;
    // Mirrors the old UINetease setup: the playing line is bold and
    // theme-contrasted, other lines stay grey.
    lyricStyle = LyricStyles.default1.copyWith(
      activeStyle: TextStyle(
        fontSize: UiSizes.size_20,
        fontWeight: FontWeight.bold,
        color: themeIsDark ? Colors.white : Colors.black,
      ),
      textStyle: TextStyle(
        fontSize: UiSizes.size_18,
        color: themeIsDark
            ? const Color.fromARGB(255, 223, 222, 222)
            : Colors.grey[600],
      ),
      selectedColor: themeIsDark ? Colors.white : Colors.black,
      activeHighlightColor: themeIsDark ? Colors.white : Colors.black,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      fadeRange: FadeRange(top: 0, bottom: 0),
    );
  }

  @override
  void initState() {
    super.initState();

    controller.initialize(
      AudioPlayer()..setSourceUrl(widget.chapter.audioFileUrl),
      widget.chapter.lyrics,
      Duration(milliseconds: widget.chapter.playDuration),
    );
    // Tapping a lyric line seeks to it (replaces the old select-line flow).
    controller.lyricController.setOnTapLineCallback((start) {
      controller.audioPlayer?.seek(start);
    });
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
              delegate: ChapterPlayerHeaderDelegate(chapter: widget.chapter),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
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
                              borderRadius: BorderRadius.circular(200),
                            ),
                            height: 5,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(106, 40, 39, 39)
                                  : const Color.fromARGB(193, 232, 230, 230),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: widget.chapter.lyrics.trim().isEmpty
                                ? Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noLyrics,
                                      style: lyricStyle.textStyle,
                                    ),
                                  )
                                : LyricView(
                                    controller: controller.lyricController,
                                    style: lyricStyle,
                                    width: double.infinity,
                                    height: 200,
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
                                AppLocalizations.of(context)!.about,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Inter',
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Text(
                                  widget.chapter.description,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterPlayerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Chapter chapter;
  const ChapterPlayerHeaderDelegate({required this.chapter});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    return ChapterPlayer(chapter: chapter, progress: progress);
  }

  @override
  double get maxExtent => 450;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
