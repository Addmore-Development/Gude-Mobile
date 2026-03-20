import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/role_select_screen.dart';
import '../../features/auth/presentation/screens/login_signup_screen.dart';
import '../../features/auth/presentation/screens/congratulations_screen.dart';
import '../../features/auth/presentation/screens/capture_banking_screen.dart';

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home — Coming Soon')),
    );
  }
}

class _ForgotPasswordPlaceholder extends StatelessWidget {
  const _ForgotPasswordPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Color(0xFF1A1A1A)),
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w700),
        ),
      ),
      body: const Center(child: Text('Forgot password — Coming Soon')),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/role-select', builder: (context, state) => const RoleSelectScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const _ForgotPasswordPlaceholder()),
    GoRoute(path: '/congratulations', builder: (context, state) => const CongratulationsScreen()),
    GoRoute(path: '/capture-banking', builder: (context, state) => const CaptureBankingScreen()),
    GoRoute(path: '/home', builder: (context, state) => const _PlaceholderHome()),
  ],
);