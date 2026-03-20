import 'package:flutter/material.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Gude Wallet',
          style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Budget'),
            Tab(text: 'Savings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _WalletOverview(),
          _BudgetPlanner(),
          _SavingsGoals(),
        ],
      ),
    );
  }
}

class _WalletOverview extends StatelessWidget {
  const _WalletOverview();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Balance card
          Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Column(
              children: [
                const Text('Total Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                const Text('R 0.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BalanceStat(label: 'Income', value: 'R 0.00',
                      icon: Icons.trending_up),
                    Container(width: 1, height: 40,
                      color: Colors.white30),
                    _BalanceStat(label: 'Spent', value: 'R 0.00',
                      icon: Icons.trending_down),
                  ],
                ),
              ],
            ),
          ),
          // Action buttons
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _WalletAction(icon: Icons.send_outlined,
                  label: 'Send', onTap: () {}),
                _WalletAction(icon: Icons.call_received_outlined,
                  label: 'Receive', onTap: () {}),
                _WalletAction(icon: Icons.account_balance_outlined,
                  label: 'Withdraw', onTap: () {}),
                _WalletAction(icon: Icons.add_card_outlined,
                  label: 'Top Up', onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Alert
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFB800)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_outlined,
                  color: Color(0xFFFFB800), size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'You may run out of funds before the end of the month.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF856404)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Transactions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions',
                  style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all',
                    style: TextStyle(color: AppColors.primary))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            child: const _TransactionList(),
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _BalanceStat({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _WalletAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _WalletAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(
            fontSize: 12, color: AppColors.textDark,
            fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    const txns = [
      _Txn(title: 'Maths Tutoring', sub: 'Marketplace', amount: '+R150',
        icon: Icons.school_outlined, isCredit: true),
      _Txn(title: 'Checkers Food', sub: 'Food', amount: '-R89',
        icon: Icons.shopping_bag_outlined, isCredit: false),
      _Txn(title: 'Taxi to Campus', sub: 'Transport', amount: '-R25',
        icon: Icons.directions_bus_outlined, isCredit: false),
      _Txn(title: 'Print Shop', sub: 'Printing', amount: '-R15',
        icon: Icons.print_outlined, isCredit: false),
    ];
    return Column(
      children: txns.map((t) => ListTile(
        leading: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: t.isCredit
              ? const Color(0xFFE8F5E9)
              : AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(t.icon,
            color: t.isCredit ? Colors.green : AppColors.textGrey,
            size: 18),
        ),
        title: Text(t.title,
          style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500,
            color: AppColors.textDark)),
        subtitle: Text(t.sub,
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        trailing: Text(t.amount,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: t.isCredit ? Colors.green : AppColors.textDark,
          )),
      )).toList(),
    );
  }
}

class _Txn {
  final String title, sub, amount;
  final IconData icon;
  final bool isCredit;
  const _Txn({required this.title, required this.sub, required this.amount,
    required this.icon, required this.isCredit});
}

class _BudgetPlanner extends StatefulWidget {
  const _BudgetPlanner();
  @override
  State<_BudgetPlanner> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<_BudgetPlanner> {
  final _budgets = {
    'Food': 800.0, 'Transport': 400.0,
    'Data': 200.0, 'Books': 300.0, 'Savings': 500.0,
  };
  final _spent = {
    'Food': 450.0, 'Transport': 150.0,
    'Data': 100.0, 'Books': 300.0, 'Savings': 0.0,
  };
  final _icons = {
    'Food': Icons.fastfood_outlined,
    'Transport': Icons.directions_bus_outlined,
    'Data': Icons.wifi_outlined,
    'Books': Icons.menu_book_outlined,
    'Savings': Icons.savings_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Monthly Budget',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('R 2,200.00',
                    style: TextStyle(color: Colors.white,
                      fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Remaining',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('R 950.00',
                    style: TextStyle(color: Colors.white,
                      fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Budget Categories',
            style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold,
              color: AppColors.textDark)),
          const SizedBox(height: 12),
          ..._budgets.entries.map((e) {
            final spent = _spent[e.key]!;
            final budget = e.value;
            final progress = (spent / budget).clamp(0.0, 1.0);
            final isOver = spent >= budget;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_icons[e.key],
                          color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(e.key,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                      ),
                      Text('R${spent.toInt()} / R${budget.toInt()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isOver ? AppColors.primary : AppColors.textGrey,
                          fontWeight: isOver ? FontWeight.bold : FontWeight.normal,
                        )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isOver ? AppColors.primary : Colors.green),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SavingsGoals extends StatelessWidget {
  const _SavingsGoals();

  @override
  Widget build(BuildContext context) {
    const goals = [
      _Goal(name: 'Laptop', target: 8000, saved: 2500,
        icon: Icons.laptop_outlined),
      _Goal(name: 'Accommodation Deposit', target: 5000, saved: 1000,
        icon: Icons.home_outlined),
      _Goal(name: 'Registration Fees', target: 3500, saved: 3500,
        icon: Icons.school_outlined),
    ];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ...goals.map((g) {
            final progress = (g.saved / g.target).clamp(0.0, 1.0);
            final done = g.saved >= g.target;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          color: done
                            ? Colors.green.withOpacity(0.1)
                            : AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(done ? Icons.check_circle_outline : g.icon,
                          color: done ? Colors.green : AppColors.primary,
                          size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark)),
                            Text('R${g.saved} of R${g.target}',
                              style: const TextStyle(
                                fontSize: 12, color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      Text('${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: done ? Colors.green : AppColors.primary,
                        )),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AppColors.surface,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        done ? Colors.green : AppColors.primary),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text('Add New Goal',
              style: TextStyle(color: AppColors.primary,
                fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Goal {
  final String name;
  final int target, saved;
  final IconData icon;
  const _Goal({required this.name, required this.target,
    required this.saved, required this.icon});
}
