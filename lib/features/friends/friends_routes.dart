import 'package:go_router/go_router.dart';
import 'package:resonate/features/friends/view/pages/friend_call_page.dart';
import 'package:resonate/features/friends/view/pages/pair_chat_page.dart';
import 'package:resonate/features/friends/view/pages/pair_chat_users_page.dart';
import 'package:resonate/features/friends/view/pages/pairing_page.dart';
import 'package:resonate/features/friends/view/pages/ringing_page.dart';
import 'package:resonate/routes/route_paths.dart';

// Routes contributed by the friends feature to the global GoRouter.
final List<GoRoute> friendsRoutes = [
  GoRoute(
    path: RoutePaths.pairing,
    builder: (context, state) => const PairingPage(),
  ),
  GoRoute(
    path: RoutePaths.pairChatUsers,
    builder: (context, state) => const PairChatUsersPage(),
  ),
  GoRoute(
    path: RoutePaths.pairChat,
    builder: (context, state) => const PairChatPage(),
  ),
  GoRoute(
    path: RoutePaths.ringingScreen,
    builder: (context, state) => const RingingPage(),
  ),
  GoRoute(
    path: RoutePaths.friendCallScreen,
    builder: (context, state) => const FriendCallPage(),
  ),
];
