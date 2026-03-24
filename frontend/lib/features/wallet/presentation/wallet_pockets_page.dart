import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class AppColors {
  static const primary = Color(0xFFE30613);
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
class _Pocket {
  final String id;
  final String name;
  final String cardNumber;
  final String expiry;
  final double balance;
  final Color cardColor;
  final Color cardColorEnd;
  final List<_PocketTransaction> transactions;

  const _Pocket({
    required this.id,
    required this.name,
    required this.cardNumber,
    required this.expiry,
    required this.balance,
    required this.cardColor,
    required this.cardColorEnd,
    required this.transactions,
  });
}

class _PocketTransaction {
  final String label;
  final double amount;
  final bool isCredit;
  final String date;
  const _PocketTransaction(this.label, this.amount, this.isCredit, this.date);
}

final _pockets = [
  _Pocket(
    id: 'saving',
    name: 'Saving Pocket',
    cardNumber: '2015 1320 8870 2351',
    expiry: '09/30',
    balance: 190.00,
    cardColor: const Color(0xFF1A1A1A),
    cardColorEnd: const Color(0xFF3A3A3A),
    transactions: const [
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Balance Changed', 20.00, false, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
    ],
  ),
  _Pocket(
    id: 'transport',
    name: 'Transport Pocket',
    cardNumber: '1202 1320 8870 2351',
    expiry: '09/30',
    balance: 100.00,
    cardColor: const Color(0xFF1A3A8F),
    cardColorEnd: const Color(0xFF3B5BD5),
    transactions: const [
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Balance Changed', 20.00, false, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
    ],
  ),
  _Pocket(
    id: 'grocery',
    name: 'Grocery Pocket',
    cardNumber: '0057 0120 8870 0234',
    expiry: '09/30',
    balance: 120.00,
    cardColor: const Color(0xFF1A3A8F),
    cardColorEnd: const Color(0xFF2B4EC7),
    transactions: const [
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Balance Changed', 20.00, false, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
    ],
  ),
  _Pocket(
    id: 'accommodation',
    name: 'Accommodation Pocket',
    cardNumber: '0587 1320 8870 5723',
    expiry: '09/30',
    balance: 200.00,
    cardColor: const Color(0xFF555555),
    cardColorEnd: const Color(0xFF888888),
    transactions: const [
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Balance Changed', 20.00, false, '26/8/2025, 3:07 PM'),
      _PocketTransaction('Top up to balance', 100.00, true, '26/8/2025, 3:07 PM'),
    ],
  ),
];

// ─────────────────────────────────────────────
// WALLET POCKETS PAGE
// ─────────────────────────────────────────────
class WalletPocketsPage extends StatefulWidget {
  const WalletPocketsPage({super.key});

  @override
  State<WalletPocketsPage> createState() => _WalletPocketsPageState();
}

class _WalletPocketsPageState extends State<WalletPocketsPage> {
  int _selectedIndex = 0;
  bool _balanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final pocket = _pockets[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1A1A1A), size: 18),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          pocket.name,
          style: const TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1A1A1A)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal pocket selector tabs
          Container(
            color: Colors.white,
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _pockets.length + 1,
              itemBuilder: (_, i) {
                if (i == _pockets.length) {
                  return GestureDetector(
                    onTap: () => _showAddPocketSheet(context),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFDDDDDD)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, size: 14, color: Color(0xFF777777)),
                          SizedBox(width: 4),
                          Text('Add', style: TextStyle(fontSize: 12, color: Color(0xFF777777), fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                }
                final selected = i == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _pockets[i].name.replaceAll(' Pocket', ''),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : const Color(0xFF777777),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Card
                  _PocketCard(pocket: pocket, balanceVisible: _balanceVisible, onToggleBalance: () => setState(() => _balanceVisible = !_balanceVisible)),

                  const SizedBox(height: 16),

                  // Available Balance Row
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Available Balance', style: TextStyle(fontSize: 11, color: Color(0xFF888888))),
                            Text(
                              _balanceVisible ? 'R${pocket.balance.toStringAsFixed(2)} ZAR' : 'R•••••',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A1A1A)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                          child: Icon(
                            _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF888888), size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _PocketAction(icon: Icons.send_rounded, label: 'Send Money', onTap: () {}),
                      _PocketAction(icon: Icons.call_received_rounded, label: 'Withdraw', onTap: () {}),
                      _PocketAction(icon: Icons.swap_horiz_rounded, label: 'Transfer', onTap: () {}),
                      _PocketAction(icon: Icons.more_horiz_rounded, label: 'More', onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Transactions header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transactions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                      GestureDetector(
                        onTap: () {},
                        child: const Row(
                          children: [
                            Text('View all', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w600)),
                            SizedBox(width: 2),
                            Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Transactions list
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                    ),
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: pocket.transactions.length,
                      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56, endIndent: 16, color: Color(0xFFF0F0F0)),
                      itemBuilder: (_, i) {
                        final tx = pocket.transactions[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 36, height: 36,
                                decoration: BoxDecoration(
                                  color: tx.isCredit ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  tx.isCredit ? Icons.check_circle_outline : Icons.remove_circle_outline,
                                  size: 18,
                                  color: tx.isCredit ? const Color(0xFF388E3C) : AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                                    Text(tx.date, style: const TextStyle(fontSize: 11, color: Color(0xFF999999))),
                                  ],
                                ),
                              ),
                              Text(
                                '${tx.isCredit ? '+' : '-'}R${tx.amount.toStringAsFixed(2)} ZAR',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: tx.isCredit ? const Color(0xFF388E3C) : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPocketSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create New Pocket', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            for (final name in ['Data Pocket', 'Entertainment Pocket', 'Books Pocket', 'Emergency Pocket'])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.add_card_outlined, color: AppColors.primary, size: 20),
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                trailing: const Icon(Icons.chevron_right, size: 16),
                onTap: () => Navigator.pop(context),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// POCKET CARD WIDGET
// ─────────────────────────────────────────────
class _PocketCard extends StatelessWidget {
  final _Pocket pocket;
  final bool balanceVisible;
  final VoidCallback onToggleBalance;

  const _PocketCard({required this.pocket, required this.balanceVisible, required this.onToggleBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [pocket.cardColor, pocket.cardColorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: pocket.cardColor.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30, right: -20,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            bottom: -40, right: 40,
            child: Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo chip
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('G', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                    // Mastercard logo
                    Row(
                      children: [
                        Container(width: 26, height: 26, decoration: const BoxDecoration(color: Color(0xFFEB001B), shape: BoxShape.circle)),
                        Transform.translate(
                          offset: const Offset(-10, 0),
                          child: Container(
                            width: 26, height: 26,
                            decoration: BoxDecoration(color: const Color(0xFFF79E1B).withOpacity(0.9), shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Chip
                Container(
                  width: 34, height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4B068),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomPaint(painter: _ChipPainter()),
                ),

                const Spacer(),

                Text(
                  pocket.cardNumber,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 2),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(pocket.expiry, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    const Spacer(),
                    Text(
                      pocket.name,
                      style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB8964A)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), paint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────
// POCKET ACTION BUTTON
// ─────────────────────────────────────────────
class _PocketAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _PocketAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF555555)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}