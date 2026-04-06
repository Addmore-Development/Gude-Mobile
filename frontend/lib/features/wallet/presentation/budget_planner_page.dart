import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/state/financial_health.dart';

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
// DATA
// ─────────────────────────────────────────────
class _BudgetItem {
  final String name;
  final IconData icon;
  final Color color;
  double allocated;
  double spent;

  _BudgetItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.allocated,
    required this.spent,
  });
}

// ─────────────────────────────────────────────
// BUDGET PLANNER PAGE
// ─────────────────────────────────────────────
class BudgetPlannerPage extends StatefulWidget {
  const BudgetPlannerPage({super.key});
  @override
  State<BudgetPlannerPage> createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends State<BudgetPlannerPage> {
  final double _monthlyBudget = 3000;

  final List<_BudgetItem> _items = [
    _BudgetItem(name: 'Food',          icon: Icons.restaurant_menu_outlined, color: const Color(0xFFE30613), allocated: 800,  spent: 650),
    _BudgetItem(name: 'Transport',     icon: Icons.directions_bus_outlined,  color: const Color(0xFF0EA5E9), allocated: 400,  spent: 420),
    _BudgetItem(name: 'Data',          icon: Icons.wifi_outlined,            color: const Color(0xFF8B5CF6), allocated: 200,  spent: 180),
    _BudgetItem(name: 'Entertainment', icon: Icons.sports_esports_outlined,  color: const Color(0xFFF59E0B), allocated: 300,  spent: 380),
    _BudgetItem(name: 'Textbooks',     icon: Icons.menu_book_outlined,       color: const Color(0xFF10B981), allocated: 300,  spent: 150),
    _BudgetItem(name: 'Savings',       icon: Icons.savings_outlined,         color: const Color(0xFF3B82F6), allocated: 200,  spent: 50),
  ];

  double get _totalAllocated =>
      _items.fold(0, (s, i) => s + i.allocated);
  double get _remaining =>
      (_monthlyBudget - _totalAllocated).clamp(0, _monthlyBudget);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Budget Planner',
            style: TextStyle(
                color: _C.dark, fontWeight: FontWeight.w800, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [

          // ── Monthly budget header card ─────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFFE30613).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Monthly Budget',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(
                    'R${_monthlyBudget.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1),
                  ),
                  const SizedBox(height: 14),

                  // ── SINGLE progress bar only ─────────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: (_totalAllocated / _monthlyBudget)
                          .clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Allocated: R${_totalAllocated.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                      Text(
                          'Remaining: R${_remaining.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                ]),
          ),

          const SizedBox(height: 20),

          // ── Budget slider items ───────────────────────────────
          ..._items.map((item) => _BudgetSliderCard(
                item: item,
                maxBudget: _monthlyBudget,
                onChanged: (v) => setState(() => item.allocated = v),
              )),

          const SizedBox(height: 8),

          // ── Save button ──────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _C.dark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                FinancialHealth.monthlyBudget = _monthlyBudget;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Budget saved!'),
                    backgroundColor: _C.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
                context.pop();
              },
              child: const Text('Save Budget',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BUDGET SLIDER CARD  — one bar only
// ─────────────────────────────────────────────
class _BudgetSliderCard extends StatelessWidget {
  final _BudgetItem item;
  final double maxBudget;
  final ValueChanged<double> onChanged;

  const _BudgetSliderCard({
    required this.item,
    required this.maxBudget,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isOver = item.spent > item.allocated;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isOver
                ? const Color(0xFFEF4444).withOpacity(0.35)
                : const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Name row ─────────────────────────────────────
        Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(item.icon, size: 18, color: item.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(item.name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A))),
          ),
          // Allocated amount badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'R${item.allocated.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: item.color),
            ),
          ),
        ]),

        const SizedBox(height: 12),

        // ── ONE slider only ──────────────────────────────
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: item.color,
            inactiveTrackColor: item.color.withOpacity(0.15),
            thumbColor: item.color,
            overlayColor: item.color.withOpacity(0.12),
            trackHeight: 5,
            thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 9),
          ),
          child: Slider(
            value: item.allocated.clamp(0, maxBudget),
            min: 0,
            max: maxBudget,
            divisions: (maxBudget / 50).round(),
            onChanged: onChanged,
          ),
        ),

        // ── Spent indicator ──────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spent: R${item.spent.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 11,
                  color: isOver
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF888888),
                  fontWeight:
                      isOver ? FontWeight.w600 : FontWeight.normal),
            ),
            if (isOver)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(4)),
                child: const Text('Over budget',
                    style: TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
          ],
        ),
      ]),
    );
  }
}