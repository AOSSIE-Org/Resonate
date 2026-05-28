import 'package:go_router/go_router.dart';
import 'package:resonate/features/rooms/view/pages/create_room_page.dart';
import 'package:resonate/routes/route_paths.dart';

// Routes contributed by the rooms feature to the global GoRouter.
final List<GoRoute> roomsRoutes = [
  GoRoute(
    path: RoutePaths.createRoom,
    builder: (context, state) => CreateRoomPage(),
  ),
];
