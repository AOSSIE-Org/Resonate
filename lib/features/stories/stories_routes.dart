import 'package:go_router/go_router.dart';
import 'package:resonate/features/stories/view/pages/create_story_page.dart';
import 'package:resonate/features/stories/view/pages/explore_page.dart';
import 'package:resonate/features/stories/view/pages/live_chapter_page.dart';
import 'package:resonate/features/stories/model/recorded_chapter.dart';
import 'package:resonate/features/stories/view/pages/recorded_chapter_detail_page.dart';
import 'package:resonate/features/stories/view/pages/recorded_chapters_page.dart';
import 'package:resonate/features/stories/view/pages/verify_chapter_details_page.dart';
import 'package:resonate/routes/route_paths.dart';

final List<GoRoute> storiesRoutes = [
  GoRoute(
    path: RoutePaths.exploreScreen,
    builder: (_, _) => const ExplorePage(),
  ),
  GoRoute(
    path: RoutePaths.createStoryScreen,
    builder: (_, _) => const CreateStoryPage(),
  ),
  GoRoute(
    path: RoutePaths.liveChapterScreen,
    builder: (_, _) => const LiveChapterPage(),
  ),
  GoRoute(
    path: RoutePaths.verifyChapterDetails,
    builder: (_, _) => const VerifyChapterDetailsPage(),
  ),
  GoRoute(
    path: RoutePaths.recordedChapters,
    builder: (_, _) => const RecordedChaptersPage(),
  ),
  GoRoute(
    path: RoutePaths.recordedChapterDetail,
    builder: (_, state) =>
        RecordedChapterDetailPage(chapter: state.extra! as RecordedChapter),
  ),
];
