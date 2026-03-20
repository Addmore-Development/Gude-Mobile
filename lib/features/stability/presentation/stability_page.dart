import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class StabilityPage extends StatefulWidget {
  const StabilityPage({super.key});
  @override
  State<StabilityPage> createState() => _StabilityPageState();
}

class _StabilityPageState extends State<StabilityPage> {
  int _selectedPeriod = 1;
  final List<String> _periods = ['Week', 'Month', '3 Months', 'Year'];

  final List<Map<String, dynamic>> _categorySpend = [
    {'label': 'Groceries',     'amount': 420.00, 'color': const Color(0xFF4CAF50), 'icon': Icons.shopping_basket_outlined,  'pct': 0.28},
    {'label': 'Transport',     'amount': 320.00, 'color': const Color(0xFF2196F3), 'icon': Icons.directions_bus_outlined,   'pct': 0.21},
    {'label': 'Accommodation', 'amount': 500.00, 'color': const Color(0xFF9C27B0), 'icon': Icons.home_outlined,             'pct': 0.33},
    {'label': 'Entertainment', 'amount': 150.00, 'color': const Color(0xFFFF9800), 'icon': Icons.movie_outlined,            'pct': 0.10},
    {'label': 'Education',     'amount': 120.00, 'color': const Color(0xFF00BCD4), 'icon': Icons.school_outlined,           'pct': 0.08},
  ];

  final List<Map<String, dynamic>> _transactions = [
    {'label': 'Shoprite Groceries', 'category': 'Groceries',     'amount': -85.00,  'date': '20 Mar', 'positive': false},
    {'label': 'NSFAS Top-up',       'category': 'Income',        'amount': 1500.00, 'date': '18 Mar', 'positive': true},
    {'label': 'Uber Ride',          'category': 'Transport',     'amount': -45.00,  'date': '17 Mar', 'positive': false},
    {'label': 'Rent Payment',       'category': 'Accommodation', 'amount': -500.00, 'date': '15 Mar', 'positive': false},
    {'label': 'Checkers Run',       'category': 'Groceries',     'amount': -120.00, 'date': '14 Mar', 'positive': false},
    {'label': 'Netflix',            'category': 'Entertainment', 'amount': -49.00,  'date': '12 Mar', 'positive': false},
    {'label': 'Textbook',           'category': 'Education',     'amount': -120.00, 'date': '10 Mar', 'positive': false},
  ];

  // Bar chart data: last 6 months spending
  final List<Map<String, dynamic>> _barData = [
    {'month': 'Oct', 'amount': 980},
    {'month': 'Nov', 'amount': 1200},
    {'month': 'Dec', 'amount': 1800},
    {'month': 'Jan', 'amount': 1100},
    {'month': 'Feb', 'amount': 1350},
    {'month': 'Mar', 'amount': 1510, 'current': true},
  ];

  double get _totalSpend => _categorySpend.fold(0, (s, c) => s + (c['amount'] as double));
  double get _maxBar => _barData.fold(0, (m, b) => b['amount'] > m ? b['amount'].toDouble() : m);

  String get _scoreLabel {
    if (_totalSpend < 1200) return 'Excellent';
    if (_totalSpend < 1600) return 'Good';
    if (_totalSpend < 2000) return 'Watch';
    return 'At Risk';
  }

  Color get _scoreColor {
    if (_totalSpend < 1200) return Colors.green;
    if (_totalSpend < 1600) return const Color(0xFF8BC34A);
    if (_totalSpend < 2000) return Colors.orange;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Spending Summary', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () => context.go('/login')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Period selector
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(4),
            child: Row(children: List.generate(_periods.length, (i) => Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPeriod = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedPeriod == i ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_periods[i], textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: _selectedPeriod == i ? Colors.white : AppColors.textGrey,
                    )),
                ),
              ),
            ))),
          ),
          const SizedBox(height: 16),

          // Score + total
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_scoreColor, _scoreColor.withOpacity(0.7)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Financial Health', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text(_scoreLabel, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Total spent: R${_totalSpend.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
                Text('Budget remaining: R${(2000 - _totalSpend).toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ])),
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Icon(
                  _totalSpend < 1600 ? Icons.sentiment_satisfied_alt : Icons.sentiment_dissatisfied,
                  color: Colors.white, size: 36,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // Budget progress bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Monthly Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('R${_totalSpend.toStringAsFixed(0)} / R2000',
                  style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (_totalSpend / 2000).clamp(0, 1),
                  minHeight: 12,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _totalSpend > 1800
                  ? '?? You are close to your budget limit!'
                  : _totalSpend > 1500
                    ? '?? You have used ${((_totalSpend / 2000) * 100).toStringAsFixed(0)}% of your budget'
                    : '? You are managing your budget well',
                style: TextStyle(fontSize: 12, color: _scoreColor, fontWeight: FontWeight.w500),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // Bar chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Spending Over Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _barData.map((b) {
                    final isCurrent = b['current'] == true;
                    final height = ((b['amount'] as int) / _maxBar) * 110;
                    return Expanded(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        if (isCurrent)
                          Text('R${b['amount']}',
                            style: const TextStyle(fontSize: 9, color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          height: height,
                          decoration: BoxDecoration(
                            color: isCurrent ? AppColors.primary : const Color(0xFFFFCDD2),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(b['month'], style: TextStyle(fontSize: 10,
                          color: isCurrent ? AppColors.primary : AppColors.textGrey,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal)),
                      ]),
                    ));
                  }).toList(),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // Category breakdown
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Spending by Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              ..._categorySpend.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(children: [
                  Row(children: [
                    Container(width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: (c['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(c['icon'] as IconData, color: c['color'] as Color, size: 18)),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(c['label'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                        Text('R${(c['amount'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ]),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: c['pct'] as double,
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(c['color'] as Color),
                        ),
                      ),
                    ])),
                  ]),
                ]),
              )),
            ]),
          ),
          const SizedBox(height: 16),

          // Insights
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Smart Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              _Insight(icon: Icons.trending_up, color: Colors.orange,
                text: 'Your grocery spend is 28% of total. Consider meal planning to reduce this.'),
              _Insight(icon: Icons.lightbulb_outline, color: Colors.blue,
                text: 'You spent R45 on transport this week. Carpooling could save you R200/month.'),
              _Insight(icon: Icons.savings_outlined, color: Colors.green,
                text: 'You have R490 left this month. Consider saving R200 towards your goals.'),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/support'),
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: const Text('Ask AI for budgeting advice'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
            ]),
          ),

          // Recent transactions
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                TextButton(onPressed: () => context.go('/transactions'),
                  child: const Text('View all', style: TextStyle(color: AppColors.primary, fontSize: 12))),
              ]),
              ..._transactions.map((t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  CircleAvatar(radius: 16,
                    backgroundColor: (t['positive'] as bool) ? Colors.green.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                    child: Icon((t['positive'] as bool) ? Icons.arrow_downward : Icons.arrow_upward,
                      size: 14, color: (t['positive'] as bool) ? Colors.green : AppColors.primary)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(t['label'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    Text(t['category'], style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${(t['amount'] as double) > 0 ? '+' : ''}${(t['amount'] as double).toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                        color: (t['positive'] as bool) ? Colors.green : AppColors.primary)),
                    Text(t['date'], style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                  ]),
                ]),
              )),
            ]),
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _Insight extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _Insight({required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 30, height: 30,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textGrey, height: 1.5))),
      ]),
    );
  }
}
