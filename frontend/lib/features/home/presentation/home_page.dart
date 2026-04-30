// lib/features/home/presentation/home_page.dart
// Home Dashboard — matches PDF section 2.2 exactly.
// Balance Card · Risk Indicator · AI Coach Message · Quick Actions · Streak Tracker
// Also includes inline Add-Expense modal (PDF 2.4) and challenge banners (PDF last page).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

// ── Additional colours not in core theme ───────────────────
class _ExtraColors {
  static const green  = Color(0xFF10B981);
  static const amber  = Color(0xFFF59E0B);
  static const blue   = Color(0xFF3B82F6);
  static const purple = Color(0xFF8B5CF6);
}

// ── Expense categories (for Add-Expense modal) ───────────────
const _expenseCategories = [
  ('Food',          Icons.restaurant_menu_outlined,  AppColors.primary),
  ('Transport',     Icons.directions_bus_outlined,   _ExtraColors.blue),
  ('Data/Airtime',  Icons.wifi_outlined,             _ExtraColors.purple),
  ('Entertainment', Icons.sports_esports_outlined,   _ExtraColors.amber),
  ('Textbooks',     Icons.menu_book_outlined,        _ExtraColors.green),
  ('Other',         Icons.more_horiz_outlined,       AppColors.textGrey),
];

// ── Quick actions (PDF 2.2 §4) ───────────────────────────────
class _QAData {
  final IconData icon;
  final String label;
  final Color color;
  final String? route;
  const _QAData(this.icon, this.label, this.color, [this.route]);
}

final _quickActions = [
  _QAData(Icons.add_circle_outline, 'Log Expense', AppColors.primary),
  _QAData(Icons.pie_chart_outline,  'View Budget', _ExtraColors.blue,  '/wallet/budget'),
  _QAData(Icons.savings_outlined,   'Save Money',  _ExtraColors.green, '/wallet/savings'),
  _QAData(Icons.account_balance_wallet_outlined, 'Wallet', AppColors.textDark, '/wallet'),
  _QAData(Icons.smart_toy_outlined, 'Coach',      _ExtraColors.purple, '/coach/chat'),
  _QAData(Icons.emoji_events_outlined, 'Rewards', _ExtraColors.amber, '/rewards'),
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
  // ── State ────────────────────────────────────────────────
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
      ? _ExtraColors.green
      : _riskScore < 65
          ? _ExtraColors.amber
          : AppColors.primary;

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

  // Coach messages (rotate based on day)
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

  // ── Add Expense ─────────────────────────────────────────
  void _showAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddExpenseSheet(
        onSave: (amount, category, note) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Expense logged: R${amount.toStringAsFixed(2)} on $category'),
              backgroundColor: _ExtraColors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          // ── App bar ───────────────────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            title: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                    child: Text('G',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            fontSize: 18))),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Good morning, 👋',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey,
                          fontWeight: FontWeight.w500)),
                  Text('Thabo',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
                ],
              ),
            ]),
            actions: [
              // Streak badge
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _ExtraColors.amber.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  const Text('🔥', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text('$_streak',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _ExtraColors.amber)),
                ]),
              ),
              // Profile button (added)
              IconButton(
                icon: const Icon(Icons.person_outline, color: AppColors.textDark),
                onPressed: () => context.push('/profile'),
              ),
              // Notifications button
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark),
                onPressed: () => context.push('/notifications'),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [

                // ── 1. Balance Card ───────────────────────────
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

                // ── Challenge banners (PDF last page) ─────────
                _ChallengeBanner(
                  onTap: () => context.push('/challenges'),
                ),

                const SizedBox(height: 14),

                // ── 4. Quick Actions ──────────────────────────
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Quick Actions',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark)),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showAddExpense,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Balance Card — "You have R1,250 left • 12 days left"
// ════════════════════════════════════════════════════════════
class _BalanceCard extends StatelessWidget {
  final double balance, spent, budget;
  final int daysLeft;
  final bool visible;
  final VoidCallback onToggle;

  const _BalanceCard({
    required this.balance,
    required this.daysLeft,
    required this.visible,
    required this.onToggle,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (spent / budget).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE30613), Color(0xFFB0000E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFE30613).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30, right: -20,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Available Balance',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      visible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white60,
                      size: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                visible
                    ? 'R ${balance.toStringAsFixed(2)}'
                    : 'R ••••••',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⏳  $daysLeft days left this month',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 6,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Spent: R${spent.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11)),
                  Text('Budget: R${budget.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11)),
                ],
              ),
            ],
          ),
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

  const _RiskCard(
      {required this.score,
      required this.color,
      required this.label,
      required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.shield_outlined, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Financial Risk',
                style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
            Text(label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color)),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
            child: Text('${score.toInt()}/100',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color)),
          ),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 7,
            backgroundColor: AppColors.inputBorder,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 8),
        Text(detail,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textGrey, height: 1.4)),
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

  const _CoachMessageCard(
      {required this.message,
      required this.onRefresh,
      required this.onOpenChat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gude Coach',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
            Text('AI Financial Insight',
                style: TextStyle(color: Colors.white54, fontSize: 10)),
          ]),
          const Spacer(),
          GestureDetector(
            onTap: onRefresh,
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.refresh_rounded,
                  color: Colors.white60, size: 16),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text(message,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onOpenChat,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('Chat with Coach',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 14),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Challenge Banners (PDF last page)
// ════════════════════════════════════════════════════════════
class _ChallengeBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _ChallengeBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Active Challenges',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDark)),
        const SizedBox(height: 10),
        _ChallengeCard(
          emoji: '💰',
          title: 'Survive till Month-End',
          subtitle: '12 days left — R1,250 remaining',
          color: AppColors.primary,
          onTap: onTap,
        ),
        const SizedBox(height: 10),
        _ChallengeCard(
          emoji: '🚀',
          title: 'R0 to R500 Savings',
          subtitle: 'You\'ve saved R190 — 38% done!',
          color: _ExtraColors.green,
          onTap: onTap,
        ),
        const SizedBox(height: 10),
        _ChallengeCard(
          emoji: '⏳',
          title: 'NSFAS Delay Survival Plan',
          subtitle: 'Tap to activate emergency budget mode',
          color: _ExtraColors.amber,
          onTap: onTap,
        ),
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String emoji, title, subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ChallengeCard(
      {required this.emoji,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04), blurRadius: 6)
          ],
        ),
        child: Row(children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textGrey)),
                ]),
          ),
          Icon(Icons.chevron_right_rounded, color: color, size: 20),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Quick Action Tile
// ════════════════════════════════════════════════════════════
class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 7),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Streak Tracker (PDF §5)
// ════════════════════════════════════════════════════════════
class _StreakCard extends StatelessWidget {
  final int streak;
  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🔥', style: TextStyle(fontSize: 22)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Tracking Streak',
                style: TextStyle(fontSize: 11, color: AppColors.textGrey)),
            Text('$streak-day tracking streak 💸',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark)),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _ExtraColors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('+${streak * 10} pts',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _ExtraColors.amber)),
          ),
        ]),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (i) {
            final active = i < streak;
            return Column(children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(
                  color: active
                      ? _ExtraColors.amber.withOpacity(0.12)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: active
                          ? _ExtraColors.amber.withOpacity(0.5)
                          : AppColors.inputBorder),
                ),
                child: Center(
                  child: active
                      ? const Text('🔥',
                          style: TextStyle(fontSize: 16))
                      : Icon(Icons.circle_outlined,
                          size: 14, color: AppColors.textGrey.withOpacity(0.4)),
                ),
              ),
              const SizedBox(height: 4),
              Text(days[i],
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: active ? _ExtraColors.amber : AppColors.textGrey)),
            ]);
          }),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Add Expense Modal (PDF 2.4)
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
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Handle
        Center(
          child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(2)),
          ),
        ),
        const SizedBox(height: 16),

        const Text('Log Expense',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark)),
        const SizedBox(height: 20),

        // Amount field
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: TextField(
            controller: _amountCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark),
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixText: 'R  ',
              prefixStyle: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textGrey),
              hintText: 'Amount',
              hintStyle: TextStyle(color: Color(0xFFCCCCCC), fontSize: 20),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Category dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _category,
              isExpanded: true,
              icon: const Icon(Icons.expand_more, color: AppColors.textGrey),
              items: _expenseCategories.map((c) {
                final (label, icon, color) = c;
                return DropdownMenuItem(
                  value: label,
                  child: Row(children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 10),
                    Text(label,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                  ]),
                );
              }).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Note field (optional)
        TextField(
          controller: _noteCtrl,
          decoration: InputDecoration(
            hintText: 'Note (optional)',
            hintStyle: const TextStyle(color: AppColors.textGrey, fontSize: 13),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 14),
          ),
        ),
        const SizedBox(height: 20),

        // Save button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              final amount =
                  double.tryParse(_amountCtrl.text.trim()) ?? 0;
              if (amount <= 0) return;
              widget.onSave(amount, _category, _noteCtrl.text.trim());
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Save',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ]),
    );
  }
}