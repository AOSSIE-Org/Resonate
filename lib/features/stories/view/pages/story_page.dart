import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:resonate/features/stories/model/live_chapter_model.dart';
import 'package:resonate/features/stories/model/story.dart';
import 'package:resonate/features/stories/model/story_detail_state.dart';
import 'package:resonate/features/stories/view/pages/add_chapter_page.dart';
import 'package:resonate/features/stories/view/pages/chapter_play_page.dart';
import 'package:resonate/features/stories/view/story_format.dart';
import 'package:resonate/features/stories/view/widgets/chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/like_button.dart';
import 'package:resonate/features/stories/view/widgets/live_chapter_list_tile.dart';
import 'package:resonate/features/stories/view/widgets/start_live_chapter_dialog.dart';
import 'package:resonate/features/stories/viewmodel/live_chapter_notifier.dart';
import 'package:resonate/features/stories/viewmodel/story_detail_notifier.dart';
import 'package:resonate/l10n/app_localizations.dart';
import 'package:resonate/routes/route_paths.dart';
import 'package:resonate/utils/enums/log_type.dart';
import 'package:resonate/utils/extensions/datetime_extension.dart';
import 'package:resonate/utils/ui_sizes.dart';
import 'package:resonate/views/widgets/snackbar.dart';

class StoryPage extends ConsumerStatefulWidget {
  const StoryPage({super.key, required this.story});
  final Story story;

  @override
  ConsumerState<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends ConsumerState<StoryPage> {
  bool descriptionIsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final story = widget.story;
    // Tint the status bar to match the story.
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: story.tintColor.withValues(alpha: 0.8),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final detailAsync = ref.watch(storyDetailProvider(story.storyId));

    return Scaffold(
      body: SafeArea(
        child: detailAsync.when(
          loading: () => Center(
            child: SizedBox(
              height: UiSizes.height_200,
              width: UiSizes.width_200,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotate,
                colors: [Theme.of(context).colorScheme.primary],
              ),
            ),
          ),
          error: (e, _) => Center(
            child: Text(AppLocalizations.of(context)!.error),
          ),
          data: (detail) => _content(context, story, detail),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Story story, StoryDetailState detail) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _header(context, story, detail),
        SizedBox(height: UiSizes.height_10),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UiSizes.width_16,
                vertical: UiSizes.height_8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
                    child: Text(
                      l10n.about,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: UiSizes.size_20,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_8),
                  GestureDetector(
                    onTap: () => setState(
                      () => descriptionIsExpanded = !descriptionIsExpanded,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: UiSizes.width_16,
                      ),
                      child: Text(
                        story.description,
                        maxLines: descriptionIsExpanded ? null : 10,
                        overflow: descriptionIsExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: UiSizes.size_16,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_40),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: UiSizes.width_16),
                    child: Text(
                      l10n.chapters,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                        fontSize: UiSizes.size_20,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: UiSizes.height_8),
                  _chaptersList(context, detail),
                  SizedBox(height: UiSizes.height_50),
                  if (story.userIsCreator)
                    _creatorActions(context, story, detail),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _header(BuildContext context, Story story, StoryDetailState detail) {
    final l10n = AppLocalizations.of(context)!;
    final tint = story.tintColor;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tint.withValues(alpha: 0.8),
            tint.withValues(alpha: 0.6),
            tint.withValues(alpha: 0.4),
            tint.withValues(alpha: 0.2),
            Colors.transparent,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(UiSizes.width_20),
        child: Column(
          children: [
            SizedBox(height: UiSizes.height_20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: UiSizes.width_10,
                        bottom: UiSizes.height_15,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(UiSizes.width_10),
                        child: Image.network(
                          story.coverImageUrl,
                          width: UiSizes.width_111,
                          height: UiSizes.width_111,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    LikeButton(
                      isLikedByUser: detail.isLikedByCurrentUser,
                      tintColor: tint,
                      onLiked: (_) => ref
                          .read(storyDetailProvider(story.storyId).notifier)
                          .toggleLike(story),
                    ),
                  ],
                ),
                SizedBox(width: UiSizes.width_16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: UiSizes.size_35,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'Inter',
                        ),
                      ),
                      SizedBox(height: UiSizes.height_8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${detail.likesCount} ${l10n.likes}',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontSize: UiSizes.size_16,
                                  fontFamily: 'Inter',
                                ),
                          ),
                          SizedBox(width: UiSizes.width_16),
                          Text(
                            '${formatPlayDuration(story.playDuration)} ${l10n.lengthMinutes}',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontSize: UiSizes.size_16,
                                  fontFamily: 'Inter',
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: UiSizes.height_8),
                      Row(
                        children: [
                          Text(
                            l10n.by,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  fontSize: UiSizes.size_16,
                                  fontFamily: 'Inter',
                                ),
                          ),
                          SizedBox(width: UiSizes.width_16),
                          CircleAvatar(
                            radius: UiSizes.width_16,
                            backgroundImage: NetworkImage(story.creatorImgUrl),
                          ),
                          SizedBox(width: UiSizes.width_8),
                          Expanded(
                            child: Text(
                              story.userIsCreator ? l10n.you : story.creatorName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(
                                    fontSize: UiSizes.size_16,
                                    fontFamily: 'Inter',
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: UiSizes.height_40),
            Text(
              l10n.created(story.creationDate.formatDateTime(context)),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: UiSizes.size_16,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinLiveChapter(LiveChapterModel live) async {
    final router = GoRouter.of(context);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref
          .read(liveChapterProvider.notifier)
          .joinLiveChapter(live.livekitRoomId, live);
      router.push(RoutePaths.liveChapterScreen);
    } catch (e) {
      customSnackbar(l10n.error, e.toString(), LogType.error);
    }
  }

  Widget _chaptersList(BuildContext context, StoryDetailState detail) {
    final hasLive = detail.liveChapter != null;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: hasLive ? detail.chapters.length + 1 : detail.chapters.length,
      itemBuilder: (context, index) {
        if (index == 0 && hasLive) {
          final live = detail.liveChapter!;
          return GestureDetector(
            onTap: () => _joinLiveChapter(live),
            child: LiveChapterListTile(chapter: live),
          );
        }
        final chapter = detail.chapters[hasLive ? index - 1 : index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChapterPlayPage(chapter: chapter)),
          ),
          child: ChapterListTile(chapter: chapter),
        );
      },
    );
  }

  Widget _creatorActions(
    BuildContext context,
    Story story,
    StoryDetailState detail,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddChapterPage(
                    storyName: story.title,
                    storyId: story.storyId,
                    currentChapters: detail.chapters,
                  ),
                ),
              ),
              child: Text(l10n.addChapter),
            ),
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => StartLiveChapterDialog(story: story),
              ),
              child: Text(l10n.liveChapter),
            ),
          ],
        ),
        SizedBox(height: UiSizes.height_20),
        ElevatedButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            await ref
                .read(storyDetailProvider(story.storyId).notifier)
                .deleteStory(story);
            navigator.pop();
          },
          child: Text(l10n.deleteStory),
        ),
      ],
    );
  }
}
