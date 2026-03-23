import 'package:flutter/material.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Support Hub',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intervention banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.support_agent, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Your Support Hub',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
                  SizedBox(height: 6),
                  Text(
                    'Resources and opportunities personalised for your current situation.',
                    style: TextStyle(color: Colors.white70, fontSize: 13,
                      height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Emergency Income'),
            const SizedBox(height: 8),
            _EmergencyGigsList(),
            const SizedBox(height: 20),
            _sectionTitle('Academic Support'),
            const SizedBox(height: 8),
            _SupportGrid(items: const [
              _SupportItem(icon: Icons.school_outlined,
                title: 'Find a Tutor', sub: 'Browse student tutors nearby',
                color: Color(0xFF6C63FF)),
              _SupportItem(icon: Icons.group_outlined,
                title: 'Study Groups', sub: 'Join or create a study group',
                color: Color(0xFF00C896)),
              _SupportItem(icon: Icons.menu_book_outlined,
                title: 'Study Materials', sub: 'Free notes and past papers',
                color: Color(0xFFFF9800)),
              _SupportItem(icon: Icons.assignment_outlined,
                title: 'Assignment Help', sub: 'Get editing and guidance',
                color: Color(0xFF2196F3)),
            ]),
            const SizedBox(height: 20),
            _sectionTitle('Food & Basic Needs'),
            const SizedBox(height: 8),
            _SupportGrid(items: const [
              _SupportItem(icon: Icons.restaurant_outlined,
                title: 'Campus Meals', sub: 'Subsidised food programmes',
                color: Color(0xFFE8453C)),
              _SupportItem(icon: Icons.volunteer_activism_outlined,
                title: 'Food Banks', sub: 'Campus food assistance',
                color: Color(0xFF00C896)),
            ]),
            const SizedBox(height: 20),
            _sectionTitle('Wellbeing & Counseling'),
            const SizedBox(height: 8),
            _SupportGrid(items: const [
              _SupportItem(icon: Icons.psychology_outlined,
                title: 'Counselor', sub: 'Talk to a professional',
                color: Color(0xFF9C27B0)),
              _SupportItem(icon: Icons.people_outline,
                title: 'Peer Support', sub: 'Connect with other students',
                color: Color(0xFF2196F3)),
              _SupportItem(icon: Icons.self_improvement_outlined,
                title: 'Wellness Tips', sub: 'Mental health resources',
                color: Color(0xFF00C896)),
              _SupportItem(icon: Icons.phone_outlined,
                title: 'Crisis Line', sub: 'SADAG: 0800 456 789',
                color: Color(0xFFE8453C)),
            ]),
            const SizedBox(height: 20),
            _sectionTitle('Mentorship'),
            const SizedBox(height: 8),
            _SupportGrid(items: const [
              _SupportItem(icon: Icons.person_outline,
                title: 'Find a Mentor', sub: 'Alumni and professionals',
                color: Color(0xFFFF9800)),
              _SupportItem(icon: Icons.work_outline,
                title: 'Career Advice', sub: 'CV, interviews, jobs',
                color: Color(0xFF6C63FF)),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(title,
    style: const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark));
}

class _EmergencyGigsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const gigs = [
      _Gig(title: 'Delivery Runner', pay: 'R80-120/day',
        desc: 'Campus delivery for local shops'),
      _Gig(title: 'Event Assistant', pay: 'R150/event',
        desc: 'Help at campus events this weekend'),
      _Gig(title: 'Data Capturer', pay: 'R100/hr',
        desc: 'Remote data entry for NGO'),
    ];
    return Column(
      children: gigs.map((g) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFE5E5)),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.flash_on_outlined,
                color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark, fontSize: 14)),
                  Text(g.desc,
                    style: const TextStyle(
                      fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(g.pay,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Apply',
                    style: TextStyle(
                      color: Colors.white, fontSize: 11,
                      fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }
}

class _Gig {
  final String title, pay, desc;
  const _Gig({required this.title, required this.pay, required this.desc});
}

class _SupportGrid extends StatelessWidget {
  final List<_SupportItem> items;
  const _SupportGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: item.color, size: 24),
                const SizedBox(height: 6),
                Text(item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13, color: AppColors.textDark)),
                Text(item.sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10, color: AppColors.textGrey)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SupportItem {
  final IconData icon;
  final String title, sub;
  final Color color;
  const _SupportItem({
    required this.icon, required this.title,
    required this.sub, required this.color,
  });
}
