import 'package:go_router/go_router.dart';
import 'package:resonate/features/profile/view/pages/change_email_page.dart';
import 'package:resonate/features/profile/view/pages/delete_account_page.dart';
import 'package:resonate/features/profile/view/pages/edit_profile_page.dart';
import 'package:resonate/features/profile/view/pages/onboarding_page.dart';
import 'package:resonate/features/profile/view/pages/profile_page.dart';
import 'package:resonate/routes/route_paths.dart';

final List<GoRoute> profileRoutes = [
  GoRoute(
    path: RoutePaths.onboarding,
    builder: (context, state) => const OnboardingPage(),
  ),
  GoRoute(
    path: RoutePaths.profile,
    builder: (context, state) => ProfilePage(),
  ),
  GoRoute(
    path: RoutePaths.editProfile,
    builder: (context, state) => const EditProfilePage(),
  ),
  GoRoute(
    path: RoutePaths.changeEmail,
    builder: (context, state) => const ChangeEmailPage(),
  ),
  GoRoute(
    path: RoutePaths.deleteAccount,
    builder: (context, state) => const DeleteAccountPage(),
  ),
];
