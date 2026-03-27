// frontend/lib/shared/widgets/bottom_nav_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/services/user_role_service.dart';

class BottomNavShell extends StatelessWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final userService = UserRoleService();
    final isInstitution = userService.isInstitution;
    final isBuyer = userService.isBuyer;

    List<NavItem> getNavItems() {
      if (isInstitution) {
        return const [
          NavItem(
              icon: Icons.work_outline,
              label: 'Jobs',
              route: '/institution/marketplace'),
          NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              route: '/institution/profile'),
        ];
      } else if (isBuyer) {
        return const [
          NavItem(
              icon: Icons.storefront_outlined,
              label: 'Marketplace',
              route: '/buyer/marketplace'),
          NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              route: '/buyer/profile'),
        ];
      } else {
        // Student nav — includes Stability
        return const [
          NavItem(icon: Icons.home_outlined, label: 'Home', route: '/home'),
          NavItem(
              icon: Icons.storefront_outlined,
              label: 'Market',
              route: '/marketplace'),
          NavItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Wallet',
              route: '/wallet'),
          NavItem(
              icon: Icons.favorite_outline,
              label: 'Stability',
              route: '/stability'),
          NavItem(
              icon: Icons.person_outline, label: 'Profile', route: '/profile'),
        ];
      }
    }

    final navItems = getNavItems();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navItems
                  .map((item) => _NavItem(
                        icon: item.icon,
                        label: item.label,
                        route: item.route,
                        currentRoute: GoRouterState.of(context).uri.toString(),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String route;
  const NavItem({required this.icon, required this.label, required this.route});
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentRoute;

  const _NavItem(
      {required this.icon,
      required this.label,
      required this.route,
      required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final active = currentRoute == route ||
        (route != '/home' && currentRoute.startsWith(route));

    return GestureDetector(
      onTap: () => context.go(route),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFE30613).withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color:
                    active ? const Color(0xFFE30613) : const Color(0xFF9E9E9E),
                size: 22),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                  color: active
                      ? const Color(0xFFE30613)
                      : const Color(0xFF9E9E9E),
                )),
          ],
        ),
      ),
    );
  }
}
