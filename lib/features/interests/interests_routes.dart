import 'package:go_router/go_router.dart';
import 'package:resonate/features/interests/view/pages/interests_screen.dart';
import 'package:resonate/routes/route_paths.dart';

final List<GoRoute> interestsRoutes = [
  GoRoute(
    path: RoutePaths.interestsScreen,
    builder: (_, _) => const InterestsScreen(),
  ),
];
