// lib/features/home/presentation/home_page.dart
// Home Dashboard — merged design:
// - Newer layout: Balance Card, Risk Indicator, Coach Message, Quick Actions (only 2: View Budget, Save Money), Streak Tracker, Challenges
// - App bar with avatar dropdown (Profile, Support, Settings, Logout) and Notifications icon
// - Expanding FAB: Notice Board, Chats, AI Buddy
// - Greeting uses real user name from UserRoleService

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/core/state/financial_health.dart';
import 'package:gude_app/services/user_role_service.dart';
import 'package:gude_app/features/chatbot/presentation/ai_coach_overlay.dart';
import 'package:gude_app/features/chatbot/services/ai_coach_service.dart';

// ── Colours (new style) ─────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
  static const amber     = Color(0xFFF59E0B);
  static const blue      = Color(0xFF3B82F6);
}

// ── Expense categories (for Add-Expense modal) – kept for completeness ──
const _expenseCategories = [
  ('Food',          Icons.restaurant_menu_outlined,  Color(0xFFE30613)),
  ('Transport',     Icons.directions_bus_outlined,   Color(0xFF3B82F6)),
  ('Data/Airtime',  Icons.wifi_outlined,             Color(0xFF8B5CF6)),
  ('Entertainment', Icons.sports_esports_outlined,   Color(0xFFF59E0B)),
  ('Textbooks',     Icons.menu_book_outlined,        Color(0xFF10B981)),
  ('Other',         Icons.more_horiz_outlined,       Color(0xFF888888)),
];

// ── Quick actions (only View Budget and Save Money – Log Expense removed) ──
class _QAData {
  final IconData icon;
  final String label;
  final Color color;
  final String? route;
  const _QAData(this.icon, this.label, this.color, [this.route]);
}

final _quickActions = [
  _QAData(Icons.add_circle_outline, 'Log Expense', _C.primary),
  _QAData(Icons.pie_chart_outline,  'View Budget', _C.blue,  '/wallet/budget'),
  _QAData(Icons.savings_outlined,   'Save Money',  _C.green, '/wallet/savings'),
];


// ════════════════════════════════════════════════════════════
//  HomePage
// ════════════════════════════════════════════════════════════
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── State from newer design ───────────────────────────────
  bool _balVisible = true;
  int  _streak     = 5;

  // Simulated data
  static const double _balance    = 1250.0;
  static const int    _daysLeft   = 12;
  static const double _budget     = 3000.0;
  static const double _spent      = 1830.0;

  // Risk: 0-100
  double get _riskScore {
    final pct = _spent / _budget;
    if (pct < 0.5)  return 20;
    if (pct < 0.75) return 55;
    return 85;
  }

  Color get _riskColor => _riskScore < 40
      ? _C.green
      : _riskScore < 65
          ? _C.amber
          : _C.primary;

  String get _riskLabel => _riskScore < 40
      ? 'On Track 🟢'
      : _riskScore < 65
          ? 'Careful 🟡'
          : 'High Risk 🔴';

  String get _riskDetail => _riskScore < 40
      ? "You're managing your money well. Keep it up!"
      : _riskScore < 65
          ? 'You\'ve used ${(_spent / _budget * 100).toInt()}% of your budget. Slow down.'
          : 'Danger zone! You\'re close to running out before month-end.';

  // Coach messages (rotate)
  final _coachMessages = [
    '💡 You spent R89 on food today. Try cooking once this week to save R150.',
    '📊 You\'re on track! R${(3000 - 1830).toInt()} budget remaining for the month.',
    '⚠️  Transport spending is 40% over budget. Consider Gautrain instead of Uber.',
    '🎯 Save R50 today to hit your Laptop goal 3 weeks earlier!',
    '🔥 5-day streak! Your financial discipline is paying off.',
  ];
  int _coachMsgIndex = 0;
  void _nextCoachMsg() =>
      setState(() => _coachMsgIndex = (_coachMsgIndex + 1) % _coachMessages.length);

  // ── State from older FAB ───────────────────────────────────
  bool _fabExpanded = false;

  // ── Add Expense (kept because it may be used elsewhere, but no UI button calls it now) ──
  void _showAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddExpenseSheet(
        onSave: (amount, category, note) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Expense logged: R${amount.toStringAsFixed(2)} on $category'),
              backgroundColor: _C.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  // ── Logout dialog (from older) ───────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        content: const Text('Are you sure you want to log out?', style: TextStyle(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF888888), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE30613),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              UserRoleService().clear();
              Navigator.pop(context);
              GoRouter.of(context).go('/login');
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Avatar dropdown menu (from older) ─────────────────────
  void _showAvatarMenu(BuildContext btnCtx) {
    final RenderBox button = btnCtx.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(btnCtx).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomLeft(Offset.zero), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<String>(
      context: btnCtx,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(children: const [
            Icon(Icons.person_outline_rounded, size: 18, color: Color(0xFF1A1A1A)),
            SizedBox(width: 10),
            Text('My Profile', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        ),
        PopupMenuItem<String>(
          value: 'support',
          child: Row(children: const [
            Icon(Icons.support_agent_outlined, size: 18, color: Color(0xFF1A1A1A)),
            SizedBox(width: 10),
            Text('Support Hub', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(children: const [
            Icon(Icons.settings_outlined, size: 18, color: Color(0xFF1A1A1A)),
            SizedBox(width: 10),
            Text('Settings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(children: const [
            Icon(Icons.logout_rounded, size: 18, color: Color(0xFFE30613)),
            SizedBox(width: 10),
            Text('Log Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFFE30613))),
          ]),
        ),
      ],
    ).then((val) {
      if (val == 'profile') context.push('/profile');
      if (val == 'support') context.push('/support');
      if (val == 'settings') context.push('/settings');
      if (val == 'logout') _showLogoutDialog();
    });
  }

  // ── Open AI Coach (from older) ────────────────────────────
  void _openAiCoach(CoachContext coachCtx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => _CoachSheetWrapper(coachContext: coachCtx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserRoleService();
    final userName = userService.userName.isNotEmpty
        ? userService.userName.split(' ').first
        : (userService.isInstitution && userService.institutionName.isNotEmpty
            ? userService.institutionName
            : 'there');
    final firstInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

    final coachCtx = CoachContext(
      walletBalance: FinancialHealth.income - FinancialHealth.totalSpent,
      monthlyBudget: FinancialHealth.monthlyBudget,
      totalSpent: FinancialHealth.totalSpent,
      income: FinancialHealth.income,
      stabilityScore: 62,
      stabilityLabel: 'Steady',
      marketplaceActivity: 3,
      missedCheckins: 2,
      page: 'home',
    );

    return Scaffold(
      backgroundColor: _C.lightGrey,
      floatingActionButton: _buildFabStack(coachCtx),
      body: CustomScrollView(
        slivers: [
          // ── App bar (older style with avatar dropdown) ─────
          SliverAppBar(
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Gude', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark),
                onPressed: () => context.push('/notifications'),
              ),
              // Avatar dropdown
              Builder(
                builder: (btnCtx) => GestureDetector(
                  onTap: () => _showAvatarMenu(btnCtx),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(firstInitial,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                        Positioned(
                          bottom: 0, right: 0,
                          child: Container(
                            width: 12, height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            child: const Icon(Icons.keyboard_arrow_down_rounded, size: 8, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // ── Greeting bar (dynamic name) ──
                _GreetingBar(userName: userName),

                const SizedBox(height: 14),

                // ── 1. Balance Card ─────────────────────────
                _BalanceCard(
                  balance: _balance,
                  daysLeft: _daysLeft,
                  visible: _balVisible,
                  onToggle: () => setState(() => _balVisible = !_balVisible),
                  spent: _spent,
                  budget: _budget,
                ),

                const SizedBox(height: 14),

                // ── 2. Risk Indicator ─────────────────────────
                _RiskCard(
                  score: _riskScore,
                  color: _riskColor,
                  label: _riskLabel,
                  detail: _riskDetail,
                ),

                const SizedBox(height: 14),

                // ── 3. AI Coach Message ───────────────────────
                _CoachMessageCard(
                  message: _coachMessages[_coachMsgIndex],
                  onRefresh: _nextCoachMsg,
                  onOpenChat: () => context.push('/coach/chat'),
                ),

                const SizedBox(height: 14),

                // ── Challenge banners (extra) ────────────────
                _ChallengeBanner(onTap: () => context.push('/challenges')),

                const SizedBox(height: 14),

                 // ── 4. Quick Actions (3 only) ─────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Quick Actions',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _C.dark)),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.05,
                  children: _quickActions.map((qa) {
                    return _QuickActionTile(
                      icon: qa.icon,
                      label: qa.label,
                      color: qa.color,
                      onTap: () {
                        if (qa.label == 'Log Expense') {
                          _showAddExpense();
                        } else if (qa.route != null) {
                          context.push(qa.route!);
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 14),

                // ── 5. Streak Tracker ─────────────────────────
                _StreakCard(streak: _streak),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }
  

  // ── Expanding FAB (Notice Board, Chats, AI Buddy) ─────────
  Widget _buildFabStack(CoachContext coachCtx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          _FloatingIcon(
            icon: Icons.campaign_rounded,
            label: 'Notice Board',
            color: const Color(0xFFF59E0B),
            onTap: () {
              setState(() => _fabExpanded = false);
              context.push('/noticeboard');
            },
          ),
          const SizedBox(height: 10),
          _FloatingIcon(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chats',
            color: const Color(0xFF3B82F6),
            onTap: () {
              setState(() => _fabExpanded = false);
              context.push('/community');
            },
          ),
          const SizedBox(height: 10),
          _FloatingIcon(
            icon: Icons.smart_toy_rounded,
            label: 'AI Buddy',
            color: const Color(0xFF10B981),
            onTap: () {
              setState(() => _fabExpanded = false);
              _openAiCoach(coachCtx);
            },
          ),
          const SizedBox(height: 10),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_fabExpanded)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                  ),
                ),
              ),
            GestureDetector(
              onTap: () => setState(() => _fabExpanded = !_fabExpanded),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: AnimatedRotation(
                  turns: _fabExpanded ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _fabExpanded ? Icons.close_rounded : Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Greeting bar
// ─────────────────────────────────────────────────────────────
class _GreetingBar extends StatelessWidget {
  final String userName;
  const _GreetingBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _C.dark),
              children: [
                const TextSpan(text: 'Good morning, 👋 '),
                TextSpan(text: userName, style: const TextStyle(color: _C.primary)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Balance Card
// ════════════════════════════════════════════════════════════
class _BalanceCard extends StatelessWidget {
  final double balance, spent, budget;
  final int daysLeft;
  final bool visible;
  final VoidCallback onToggle;
  const _BalanceCard({required this.balance, required this.daysLeft, required this.visible, required this.onToggle, required this.spent, required this.budget});

  @override
  Widget build(BuildContext context) {
    final pct = (spent / budget).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE30613), Color(0xFFB0000E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFFE30613).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(top: -30, right: -20, child: Container(width: 130, height: 130, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('You have', style: TextStyle(color: Colors.white70, fontSize: 12)),
              GestureDetector(onTap: onToggle, child: Icon(visible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.white60, size: 18)),
            ]),
            const SizedBox(height: 6),
            Text(visible ? 'R ${balance.toStringAsFixed(2)} left' : 'R •••••• left', style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1)),
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white30, borderRadius: BorderRadius.circular(20)), child: Text('⏳  $daysLeft days left this month', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
            const SizedBox(height: 16),
            ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: pct, minHeight: 6, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation<Color>(Colors.white))),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Spent: R${spent.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              Text('Budget: R${budget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ]),
          ]),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Risk Indicator
// ════════════════════════════════════════════════════════════
class _RiskCard extends StatelessWidget {
  final double score;
  final Color color;
  final String label, detail;
  const _RiskCard({required this.score, required this.color, required this.label, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.35), width: 1.5), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.shield_outlined, color: color, size: 20)),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Financial Risk', style: TextStyle(fontSize: 11, color: _C.grey)), Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color))]),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('${score.toInt()}/100', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color))),
        ]),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: score / 100, minHeight: 7, backgroundColor: _C.border, valueColor: AlwaysStoppedAnimation(color))),
        const SizedBox(height: 8),
        Text(detail, style: const TextStyle(fontSize: 12, color: _C.grey)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  AI Coach Message
// ════════════════════════════════════════════════════════════
class _CoachMessageCard extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh, onOpenChat;
  const _CoachMessageCard({required this.message, required this.onRefresh, required this.onOpenChat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)]), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18)))),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gude Coach', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
            Text('AI Financial Insight', style: TextStyle(color: Colors.white54, fontSize: 10)),
          ]),
          const Spacer(),
          GestureDetector(onTap: onRefresh, child: Container(width: 32, height: 32, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.refresh_rounded, color: Colors.white60, size: 16))),
        ]),
        const SizedBox(height: 12),
        Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onOpenChat,
          child: Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(10)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Text('Chat with Coach', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)), SizedBox(width: 4), Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 14)])),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Challenge Banners
// ════════════════════════════════════════════════════════════
class _ChallengeBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _ChallengeBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Active Challenges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _C.dark)),
        const SizedBox(height: 10),
        _ChallengeCard(emoji: '💰', title: 'Survive till Month-End', subtitle: '12 days left — R1,250 remaining', color: _C.primary, onTap: onTap),
        const SizedBox(height: 10),
        _ChallengeCard(emoji: '🚀', title: 'R0 to R500 Savings', subtitle: 'You\'ve saved R190 — 38% done!', color: _C.green, onTap: onTap),
        const SizedBox(height: 10),
        _ChallengeCard(emoji: '⏳', title: 'NSFAS Delay Survival Plan', subtitle: 'Tap to activate emergency budget mode', color: _C.amber, onTap: onTap),
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ChallengeCard({required this.emoji, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.3)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
        child: Row(children: [
          Container(width: 42, height: 42, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(fontSize: 11, color: _C.grey))])),
          Icon(Icons.chevron_right_rounded, color: color, size: 20),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Quick Action Tile (reused for both actions)
// ════════════════════════════════════════════════════════════
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickActionTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
          const SizedBox(height: 7),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _C.dark), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Streak Tracker
// ════════════════════════════════════════════════════════════
class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🔥', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tracking Streak', style: TextStyle(fontSize: 11, color: _C.grey)),
            Text('$streak-day tracking streak 💸', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _C.dark)),
          ]),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: _C.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text('+${streak * 10} pts', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _C.amber))),
        ]),
        const SizedBox(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(7, (i) {
          final active = i < streak;
          return Column(children: [
            Container(width: 34, height: 34, decoration: BoxDecoration(color: active ? _C.amber.withOpacity(0.12) : _C.lightGrey, borderRadius: BorderRadius.circular(10), border: Border.all(color: active ? _C.amber.withOpacity(0.5) : _C.border)), child: Center(child: active ? const Text('🔥', style: TextStyle(fontSize: 16)) : Icon(Icons.circle_outlined, size: 14, color: _C.grey.withOpacity(0.4)))),
            const SizedBox(height: 4),
            Text(days[i], style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: active ? _C.amber : _C.grey)),
          ]);
        })),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Add Expense Modal (kept but not exposed via UI)
// ════════════════════════════════════════════════════════════
class _AddExpenseSheet extends StatefulWidget {
  final void Function(double amount, String category, String note) onSave;
  const _AddExpenseSheet({required this.onSave});
  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();
  String _category  = 'Food';
  @override
  void dispose() { _amountCtrl.dispose(); _noteCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: _C.border, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 16),
        const Text('Log Expense', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _C.dark)),
        const SizedBox(height: 20),
        Container(decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)), child: TextField(controller: _amountCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _C.dark), decoration: const InputDecoration(border: InputBorder.none, prefixText: 'R  ', prefixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: _C.grey), hintText: 'Amount', hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 20), contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14)))),
        const SizedBox(height: 12),
        Container(padding: const EdgeInsets.symmetric(horizontal: 14), decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _category, isExpanded: true, icon: const Icon(Icons.expand_more, color: _C.grey), items: _expenseCategories.map((c) { final (label, icon, color) = c; return DropdownMenuItem(value: label, child: Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 10), Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _C.dark))])); }).toList(), onChanged: (v) => setState(() => _category = v!)))),
        const SizedBox(height: 12),
        TextField(controller: _noteCtrl, decoration: InputDecoration(hintText: 'Note (optional)', hintStyle: const TextStyle(color: _C.grey, fontSize: 13), filled: true, fillColor: _C.lightGrey, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border)), contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14))),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0; if (amount <= 0) return; widget.onSave(amount, _category, _noteCtrl.text.trim()); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: _C.dark, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), child: const Text('Save', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Helper widgets for FAB
// ─────────────────────────────────────────────────────────────
class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _FloatingIcon({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 2))]), child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
        const SizedBox(width: 8),
        GestureDetector(onTap: onTap, child: Container(width: 46, height: 46, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 3))]), child: Icon(icon, color: Colors.white, size: 22))),
      ],
    );
  }
}

class _CoachSheetWrapper extends StatelessWidget {
  final CoachContext coachContext;
  const _CoachSheetWrapper({required this.coachContext});
  @override
  Widget build(BuildContext context) => AiCoachFab(context: coachContext);
}