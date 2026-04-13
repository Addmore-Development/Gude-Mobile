// lib/features/wallet/presentation/wallet_page.dart
// Wallet landing page — main card at top with a "›" arrow button beside it
// that manually steps through each pocket card (no auto-play slideshow).
// Pressing the arrow changes the card AND the info beneath it in sync.
import 'package:flutter/material.dart';
import 'package:gude_app/features/chatbot/presentation/ai_coach_overlay.dart';
import 'package:gude_app/features/chatbot/services/ai_coach_service.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ── Colours ─────────────────────────────────────────────────
class _C {
  static const primary = Color(0xFFE30613);
  static const dark = Color(0xFF1A1A1A);
  static const grey = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border = Color(0xFFEEEEEE);
  static const green = Color(0xFF10B981);
}

// ── Pocket model ─────────────────────────────────────────────
class _Pocket {
  final String name, emoji, cardNumber, expiry;
  final double balance, income, spent;
  final Color cardColor, cardColorEnd;
  final bool isMain;
  final List<_Tx> transactions;
  const _Pocket({
    required this.name,
    required this.emoji,
    required this.cardNumber,
    required this.expiry,
    required this.balance,
    required this.cardColor,
    required this.cardColorEnd,
    this.income = 0,
    this.spent = 0,
    this.isMain = false,
    this.transactions = const [],
  });
}

class _Tx {
  final String label, date;
  final double amount;
  final bool isCredit;
  final IconData icon;
  const _Tx(this.label, this.amount, this.isCredit, this.date, this.icon);
}

// ── Data ─────────────────────────────────────────────────────
final _pockets = [
  _Pocket(
    name: 'Main Wallet',
    emoji: '💳',
    cardNumber: '2015 1320 8870 2351',
    expiry: '09/30',
    balance: 610,
    income: 4200,
    spent: 1830,
    cardColor: const Color(0xFF1A1A1A),
    cardColorEnd: const Color(0xFF3A3A3A),
    isMain: true,
    transactions: const [
      _Tx('Tutoring Session', 150, true, 'Today, 10:30', Icons.school_outlined),
      _Tx('Withdrawal to FNB', 500, false, 'Today, 08:15',
          Icons.arrow_upward_rounded),
      _Tx('Design Work', 300, true, 'Yesterday, 15:42', Icons.brush_outlined),
      _Tx('Chicken Licken', 89, false, 'Yesterday, 13:10',
          Icons.fastfood_outlined),
      _Tx('Photography Gig', 450, true, 'Mon, 09:00',
          Icons.camera_alt_outlined),
      _Tx('Uber', 75, false, 'Mon, 07:30', Icons.directions_car_outlined),
    ],
  ),
  _Pocket(
    name: 'Saving',
    emoji: '💰',
    cardNumber: '2015 1320 8870 2351',
    expiry: '09/30',
    balance: 190,
    cardColor: const Color(0xFF1A1A1A),
    cardColorEnd: const Color(0xFF3A3A3A),
    transactions: const [
      _Tx('Top up to balance', 100, true, '26/8/2025, 3:07 PM',
          Icons.add_circle_outline),
      _Tx('Balance Changed', 20, false, '26/8/2025, 3:07 PM',
          Icons.remove_circle_outline),
      _Tx('Top up', 70, true, '25/8/2025, 11:00 AM', Icons.add_circle_outline),
    ],
  ),
  _Pocket(
    name: 'Transport',
    emoji: '🚌',
    cardNumber: '1202 1320 8870 2351',
    expiry: '09/30',
    balance: 100,
    cardColor: const Color(0xFF1A3A8F),
    cardColorEnd: const Color(0xFF3B5BD5),
    transactions: const [
      _Tx('Gautrain', 32, false, '26/8/2025, 8:00 AM', Icons.train_outlined),
      _Tx('Top up', 100, true, '25/8/2025, 9:00 AM', Icons.add_circle_outline),
      _Tx('Uber', 45, false, '24/8/2025, 6:30 PM',
          Icons.directions_car_outlined),
    ],
  ),
  _Pocket(
    name: 'Grocery',
    emoji: '🛒',
    cardNumber: '0057 0120 8870 0234',
    expiry: '09/30',
    balance: 120,
    cardColor: const Color(0xFF065F46),
    cardColorEnd: const Color(0xFF059669),
    transactions: const [
      _Tx('Checkers', 89, false, '26/8/2025, 12:00 PM',
          Icons.shopping_cart_outlined),
      _Tx('Top up', 150, true, '24/8/2025, 9:00 AM', Icons.add_circle_outline),
      _Tx('Woolworths Food', 61, false, '23/8/2025, 1:00 PM',
          Icons.shopping_bag_outlined),
    ],
  ),
  _Pocket(
    name: 'Accommodation',
    emoji: '🏠',
    cardNumber: '0587 1320 8870 5723',
    expiry: '09/30',
    balance: 200,
    cardColor: const Color(0xFF5B21B6),
    cardColorEnd: const Color(0xFF7C3AED),
    transactions: const [
      _Tx('Rent payment', 200, false, '26/8/2025, 7:00 AM',
          Icons.home_outlined),
      _Tx('Top up', 200, true, '25/8/2025, 8:00 AM', Icons.add_circle_outline),
      _Tx('Deposit refund', 50, true, '20/8/2025, 3:00 PM',
          Icons.redo_outlined),
    ],
  ),
];

// ── Spending categories ───────────────────────────────────────
class _Cat {
  final String name;
  final double spent, budget;
  final Color color;
  final IconData icon;
  const _Cat(this.name, this.spent, this.budget, this.color, this.icon);
  bool get isOver => spent > budget;
}

const _cats = [
  _Cat('Food', 650, 500, Color(0xFF10B981), Icons.fastfood_outlined),
  _Cat('Transport', 420, 300, Color(0xFF3B82F6), Icons.directions_bus_outlined),
  _Cat('Entertainment', 380, 150, Color(0xFFF59E0B),
      Icons.sports_esports_outlined),
  _Cat('Data/Airtime', 180, 200, Color(0xFF8B5CF6), Icons.wifi_outlined),
  _Cat('Textbooks', 150, 300, Color(0xFFEC4899), Icons.book_outlined),
];

// ════════════════════════════════════════════════════════════════
//  WalletPage
// ════════════════════════════════════════════════════════════════
class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  int _pocketIndex = 0;
  int _pocketDir = 1; // 1 = forward, -1 = backward
  bool _balVisible = true;
  bool _showAllTx = false;

  late AnimationController _arrowCtrl;
  late Animation<double> _arrowScale;

  @override
  void initState() {
    super.initState();
    _arrowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _arrowScale = Tween<double>(begin: 1.0, end: 0.82)
        .animate(CurvedAnimation(parent: _arrowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _arrowCtrl.dispose();
    super.dispose();
  }

  // Advance to next pocket — this is the ONLY navigation trigger
  void _nextPocket() {
    HapticFeedback.lightImpact();
    _arrowCtrl.forward().then((_) => _arrowCtrl.reverse());
    setState(() {
      _pocketDir = 1;
      _pocketIndex = (_pocketIndex + 1) % _pockets.length;
      _showAllTx = false;
    });
  }

  _Pocket get _pocket => _pockets[_pocketIndex];

  // ── Financial health helpers ──────────────────────────────
  static const _budget = 3000.0;
  static const _spent = 1830.0;
  static const _income = 4200.0;
  double get _score => ((_budget - _spent) / _budget * 100).clamp(0, 100);
  Color get _hColor => _score >= 70
      ? const Color(0xFF10B981)
      : _score >= 40
          ? const Color(0xFFF59E0B)
          : const Color(0xFFEF4444);
  String get _hLabel => _score >= 70
      ? 'Good'
      : _score >= 40
          ? 'Fair'
          : 'Critical';
  String get _hEmoji => _score >= 70
      ? '🟢'
      : _score >= 40
          ? '🟡'
          : '🔴';

  @override
  Widget build(BuildContext context) {
    final p = _pocket;
    // Build coach context from wallet data
    const coachCtx = CoachContext(
      walletBalance: 610,
      monthlyBudget: _budget,
      totalSpent: _spent,
      income: _income,
      stabilityScore: 62,
      stabilityLabel: 'Steady',
      marketplaceActivity: 3,
      missedCheckins: 2,
      page: 'wallet',
    );

    return Scaffold(
      backgroundColor: _C.lightGrey,
      floatingActionButton: AiCoachFab(context: coachCtx),
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Wallet',
                style: TextStyle(
                    color: _C.dark, fontWeight: FontWeight.w800, fontSize: 20)),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: _C.dark),
                onPressed: () => context.push('/notifications'),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) {
                final isIncoming = child.key == ValueKey(_pocketIndex);
                final slideIn = Tween<Offset>(
                  begin: Offset(_pocketDir * (isIncoming ? 1.0 : -1.0), 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic));
                return SlideTransition(
                  position: slideIn,
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: anim,
                        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: _PocketContent(
                key: ValueKey(_pocketIndex),
                pocket: p,
                balVisible: _balVisible,
                showAllTx: _showAllTx,
                arrowScale: _arrowScale,
                pocketIndex: _pocketIndex,
                totalPockets: _pockets.length,
                onToggleBal: () => setState(() => _balVisible = !_balVisible),
                onNext: _nextPocket,
                onToggleAllTx: () => setState(() => _showAllTx = !_showAllTx),
                income: _income,
                spent: _spent,
                budget: _budget,
                score: _score,
                hColor: _hColor,
                hLabel: _hLabel,
                hEmoji: _hEmoji,
                cats: _cats,
                onNavigate: (route) => context.push(route),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  _PocketContent — all scrollable content for the active pocket
// ════════════════════════════════════════════════════════════════
class _PocketContent extends StatelessWidget {
  final _Pocket pocket;
  final bool balVisible, showAllTx;
  final Animation<double> arrowScale;
  final int pocketIndex, totalPockets;
  final VoidCallback onToggleBal, onNext, onToggleAllTx;
  final double income, spent, budget, score;
  final Color hColor;
  final String hLabel, hEmoji;
  final List<_Cat> cats;
  final void Function(String) onNavigate;

  const _PocketContent({
    super.key,
    required this.pocket,
    required this.balVisible,
    required this.showAllTx,
    required this.arrowScale,
    required this.pocketIndex,
    required this.totalPockets,
    required this.onToggleBal,
    required this.onNext,
    required this.onToggleAllTx,
    required this.income,
    required this.spent,
    required this.budget,
    required this.score,
    required this.hColor,
    required this.hLabel,
    required this.hEmoji,
    required this.cats,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final txList =
        showAllTx ? pocket.transactions : pocket.transactions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Card with arrow button overlaid on the right edge ─────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Stack(
            children: [
              // Card fills full width
              _PocketCard(
                pocket: pocket,
                balVisible: balVisible,
                onToggle: onToggleBal,
                income: income,
                spent: spent,
              ),
              // Arrow button overlaid on the right-centre of the card
              Positioned(
                right: 12,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: arrowScale,
                        child: GestureDetector(
                          onTap: onNext,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.chevron_right_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Dot indicators
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                            totalPockets,
                            (i) => Container(
                                  width: i == pocketIndex ? 12 : 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                                  decoration: BoxDecoration(
                                    color: i == pocketIndex
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Pocket name label ─────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(
            children: [
              Text(pocket.emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(pocket.name,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _C.dark)),
              const Spacer(),
              Text(
                '${pocketIndex + 1} / $totalPockets',
                style: const TextStyle(fontSize: 11, color: _C.grey),
              ),
            ],
          ),
        ),

        // ── Available balance ─────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: pocket.cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.account_balance_outlined,
                      color: pocket.cardColor == const Color(0xFF1A1A1A)
                          ? _C.dark
                          : pocket.cardColor,
                      size: 18),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Available Balance',
                      style: TextStyle(fontSize: 11, color: _C.grey)),
                  Text(
                    balVisible
                        ? 'R${pocket.balance.toStringAsFixed(2)} ZAR'
                        : 'R••••• ZAR',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _C.dark),
                  ),
                ]),
                const Spacer(),
                GestureDetector(
                  onTap: onToggleBal,
                  child: Icon(
                    balVisible
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: _C.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Quick actions ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _QA(
                  icon: Icons.send_rounded,
                  label: 'Send',
                  onTap: () => onNavigate('/wallet/send')),
              _QA(
                  icon: Icons.call_received_rounded,
                  label: 'Received',
                  onTap: () => onNavigate('/wallet/received')),
              _QA(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Transfer',
                  onTap: () {}),
              _QA(
                  icon: Icons.account_balance_rounded,
                  label: 'Withdraw',
                  onTap: () => onNavigate('/wallet/withdraw')),
              _QA(
                  icon: Icons.pie_chart_outline,
                  label: 'Budget',
                  onTap: () => onNavigate('/wallet/budget')),
              _QA(
                  icon: Icons.savings_outlined,
                  label: 'Goals',
                  onTap: () => onNavigate('/wallet/savings')),
            ],
          ),
        ),

        // ── Financial health (main card only) ─────────────
        if (pocket.isMain) ...[
          _HealthCard(
              score: score,
              hColor: hColor,
              hLabel: hLabel,
              hEmoji: hEmoji,
              budget: budget,
              spent: spent),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Text('Spending by Category',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: _C.dark)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
              ],
            ),
            child: Column(children: cats.map((c) => _CatBar(cat: c)).toList()),
          ),
        ],

        // ── Transactions ──────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Transactions',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _C.dark)),
              GestureDetector(
                onTap: onToggleAllTx,
                child: Text(
                  showAllTx ? 'Show less' : 'View all',
                  style: const TextStyle(
                      color: _C.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
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
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
            ],
          ),
          child: pocket.transactions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text('No transactions yet',
                        style: TextStyle(color: _C.grey, fontSize: 13)),
                  ),
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: txList.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 62,
                      endIndent: 16,
                      color: Color(0xFFF0F0F0)),
                  itemBuilder: (_, i) => _TxTile(tx: txList[i]),
                ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Pocket Card
// ════════════════════════════════════════════════════════════════
class _PocketCard extends StatelessWidget {
  final _Pocket pocket;
  final bool balVisible;
  final VoidCallback onToggle;
  final double income, spent;

  const _PocketCard({
    required this.pocket,
    required this.balVisible,
    required this.onToggle,
    required this.income,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [pocket.cardColor, pocket.cardColorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: pocket.cardColor.withOpacity(0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -35,
            right: -25,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06)),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -15,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Text(pocket.emoji, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(pocket.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ]),
                    Row(children: [
                      GestureDetector(
                        onTap: onToggle,
                        child: Icon(
                          balVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white70,
                          size: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Stack(children: [
                        Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                                color: Color(0xFFEB001B),
                                shape: BoxShape.circle)),
                        Positioned(
                          left: 12,
                          child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFF79E1B).withOpacity(0.9),
                                  shape: BoxShape.circle)),
                        ),
                      ]),
                    ]),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  width: 32,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomPaint(painter: _ChipPainter()),
                ),
                const Spacer(),
                Text(pocket.cardNumber,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.8)),
                const SizedBox(height: 6),
                Row(children: [
                  Text(pocket.expiry,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 11)),
                  const Spacer(),
                  if (pocket.isMain) ...[
                    _CardStat(
                        label: 'Income',
                        value: balVisible
                            ? '+R${income.toStringAsFixed(0)}'
                            : '••••',
                        icon: Icons.arrow_downward_rounded,
                        color: Colors.greenAccent),
                    const SizedBox(width: 10),
                    _CardStat(
                        label: 'Spent',
                        value: balVisible
                            ? '-R${spent.toStringAsFixed(0)}'
                            : '••••',
                        icon: Icons.arrow_upward_rounded,
                        color: Colors.orangeAccent),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    balVisible
                        ? 'R${pocket.balance.toStringAsFixed(2)}'
                        : 'R•••••',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  ),
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
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, color: color, size: 9),
      ),
      const SizedBox(width: 4),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 8)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700)),
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
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), p);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), p);
    canvas.drawLine(
        Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), p);
    canvas.drawLine(
        Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), p);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════════════
//  Financial health card
// ════════════════════════════════════════════════════════════════
class _HealthCard extends StatelessWidget {
  final double score, budget, spent;
  final Color hColor;
  final String hLabel, hEmoji;
  const _HealthCard({
    required this.score,
    required this.hColor,
    required this.hLabel,
    required this.hEmoji,
    required this.budget,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final pct = (spent / budget * 100).round();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hColor.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text(hEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Financial Health',
                style: TextStyle(fontSize: 11, color: _C.grey)),
            Text(hLabel,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: hColor)),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: hColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20)),
            child: Text('${score.toInt()}/100',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: hColor)),
          ),
        ]),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor: _C.border,
            valueColor: AlwaysStoppedAnimation(hColor),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Total spent: R${spent.toStringAsFixed(2)}   '
          'Budget remaining: R${(budget - spent).abs().toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 11, color: _C.grey),
        ),
        const SizedBox(height: 4),
        Text(
          'You have used $pct% of your budget.',
          style: TextStyle(
              fontSize: 12,
              color: pct > 80 ? const Color(0xFFEF4444) : _C.grey,
              fontWeight: FontWeight.w500),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════════
//  Small widgets
// ════════════════════════════════════════════════════════════════
class _CatBar extends StatelessWidget {
  final _Cat cat;
  const _CatBar({required this.cat});

  @override
  Widget build(BuildContext context) {
    final pct = (cat.spent / cat.budget).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(cat.icon, size: 15, color: cat.color),
          const SizedBox(width: 7),
          Text(cat.name,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: _C.dark)),
          const Spacer(),
          Text('R${cat.spent.toInt()} / R${cat.budget.toInt()}',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: cat.isOver
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF555555))),
          if (cat.isOver) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: _C.border,
            valueColor: AlwaysStoppedAnimation(
                cat.isOver ? const Color(0xFFEF4444) : cat.color),
          ),
        ),
      ]),
    );
  }
}

class _TxTile extends StatelessWidget {
  final _Tx tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color:
                tx.isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tx.label,
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
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Icon(icon, color: _C.primary, size: 20),
        ),
        const SizedBox(height: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Color(0xFF555555))),
      ]),
    );
  }
}