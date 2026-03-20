import 'package:go_router/go_router.dart';
import 'package:gude_mobile/features/auth/presentation/splash_page.dart';
import 'package:gude_mobile/features/auth/presentation/onboarding_page.dart';
import 'package:gude_mobile/features/auth/presentation/login_page.dart';
import 'package:gude_mobile/features/auth/presentation/signup_page.dart';
import 'package:gude_mobile/features/auth/presentation/forgot_password_page.dart';
import 'package:gude_mobile/features/home/presentation/home_page.dart';
import 'package:gude_mobile/features/marketplace/presentation/marketplace_page.dart';
import 'package:gude_mobile/features/wallet/presentation/wallet_page.dart';
import 'package:gude_mobile/features/stability/presentation/stability_page.dart';
import 'package:gude_mobile/features/support_hub/presentation/support_page.dart';
import 'package:gude_mobile/features/profile/presentation/profile_page.dart';
import 'package:gude_mobile/shared/widgets/bottom_nav_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash',
        builder: (c, s) => const SplashPage()),
      GoRoute(path: '/onboarding',
        builder: (c, s) => const OnboardingPage()),
      GoRoute(path: '/login',
        builder: (c, s) => const LoginPage()),
      GoRoute(path: '/signup',
        builder: (c, s) => const SignupPage()),
      GoRoute(path: '/forgot-password',
        builder: (c, s) => const ForgotPasswordPage()),
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(path: '/home',
            builder: (c, s) => const HomePage()),
          GoRoute(path: '/marketplace',
            builder: (c, s) => const MarketplacePage()),
          GoRoute(path: '/wallet',
            builder: (c, s) => const WalletPage()),
          GoRoute(path: '/support',
            builder: (c, s) => const SupportPage()),
          GoRoute(path: '/stability',
            builder: (c, s) => const StabilityPage()),
          GoRoute(path: '/profile',
            builder: (c, s) => const ProfilePage()),
        ],
      ),
    ],
  );
}
