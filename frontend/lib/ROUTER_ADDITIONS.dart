// ════════════════════════════════════════════════════════════════════════════
// ADD THESE IMPORTS to the top of lib/navigation/app_router.dart
// ════════════════════════════════════════════════════════════════════════════

import '../features/auth/presentation/screens/skills_selection_screen.dart';
import '../features/auth/presentation/screens/profile_setup_screen.dart';
import '../features/home/presentation/screens/home_shell.dart';
import '../features/wallet/presentation/screens/wallet_screen.dart';
import '../features/wallet/presentation/screens/transactions_screen.dart';
import '../features/wallet/presentation/screens/budget_planner_screen.dart';
import '../features/wallet/presentation/screens/savings_goals_screen.dart';
import '../features/wallet/presentation/screens/send_money_screen.dart';
import '../features/wallet/presentation/screens/withdraw_screen.dart';


// ════════════════════════════════════════════════════════════════════════════
// ADD THESE ROUTES inside your GoRouter routes: [ ... ] list
// ════════════════════════════════════════════════════════════════════════════

    // ── Student onboarding (post-signup) ──────────────────
    GoRoute(
      path: '/onboarding/skills',
      builder: (_, __) => const SkillsSelectionScreen(),
    ),
    GoRoute(
      path: '/onboarding/profile',
      builder: (_, __) => const ProfileSetupScreen(),
    ),

    // ── Main shell with bottom nav ─────────────────────────
    GoRoute(
      path: '/home',
      builder: (_, __) => const HomeShell(),
    ),

    // ── Wallet sub-screens ─────────────────────────────────
    GoRoute(
      path: '/wallet/transactions',
      builder: (_, __) => const TransactionsScreen(),
    ),
    GoRoute(
      path: '/wallet/budget',
      builder: (_, __) => const BudgetPlannerScreen(),
    ),
    GoRoute(
      path: '/wallet/savings',
      builder: (_, __) => const SavingsGoalsScreen(),
    ),
      GoRoute(
      path: '/wallet/send',
      builder: (_, __) => const SendMoneyScreen(),
    ),
      GoRoute(
      path: '/wallet/withdraw',
      builder: (_, __) => const WithdrawMoneyScreen(),
    ),

// ════════════════════════════════════════════════════════════════════════════
// ALSO: In whichever screen currently navigates to '/home' after onboarding
// (likely capture_banking_screen.dart or student_verify_screen.dart),
// change:
//   context.go('/home');
// to:
//   context.go('/onboarding/skills');
// ════════════════════════════════════════════════════════════════════════════
