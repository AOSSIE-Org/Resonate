import 'package:go_router/go_router.dart';
import 'package:resonate/features/settings/view/pages/about_app_screen.dart';
import 'package:resonate/features/settings/view/pages/app_preferences_screen.dart';
import 'package:resonate/features/settings/view/pages/contribute_screen.dart';
import 'package:resonate/features/settings/view/pages/settings_screen.dart';
import 'package:resonate/features/settings/view/pages/user_account_screen.dart';
import 'package:resonate/routes/route_paths.dart';

final List<GoRoute> settingsRoutes = [
  GoRoute(
    path: RoutePaths.settings,
    builder: (_, _) => SettingsScreen(),
  ),
  GoRoute(
    path: RoutePaths.userAccountScreen,
    builder: (_, _) => const UserAccountScreen(),
  ),
  GoRoute(
    path: RoutePaths.aboutApp,
    builder: (_, _) => const AboutAppScreen(),
  ),
  GoRoute(
    path: RoutePaths.contributeScreen,
    builder: (_, _) => const ContributeScreen(),
  ),
  GoRoute(
    path: RoutePaths.appPreferencesScreen,
    builder: (_, _) => const AppPreferencesScreen(),
  ),
];
