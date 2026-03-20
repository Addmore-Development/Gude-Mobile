import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  int _index(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/home') || loc.startsWith('/marketplace')) return 0;
    if (loc.startsWith('/wallet'))    return 1;
    if (loc.startsWith('/support'))   return 2;
    if (loc.startsWith('/stability')) return 3;
    if (loc.startsWith('/profile'))   return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index(context),
        indicatorColor: AppColors.primary.withOpacity(0.1),
        onDestinationSelected: (i) {
          switch (i) {
            case 0: context.go('/marketplace'); break;
            case 1: context.go('/wallet');      break;
            case 2: context.go('/support');     break;
            case 3: context.go('/stability');   break;
            case 4: context.go('/profile');     break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: AppColors.primary),
            label: 'Market'),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet,
              color: AppColors.primary),
            label: 'Wallet'),
          NavigationDestination(
            icon: Icon(Icons.support_agent_outlined),
            selectedIcon: Icon(Icons.support_agent, color: AppColors.primary),
            label: 'Support'),
          NavigationDestination(
            icon: Icon(Icons.monitor_heart_outlined),
            selectedIcon: Icon(Icons.monitor_heart, color: AppColors.primary),
            label: 'Stability'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: AppColors.primary),
            label: 'Profile'),
        ],
      ),
    );
  }
}
