class AppRoutes {
  AppRoutes._();

  // ── Auth ────────────────────────────────────────────
  static const String splash          = '/';
  static const String onboarding      = '/onboarding';
  static const String login           = '/login';
  static const String signup          = '/signup';
  static const String forgotPassword  = '/forgot-password';
  static const String verifyEmail     = '/verify-email';
  static const String studentVerify   = '/student-verify';
  static const String captureBanking  = '/capture-banking';
  static const String congratulations = '/congratulations';

  // ── Main ────────────────────────────────────────────
  static const String home            = '/home';
  static const String marketplace     = '/marketplace';
  static const String wallet          = '/wallet';
  static const String stability       = '/stability';
  static const String profile         = '/profile';

  // ── Marketplace ─────────────────────────────────────
  static const String listingDetail   = '/marketplace/listing/:id';
  static const String createListing   = '/marketplace/create';
  static const String jobDashboard    = '/marketplace/jobs';

  // ── Wallet ──────────────────────────────────────────
  static const String transactions    = '/wallet/transactions';
  static const String budgetPlanner   = '/wallet/budget';
  static const String savingsGoals    = '/wallet/savings';

  // ── Stability ───────────────────────────────────────
  static const String weeklyCheckIn   = '/stability/checkin';
  static const String supportHub      = '/stability/support';
}
