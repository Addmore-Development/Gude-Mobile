// lib/features/wallet/presentation/wallet_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/core/state/financial_health.dart';

class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
}

// ─── Pocket data ──────────────────────────────────────────────────────
const _pocketData = [
  {'name': 'Saving',        'balance': 190.0, 'emoji': '💰', 'cardColor': 0xFF1A1A1A, 'cardColorEnd': 0xFF3A3A3A, 'cardNumber': '2015 1320 8870 2351', 'expiry': '09/30', 'index': 0},
  {'name': 'Transport',     'balance': 100.0, 'emoji': '🚌', 'cardColor': 0xFF1A3A8F, 'cardColorEnd': 0xFF3B5BD5, 'cardNumber': '1202 1320 8870 2351', 'expiry': '09/30', 'index': 1},
  {'name': 'Grocery',       'balance': 120.0, 'emoji': '🛒', 'cardColor': 0xFF065F46, 'cardColorEnd': 0xFF059669, 'cardNumber': '0057 0120 8870 0234', 'expiry': '09/30', 'index': 2},
  {'name': 'Accommodation', 'balance': 200.0, 'emoji': '🏠', 'cardColor': 0xFF5B21B6, 'cardColorEnd': 0xFF7C3AED, 'cardNumber': '0587 1320 8870 5723', 'expiry': '09/30', 'index': 3},
];

class _SpendingCat {
  final String name;
  final double spent, budget;
  final Color color;
  final IconData icon;
  const _SpendingCat(this.name, this.spent, this.budget, this.color, this.icon);
  bool get isOver => spent > budget;
}

class _Tx {
  final String title, date;
  final double amount;
  final bool isCredit;
  final IconData icon;
  const _Tx(this.title, this.amount, this.isCredit, this.date, this.icon);
}

class _Resource {
  final String title, source, tag;
  final IconData icon;
  const _Resource({required this.title, required this.source, required this.icon, required this.tag});
}

// ─── Wallet page ──────────────────────────────────────────────────────
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _balanceVisible = true;
  bool _showAllTx = false;
  int _selectedPocket = 0;

  double get _budget  => FinancialHealth.monthlyBudget;
  double get _spent   => FinancialHealth.totalSpent;
  double get _income  => FinancialHealth.income;
  double get _score   => FinancialHealth.score;
  Color  get _hColor  => Color(FinancialHealth.colorValue);
  String get _hLabel  => FinancialHealth.label;
  String get _hEmoji  => FinancialHealth.emoji;

  final _categories = const [
    _SpendingCat('Food',         650, 500, Color(0xFF10B981), Icons.fastfood_outlined),
    _SpendingCat('Transport',    420, 300, Color(0xFF3B82F6), Icons.directions_bus_outlined),
    _SpendingCat('Entertainment',380, 150, Color(0xFFF59E0B), Icons.sports_esports_outlined),
    _SpendingCat('Data/Airtime', 180, 200, Color(0xFF8B5CF6), Icons.wifi_outlined),
    _SpendingCat('Textbooks',    150, 300, Color(0xFFEC4899), Icons.book_outlined),
  ];

  final _allTx = const [
    _Tx('Tutoring Session — James', 150.00, true,  'Today, 10:30',     Icons.school_outlined),
    _Tx('Withdrawal to FNB',        500.00, false, 'Today, 08:15',     Icons.arrow_upward_rounded),
    _Tx('Design Work — Sipho',      300.00, true,  'Yesterday, 15:42', Icons.brush_outlined),
    _Tx('Chicken Licken',            89.00, false, 'Yesterday, 13:10', Icons.fastfood_outlined),
    _Tx('Photography Gig',          450.00, true,  'Mon, 09:00',       Icons.camera_alt_outlined),
    _Tx('Uber',                      75.00, false, 'Mon, 07:30',       Icons.directions_car_outlined),
    _Tx('Checkers Groceries',       210.00, false, 'Sun, 11:00',       Icons.shopping_cart_outlined),
    _Tx('Airtime Purchase',          50.00, false, 'Sun, 09:00',       Icons.wifi_outlined),
    _Tx('Writing Gig — Nandi',      200.00, true,  'Sat, 14:00',       Icons.edit_outlined),
    _Tx('Electricity Token',        150.00, false, 'Fri, 16:00',       Icons.bolt_outlined),
  ];

  List<_Tx> get _visibleTx => _showAllTx ? _allTx : _allTx.take(6).toList();

  final _resources = const [
    _Resource(title: 'The 50/30/20 Budget Rule',        source: 'National Credit Regulator', icon: Icons.pie_chart_outline,   tag: 'Budgeting'),
    _Resource(title: 'Make Your NSFAS Money Last',       source: 'MyBursary SA',              icon: Icons.savings_outlined,     tag: 'NSFAS Guide'),
    _Resource(title: 'Free Financial Literacy Course',   source: 'Coursera (Audit Free)',     icon: Icons.play_circle_outline,  tag: 'Free Course'),
    _Resource(title: 'Student Debt & Budgeting Toolkit', source: 'NSFAS Official',            icon: Icons.description_outlined, tag: 'Official'),
  ];

  Map<String, dynamic> get _activePocket => _pocketData[_selectedPocket];

  @override
  Widget build(BuildContext context) {
    final pocket = _activePocket;
    final cardColor    = Color(pocket['cardColor'] as int);
    final cardColorEnd = Color(pocket['cardColorEnd'] as int);
    final balance      = pocket['balance'] as double;

    return Scaffold(
      backgroundColor: _C.lightGrey,
      body: CustomScrollView(
        slivers: [
          // ── App bar ────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Wallet',
                style: TextStyle(color: _C.dark, fontWeight: FontWeight.w800, fontSize: 20)),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: _C.dark),
                onPressed: () => context.push('/notifications'),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── MAIN POCKET CARD (full width, image-2 style) ────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: _PocketCard(
                    name:           pocket['name'] as String,
                    emoji:          pocket['emoji'] as String,
                    cardNumber:     pocket['cardNumber'] as String,
                    expiry:         pocket['expiry'] as String,
                    balance:        balance,
                    cardColor:      cardColor,
                    cardColorEnd:   cardColorEnd,
                    balanceVisible: _balanceVisible,
                    onToggle:       () => setState(() => _balanceVisible = !_balanceVisible),
                    income:         _income,
                    spent:          _spent,
                    showStats:      _selectedPocket == 0, // show income/spent only on main (saving) card
                  ),
                ),

                // ── POCKET SELECTOR TABS (no third-image strip) ─────
                const SizedBox(height: 14),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _pocketData.length,
                    itemBuilder: (_, i) {
                      final p   = _pocketData[i];
                      final sel = i == _selectedPocket;
                      final col = Color(p['cardColor'] as int);
                      return GestureDetector(
                        onTap: () => setState(() => _selectedPocket = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: sel ? col : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? col : _C.border,
                              width: 1.5,
                            ),
                            boxShadow: sel
                                ? [BoxShadow(color: col.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(p['emoji'] as String, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(
                                p['name'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: sel ? Colors.white : _C.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Available balance row ───────────────────────────
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.account_balance_outlined, color: cardColor, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Available Balance',
                              style: TextStyle(fontSize: 11, color: _C.grey)),
                          Text(
                            _balanceVisible
                                ? 'R${balance.toStringAsFixed(2)} ZAR'
                                : 'R••••• ZAR',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800, color: _C.dark),
                          ),
                        ]),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                          child: Icon(
                            _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: _C.grey, size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Financial health ────────────────────────────────
                _HealthCard(
                  color: _hColor, label: _hLabel,
                  emoji: _hEmoji, score: _score,
                  budget: _budget, spent: _spent,
                ),

                // ── Alerts ──────────────────────────────────────────
                if (FinancialHealth.needsAlert)
                  _AlertBanner(isAlert: true, resources: _resources, onFix: () => context.push('/wallet/budget'))
                else if (FinancialHealth.needsWarning)
                  _AlertBanner(isAlert: false, resources: _resources, onFix: () => context.push('/wallet/budget')),

                // ── Quick actions ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QA(icon: Icons.send_rounded,              label: 'Send',     onTap: () => context.push('/wallet/send')),
                      _QA(icon: Icons.call_received_rounded,     label: 'Received', onTap: () => context.push('/wallet/received')),
                      _QA(icon: Icons.trending_up_rounded,       label: 'Profit',   onTap: () => _showProfitSheet(context)),
                      _QA(icon: Icons.account_balance_rounded,   label: 'Withdraw', onTap: () => context.push('/wallet/withdraw')),
                      _QA(icon: Icons.pie_chart_outline_rounded, label: 'Budget',   onTap: () => context.push('/wallet/budget')),
                      _QA(icon: Icons.savings_outlined,          label: 'Goals',    onTap: () => context.push('/wallet/savings')),
                    ],
                  ),
                ),

                // ── Spending by category ────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 22, 16, 10),
                  child: Text('Spending by Category',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.dark)),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Column(children: _categories.map((c) => _CatBar(cat: c)).toList()),
                ),

                // ── Recent transactions ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Transactions',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.dark)),
                      GestureDetector(
                        onTap: () => setState(() => _showAllTx = !_showAllTx),
                        child: Text(
                          _showAllTx ? 'Show less' : 'See all',
                          style: const TextStyle(
                              color: _C.primary, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _visibleTx.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 62, endIndent: 16, color: Color(0xFFF0F0F0)),
                    itemBuilder: (_, i) => _TxTile(tx: _visibleTx[i]),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, sc) => Column(children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),
          const Text('My Profit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _C.dark)),
          const SizedBox(height: 4),
          const Text('Earnings from gigs & marketplace sales',
              style: TextStyle(fontSize: 12, color: _C.grey)),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Total Earned this month',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 4),
                  Text('R 900.00',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1)),
                  SizedBox(height: 8),
                  Text('3 gigs completed ✓',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
              ),
              Text('💸', style: TextStyle(fontSize: 42)),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              controller: sc,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _ProfitEntry(title: 'Tutoring Session — James', amount: 'R150.00', date: 'Today'),
                _ProfitEntry(title: 'Design Work — Sipho',      amount: 'R300.00', date: 'Yesterday'),
                _ProfitEntry(title: 'Photography Gig',          amount: 'R450.00', date: 'Monday'),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Full-width pocket card (image-2 style) ───────────────────────────
class _PocketCard extends StatelessWidget {
  final String name, emoji, cardNumber, expiry;
  final double balance, income, spent;
  final Color cardColor, cardColorEnd;
  final bool balanceVisible, showStats;
  final VoidCallback onToggle;

  const _PocketCard({
    required this.name,
    required this.emoji,
    required this.cardNumber,
    required this.expiry,
    required this.balance,
    required this.cardColor,
    required this.cardColorEnd,
    required this.balanceVisible,
    required this.showStats,
    required this.onToggle,
    required this.income,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [cardColor, cardColorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: cardColor.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 10))
        ],
      ),
      child: Stack(children: [
        // Decorative circles
        Positioned(
          top: -40, right: -30,
          child: Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06)),
          ),
        ),
        Positioned(
          bottom: -50, left: -20,
          child: Container(
            width: 130, height: 130,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Top row: name + mastercard logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Text(emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ]),
                Row(children: [
                  // Visibility toggle
                  GestureDetector(
                    onTap: onToggle,
                    child: Icon(
                      balanceVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Mastercard circles
                  Stack(children: [
                    Container(
                        width: 22, height: 22,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEB001B), shape: BoxShape.circle)),
                    Positioned(
                      left: 12,
                      child: Container(
                          width: 22, height: 22,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF79E1B).withOpacity(0.9),
                              shape: BoxShape.circle)),
                    ),
                  ]),
                ]),
              ],
            ),
            const SizedBox(height: 10),
            // Chip
            Container(
              width: 34, height: 26,
              decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(4)),
              child: CustomPaint(painter: _ChipPainter()),
            ),
            const Spacer(),
            // Card number
            Text(cardNumber,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2)),
            const SizedBox(height: 6),
            // Bottom row: expiry + balance + optional income/spent
            Row(children: [
              Text(expiry,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
              const Spacer(),
              if (showStats) ...[
                _CardStat(
                    label: 'Income',
                    value: balanceVisible ? '+R ${income.toStringAsFixed(0)}' : '••••',
                    icon: Icons.arrow_downward_rounded,
                    color: Colors.greenAccent),
                const SizedBox(width: 10),
                _CardStat(
                    label: 'Spent',
                    value: balanceVisible ? '-R ${spent.toStringAsFixed(0)}' : '••••',
                    icon: Icons.arrow_upward_rounded,
                    color: Colors.orangeAccent),
                const SizedBox(width: 10),
              ],
              Text(
                balanceVisible ? 'R${balance.toStringAsFixed(2)}' : 'R•••••',
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }
}

class _CardStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _CardStat(
      {required this.label, required this.value, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5)),
        child: Icon(icon, color: color, size: 10),
      ),
      const SizedBox(width: 5),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      ]),
    ]);
  }
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFFB8964A)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), p);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), p);
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), p);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), p);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ─── Financial health card ────────────────────────────────────────────
class _HealthCard extends StatelessWidget {
  final Color color;
  final String label, emoji;
  final double score, budget, spent;
  const _HealthCard(
      {required this.color, required this.label, required this.emoji, required this.score, required this.budget, required this.spent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FinancialHealth.needsAlert ? const Color(0xFFFFF1F1) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Financial Health', style: TextStyle(fontSize: 12, color: _C.grey)),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Text('${score.toInt()}/100',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              backgroundColor: _C.border,
              valueColor: AlwaysStoppedAnimation(color)),
        ),
        const SizedBox(height: 6),
        Text(
            'Total spent: R${spent.toStringAsFixed(2)}   Budget remaining: R${(budget - spent).abs().toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 11, color: _C.grey)),
        const SizedBox(height: 4),
        Text(
            'You have used ${((spent / budget) * 100).toInt()}% of your budget.',
            style: TextStyle(
                fontSize: 12,
                color: FinancialHealth.needsWarning
                    ? const Color(0xFFEF4444)
                    : _C.grey,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// ─── Alert banner ─────────────────────────────────────────────────────
class _AlertBanner extends StatelessWidget {
  final bool isAlert;
  final List<_Resource> resources;
  final VoidCallback onFix;
  const _AlertBanner(
      {required this.isAlert, required this.resources, required this.onFix});

  @override
  Widget build(BuildContext context) {
    if (isAlert) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF7F1D1D).withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFEF4444).withOpacity(0.5), width: 1.5),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 22),
            SizedBox(width: 8),
            Expanded(
              child: Text('⚠️ Dropout Risk Detected',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFB91C1C))),
            ),
          ]),
          const SizedBox(height: 8),
          const Text(
              'Your spending patterns suggest financial stress that may put your studies at risk.',
              style: TextStyle(fontSize: 13, color: Color(0xFF7F1D1D), height: 1.5)),
          const SizedBox(height: 14),
          const Text('📚 Free resources to help you:',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
          const SizedBox(height: 10),
          ...resources.map((r) => _ResTile(r: r)),
        ]),
      );
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
      ),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 20),
        const SizedBox(width: 10),
        const Expanded(
          child: Text('Spending habits need attention. Check your budget.',
              style: TextStyle(
                  color: Color(0xFF92400E), fontSize: 13, fontWeight: FontWeight.w500)),
        ),
        TextButton(
          onPressed: onFix,
          style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: const Text('Fix →',
              style: TextStyle(
                  color: _C.primary, fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ]),
    );
  }
}

class _ResTile extends StatelessWidget {
  final _Resource r;
  const _ResTile({required this.r});
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
              color: _C.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(r.icon, size: 18, color: _C.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(r.title,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: _C.dark)),
            Text(r.source, style: const TextStyle(fontSize: 11, color: _C.grey)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: _C.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6)),
          child: Text(r.tag,
              style: const TextStyle(
                  fontSize: 10, color: _C.primary, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

// ─── Category bar ─────────────────────────────────────────────────────
class _CatBar extends StatelessWidget {
  final _SpendingCat cat;
  const _CatBar({required this.cat});
  @override
  Widget build(BuildContext context) {
    final pct = (cat.spent / cat.budget).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(cat.icon, size: 16, color: cat.color),
          const SizedBox(width: 8),
          Text(cat.name,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: _C.dark)),
          const Spacer(),
          Text(
            'R${cat.spent.toInt()} / R${cat.budget.toInt()}',
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: cat.isOver ? const Color(0xFFEF4444) : const Color(0xFF555555)),
          ),
          if (cat.isOver) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(4)),
              child: const Text('Over',
                  style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: _C.border,
              valueColor: AlwaysStoppedAnimation(
                  cat.isOver ? const Color(0xFFEF4444) : cat.color)),
        ),
      ]),
    );
  }
}

// ─── Transaction tile ──────────────────────────────────────────────────
class _TxTile extends StatelessWidget {
  final _Tx tx;
  const _TxTile({required this.tx});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: tx.isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(tx.icon,
              size: 18,
              color: tx.isCredit ? const Color(0xFF388E3C) : const Color(0xFFF57C00)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tx.title,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: _C.dark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(tx.date,
                style: const TextStyle(fontSize: 11, color: Color(0xFF999999))),
          ]),
        ),
        Text(
          '${tx.isCredit ? '+' : '-'}R ${tx.amount.toStringAsFixed(2)}',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: tx.isCredit ? const Color(0xFF388E3C) : _C.dark),
        ),
      ]),
    );
  }
}

// ─── Quick action ─────────────────────────────────────────────────────
class _QA extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QA({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 8,
                offset: const Offset(0, 2))],
          ),
          child: Icon(icon, color: _C.primary, size: 20),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF555555))),
      ]),
    );
  }
}

// ─── Profit entry ──────────────────────────────────────────────────────
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
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.trending_up_rounded,
              color: Color(0xFF10B981), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
            Text(date, style: const TextStyle(fontSize: 11, color: _C.grey)),
          ]),
        ),
        Text('+$amount',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF059669))),
      ]),
    );
  }
}