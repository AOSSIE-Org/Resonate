import 'package:go_router/go_router.dart';
import 'package:resonate/features/auth/view/pages/email_verification_page.dart';
import 'package:resonate/features/auth/view/pages/forgot_password_page.dart';
import 'package:resonate/features/auth/view/pages/landing_page.dart';
import 'package:resonate/features/auth/view/pages/login_page.dart';
import 'package:resonate/features/auth/view/pages/reset_password_page.dart';
import 'package:resonate/features/auth/view/pages/signup_page.dart';
import 'package:resonate/features/auth/view/pages/splash_page.dart';
import 'package:resonate/features/auth/view/pages/user_blocked_page.dart';
import 'package:resonate/features/auth/view/pages/welcome_page.dart';
import 'package:resonate/routes/route_paths.dart';

// Routes contributed by the auth feature to the global GoRouter.
final List<GoRoute> authRoutes = [
  GoRoute(
    path: RoutePaths.splash,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: RoutePaths.landing,
    builder: (context, state) => const LandingPage(),
  ),
  GoRoute(
    path: RoutePaths.welcome,
    builder: (context, state) => const WelcomePage(),
  ),
  GoRoute(
    path: RoutePaths.login,
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: RoutePaths.signup,
    builder: (context, state) => const SignupPage(),
  ),
  GoRoute(
    path: RoutePaths.emailVerification,
    builder: (context, state) => const EmailVerificationPage(),
  ),
  GoRoute(
    path: RoutePaths.forgotPassword,
    builder: (context, state) => const ForgotPasswordPage(),
  ),
  GoRoute(
    path: RoutePaths.resetPassword,
    builder: (context, state) => ResetPasswordPage(
      userId: state.uri.queryParameters['userId'],
      secret: state.uri.queryParameters['secret'],
    ),
  ),
  GoRoute(
    path: RoutePaths.userBlocked,
    builder: (context, state) => const UserBlockedPage(),
  ),
];
