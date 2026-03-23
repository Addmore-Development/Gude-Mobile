import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class SavingsGoalsPage extends StatefulWidget {
  const SavingsGoalsPage({super.key});
  @override
  State<SavingsGoalsPage> createState() => _SavingsGoalsPageState();
}

class _SavingsGoalsPageState extends State<SavingsGoalsPage> {
  final _goals = [
    {'name': 'Laptop', 'current': 1200.0, 'target': 8000.0, 'icon': '??', 'color': 0xFF6C3CE1},
    {'name': 'Accommodation', 'current': 3500.0, 'target': 12000.0, 'icon': '??', 'color': 0xFF4ECDC4},
    {'name': 'Registration Fees', 'current': 800.0, 'target': 2500.0, 'icon': '??', 'color': 0xFFFF6B6B},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.textDark), onPressed: () => context.pop()),
        title: const Text('Savings Goals', style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () => _showAddGoal(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _headerStat('R5,500', 'Total Saved'),
                Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
                _headerStat('R22,500', 'Total Goals'),
                Container(width: 1, height: 30, color: Colors.white.withOpacity(0.3)),
                _headerStat('24%', 'Progress'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._goals.map((g) => _goalCard(g)),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showAddGoal(context),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text('Add New Goal', style: TextStyle(color: AppColors.primary)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label) => Column(
    children: [
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
    ],
  );

  Widget _goalCard(Map<String, dynamic> g) {
    final progress = (g['current'] as double) / (g['target'] as double);
    final color = Color(g['color'] as int);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(g['icon'] as String, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    Text('R${(g['current'] as double).toStringAsFixed(0)} of R${(g['target'] as double).toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
              Text('${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: color),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Add Funds', style: TextStyle(color: color, fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddGoal(BuildContext context) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Savings Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Goal name', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target amount', prefixText: 'R ', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && amountCtrl.text.isNotEmpty) {
                  setState(() {
                    _goals.add({
                      'name': nameCtrl.text,
                      'current': 0.0,
                      'target': double.tryParse(amountCtrl.text) ?? 1000.0,
                      'icon': 'S',
                      'color': 0xFFE8453C,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Create Goal', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
