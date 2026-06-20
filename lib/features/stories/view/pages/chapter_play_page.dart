import 'package:flutter/material.dart';
import 'package:flutter_lyric/flutter_lyric.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resonate/features/stories/model/chapter.dart';
import 'package:resonate/features/stories/view/widgets/chapter_player.dart';
import 'package:resonate/features/stories/viewmodel/chapter_player_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/utils/ui_sizes.dart';

class ChapterPlayPage extends ConsumerStatefulWidget {
  const ChapterPlayPage({super.key, required this.chapter});
  final Chapter chapter;

  @override
  ConsumerState<ChapterPlayPage> createState() => _ChapterPlayPageState();
}

class _ChapterPlayPageState extends ConsumerState<ChapterPlayPage> {
  late LyricStyle lyricStyle;

  @override
  void initState() {
    super.initState();
    ref
        .read(chapterPlayerProvider(widget.chapter.chapterId).notifier)
        .initialize(
          audioUrl: widget.chapter.audioFileUrl,
          lyrics: widget.chapter.lyrics,
          duration: Duration(milliseconds: widget.chapter.playDuration),
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final mainTextColor = onSurface.withValues(alpha: 0.7);
    lyricStyle = LyricStyles.default1.copyWith(
      textStyle: TextStyle(fontSize: UiSizes.size_18, color: mainTextColor),
      activeStyle: TextStyle(
        fontSize: UiSizes.size_20,
        fontWeight: FontWeight.bold,
        color: mainTextColor,
      ),
      activeHighlightColor: onSurface,
      selectedColor: onSurface,
      contentPadding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
      anchorPosition: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lyricController = ref
        .read(chapterPlayerProvider(widget.chapter.chapterId).notifier)
        .lyricController;
    // Keeping the provider alive for the lifetime of this page
    ref.watch(chapterPlayerProvider(widget.chapter.chapterId));
    final cardColor = colorScheme.onSurface.withValues(alpha: 0.06);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _ChapterPlayerHeaderDelegate(chapter: widget.chapter),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.all(UiSizes.width_10),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(UiSizes.width_20),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            width: UiSizes.width_111,
                            height: UiSizes.height_5,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                UiSizes.width_200,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: UiSizes.height_10,
                          ),
                          child: Container(
                            height: UiSizes.height_200,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(
                                UiSizes.width_10,
                              ),
                            ),
                            child: widget.chapter.lyrics.trim().isEmpty
                                ? Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.noLyrics,
                                      style: lyricStyle.textStyle,
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      LyricView(
                                        controller: lyricController,
                                        style: lyricStyle,
                                        height: UiSizes.height_200,
                                      ),
                                      LyricSelectionProgress(
                                        controller: lyricController,
                                        style: lyricStyle,
                                        onPlay: (state) => ref
                                            .read(
                                              chapterPlayerProvider(
                                                widget.chapter.chapterId,
                                              ).notifier,
                                            )
                                            .seek(state.duration),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(UiSizes.width_10),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(UiSizes.width_10),
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.about,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w500,
                                      fontSize: UiSizes.size_17,
                                      fontFamily: 'Inter',
                                    ),
                              ),
                              SizedBox(height: UiSizes.height_10),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: UiSizes.width_5,
                                ),
                                child: Text(
                                  widget.chapter.description,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.w300,
                                        fontSize: UiSizes.size_16,
                                        fontFamily: 'Inter',
                                      ),
                                ),
                              ),
                              SizedBox(height: UiSizes.height_5),
                            ],
                          ),
                        ),
                        SizedBox(height: UiSizes.height_20),
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

class _ChapterPlayerHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Chapter chapter;
  const _ChapterPlayerHeaderDelegate({required this.chapter});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    return ChapterPlayerView(chapter: chapter, progress: progress);
  }

  @override
  double get maxExtent => 450;

  @override
  double get minExtent => 120;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
