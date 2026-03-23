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
import 'package:gude_app/features/stability/presentation/stability_page.dart';
import 'package:gude_app/features/stability/presentation/weekly_checkin_page.dart';
import 'package:gude_app/features/support_hub/presentation/support_page.dart';
import 'package:gude_app/features/home/presentation/home_page.dart';
import 'package:gude_app/features/profile/presentation/profile_page.dart';
import 'package:gude_app/shared/widgets/bottom_nav_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
      GoRoute(path: '/signup', builder: (c, s) => const SignupPage()),
      GoRoute(path: '/forgot-password', builder: (c, s) => const ForgotPasswordPage()),
      GoRoute(path: '/skills', builder: (c, s) => const SkillsSelectionPage()),
      GoRoute(path: '/verify-student', builder: (c, s) => const StudentVerificationPage()),
      GoRoute(path: '/marketplace/create', builder: (c, s) => const CreateListingPage()),
      GoRoute(path: '/marketplace/jobs', builder: (c, s) => const JobDashboardPage()),
      GoRoute(path: '/marketplace/listing', builder: (c, s) {
        final listing = s.extra as Map<String, String>? ?? {'name': 'Student', 'title': 'Service', 'university': 'UCT', 'price': 'R150/hr', 'rating': '4.9', 'jobs': '10'};
        return ListingDetailPage(listing: listing);
      }),
      GoRoute(path: '/marketplace/hire', builder: (c, s) {
        final listing = s.extra as Map<String, String>? ?? {'name': 'Student', 'title': 'Service', 'university': 'UCT', 'price': 'R150/hr', 'rating': '4.9', 'jobs': '10'};
        return HireStudentPage(listing: listing);
      }),
      GoRoute(path: '/wallet/budget', builder: (c, s) => const BudgetPlannerPage()),
      GoRoute(path: '/wallet/savings', builder: (c, s) => const SavingsGoalsPage()),
      GoRoute(path: '/stability/checkin', builder: (c, s) => const WeeklyCheckinPage()),
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomePage()),
          GoRoute(path: '/marketplace', builder: (c, s) => const MarketplacePage()),
          GoRoute(path: '/wallet', builder: (c, s) => const WalletPage()),
          GoRoute(path: '/support', builder: (c, s) => const SupportPage()),
          GoRoute(path: '/stability', builder: (c, s) => const StabilityPage()),
          GoRoute(path: '/profile', builder: (c, s) => const ProfilePage()),
        ],
      ),
    ],
  );
}
