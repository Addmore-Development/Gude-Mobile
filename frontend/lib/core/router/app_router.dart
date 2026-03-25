import 'package:go_router/go_router.dart';
import 'package:gude_app/features/auth/presentation/splash_page.dart';
import 'package:gude_app/features/auth/presentation/onboarding_page.dart';
import 'package:gude_app/features/auth/presentation/login_page.dart';
import 'package:gude_app/features/auth/presentation/signup_page.dart';
import 'package:gude_app/features/auth/presentation/forgot_password_page.dart';
import 'package:gude_app/features/auth/presentation/skills_selection_page.dart';
import 'package:gude_app/features/auth/presentation/student_verification_page.dart';
import 'package:gude_app/features/marketplace/presentation/marketplace_page.dart';
import 'package:gude_app/features/marketplace/presentation/listing_detail_page.dart';
import 'package:gude_app/features/marketplace/presentation/create_listing_page.dart';
import 'package:gude_app/features/marketplace/presentation/hire_student_page.dart';
import 'package:gude_app/features/marketplace/presentation/job_dashboard_page.dart';
import 'package:gude_app/features/wallet/presentation/wallet_page.dart';
import 'package:gude_app/features/wallet/presentation/budget_planner_page.dart';
import 'package:gude_app/features/wallet/presentation/savings_goals_page.dart';
import 'package:gude_app/features/wallet/presentation/screens/send_money_screen.dart';
import 'package:gude_app/features/wallet/presentation/screens/withdraw_screen.dart';
import 'package:gude_app/features/stability/presentation/stability_page.dart';
import 'package:gude_app/features/stability/presentation/weekly_checkin_page.dart';
import 'package:gude_app/features/support_hub/presentation/support_page.dart';
import 'package:gude_app/features/home/presentation/home_page.dart';
import 'package:gude_app/features/profile/presentation/profile_page.dart';
<<<<<<< HEAD
import 'package:gude_app/features/marketplace/presentation/messaging_inbox_page.dart';
=======
import 'package:gude_app/features/buyer/presentation/buyer_profile_page.dart';
>>>>>>> d0cd6e66942206947b6fcc5a1fb5accfe43c2ece
import 'package:gude_app/shared/widgets/bottom_nav_shell.dart';
import 'package:gude_app/features/wallet/presentation/screens/transactions_screen.dart';

// ── Buyer onboarding screens ────────────────────────
import 'package:gude_app/features/auth/presentation/buyer_onboarding_welcome_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // ── Auth & onboarding ──────────────────────────────────
      GoRoute(path: '/splash', builder: (c, s) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
      GoRoute(path: '/signup', builder: (c, s) => const SignupPage()),
      GoRoute(
          path: '/forgot-password',
          builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/skills', builder: (c, s) => const SkillsSelectionPage()),
      GoRoute(
          path: '/verify-student',
          builder: (c, s) => const StudentVerificationPage()),

      // ── Buyer onboarding flow ──────────────────────────────
      GoRoute(
          path: '/buyer-onboarding/welcome',
          builder: (c, s) => const BuyerOnboardingWelcomePage()),
      GoRoute(
          path: '/buyer-onboarding/type',
          builder: (c, s) => const BuyerTypePage()),
      GoRoute(
          path: '/buyer-onboarding/interests',
          builder: (c, s) =>
              BuyerInterestsPage(extra: s.extra as Map<String, dynamic>?)),
      GoRoute(
          path: '/buyer-onboarding/profile',
          builder: (c, s) =>
              BuyerProfileSetupPage(extra: s.extra as Map<String, dynamic>?)),
      GoRoute(
          path: '/buyer-onboarding/complete',
          builder: (c, s) => const BuyerOnboardingCompletePage()),

      // ── Marketplace (outside shell) ────────────────────────
      GoRoute(
          path: '/marketplace/create',
          builder: (c, s) => const CreateListingPage()),
      GoRoute(
          path: '/marketplace/jobs',
          builder: (c, s) => const JobDashboardPage()),
      GoRoute(
          path: '/marketplace/listing',
          builder: (c, s) {
            final listing = s.extra as Map<String, String>? ??
                {
                  'name': 'Student',
                  'title': 'Service',
                  'university': 'UCT',
                  'price': 'R150/hr',
                  'rating': '4.9',
                  'jobs': '10'
                };
            return ListingDetailPage(listing: listing);
          }),
      GoRoute(
          path: '/marketplace/hire',
          builder: (c, s) {
            final listing = s.extra as Map<String, String>? ??
                {
                  'name': 'Student',
                  'title': 'Service',
                  'university': 'UCT',
                  'price': 'R150/hr',
                  'rating': '4.9',
                  'jobs': '10'
                };
            return HireStudentPage(listing: listing);
          }),

      // ── Wallet sub-screens (outside shell) ────────────────
      GoRoute(
          path: '/wallet/budget', builder: (c, s) => const BudgetPlannerPage()),
      GoRoute(
          path: '/wallet/savings', builder: (c, s) => const SavingsGoalsPage()),
      GoRoute(
          path: '/wallet/send', builder: (_, __) => const SendMoneyScreen()),
      GoRoute(
          path: '/wallet/withdraw', builder: (_, __) => const WithdrawScreen()),
      GoRoute(
          path: '/wallet/transactions',
          builder: (_, __) => const TransactionsScreen()),

      // ── Stability (outside shell) ──────────────────────────
      GoRoute(
          path: '/stability/checkin',
          builder: (c, s) => const WeeklyCheckinPage()),

      // ══════════════════════════════════════════════════════
      // STUDENT shell — full 6-tab nav
      // ══════════════════════════════════════════════════════
      ShellRoute(
        builder: (context, state, child) =>
            BottomNavShell(child: child, isBuyer: false),
        routes: [
<<<<<<< HEAD
          GoRoute(path: '/home',        builder: (c, s) => const HomePage()),
          GoRoute(path: '/marketplace', builder: (c, s) => const MarketplacePage()),
          GoRoute(path: '/wallet',      builder: (c, s) => const WalletPage()),
          GoRoute(path: '/messages',    builder: (c, s) => const MessagingInboxPage()),
          GoRoute(path: '/support',     builder: (c, s) => const SupportPage()),
          GoRoute(path: '/stability',   builder: (c, s) => const StabilityPage()),
          GoRoute(path: '/profile',     builder: (c, s) => const ProfilePage()),
=======
          GoRoute(path: '/home', builder: (c, s) => const HomePage()),
          GoRoute(
              path: '/marketplace', builder: (c, s) => const MarketplacePage()),
          GoRoute(path: '/wallet', builder: (c, s) => const WalletPage()),
          GoRoute(path: '/support', builder: (c, s) => const SupportPage()),
          GoRoute(path: '/stability', builder: (c, s) => const StabilityPage()),
          GoRoute(path: '/profile', builder: (c, s) => const ProfilePage()),
        ],
      ),

      // ══════════════════════════════════════════════════════
      // BUYER shell — Marketplace + Profile only
      // Entry point: context.go('/buyer/marketplace')
      // ══════════════════════════════════════════════════════
      ShellRoute(
        builder: (context, state, child) =>
            BottomNavShell(child: child, isBuyer: true),
        routes: [
          GoRoute(
              path: '/buyer/marketplace',
              builder: (c, s) => const MarketplacePage()),
          GoRoute(
              path: '/buyer/profile',
              builder: (_, __) => const BuyerProfilePage()),
>>>>>>> d0cd6e66942206947b6fcc5a1fb5accfe43c2ece
        ],
      ),
    ],
  );
}
