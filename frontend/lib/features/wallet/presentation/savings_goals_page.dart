import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
class _Goal {
  final String id, name, emoji;
  double saved, target;
  final Color color, colorDark;
  final List<_GoalTransaction> transactions;

  _Goal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.saved,
    required this.target,
    required this.color,
    required this.colorDark,
    required this.transactions,
  });

  double get progress => (saved / target).clamp(0.0, 1.0);
  String get cardNumber => '•••• •••• •••• ${id.hashCode.abs() % 9000 + 1000}';
}

class _GoalTransaction {
  final String label, date;
  final double amount;
  final bool isCredit;
  const _GoalTransaction(this.label, this.amount, this.isCredit, this.date);
}

// ─────────────────────────────────────────────
// SAVINGS GOALS PAGE
// ─────────────────────────────────────────────
class SavingsGoalsPage extends StatefulWidget {
  const SavingsGoalsPage({super.key});
  @override
  State<SavingsGoalsPage> createState() => _SavingsGoalsPageState();
}

class _SavingsGoalsPageState extends State<SavingsGoalsPage> {
  final List<_Goal> _goals = [
    _Goal(
      id: 'food', name: 'Food & Groceries', emoji: '🍎',
      saved: 650, target: 1200,
      color: const Color(0xFF10B981), colorDark: const Color(0xFF065F46),
      transactions: const [
        _GoalTransaction('Woolworths Food', 120.00, false, 'Today, 11:30'),
        _GoalTransaction('Pocket top-up', 300.00, true, 'Yesterday, 09:00'),
        _GoalTransaction('Pick n Pay', 230.00, false, 'Mon, 14:20'),
      ],
    ),
    _Goal(
      id: 'laptop', name: 'Laptop Savings', emoji: '💻',
      saved: 3200, target: 5200,
      color: const Color(0xFF3B82F6), colorDark: const Color(0xFF1E40AF),
      transactions: const [
        _GoalTransaction('Monthly contribution', 800.00, true, 'Mar 1, 08:00'),
        _GoalTransaction('Monthly contribution', 800.00, true, 'Feb 1, 08:00'),
        _GoalTransaction('Monthly contribution', 800.00, true, 'Jan 1, 08:00'),
      ],
    ),
    _Goal(
      id: 'rent', name: 'Accommodation', emoji: '🏠',
      saved: 2800, target: 4500,
      color: const Color(0xFF8B5CF6), colorDark: const Color(0xFF5B21B6),
      transactions: const [
        _GoalTransaction('Rent deposit top-up', 1000.00, true, 'Mar 5, 10:00'),
        _GoalTransaction('Pocket to wallet transfer', 200.00, false, 'Feb 28, 16:00'),
        _GoalTransaction('Rent deposit top-up', 1000.00, true, 'Feb 5, 10:00'),
      ],
    ),
    _Goal(
      id: 'emergency', name: 'Emergency Fund', emoji: '🆘',
      saved: 500, target: 3000,
      color: const Color(0xFFF59E0B), colorDark: const Color(0xFF92400E),
      transactions: const [
        _GoalTransaction('First contribution', 500.00, true, 'Mar 10, 09:00'),
      ],
    ),
  ];

  void _showAddGoalDialog() {
    final nameCtrl   = TextEditingController();
    final targetCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add New Goal', style: TextStyle(fontWeight: FontWeight.w800)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Goal name (e.g. Books)', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: targetCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Target amount (R)', border: OutlineInputBorder())),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: _C.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _C.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () {
            final name   = nameCtrl.text.trim();
            final target = double.tryParse(targetCtrl.text) ?? 0;
            if (name.isEmpty || target <= 0) return;
            final colors = [const Color(0xFFEC4899), const Color(0xFF06B6D4), const Color(0xFFEF4444)];
            final colorDarks = [const Color(0xFF9D174D), const Color(0xFF0E7490), const Color(0xFFB91C1C)];
            final idx = _goals.length % 3;
            setState(() => _goals.add(_Goal(
              id: 'goal_${DateTime.now().millisecondsSinceEpoch}',
              name: name, emoji: '🎯', saved: 0, target: target,
              color: colors[idx], colorDark: colorDarks[idx], transactions: [],
            )));
            Navigator.pop(context);
          },
          child: const Text('Add Goal', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  void _openPocketDetail(_Goal goal) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _GoalPocketPage(goal: goal)));
  }

  void _addFunds(_Goal goal) {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Add to ${goal.name}', style: const TextStyle(fontWeight: FontWeight.w800)),
      content: TextField(controller: ctrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (R)', border: OutlineInputBorder())),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: _C.grey))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _C.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          onPressed: () {
            final amount = double.tryParse(ctrl.text) ?? 0;
            if (amount <= 0) return;
            setState(() { goal.saved = (goal.saved + amount).clamp(0, goal.target); });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('R${amount.toStringAsFixed(0)} added to ${goal.name}!'), backgroundColor: _C.green, duration: const Duration(seconds: 2)));
          },
          child: const Text('Add Funds', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final totalSaved  = _goals.fold<double>(0, (s, g) => s + g.saved);
    final totalTarget = _goals.fold<double>(0, (s, g) => s + g.target);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: _C.dark), onPressed: () => context.pop()),
        title: const Text('Savings Goals', style: TextStyle(color: _C.dark, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline, color: _C.primary), onPressed: _showAddGoalDialog),
        ],
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [

        // ── Overall summary card ─────────────────────────────
        Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF333333)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(18),
        ), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Total Savings', style: TextStyle(color: Colors.white70, fontSize: 12)),
              SizedBox(height: 2),
            ]),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: Text('${_goals.length} goals', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
          ]),
          Align(alignment: Alignment.centerLeft, child: Text('R${totalSaved.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -1))),
          const SizedBox(height: 14),
          // Single overall progress bar
          ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(
            value: totalTarget > 0 ? (totalSaved / totalTarget).clamp(0.0, 1.0) : 0,
            minHeight: 8,
            backgroundColor: Colors.white.withOpacity(0.25),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
          )),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Saved: R${totalSaved.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text('Target: R${totalTarget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ]),
        ])),

        const SizedBox(height: 20),

        // ── Goal pocket cards ────────────────────────────────
        ...(_goals.map((goal) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _GoalCard(
            goal: goal,
            onAddFunds: () => _addFunds(goal),
            onOpenPocket: () => _openPocketDetail(goal),
          ),
        ))),

        const SizedBox(height: 40),
      ])),
    );
  }
}

// ─────────────────────────────────────────────
// GOAL CARD  — single-line progress bar only
// ─────────────────────────────────────────────
class _GoalCard extends StatelessWidget {
  final _Goal goal;
  final VoidCallback onAddFunds, onOpenPocket;
  const _GoalCard({required this.goal, required this.onAddFunds, required this.onOpenPocket});

  @override
  Widget build(BuildContext context) {
    final pct   = (goal.progress * 100).toInt();
    final left  = (goal.target - goal.saved).clamp(0, goal.target);
    final done  = goal.progress >= 1.0;

    return GestureDetector(
      onTap: onOpenPocket,
      child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: done ? goal.color.withOpacity(0.4) : _C.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: goal.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(goal.emoji, style: const TextStyle(fontSize: 22)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(goal.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
            Text(done ? '🎉 Goal reached!' : 'R${left.toStringAsFixed(0)} to go', style: TextStyle(fontSize: 12, color: done ? goal.color : _C.grey, fontWeight: done ? FontWeight.w600 : FontWeight.normal)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('R${goal.saved.toStringAsFixed(0)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: goal.color)),
            Text('of R${goal.target.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: _C.grey)),
          ]),
        ]),

        const SizedBox(height: 12),

        // ── Single progress bar ───────────────────────────────
        Row(children: [
          Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(
            value: goal.progress, minHeight: 8,
            backgroundColor: goal.color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation(goal.color),
          ))),
          const SizedBox(width: 10),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: goal.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text('$pct%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: goal.color))),
        ]),

        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: OutlinedButton.icon(
            onPressed: onOpenPocket,
            icon: Icon(Icons.credit_card_outlined, size: 15, color: goal.color),
            label: Text('View Pocket', style: TextStyle(color: goal.color, fontSize: 12)),
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8), side: BorderSide(color: goal.color.withOpacity(0.4)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          )),
          const SizedBox(width: 10),
          Expanded(child: ElevatedButton.icon(
            onPressed: done ? null : onAddFunds,
            icon: const Icon(Icons.add, size: 15, color: Colors.white),
            label: const Text('Add Funds', style: TextStyle(color: Colors.white, fontSize: 12)),
            style: ElevatedButton.styleFrom(backgroundColor: done ? _C.grey : goal.color, padding: const EdgeInsets.symmetric(vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
          )),
        ]),
      ])),
    );
  }
}

// ─────────────────────────────────────────────
// GOAL POCKET PAGE — looks like the main wallet
// ─────────────────────────────────────────────
class _GoalPocketPage extends StatelessWidget {
  final _Goal goal;
  const _GoalPocketPage({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text(goal.name, style: const TextStyle(color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        // ── Pocket Card (styled like main wallet card) ──────
        Container(height: 180, width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [goal.color, goal.colorDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: goal.color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Stack(children: [
            Positioned(top: -30, right: -20, child: Container(width: 140, height: 140, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
            Positioned(bottom: -40, right: 40, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),
            Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [Text(goal.emoji, style: const TextStyle(fontSize: 16)), const SizedBox(width: 4), const Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16))])),
                Row(children: [
                  Container(width: 26, height: 26, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
                  Transform.translate(offset: const Offset(-10, 0), child: Container(width: 26, height: 26, decoration: BoxDecoration(color: const Color(0xFFF79E1B).withOpacity(0.9), shape: BoxShape.circle))),
                ]),
              ]),
              const SizedBox(height: 14),
              Text('R${goal.saved.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1)),
              const SizedBox(height: 4),
              Text('of R${goal.target.toStringAsFixed(2)} goal', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const Spacer(),
              Text(goal.cardNumber, style: const TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 2)),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Savings Pocket', style: TextStyle(color: Colors.white70, fontSize: 11)),
                Text('${(goal.progress * 100).toInt()}% complete', style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ]),
            ])),
          ]),
        ),

        const SizedBox(height: 16),

        // ── Progress bar ──────────────────────────────────────
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.border)), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Progress', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: goal.color)),
            Text('R${(goal.target - goal.saved).clamp(0, goal.target).toStringAsFixed(0)} remaining', style: const TextStyle(fontSize: 12, color: _C.grey)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(borderRadius: BorderRadius.circular(6), child: LinearProgressIndicator(value: goal.progress, minHeight: 10, backgroundColor: goal.color.withOpacity(0.12), valueColor: AlwaysStoppedAnimation(goal.color))),
        ])),

        const SizedBox(height: 16),

        // ── Spending in this pocket ───────────────────────────
        Row(children: [
          Expanded(child: _StatCell(label: 'Saved', value: 'R${goal.saved.toStringAsFixed(0)}', color: goal.color)),
          const SizedBox(width: 12),
          Expanded(child: _StatCell(label: 'Target', value: 'R${goal.target.toStringAsFixed(0)}', color: _C.dark)),
          const SizedBox(width: 12),
          Expanded(child: _StatCell(label: 'Progress', value: '${(goal.progress * 100).toInt()}%', color: goal.color)),
        ]),

        const SizedBox(height: 20),

        // ── Transactions ──────────────────────────────────────
        const Text('Pocket Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _C.dark)),
        const SizedBox(height: 10),
        goal.transactions.isEmpty
          ? Container(padding: const EdgeInsets.all(40), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: const Center(child: Column(children: [
                Icon(Icons.receipt_long_outlined, size: 48, color: _C.border),
                SizedBox(height: 10),
                Text('No activity yet', style: TextStyle(color: _C.grey, fontSize: 14)),
              ])))
          : Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.border)), child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(), shrinkWrap: true,
              itemCount: goal.transactions.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFF0F0F0)),
              itemBuilder: (_, i) {
                final tx = goal.transactions[i];
                return Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: Row(children: [
                  Container(width: 36, height: 36, decoration: BoxDecoration(color: tx.isCredit ? _C.green.withOpacity(0.12) : _C.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(tx.isCredit ? Icons.add_rounded : Icons.remove_rounded, size: 18, color: tx.isCredit ? _C.green : _C.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(tx.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _C.dark)),
                    Text(tx.date, style: const TextStyle(fontSize: 11, color: _C.grey)),
                  ])),
                  Text('${tx.isCredit ? '+' : '-'}R${tx.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: tx.isCredit ? _C.green : _C.primary)),
                ]));
              },
            )),
        const SizedBox(height: 32),
      ])),
    );
  }
}

// ─────────────────────────────────────────────
// STAT CELL
// ─────────────────────────────────────────────
class _StatCell extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatCell({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)), child: Column(children: [
    Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 11, color: _C.grey)),
  ]));
}