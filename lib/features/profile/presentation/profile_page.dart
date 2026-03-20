import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Profile',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Text('S',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          )),
                      ),
                      Positioned(
                        bottom: 0, right: 0,
                        child: Container(
                          width: 26, height: 26,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Student Name',
                    style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
                  const Text('s21961082@mandela.ac.za',
                    style: TextStyle(
                      fontSize: 13, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Nelson Mandela University',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      )),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ProfileStat(label: 'Jobs Done', value: '0'),
                      Container(width: 1, height: 40,
                        color: AppColors.inputBorder),
                      _ProfileStat(label: 'Rating', value: '-'),
                      Container(width: 1, height: 40,
                        color: AppColors.inputBorder),
                      _ProfileStat(label: 'Earned', value: 'R0'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Verification
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verification',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, color: AppColors.textDark)),
                  const SizedBox(height: 12),
                  _VerificationRow(
                    label: 'Email verified',
                    done: true),
                  _VerificationRow(
                    label: 'Student ID uploaded',
                    done: false),
                  _VerificationRow(
                    label: 'University verified',
                    done: false),
                  _VerificationRow(
                    label: 'Skills verified',
                    done: false),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Skills
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Skills',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, color: AppColors.textDark)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Add Skill',
                          style: TextStyle(color: AppColors.primary))),
                    ],
                  ),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: const [
                      _SkillChip(label: 'Mathematics'),
                      _SkillChip(label: 'Tutoring'),
                      _SkillChip(label: 'Python'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Settings
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline,
                    label: 'Privacy & Security',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.help_outline,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  _SettingsTile(
                    icon: Icons.logout,
                    label: 'Log Out',
                    onTap: () => context.go('/login'),
                    isRed: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label, value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value,
        style: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold,
          color: AppColors.textDark)),
      Text(label,
        style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
    ]);
  }
}

class _VerificationRow extends StatelessWidget {
  final String label;
  final bool done;
  const _VerificationRow({required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? Colors.green : AppColors.textGrey,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(label,
          style: TextStyle(
            fontSize: 14,
            color: done ? AppColors.textDark : AppColors.textGrey,
          )),
        const Spacer(),
        if (!done)
          TextButton(
            onPressed: () {},
            child: const Text('Verify',
              style: TextStyle(
                color: AppColors.primary, fontSize: 12))),
      ]),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Text(label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isRed;
  const _SettingsTile({
    required this.icon, required this.label,
    required this.onTap, this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,
        color: isRed ? AppColors.primary : AppColors.textGrey),
      title: Text(label,
        style: TextStyle(
          fontSize: 14,
          color: isRed ? AppColors.primary : AppColors.textDark,
        )),
      trailing: isRed ? null : const Icon(Icons.chevron_right,
        color: AppColors.textGrey),
      onTap: onTap,
    );
  }
}
