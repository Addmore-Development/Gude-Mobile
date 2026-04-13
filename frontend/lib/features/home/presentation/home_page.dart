// lib/features/home/presentation/home_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/core/state/financial_health.dart';
import 'package:gude_app/services/user_role_service.dart';
import 'package:gude_app/features/chatbot/presentation/ai_coach_overlay.dart';
import 'package:gude_app/features/chatbot/services/ai_coach_service.dart';

// ─── Available quick actions catalogue ────────────────────────────────────────
class _ActionDef {
  final String id, label;
  final IconData icon;
  final String route;
  const _ActionDef(this.id, this.label, this.icon, this.route);
}

const _kAllActions = [
  _ActionDef('marketplace', 'Browse\nMarket', Icons.storefront_outlined,
      '/marketplace'),
  _ActionDef('create', 'Create\nListing', Icons.add_circle_outline,
      '/marketplace/create'),
  _ActionDef('send', 'Send\nMoney', Icons.send_outlined, '/wallet/send'),
  _ActionDef(
      'support', 'Support\nHub', Icons.support_agent_outlined, '/support'),
  _ActionDef('stability', 'Stability', Icons.favorite_outline, '/stability'),
  _ActionDef(
      'wallet', 'My Wallet', Icons.account_balance_wallet_outlined, '/wallet'),
  _ActionDef(
      'notices', 'Notice\nBoard', Icons.campaign_outlined, '/noticeboard'),
  _ActionDef('profile', 'My Profile', Icons.person_outline_rounded, '/profile'),
];

// ─── HomePage ─────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Default: only Notice Board pinned — user can add more via Customise
  List<String> _pinnedIds = ['notices'];
  bool _fabExpanded = false;
  bool _walletRevealed = false;

  void _showLogoutDialog() {
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
              final nav = GoRouter.of(context);
              UserRoleService().clear();
              Navigator.pop(context);
              Future.microtask(() => nav.go('/login'));
            },
            child: const Text('Log Out',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // Avatar dropdown now includes all former hamburger items too
  void _showAvatarMenu(BuildContext btnCtx) {
    final RenderBox button = btnCtx.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(btnCtx).overlay!.context.findRenderObject() as RenderBox;
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
      context: btnCtx,
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
        PopupMenuItem<String>(
          value: 'support',
          child: Row(
            children: const [
              Icon(Icons.support_agent_outlined,
                  size: 18, color: Color(0xFF1A1A1A)),
              SizedBox(width: 10),
              Text('Support Hub',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: Row(
            children: const [
              Icon(Icons.settings_outlined,
                  size: 18, color: Color(0xFF1A1A1A)),
              SizedBox(width: 10),
              Text('Settings',
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
      if (val == 'profile') context.push('/profile');
      if (val == 'support') context.push('/support');
      if (val == 'settings') context.push('/settings');
      if (val == 'logout') _showLogoutDialog();
    });
  }

  void _showCustomiseActions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _CustomiseActionsSheet(
        pinnedIds: List.from(_pinnedIds),
        onSave: (ids) => setState(() => _pinnedIds = ids),
      ),
    );
  }

  void _openAiCoach(CoachContext coachCtx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => _CoachSheetWrapper(coachContext: coachCtx),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserRoleService();
    final isInstitution = userService.isInstitution;
    // Get user's first name for the initial and greeting
    final userName = userService.userName.isNotEmpty
        ? userService.userName.split(' ').first
        : (isInstitution && userService.institutionName.isNotEmpty
            ? userService.institutionName
            : 'there');
    final firstInitial = userName.isNotEmpty
        ? userName[0].toUpperCase()
        : 'U';

    final coachCtx = CoachContext(
      walletBalance: FinancialHealth.income - FinancialHealth.totalSpent,
      monthlyBudget: FinancialHealth.monthlyBudget,
      totalSpent: FinancialHealth.totalSpent,
      income: FinancialHealth.income,
      stabilityScore: 62,
      stabilityLabel: 'Steady',
      marketplaceActivity: 3,
      missedCheckins: 2,
      page: 'home',
    );

    final pinnedActions =
        _kAllActions.where((a) => _pinnedIds.contains(a.id)).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: _buildFabStack(coachCtx),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
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
            onPressed: () => context.push('/notifications'),
          ),
          // Avatar with first initial — dropdown includes all menu items
          // (hamburger removed; its items merged here)
          Builder(
            builder: (btnCtx) => GestureDetector(
              onTap: () => _showAvatarMenu(btnCtx),
              child: Container(
                width: 34,
                height: 34,
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
                    Center(
                      child: Text(firstInitial,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: const Icon(Icons.keyboard_arrow_down_rounded,
                            size: 8, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Hamburger REMOVED — items merged into avatar dropdown above
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _GreetingBar(userName: userName),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quick Actions',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                GestureDetector(
                  onTap: _showCustomiseActions,
                  child: const Text('Customise',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (pinnedActions.isEmpty)
              GestureDetector(
                onTap: _showCustomiseActions,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withOpacity(0.3), width: 1.5),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: AppColors.primary, size: 28),
                      SizedBox(height: 6),
                      Text('Tap to add quick actions',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )
            else
              Row(
                children: pinnedActions.map((a) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: a == pinnedActions.last ? 0 : 10),
                      child: _QuickAction(
                        icon: a.icon,
                        label: a.label,
                        color: AppColors.primary,
                        onTap: () => context.push(a.route),
                      ),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 24),

            if (!isInstitution) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Wallet Summary',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  GestureDetector(
                    onTap: () => setState(() => _walletRevealed = !_walletRevealed),
                    child: Row(
                      children: [
                        Icon(
                          _walletRevealed ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          size: 18,
                          color: AppColors.textGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _walletRevealed ? 'Hide' : 'Reveal',
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                child: _walletRevealed
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _WalletStat(
                              label: 'Balance',
                              value: 'R ${(FinancialHealth.income - FinancialHealth.totalSpent).toStringAsFixed(2)}',
                              icon: Icons.account_balance_wallet_outlined),
                          Container(width: 1, height: 40, color: AppColors.inputBorder),
                          _WalletStat(
                              label: 'Earned',
                              value: 'R ${FinancialHealth.income.toStringAsFixed(2)}',
                              icon: Icons.trending_up),
                          Container(width: 1, height: 40, color: AppColors.inputBorder),
                          _WalletStat(
                              label: 'Spent',
                              value: 'R ${FinancialHealth.totalSpent.toStringAsFixed(2)}',
                              icon: Icons.shopping_bag_outlined),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.visibility_off_outlined, size: 16, color: AppColors.textGrey),
                          SizedBox(width: 8),
                          Text(
                            'Tap Reveal to show your balance',
                            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
            ],

            if (isInstitution) ...[
              const Text('Active Job Posts',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => context.go('/institution/marketplace'),
                child: Container(
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
                          label: 'Active Jobs',
                          value: '3',
                          icon: Icons.work_outline),
                      Container(
                          width: 1, height: 40, color: AppColors.inputBorder),
                      _WalletStat(
                          label: 'Applicants',
                          value: '25',
                          icon: Icons.people_outline),
                      Container(
                          width: 1, height: 40, color: AppColors.inputBorder),
                      _WalletStat(
                          label: 'Closing Soon',
                          value: '1',
                          icon: Icons.timer_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

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
                        style:
                            TextStyle(color: AppColors.textGrey, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('Start by browsing the marketplace',
                        style:
                            TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildFabStack(CoachContext coachCtx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (_fabExpanded) ...[
          _FloatingIcon(
            icon: Icons.campaign_rounded,
            label: 'Notice Board',
            color: const Color(0xFFF59E0B),
            onTap: () {
              setState(() => _fabExpanded = false);
              context.push('/noticeboard');
            },
          ),
          const SizedBox(height: 10),
          // Renamed: Community → Chats
          _FloatingIcon(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chats',
            color: const Color(0xFF3B82F6),
            onTap: () {
              setState(() => _fabExpanded = false);
              context.push('/community');
            },
          ),
          const SizedBox(height: 10),
          // Renamed: Coach Gude / Chatbot → AI Buddy
          _FloatingIcon(
            icon: Icons.smart_toy_rounded,
            label: 'AI Buddy',
            color: const Color(0xFF10B981),
            onTap: () {
              setState(() => _fabExpanded = false);
              _openAiCoach(coachCtx);
            },
          ),
          const SizedBox(height: 10),
        ],

        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_fabExpanded)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  'Chats',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                  ),
                ),
              ),
            GestureDetector(
              onTap: () => setState(() => _fabExpanded = !_fabExpanded),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: AnimatedRotation(
                  turns: _fabExpanded ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    _fabExpanded
                        ? Icons.close_rounded
                        : Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CoachSheetWrapper extends StatelessWidget {
  final CoachContext coachContext;
  const _CoachSheetWrapper({required this.coachContext});

  @override
  Widget build(BuildContext context) {
    return AiCoachFab(context: coachContext);
  }
}

// ─── Greeting bar — shows "Welcome back, [name] 👋" ──────────────────────────
class _GreetingBar extends StatelessWidget {
  final String userName;
  const _GreetingBar({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark),
              children: [
                const TextSpan(text: 'Welcome back, '),
                TextSpan(
                  text: userName,
                  style: const TextStyle(color: AppColors.primary),
                ),
                const TextSpan(text: ' 👋'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE30613).withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: Color(FinancialHealth.badgeColorValue),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Stable',
                style: TextStyle(
                    color: Color(0xFFE30613),
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _FloatingIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 3))
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }
}

class _CustomiseActionsSheet extends StatefulWidget {
  final List<String> pinnedIds;
  final void Function(List<String>) onSave;
  const _CustomiseActionsSheet({required this.pinnedIds, required this.onSave});

  @override
  State<_CustomiseActionsSheet> createState() => _CustomiseActionsSheetState();
}

class _CustomiseActionsSheetState extends State<_CustomiseActionsSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.pinnedIds);
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        if (_selected.length >= 4) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Max 4 quick actions'),
              duration: Duration(seconds: 1)));
          return;
        }
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Customise Quick Actions',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A))),
                Text('${_selected.length}/4',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Choose up to 4 shortcuts to show on your home screen.',
                style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _kAllActions.map((a) {
                final sel = _selected.contains(a.id);
                return GestureDetector(
                  onTap: () => _toggle(a.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.primary.withOpacity(0.08)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            sel ? AppColors.primary : const Color(0xFFEEEEEE),
                        width: sel ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(a.icon,
                            size: 18,
                            color: sel
                                ? AppColors.primary
                                : const Color(0xFF888888)),
                        const SizedBox(width: 8),
                        Text(
                          a.label.replaceAll('\n', ' '),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: sel
                                  ? AppColors.primary
                                  : const Color(0xFF1A1A1A)),
                        ),
                        if (sel) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.check_circle_rounded,
                              size: 14, color: AppColors.primary),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(_selected);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
    return GestureDetector(
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
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ],
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
            style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
      ],
    );
  }
}