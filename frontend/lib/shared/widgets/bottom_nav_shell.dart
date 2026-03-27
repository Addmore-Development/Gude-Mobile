// lib/shared/widgets/bottom_nav_shell.dart
// Student bottom nav — includes Messages tab and Community tab
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  static const _tabs = [
    _Tab('/home',        Icons.home_outlined,            Icons.home_rounded,            'Home'),
    _Tab('/marketplace', Icons.storefront_outlined,       Icons.storefront_rounded,      'Market'),
    _Tab('/wallet',      Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Wallet'),
    _Tab('/messages',    Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded,   'Messages'),
    _Tab('/community',   Icons.groups_outlined,           Icons.groups_rounded,          'Community'),
    _Tab('/stability',   Icons.favorite_outline,          Icons.favorite_rounded,        'Stability'),
    _Tab('/profile',     Icons.person_outline_rounded,    Icons.person_rounded,          'Profile'),
  ];

  int _activeIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexWhere((t) => loc.startsWith(t.path));
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeIndex(context);
    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 62,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final tab = _tabs[i];
              final sel = i == active;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.go(tab.path),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        sel ? tab.activeIcon : tab.icon,
                        size: 22,
                        color: sel ? const Color(0xFFE30613) : const Color(0xFF888888),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          color: sel ? const Color(0xFFE30613) : const Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final String path, label;
  final IconData icon, activeIcon;
  const _Tab(this.path, this.icon, this.activeIcon, this.label);
}