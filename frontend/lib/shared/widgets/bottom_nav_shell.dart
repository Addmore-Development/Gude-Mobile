import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// BOTTOM NAV SHELL
// lib/shared/widgets/bottom_nav_shell.dart
//
// isBuyer: true  → shows only Marketplace + Profile
// isBuyer: false → shows all 6 student tabs
// ─────────────────────────────────────────────

class BottomNavShell extends StatelessWidget {
  final Widget child;
  final bool isBuyer;

  const BottomNavShell({
    super.key,
    required this.child,
    this.isBuyer = false,
  });

  static const _studentItems = [
    _NavItem(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        path: '/home'),
    _NavItem(
        label: 'Marketplace',
        icon: Icons.storefront_outlined,
        activeIcon: Icons.storefront_rounded,
        path: '/marketplace'),
    _NavItem(
        label: 'Wallet',
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet_rounded,
        path: '/wallet'),
    _NavItem(
        label: 'Support',
        icon: Icons.headset_mic_outlined,
        activeIcon: Icons.headset_mic_rounded,
        path: '/support'),
    _NavItem(
        label: 'Stability',
        icon: Icons.self_improvement_outlined,
        activeIcon: Icons.self_improvement_rounded,
        path: '/stability'),
    _NavItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        path: '/profile'),
  ];

  // Buyers only see Marketplace and Profile
  static const _buyerItems = [
    _NavItem(
        label: 'Marketplace',
        icon: Icons.storefront_outlined,
        activeIcon: Icons.storefront_rounded,
        path: '/buyer/marketplace'),
    _NavItem(
        label: 'Profile',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        path: '/buyer/profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final items = isBuyer ? _buyerItems : _studentItems;
    final location = GoRouterState.of(context).uri.toString();

    int currentIndex = items.indexWhere((e) => location.startsWith(e.path));
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          boxShadow: [
            BoxShadow(
                color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, -2))
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 62,
            child: Row(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final selected = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.go(item.path),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(selected ? item.activeIcon : item.icon,
                            size: 22,
                            color: selected
                                ? const Color(0xFFE30613)
                                : const Color(0xFF888888)),
                        const SizedBox(height: 3),
                        Text(item.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected
                                  ? const Color(0xFFE30613)
                                  : const Color(0xFF888888),
                            )),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label, path;
  final IconData icon, activeIcon;
  const _NavItem(
      {required this.label,
      required this.icon,
      required this.activeIcon,
      required this.path});
}
