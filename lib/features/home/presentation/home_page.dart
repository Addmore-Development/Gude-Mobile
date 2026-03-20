import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';
import 'package:gude_mobile/core/utils/responsive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: R.h(56),
        title: Row(children: [
          CircleAvatar(radius: R.w(18), backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: R.w(18))),
          SizedBox(width: R.w(10)),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Good morning,', style: TextStyle(fontSize: R.sp(11), color: AppColors.textGrey)),
            Text('Student', style: TextStyle(fontSize: R.sp(14), fontWeight: FontWeight.bold, color: AppColors.textDark)),
          ]),
        ]),
        actions: [
          IconButton(icon: Icon(Icons.notifications_outlined, size: R.w(22), color: AppColors.textDark), onPressed: () {}),
          IconButton(icon: Icon(Icons.logout, size: R.w(22), color: AppColors.textDark),
            onPressed: () => context.go('/login')),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(R.w(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Stability Score Banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(R.w(16)),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8453C), Color(0xFFFF7043)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(R.w(16)),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Your Stability Score', style: TextStyle(color: Colors.white70, fontSize: R.sp(12))),
                SizedBox(height: R.h(4)),
                Row(children: [
                  Container(width: R.w(12), height: R.w(12),
                    decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                  SizedBox(width: R.w(6)),
                  Text('Stable', style: TextStyle(color: Colors.white, fontSize: R.sp(20), fontWeight: FontWeight.bold)),
                ]),
                SizedBox(height: R.h(6)),
                Text('Keep it up! Your finances look healthy.',
                  style: TextStyle(color: Colors.white70, fontSize: R.sp(12))),
              ])),
              GestureDetector(
                onTap: () => context.go('/stability'),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: R.w(12), vertical: R.h(8)),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(R.w(8)),
                  ),
                  child: Text('View', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: R.sp(13))),
                ),
              ),
            ]),
          ),
          SizedBox(height: R.h(16)),

          // Wallet card
          GestureDetector(
            onTap: () => context.go('/wallet'),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(R.w(20)),
              decoration: BoxDecoration(
                color: const Color(0xFF1A237E),
                borderRadius: BorderRadius.circular(R.w(16)),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Gude Wallet', style: TextStyle(color: Colors.white70, fontSize: R.sp(13))),
                  Icon(Icons.account_balance_wallet, color: Colors.white70, size: R.w(20)),
                ]),
                SizedBox(height: R.h(8)),
                Text('R190.00 ZAR', style: TextStyle(color: Colors.white, fontSize: R.sp(28), fontWeight: FontWeight.bold)),
                SizedBox(height: R.h(16)),
                Row(children: [
                  _WalletAction(icon: Icons.send,        label: 'Send',     onTap: () => context.go('/send-money')),
                  _WalletAction(icon: Icons.download,    label: 'Withdraw', onTap: () => context.go('/withdraw')),
                  _WalletAction(icon: Icons.swap_horiz,  label: 'Transfer', onTap: () {}),
                  _WalletAction(icon: Icons.more_horiz,  label: 'More',     onTap: () => context.go('/quick-actions')),
                ]),
              ]),
            ),
          ),
          SizedBox(height: R.h(20)),

          // Quick access
          Text('Quick Access', style: TextStyle(fontWeight: FontWeight.bold, fontSize: R.sp(15))),
          SizedBox(height: R.h(12)),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: R.w(8),
            mainAxisSpacing: R.h(8),
            childAspectRatio: 1,
            children: [
              _NavTile(icon: Icons.storefront_outlined,             label: 'Market',     color: const Color(0xFFE3F2FD), iconColor: Colors.blue,        onTap: () => context.go('/marketplace')),
              _NavTile(icon: Icons.account_balance_wallet_outlined, label: 'Wallet',     color: const Color(0xFFFCE4EC), iconColor: AppColors.primary,   onTap: () => context.go('/wallet')),
              _NavTile(icon: Icons.monitor_heart_outlined,          label: 'Stability',  color: const Color(0xFFE8F5E9), iconColor: Colors.green,        onTap: () => context.go('/stability')),
              _NavTile(icon: Icons.support_agent_outlined,          label: 'Support',    color: const Color(0xFFFFF3E0), iconColor: Colors.orange,       onTap: () => context.go('/support')),
              _NavTile(icon: Icons.shopping_bag_outlined,           label: 'Cart',       color: const Color(0xFFF3E5F5), iconColor: Colors.purple,       onTap: () => context.go('/cart')),
              _NavTile(icon: Icons.receipt_long_outlined,           label: 'Txns',       color: const Color(0xFFE0F2F1), iconColor: Colors.teal,         onTap: () => context.go('/transactions')),
              _NavTile(icon: Icons.savings_outlined,                label: 'Savings',    color: const Color(0xFFFFF8E1), iconColor: Colors.amber,        onTap: () => context.go('/wallet')),
              _NavTile(icon: Icons.people_outline,                  label: 'Community',  color: const Color(0xFFE8EAF6), iconColor: Colors.indigo,       onTap: () {}),
            ],
          ),
          SizedBox(height: R.h(20)),

          // Recent transactions
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: R.sp(15))),
            TextButton(onPressed: () => context.go('/transactions'),
              child: Text('View all >', style: TextStyle(color: AppColors.primary, fontSize: R.sp(13)))),
          ]),
          SizedBox(height: R.h(8)),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(R.w(12))),
            child: Column(children: [
              _TxRow(label: 'Top up to balance', amount: '+R190.00', date: '20 Mar', positive: true),
              const Divider(height: 1, indent: 16),
              _TxRow(label: 'Balance Changed',   amount: '-R20.00',  date: '19 Mar', positive: false),
              const Divider(height: 1, indent: 16),
              _TxRow(label: 'Top up to balance', amount: '+R190.00', date: '18 Mar', positive: true),
            ]),
          ),
          SizedBox(height: R.h(20)),

          // Marketplace spotlight
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Marketplace Spotlight', style: TextStyle(fontWeight: FontWeight.bold, fontSize: R.sp(15))),
            TextButton(onPressed: () => context.go('/marketplace'),
              child: Text('View all >', style: TextStyle(color: AppColors.primary, fontSize: R.sp(13)))),
          ]),
          SizedBox(height: R.h(8)),
          SizedBox(
            height: R.h(160),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _SpotlightCard(name: 'Macbook Pro 16', price: 'R20.90',   badge: '15%'),
                _SpotlightCard(name: 'iPhone 14',      price: 'R999.00',  badge: '20%'),
                _SpotlightCard(name: 'AirPods Pro',    price: 'R299.00',  badge: null),
                _SpotlightCard(name: 'Meitorp',        price: 'R2500.90', badge: null),
              ],
            ),
          ),
          SizedBox(height: R.h(80)),
        ]),
      ),
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
    R.init(context);
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: R.w(40), height: R.w(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(R.w(10)),
          ),
          child: Icon(icon, color: Colors.white, size: R.w(20)),
        ),
        SizedBox(height: R.h(4)),
        Text(label, style: TextStyle(color: Colors.white70, fontSize: R.sp(10))),
      ]),
    ));
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color, iconColor;
  final VoidCallback onTap;
  const _NavTile({required this.icon, required this.label, required this.color, required this.iconColor, required this.onTap});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(R.w(12))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: iconColor, size: R.w(26)),
          SizedBox(height: R.h(4)),
          Text(label, style: TextStyle(fontSize: R.sp(10), color: iconColor, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final String label, amount, date;
  final bool positive;
  const _TxRow({required this.label, required this.amount, required this.date, required this.positive});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: R.w(16), vertical: R.h(12)),
      child: Row(children: [
        CircleAvatar(radius: R.w(16),
          backgroundColor: positive ? Colors.green : AppColors.primary,
          child: Icon(positive ? Icons.arrow_downward : Icons.arrow_upward,
            color: Colors.white, size: R.w(14))),
        SizedBox(width: R.w(12)),
        Expanded(child: Text(label, style: TextStyle(fontSize: R.sp(13), fontWeight: FontWeight.w500))),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: R.sp(13),
            color: positive ? Colors.green : AppColors.primary)),
          Text(date, style: TextStyle(fontSize: R.sp(10), color: AppColors.textGrey)),
        ]),
      ]),
    );
  }
}

class _SpotlightCard extends StatelessWidget {
  final String name, price;
  final String? badge;
  const _SpotlightCard({required this.name, required this.price, this.badge});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Container(
      width: R.w(120),
      margin: EdgeInsets.only(right: R.w(12)),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(R.w(12))),
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(R.w(12)))),
              child: Center(child: Icon(Icons.laptop_mac, size: R.w(40), color: Colors.grey)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(R.w(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: TextStyle(fontSize: R.sp(11), fontWeight: FontWeight.w600),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(price, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: R.sp(12))),
            ]),
          ),
        ]),
        if (badge != null)
          Positioned(top: R.h(6), left: R.w(6),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: R.w(5), vertical: R.h(2)),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(R.w(4))),
              child: Text(badge!, style: TextStyle(color: Colors.white, fontSize: R.sp(9))),
            )),
      ]),
    );
  }
}
