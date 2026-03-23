import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_routes.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/student_verify_screen.dart';
import '../features/auth/presentation/screens/capture_banking_screen.dart';
import '../features/auth/presentation/screens/congratulations_screen.dart';
import '../features/auth/presentation/screens/home_screen.dart';

// TODO: import home + feature screens when built

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: false,
  routes: [
    // ── Auth ──────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (_, __) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.studentVerify,
      builder: (_, __) => const StudentVerifyScreen(),
    ),
    GoRoute(
      path: AppRoutes.captureBanking,
      builder: (_, __) => const CaptureBankingScreen(),
    ),
    GoRoute(
      path: AppRoutes.congratulations,
      builder: (_, __) => const CongratulationsScreen(),
    ),

    // ── Main (placeholder — build next) ──────────────────
    GoRoute(
      path: AppRoutes.home,
      builder: (_, __) => const _PlaceholderHome(),
    ),
  ],

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text('Page not found: ${state.uri}'),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go(AppRoutes.splash),
            child: const Text('Go Home'),
          ),
        ],
      ),
    ),
  ),
);

// ── Placeholder home — replace with real HomeScreen ──────
class home_screen extends StatelessWidget {
  const home_screen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE30613),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'G',
                style: TextStyle(
                  fontSize: 48, fontWeight: FontWeight.w800,
                  color: Colors.white, fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Home Dashboard',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 8),
            const Text(
              '✅ Auth flow complete!\nBuild HomeScreen next.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }
}
