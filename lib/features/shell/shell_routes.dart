import 'package:go_router/go_router.dart';
import 'package:resonate/features/shell/view/pages/home_screen.dart';
import 'package:resonate/features/shell/view/pages/notifications_screen.dart';
import 'package:resonate/features/shell/view/pages/tabview_screen.dart';
import 'package:resonate/routes/route_paths.dart';

final List<GoRoute> shellRoutes = [
  GoRoute(
    path: RoutePaths.tabview,
    builder: (_, _) => const TabViewScreen(),
  ),
  GoRoute(
    path: RoutePaths.homeScreen,
    builder: (_, _) => const HomeScreen(),
  ),
  GoRoute(
    path: RoutePaths.notificationsScreen,
    builder: (_, _) => NotificationsScreen(),
  ),
];
