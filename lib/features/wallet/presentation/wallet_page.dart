import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});
  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int _selectedPocket = 0;
  final List<Map<String, dynamic>> _pockets = [
    {'name': 'Saving Pocket',      'balance': 190.00, 'color': const Color(0xFF1A237E)},
    {'name': 'Transport Pocket',   'balance': 100.00, 'color': const Color(0xFF1565C0)},
    {'name': 'Grocery Pocket',     'balance': 120.00, 'color': const Color(0xFF2E7D32)},
    {'name': 'Accommodation',      'balance': 200.00, 'color': const Color(0xFF4A148C)},
  ];

  final List<Map<String, dynamic>> _transactions = [
    {'type': 'Top up to balance', 'amount': 190.00, 'date': '26/6/2025, 3:07 PM', 'positive': true},
    {'type': 'Balance Changed',   'amount': -20.00,  'date': '26/6/2025, 3:07 PM', 'positive': false},
    {'type': 'Top up to balance', 'amount': 190.00, 'date': '26/6/2025, 3:07 PM', 'positive': true},
    {'type': 'Balance Changed',   'amount': -20.00,  'date': '26/6/2025, 3:07 PM', 'positive': false},
    {'type': 'Top up to balance', 'amount': 190.00, 'date': '26/6/2025, 3:07 PM', 'positive': true},
    {'type': 'Balance Changed',   'amount': -20.00,  'date': '26/6/2025, 3:07 PM', 'positive': false},
  ];

  @override
  Widget build(BuildContext context) {
    final pocket = _pockets[_selectedPocket];
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          const CircleAvatar(radius: 16, backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 18)),
          const SizedBox(width: 8),
          Text(pocket['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark), onPressed: () {}),
          IconButton(icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () => context.go('/login')),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Card carousel
          SizedBox(
            height: 180,
            child: PageView.builder(
              onPageChanged: (i) => setState(() => _selectedPocket = i),
              itemCount: _pockets.length,
              padEnds: false,
              controller: PageController(viewportFraction: 0.85),
              itemBuilder: (_, i) => _WalletCard(pocket: _pockets[i], selected: i == _selectedPocket),
            ),
          ),
          const SizedBox(height: 12),
          // Available Balance
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.textDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text('R${pocket['balance'].toStringAsFixed(2)} ZAR',
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ]),
              const Icon(Icons.visibility_outlined, color: Colors.white70),
            ]),
          ),
          const SizedBox(height: 16),
          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _QuickAction(icon: Icons.send, label: 'Send Money', onTap: () => context.go('/send-money')),
              _QuickAction(icon: Icons.download, label: 'Withdraw', onTap: () => context.go('/withdraw')),
              _QuickAction(icon: Icons.swap_horiz, label: 'Transfer', onTap: () {}),
              _QuickAction(icon: Icons.more_horiz, label: 'More', onTap: () => context.go('/quick-actions')),
            ]),
          ),
          const SizedBox(height: 16),
          // Transactions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(onPressed: () => context.go('/transactions'),
                  child: const Text('View all >', style: TextStyle(color: AppColors.primary, fontSize: 13))),
              ]),
              ..._transactions.map((t) => _TransactionTile(transaction: t)),
            ]),
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final Map<String, dynamic> pocket;
  final bool selected;
  const _WalletCard({required this.pocket, required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: selected ? 0 : 8),
      decoration: BoxDecoration(
        color: pocket['color'],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Icon(Icons.credit_card, color: Colors.white70, size: 28),
          Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
            height: 28, errorBuilder: (_, __, ___) => const Icon(Icons.credit_card, color: Colors.white)),
        ]),
        const Spacer(),
        const Text('0015  1320  8870  2351',
          style: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 2)),
        const SizedBox(height: 4),
        const Text('09/30', style: TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        const Text('MR NB BALOY', style: TextStyle(color: Colors.white, fontSize: 12)),
      ]),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)],
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
      ]),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> transaction;
  const _TransactionTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final positive = transaction['positive'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: positive ? Colors.green : AppColors.primary,
          child: Icon(positive ? Icons.check : Icons.close, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(transaction['type'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          Text('${transaction['amount'].toStringAsFixed(2)} ZAR',
            style: TextStyle(fontSize: 13, color: positive ? Colors.green : AppColors.primary,
              fontWeight: FontWeight.bold)),
        ])),
        Text(transaction['date'], style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
      ]),
    );
  }
}
