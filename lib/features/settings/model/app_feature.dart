import 'package:resonate/routes/route_paths.dart';


enum AppFeature {
  pairChat(
    storageKey: 'featureEnabled_pairChat',
    routes: {
      RoutePaths.pairing,
      RoutePaths.pairChat,
      RoutePaths.pairChatUsers,
    },
  );

  const AppFeature({required this.storageKey, required this.routes});

  final String storageKey;

  final Set<String> routes;
}
