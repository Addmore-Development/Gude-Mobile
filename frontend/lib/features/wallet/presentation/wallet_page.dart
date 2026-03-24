import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _balanceVisible = true;

  final List<_Transaction> _transactions = [
    _Transaction(
      title: 'Tutoring Session — James',
      amount: 150.00,
      isCredit: true,
      category: 'Marketplace',
      date: 'Today, 10:30',
      icon: Icons.school_outlined,
    ),
    _Transaction(
      title: 'Withdrawal to FNB',
      amount: 500.00,
      isCredit: false,
      category: 'Withdrawal',
      date: 'Today, 08:15',
      icon: Icons.arrow_upward_rounded,
    ),
    _Transaction(
      title: 'Design Work — Sipho',
      amount: 300.00,
      isCredit: true,
      category: 'Marketplace',
      date: 'Yesterday, 15:42',
      icon: Icons.brush_outlined,
    ),
    _Transaction(
      title: 'Budget: Food',
      amount: 85.00,
      isCredit: false,
      category: 'Budget',
      date: 'Yesterday, 12:10',
      icon: Icons.fastfood_outlined,
    ),
    _Transaction(
      title: 'Photography Gig — UCT',
      amount: 450.00,
      isCredit: true,
      category: 'Marketplace',
      date: 'Mon, 09:00',
      icon: Icons.camera_alt_outlined,
    ),
    _Transaction(
      title: 'Transport',
      amount: 35.00,
      isCredit: false,
      category: 'Budget',
      date: 'Mon, 07:30',
      icon: Icons.directions_bus_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Wallet',
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1A1A1A)),
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE30613).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Available Balance',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                              child: Icon(
                                _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: Colors.white70,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _balanceVisible ? 'R 2,450.00' : 'R ••••••',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _BalanceStat(
                              label: 'This Month In',
                              value: _balanceVisible ? '+R 900' : '••••',
                              icon: Icons.arrow_downward_rounded,
                              color: Colors.greenAccent,
                            ),
                            const SizedBox(width: 24),
                            _BalanceStat(
                              label: 'This Month Out',
                              value: _balanceVisible ? '-R 620' : '••••',
                              icon: Icons.arrow_upward_rounded,
                              color: Colors.orangeAccent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Quick Actions
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _QuickAction(
                        icon: Icons.send_rounded,
                        label: 'Send',
                        onTap: () => context.push('/wallet/send'),
                      ),
                      _QuickAction(
                        icon: Icons.call_received_rounded,
                        label: 'Receive',
                        onTap: () {},
                      ),
                      _QuickAction(
                        icon: Icons.account_balance_rounded,
                        label: 'Withdraw',
                        onTap: () => context.push('/wallet/withdraw'),
                      ),
                      _QuickAction(
                        icon: Icons.pie_chart_outline_rounded,
                        label: 'Budget',
                        onTap: () => context.push('/wallet/budget'),
                      ),
                      _QuickAction(
                        icon: Icons.savings_outlined,
                        label: 'Goals',
                        onTap: () => context.push('/wallet/savings'),
                      ),
                    ],
                  ),
                ),

                // Spending Alert
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 20),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'You\'ve used 78% of your Food budget this month.',
                          style: TextStyle(
                            color: Color(0xFF92400E),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/wallet/budget'),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            color: Color(0xFFE30613),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Transactions Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/wallet/transactions'),
                        child: const Text(
                          'See all',
                          style: TextStyle(
                            color: Color(0xFFE30613),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Transaction List
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _transactions.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 64,
                      endIndent: 16,
                      color: Color(0xFFF0F0F0),
                    ),
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      return _TransactionTile(tx: tx);
                    },
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _BalanceStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: const Color(0xFFE30613), size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
        ],
      ),
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tx.isCredit
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              tx.icon,
              size: 18,
              color: tx.isCredit ? const Color(0xFF388E3C) : const Color(0xFFF57C00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  tx.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${tx.isCredit ? '+' : '-'}R ${tx.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: tx.isCredit ? const Color(0xFF388E3C) : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}

class _Transaction {
  final String title;
  final double amount;
  final bool isCredit;
  final String category;
  final String date;
  final IconData icon;

  const _Transaction({
    required this.title,
    required this.amount,
    required this.isCredit,
    required this.category,
    required this.date,
    required this.icon,
  });
}