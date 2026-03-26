// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';

// Auth
import 'package:gude_app/features/auth/presentation/splash_page.dart';
import 'package:gude_app/features/auth/presentation/onboarding_page.dart';
import 'package:gude_app/features/auth/presentation/login_page.dart';
import 'package:gude_app/features/auth/presentation/signup_page.dart';
import 'package:gude_app/features/auth/presentation/forgot_password_page.dart';
import 'package:gude_app/features/auth/presentation/skills_selection_page.dart';
import 'package:gude_app/features/auth/presentation/student_verification_page.dart';

// Buyer onboarding (assuming these pages exist)
import 'package:gude_app/features/auth/presentation/buyer_onboarding_welcome_page.dart';
import 'package:gude_app/features/auth/presentation/buyer_type_page.dart';           // add if missing
import 'package:gude_app/features/auth/presentation/buyer_interests_page.dart';     // add if missing
import 'package:gude_app/features/auth/presentation/buyer_profile_setup_page.dart'; // add if missing
import 'package:gude_app/features/auth/presentation/buyer_onboarding_complete_page.dart';

// Marketplace
import 'package:gude_app/features/marketplace/presentation/marketplace_page.dart';
import 'package:gude_app/features/marketplace/presentation/listing_detail_page.dart';
import 'package:gude_app/features/marketplace/presentation/create_listing_page.dart';
import 'package:gude_app/features/marketplace/presentation/hire_student_page.dart';
import 'package:gude_app/features/marketplace/presentation/job_dashboard_page.dart';

// Full pages - use prefixes to avoid conflicts
import 'package:gude_app/features/marketplace/presentation/notifications_page.dart' as notifications;
import 'package:gude_app/features/marketplace/presentation/wishlist_page.dart' as wishlist;

// Wallet
import 'package:gude_app/features/wallet/presentation/wallet_page.dart';
import 'package:gude_app/features/wallet/presentation/wallet_pockets_page.dart';
import 'package:gude_app/features/wallet/presentation/budget_planner_page.dart';
import 'package:gude_app/features/wallet/presentation/savings_goals_page.dart';
import 'package:gude_app/features/wallet/presentation/screens/send_money_screen.dart';
import 'package:gude_app/features/wallet/presentation/screens/withdraw_screen.dart';
import 'package:gude_app/features/wallet/presentation/screens/received_money_screen.dart'; // assume exists

// Other
import 'package:gude_app/features/stability/presentation/stability_page.dart';
import 'package:gude_app/features/stability/presentation/weekly_checkin_page.dart';
import 'package:gude_app/features/support_hub/presentation/support_page.dart';
import 'package:gude_app/features/home/presentation/home_page.dart';
import 'package:gude_app/features/profile/presentation/profile_page.dart';
import 'package:gude_app/features/messaging/presentation/messaging_inbox_page.dart';
import 'package:gude_app/features/community/presentation/community_chat_page.dart';

// Buyer
import 'package:gude_app/features/buyer/presentation/buyer_profile_page.dart';
import 'package:gude_app/features/buyer/presentation/buyer_messages_page.dart';
import 'package:gude_app/shared/widgets/bottom_nav_shell.dart';
import 'package:gude_app/shared/widgets/buyer_nav_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Auth
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupPage()),
      GoRoute(path: '/forgot-password', builder: (_, __) => const ForgotPasswordPage()),
      GoRoute(path: '/skills', builder: (_, __) => const SkillsSelectionPage()),
      GoRoute(path: '/verify-student', builder: (_, __) => const StudentVerificationPage()),

      // Buyer Onboarding
      GoRoute(path: '/buyer-onboarding/welcome', builder: (_, __) => const BuyerOnboardingWelcomePage()),
      GoRoute(path: '/buyer-onboarding/type', builder: (_, __) => const BuyerTypePage()),
      GoRoute(path: '/buyer-onboarding/interests', builder: (_, s) => BuyerInterestsPage(extra: s.extra)),
      GoRoute(path: '/buyer-onboarding/profile', builder: (_, s) => BuyerProfileSetupPage(extra: s.extra)),
      GoRoute(path: '/buyer-onboarding/complete', builder: (_, __) => const BuyerOnboardingCompletePage()),

      // Marketplace full pages
      GoRoute(path: '/marketplace/create', builder: (_, __) => const CreateListingPage()),
      GoRoute(path: '/marketplace/jobs', builder: (_, __) => const JobDashboardPage()),
      GoRoute(path: '/marketplace/listing', builder: (_, s) => ListingDetailPage(listing: s.extra as Map? ?? {})),
      GoRoute(path: '/marketplace/hire', builder: (_, s) => HireStudentPage(listing: s.extra as Map? ?? {})),

      GoRoute(path: '/notifications', builder: (_, __) => const notifications.NotificationsPage()),
      GoRoute(path: '/wishlist', builder: (_, __) => const wishlist.WishlistPage()),

      // Wallet
      GoRoute(path: '/wallet/budget', builder: (_, __) => const BudgetPlannerPage()),
      GoRoute(path: '/wallet/savings', builder: (_, __) => const SavingsGoalsPage()),
      GoRoute(path: '/wallet/send', builder: (_, __) => const SendMoneyScreen()),
      GoRoute(path: '/wallet/withdraw', builder: (_, __) => const WithdrawScreen()),
      GoRoute(path: '/wallet/received', builder: (_, __) => const ReceivedMoneyScreen()),
      GoRoute(
        path: '/wallet/pockets',
        builder: (_, s) => WalletPocketsPage(initialIndex: (s.extra as Map?)?['index'] ?? 0),
      ),

      GoRoute(path: '/stability/checkin', builder: (_, __) => const WeeklyCheckinPage()),

      // Student Shell
      ShellRoute(
        builder: (_, __, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(path: '/marketplace', builder: (_, __) => const MarketplacePage()),
          GoRoute(path: '/wallet', builder: (_, __) => const WalletPage()),
          GoRoute(path: '/messages', builder: (_, __) => const MessagingInboxPage()),
          GoRoute(path: '/community', builder: (_, __) => const CommunityChatPage()),
          GoRoute(path: '/support', builder: (_, __) => const SupportPage()),
          GoRoute(path: '/stability', builder: (_, __) => const StabilityPage()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        ],
      ),

      // Buyer Shell
      ShellRoute(
        builder: (_, __, child) => BuyerNavShell(child: child),
        routes: [
          GoRoute(path: '/buyer/marketplace', builder: (_, __) => const MarketplacePage()),
          GoRoute(path: '/buyer/messages', builder: (_, __) => const BuyerMessagesPage()),
          GoRoute(path: '/buyer/profile', builder: (_, __) => const BuyerProfilePage()),
        ],
      ),
    ],
  );
}