import 'package:resonate/routes/route_paths.dart';


enum AppFeature {
  pairChat(
    storageKey: 'featureEnabled_pairChat',
    routes: {
      RoutePaths.pairing,
      RoutePaths.pairChat,
      RoutePaths.pairChatUsers,
    },
  ),
  liveChapter(
    storageKey: 'featureEnabled_liveChapter',
    routes: {
      RoutePaths.liveChapterScreen,
      RoutePaths.verifyChapterDetails,
    },
  );

  const AppFeature({required this.storageKey, required this.routes});

  final String storageKey;

  final Set<String> routes;
}
