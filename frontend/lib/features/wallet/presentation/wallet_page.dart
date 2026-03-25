import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/core/state/financial_health.dart';

// ─────────────────────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
  static const amber     = Color(0xFFF59E0B);
}

// ─────────────────────────────────────────────────────────────
// WALLET PAGE
// ─────────────────────────────────────────────────────────────
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _balanceVisible = true;

  double get _monthlyBudget => FinancialHealth.monthlyBudget;
  double get _totalSpent    => FinancialHealth.totalSpent;
  double get _income        => FinancialHealth.income;
  double get _healthScore   => FinancialHealth.score;

  Color  get _healthColor => Color(FinancialHealth.colorValue);
  String get _healthLabel => FinancialHealth.label;
  String get _healthEmoji => FinancialHealth.emoji;

  final List<_SpendingCategory> _categories = [
    _SpendingCategory('Food',          650, 500, const Color(0xFF10B981), Icons.fastfood_outlined),
    _SpendingCategory('Transport',     420, 300, const Color(0xFF3B82F6), Icons.directions_bus_outlined),
    _SpendingCategory('Entertainment', 380, 150, const Color(0xFFF59E0B), Icons.sports_esports_outlined),
    _SpendingCategory('Data/Airtime',  180, 200, const Color(0xFF8B5CF6), Icons.wifi_outlined),
    _SpendingCategory('Textbooks',     150, 300, const Color(0xFFEC4899), Icons.book_outlined),
  ];

  final List<_Transaction> _transactions = [
    _Transaction('Tutoring Session — James', 150.00, true,  'Today, 10:30',     Icons.school_outlined),
    _Transaction('Withdrawal to FNB',        500.00, false, 'Today, 08:15',     Icons.arrow_upward_rounded),
    _Transaction('Design Work — Sipho',      300.00, true,  'Yesterday, 15:42', Icons.brush_outlined),
    _Transaction('Chicken Licken',            89.00, false, 'Yesterday, 13:10', Icons.fastfood_outlined),
    _Transaction('Photography Gig',          450.00, true,  'Mon, 09:00',       Icons.camera_alt_outlined),
    _Transaction('Uber',                      75.00, false, 'Mon, 07:30',       Icons.directions_car_outlined),
  ];

  final List<_Resource> _resources = [
    _Resource(title: 'The 50/30/20 Budget Rule',        source: 'National Credit Regulator', icon: Icons.pie_chart_outline,    tag: 'Budgeting'),
    _Resource(title: 'Make Your NSFAS Money Last',       source: 'MyBursary SA',              icon: Icons.savings_outlined,     tag: 'NSFAS Guide'),
    _Resource(title: 'Free Financial Literacy Course',   source: 'Coursera (Audit Free)',      icon: Icons.play_circle_outline,  tag: 'Free Course'),
    _Resource(title: 'Student Debt & Budgeting Toolkit', source: 'NSFAS Official',             icon: Icons.description_outlined, tag: 'Official'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Wallet',
              style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF1A1A1A)),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── REALISTIC CARD ────────────────────────
                _RealisticWalletCard(
                  balance: _income - _totalSpent,
                  income: _income,
                  spent: _totalSpent,
                  visible: _balanceVisible,
                  onToggle: () =>
                      setState(() => _balanceVisible = !_balanceVisible),
                ),

                // ── Financial health card ─────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: FinancialHealth.needsAlert
                        ? const Color(0xFFFFF1F1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _healthColor.withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(_healthEmoji,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Financial Health',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888))),
                              Text(_healthLabel,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: _healthColor)),
                            ]),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _healthColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_healthScore.toInt()}/100',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _healthColor),
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _healthScore / 100,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFEEEEEE),
                          valueColor: AlwaysStoppedAnimation(_healthColor),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Total spent: R${_totalSpent.toStringAsFixed(2)}   '
                        'Budget remaining: R${(_monthlyBudget - _totalSpent).abs().toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF888888)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You have used ${((_totalSpent / _monthlyBudget) * 100).toInt()}% of your budget.',
                        style: TextStyle(
                            fontSize: 12,
                            color: FinancialHealth.needsWarning
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF888888),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

                // ── Dropout risk / warning ────────────────
                if (FinancialHealth.needsAlert) ...[
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7F1D1D).withOpacity(0.07),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.5),
                          width: 1.5),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(children: [
                            Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFEF4444), size: 22),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '⚠️ Dropout Risk Detected',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFB91C1C)),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          const Text(
                            'Your spending patterns suggest financial stress that may put your studies at risk.',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7F1D1D),
                                height: 1.5),
                          ),
                          const SizedBox(height: 14),
                          const Text('📚 Free resources to help you:',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A))),
                          const SizedBox(height: 10),
                          ..._resources.map((r) => _ResourceTile(resource: r)),
                        ]),
                  ),
                ] else if (FinancialHealth.needsWarning) ...[
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3CD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: const Color(0xFFFFD700).withOpacity(0.5)),
                    ),
                    child: Row(children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFF59E0B), size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Spending habits need attention. Check your budget.',
                          style: TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/wallet/budget'),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap),
                        child: const Text('Fix →',
                            style: TextStyle(
                                color: Color(0xFFE30613),
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                      ),
                    ]),
                  ),
                ],

                // ── Quick actions ─────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuickAction(
                          icon: Icons.send_rounded,
                          label: 'Send',
                          onTap: () => context.push('/wallet/send')),
                      _QuickAction(
                          icon: Icons.call_received_rounded,
                          label: 'Received',
                          onTap: () => context.push('/wallet/received')),
                          icon: Icons.trending_up_rounded,
                          label: 'Profit',
                          onTap: () => _showProfitSheet(context)),
                      _QuickAction(
                          icon: Icons.account_balance_rounded,
                          label: 'Withdraw',
                          onTap: () => context.push('/wallet/withdraw')),
                      _QuickAction(
                          icon: Icons.pie_chart_outline_rounded,
                          label: 'Budget',
                          onTap: () => context.push('/wallet/budget')),
                      _QuickAction(
                          icon: Icons.savings_outlined,
                          label: 'Goals',
                          onTap: () => context.push('/wallet/savings')),
                    ],
                  ),
                ),

                // ── Pockets quick-view ────────────────────
                _PocketsQuickView(),

                // ── Spending by category ──────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 22, 16, 10),
                  child: Text('Spending by Category',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A))),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8),
                    ],
                  ),
                  child: Column(
                    children:
                        _categories.map((c) => _CategoryBar(cat: c)).toList(),
                  ),
                ),

                // ── Recent transactions ───────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Transactions',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A))),
                      GestureDetector(
                        onTap: () {},
                        child: const Text('See all',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8),
                    ],
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _transactions.length,
                    separatorBuilder: (_, __) => const Divider(
                        height: 1,
                        indent: 62,
                        endIndent: 16,
                        color: Color(0xFFF0F0F0)),
                    itemBuilder: (_, i) =>
                        _TransactionTile(tx: _transactions[i]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, sc) => Column(children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Text('My Profit',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A))),
          const SizedBox(height: 4),
          const Text('Earnings from completed gigs & marketplace sales',
              style:
                  TextStyle(fontSize: 12, color: Color(0xFF888888))),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Earned this month',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('R 900.00',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1)),
                      SizedBox(height: 8),
                      Text('3 gigs completed ✓',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ]),
              ),
              const Text('💸', style: TextStyle(fontSize: 42)),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _ProfitEntry(
                    title: 'Tutoring Session — James',
                    amount: 'R150.00',
                    date: 'Today'),
                _ProfitEntry(
                    title: 'Design Work — Sipho',
                    amount: 'R300.00',
                    date: 'Yesterday'),
                _ProfitEntry(
                    title: 'Photography Gig',
                    amount: 'R450.00',
                    date: 'Monday'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// REALISTIC WALLET CARD  (Gude-branded physical-style card)
// ─────────────────────────────────────────────────────────────
class _RealisticWalletCard extends StatelessWidget {
  final double balance, income, spent;
  final bool visible;
  final VoidCallback onToggle;

  const _RealisticWalletCard({
    required this.balance,
    required this.income,
    required this.spent,
    required this.visible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE30613), Color(0xFF8B000A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFE30613).withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────────────
          Positioned(
            top: -40, right: -30,
            child: Container(
              width: 160, height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -50, left: -20,
            child: Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // ── Card content ──────────────────────────────
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: logo + mastercard + eye
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Gude logo mark from assets
                    Row(children: [
                      Image.asset(
                        'assets/images/gude_logo.webp',
                        width: 30,
                        height: 30,
                        errorBuilder: (_, __, ___) => Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Center(
                            child: Text('G',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('GUDE',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              letterSpacing: 1)),
                    ]),
                    Row(children: [
                      // Visibility toggle
                      GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          visible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white70, size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Mastercard logo
                      Stack(children: [
                        Container(
                          width: 24, height: 24,
                          decoration: const BoxDecoration(
                              color: Color(0xFFEB001B),
                              shape: BoxShape.circle),
                        ),
                        Positioned(
                          left: 14,
                          child: Container(
                            width: 24, height: 24,
                            decoration: BoxDecoration(
                                color:
                                    const Color(0xFFF79E1B).withOpacity(0.9),
                                shape: BoxShape.circle),
                          ),
                        ),
                      ]),
                    ]),
                  ],
                ),

                const SizedBox(height: 10),

                // EMV chip
                Container(
                  width: 34, height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomPaint(painter: _ChipPainter()),
                ),

                const Spacer(),

                // Balance
                Text(
                  visible
                      ? 'R ${balance.toStringAsFixed(2)}'
                      : 'R ••••••',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8),
                ),
                const SizedBox(height: 2),
                const Text('Available Balance',
                    style:
                        TextStyle(color: Colors.white60, fontSize: 11)),

                const SizedBox(height: 10),

                // Income / Spent row
                Row(children: [
                  _CardStat(
                      label: 'Income',
                      value: visible
                          ? '+R ${income.toStringAsFixed(0)}'
                          : '••••',
                      icon: Icons.arrow_downward_rounded,
                      color: Colors.greenAccent),
                  const SizedBox(width: 24),
                  _CardStat(
                      label: 'Spent',
                      value: visible
                          ? '-R ${spent.toStringAsFixed(0)}'
                          : '••••',
                      icon: Icons.arrow_upward_rounded,
                      color: Colors.orangeAccent),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _CardStat(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5)),
        child: Icon(icon, color: color, size: 12),
      ),
      const SizedBox(width: 6),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 9)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700)),
      ]),
    ]);
  }
}

// EMV chip painter
class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB8964A)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(0, size.height * 0.3),
        Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// POCKETS QUICK-VIEW  (inline — no separate page navigation)
// ─────────────────────────────────────────────────────────────
class _PocketsQuickView extends StatefulWidget {
  @override
  State<_PocketsQuickView> createState() => _PocketsQuickViewState();
}

class _PocketsQuickViewState extends State<_PocketsQuickView> {
  bool _expanded = false;

  static const _pockets = [
    {'name': 'Saving',         'balance': 190.0,  'emoji': '💰', 'color': 0xFF1A1A1A},
    {'name': 'Transport',      'balance': 100.0,  'emoji': '🚌', 'color': 0xFF1A3A8F},
    {'name': 'Grocery',        'balance': 120.0,  'emoji': '🛒', 'color': 0xFF065F46},
    {'name': 'Accommodation',  'balance': 200.0,  'emoji': '🏠', 'color': 0xFF5B21B6},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── Header row ───────────────────────────────────
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('My Pockets',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A))),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _expanded
                      ? const Color(0xFFE30613)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _expanded
                          ? const Color(0xFFE30613)
                          : const Color(0xFFEEEEEE)),
                ),
                child: Row(children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.credit_card_rounded,
                    size: 14,
                    color: _expanded ? Colors.white : const Color(0xFF555555),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _expanded ? 'Hide' : 'View Pockets',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _expanded
                            ? Colors.white
                            : const Color(0xFF555555)),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),

      // ── Expandable pocket cards ───────────────────────
      AnimatedSize(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
        child: _expanded
            ? SizedBox(
                height: 130,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _pockets.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final p = _pockets[i];
                    return _PocketMiniCard(pocket: p);
                  },
                ),
              )
            : const SizedBox.shrink(),
      ),
    ]);
  }
}

class _PocketMiniCard extends StatelessWidget {
  final Map<String, dynamic> pocket;
  const _PocketMiniCard({required this.pocket});

  @override
  Widget build(BuildContext context) {
    final baseColor = Color(pocket['color'] as int);
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [baseColor, baseColor.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: baseColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pocket['emoji'] as String,
                  style: const TextStyle(fontSize: 18)),
              Container(
                width: 20, height: 14,
                decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(3)),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'R ${(pocket['balance'] as double).toStringAsFixed(2)}',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5),
          ),
          const SizedBox(height: 2),
          Text(
            '${pocket['name']} Pocket',
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PROFIT ENTRY
// ─────────────────────────────────────────────────────────────
class _ProfitEntry extends StatelessWidget {
  final String title, amount, date;
  const _ProfitEntry(
      {required this.title, required this.amount, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FFF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.trending_up_rounded,
              color: Color(0xFF10B981), size: 18),
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
                        color: Color(0xFF1A1A1A))),
                Text(date,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF888888))),
              ]),
        ),
        Text('+$amount',
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Color(0xFF059669))),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MODELS & SHARED WIDGETS
// ─────────────────────────────────────────────────────────────
class _SpendingCategory {
  final String name;
  final double spent, budget;
  final Color color;
  final IconData icon;
  const _SpendingCategory(
      this.name, this.spent, this.budget, this.color, this.icon);
  bool get isOver => spent > budget;
}

class _Transaction {
  final String title, date;
  final double amount;
  final bool isCredit;
  final IconData icon;
  const _Transaction(
      this.title, this.amount, this.isCredit, this.date, this.icon);
}

class _Resource {
  final String title, source, tag;
  final IconData icon;
  const _Resource(
      {required this.title,
      required this.source,
      required this.icon,
      required this.tag});
}

class _CategoryBar extends StatelessWidget {
  final _SpendingCategory cat;
  const _CategoryBar({required this.cat});

  @override
  Widget build(BuildContext context) {
    final pct = (cat.spent / cat.budget).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(cat.icon, size: 16, color: cat.color),
          const SizedBox(width: 8),
          Text(cat.name,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          const Spacer(),
          Text('R${cat.spent.toInt()} / R${cat.budget.toInt()}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: cat.isOver
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF555555))),
          if (cat.isOver) ...[
            const SizedBox(width: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(4)),
              child: const Text('Over',
                  style: TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation(
                cat.isOver ? const Color(0xFFEF4444) : cat.color),
          ),
        ),
      ]),
    );
  }
}

class _ResourceTile extends StatelessWidget {
  final _Resource resource;
  const _ResourceTile({required this.resource});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFDDDD)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
              color: const Color(0xFFE30613).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(resource.icon,
              size: 18, color: const Color(0xFFE30613)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resource.title,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A))),
                Text(resource.source,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF888888))),
              ]),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: const Color(0xFFE30613).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6)),
          child: Text(resource.tag,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFFE30613),
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final _Transaction tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: tx.isCredit
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(tx.icon,
              size: 18,
              color: tx.isCredit
                  ? const Color(0xFF388E3C)
                  : const Color(0xFFF57C00)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(tx.date,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF999999))),
              ]),
        ),
        Text(
          '${tx.isCredit ? '+' : '-'}R ${tx.amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: tx.isCredit
                  ? const Color(0xFF388E3C)
                  : const Color(0xFF1A1A1A)),
        ),
      ]),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _BalanceStat(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6)),
        child: Icon(icon, color: color, size: 14),
      ),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 11)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700)),
      ]),
    ]);
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555))),
      ]),
    );
  }
}