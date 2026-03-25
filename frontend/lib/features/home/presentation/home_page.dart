import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/core/state/financial_health.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ── Avatar menu — profile / logout ──────────────────────────────
  void _showAvatarMenu(BuildContext context) {
    final RenderBox button =
        context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()
            as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomLeft(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: const [
              Icon(Icons.person_outline_rounded,
                  size: 18, color: Color(0xFF1A1A1A)),
              SizedBox(width: 10),
              Text('My Profile',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'logout',
          child: Row(
            children: const [
              Icon(Icons.logout_rounded, size: 18, color: Color(0xFFE30613)),
              SizedBox(width: 10),
              Text('Log Out',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE30613))),
            ],
          ),
        ),
      ],
    ).then((val) {
      if (val == 'profile') {
        context.push('/profile');
      } else if (val == 'logout') {
        _showLogoutDialog(context);
      }
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(fontSize: 14, color: Color(0xFF555555))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Color(0xFF888888), fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE30613),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: const Text('Log Out',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(FinancialHealth.badgeColorValue);
    final isAlert    = FinancialHealth.needsAlert;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('G',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
            ),
            const SizedBox(width: 8),
            const Text('Gude',
                style: TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.textDark),
            onPressed: () {},
          ),
          // ── Tappable avatar with popup menu ──────────────
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(
              builder: (btnCtx) => GestureDetector(
                onTap: () => _showAvatarMenu(btnCtx),
                child: Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text('S',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ),
                      // Small dropdown indicator
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 12, height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primary, width: 1.5),
                          ),
                          child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 8,
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome card ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isAlert
                    ? const Color(0xFFB91C1C)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Welcome back, Student 👋',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    FinancialHealth.homepageSubtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => context.go('/wallet'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle,
                              color: badgeColor, size: 10),
                          const SizedBox(width: 6),
                          Text(
                            '${FinancialHealth.emoji}  ${FinancialHealth.statusBadge}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.chevron_right,
                              color: Colors.white70, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── At-risk nudge banner ───────────────────
            if (FinancialHealth.needsWarning) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.go('/wallet'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isAlert
                        ? const Color(0xFFFFF1F1)
                        : const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isAlert
                          ? const Color(0xFFEF4444).withOpacity(0.4)
                          : const Color(0xFFFFD700).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: isAlert
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          isAlert
                              ? 'Financial health is critical. Tap to review your wallet.'
                              : 'Your spending is over budget. Tap to manage.',
                          style: TextStyle(
                            color: isAlert
                                ? const Color(0xFF7F1D1D)
                                : const Color(0xFF92400E),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('View →',
                          style: TextStyle(
                              color: isAlert
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFFE30613),
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ── Quick actions ──────────────────────────
            const Text('Quick Actions',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            Row(
              children: [
                _QuickAction(
                    icon: Icons.storefront_outlined,
                    label: 'Marketplace',
                    color: const Color(0xFF6C63FF),
                    onTap: () => context.go('/marketplace')),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet',
                    color: AppColors.primary,
                    onTap: () => context.go('/wallet')),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.support_agent_outlined,
                    label: 'Support',
                    color: const Color(0xFF00C896),
                    onTap: () => context.go('/support')),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.monitor_heart_outlined,
                    label: 'Stability',
                    color: const Color(0xFFFF9800),
                    onTap: () => context.go('/stability')),
              ],
            ),
            const SizedBox(height: 24),

            // ── Wallet summary ─────────────────────────
            const Text('Wallet Summary',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _WalletStat(
                      label: 'Balance',
                      value:
                          'R ${(FinancialHealth.income - FinancialHealth.totalSpent).toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet_outlined),
                  Container(
                      width: 1,
                      height: 40,
                      color: AppColors.inputBorder),
                  _WalletStat(
                      label: 'Earned',
                      value:
                          'R ${FinancialHealth.income.toStringAsFixed(2)}',
                      icon: Icons.trending_up),
                  Container(
                      width: 1,
                      height: 40,
                      color: AppColors.inputBorder),
                  _WalletStat(
                      label: 'Spent',
                      value:
                          'R ${FinancialHealth.totalSpent.toStringAsFixed(2)}',
                      icon: Icons.shopping_bag_outlined),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Recent activity ────────────────────────
            const Text('Recent Activity',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined,
                        size: 48, color: AppColors.textGrey),
                    SizedBox(height: 12),
                    Text('No activity yet',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Start by browsing the marketplace',
                        style: TextStyle(
                            color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _WalletStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.textDark)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textGrey)),
      ],
    );
  }
}