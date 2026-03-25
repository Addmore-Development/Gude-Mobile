// ═══════════════════════════════════════════════════════════════
// bottom_nav_shell.dart
// Buyer users see only: Marketplace + Profile
// Student users see all tabs
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/services/user_role_service.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  // ── All student tabs ───────────────────────────────────────────
  static const _studentTabs = [
    _TabItem(path: '/home',        icon: Icons.home_outlined,            activeIcon: Icons.home_rounded,                label: 'Home'),
    _TabItem(path: '/marketplace', icon: Icons.storefront_outlined,      activeIcon: Icons.storefront_rounded,          label: 'Market'),
    _TabItem(path: '/wallet',      icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    _TabItem(path: '/messages',    icon: Icons.chat_bubble_outline_rounded,     activeIcon: Icons.chat_bubble_rounded,          label: 'Messages'),
    _TabItem(path: '/stability',   icon: Icons.monitor_heart_outlined,          activeIcon: Icons.monitor_heart_rounded,         label: 'Wellbeing'),
    _TabItem(path: '/profile',     icon: Icons.person_outline_rounded,          activeIcon: Icons.person_rounded,               label: 'Profile'),
  ];

  // ── Buyer tabs: marketplace + profile only ──────────────────────
  static const _buyerTabs = [
    _TabItem(path: '/marketplace', icon: Icons.storefront_outlined,  activeIcon: Icons.storefront_rounded,   label: 'Market'),
    _TabItem(path: '/buyer/profile', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isBuyer = UserRoleService().role == 'buyer';
    final tabs    = isBuyer ? _buyerTabs : _studentTabs;

    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexForLocation(tabs, location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 58,
            child: Row(
              children: tabs.asMap().entries.map((entry) {
                final i    = entry.key;
                final tab  = entry.value;
                final sel  = i == currentIndex;
                return Expanded(child: GestureDetector(
                  onTap: () => context.go(tab.path),
                  behavior: HitTestBehavior.opaque,
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: Icon(
                      sel ? tab.activeIcon : tab.icon,
                      key: ValueKey(sel),
                      size: 22,
                      color: sel ? const Color(0xFFE30613) : const Color(0xFF888888),
                    )),
                    const SizedBox(height: 3),
                    Text(tab.label, style: TextStyle(fontSize: 9, fontWeight: sel ? FontWeight.w700 : FontWeight.w500, color: sel ? const Color(0xFFE30613) : const Color(0xFF888888))),
                  ]),
                ));
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  int _indexForLocation(List<_TabItem> tabs, String location) {
    for (int i = tabs.length - 1; i >= 0; i--) {
      if (location.startsWith(tabs[i].path)) return i;
    }
    return 0;
  }
}

class _TabItem {
  final String path, label;
  final IconData icon, activeIcon;
  const _TabItem({required this.path, required this.icon, required this.activeIcon, required this.label});
}