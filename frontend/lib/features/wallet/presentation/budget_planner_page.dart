import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class BudgetPlannerPage extends StatefulWidget {
  const BudgetPlannerPage({super.key});
  @override
  State<BudgetPlannerPage> createState() => _BudgetPlannerPageState();
}

class _BudgetPlannerPageState extends State<BudgetPlannerPage> {
  double _food = 800;
  double _transport = 400;
  double _data = 200;
  double _books = 300;
  double _savings = 500;
  final double _total = 3000;

  double get _spent => _food + _transport + _data + _books + _savings;
  double get _remaining => _total - _spent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => context.pop()),
        title: const Text('Budget Planner', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  const Text('Monthly Budget', style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('R${_total.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (_spent / _total).clamp(0, 1),
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Allocated: R${_spent.toStringAsFixed(0)}', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                      Text('Remaining: R${_remaining.toStringAsFixed(0)}',
                        style: TextStyle(color: _remaining < 0 ? Colors.red[200] : Colors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _budgetSlider('Food', _food, 2000, const Color(0xFFFF6B6B), (v) => setState(() => _food = v), Icons.restaurant_outlined),
            _budgetSlider('Transport', _transport, 1000, const Color(0xFF4ECDC4), (v) => setState(() => _transport = v), Icons.directions_bus_outlined),
            _budgetSlider('Data', _data, 500, const Color(0xFF45B7D1), (v) => setState(() => _data = v), Icons.wifi_outlined),
            _budgetSlider('Books', _books, 1000, const Color(0xFF96CEB4), (v) => setState(() => _books = v), Icons.book_outlined),
            _budgetSlider('Savings', _savings, 2000, const Color(0xFFDDA0DD), (v) => setState(() => _savings = v), Icons.savings_outlined),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () { context.pop(); },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save Budget', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _budgetSlider(String label, double value, double max, Color color, ValueChanged<double> onChanged, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
              Text('R${value.toStringAsFixed(0)}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(activeTrackColor: color, thumbColor: color, inactiveTrackColor: color.withOpacity(0.2)),
            child: Slider(value: value, min: 0, max: max, onChanged: onChanged),
          ),
          LinearProgressIndicator(
            value: value / max,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }
}
