import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// AVAILABLE SKILLS
// ─────────────────────────────────────────────

const List<Map<String, dynamic>> _availableSkills = [
  {'label': 'Mathematics', 'icon': Icons.calculate_outlined},
  {'label': 'Tutoring', 'icon': Icons.menu_book_outlined},
  {'label': 'Python', 'icon': Icons.code_rounded},
  {'label': 'Design', 'icon': Icons.brush_outlined},
  {'label': 'Photography', 'icon': Icons.camera_alt_outlined},
  {'label': 'Writing', 'icon': Icons.edit_note_outlined},
  {'label': 'Video Editing', 'icon': Icons.movie_filter_outlined},
  {'label': 'Translation', 'icon': Icons.translate_outlined},
  {'label': 'Music', 'icon': Icons.music_note_outlined},
  {'label': 'Social Media', 'icon': Icons.smartphone_outlined},
  {'label': 'Delivery', 'icon': Icons.delivery_dining_outlined},
  {'label': 'Campus Help', 'icon': Icons.school_outlined},
  {'label': 'Accounting', 'icon': Icons.receipt_long_outlined},
  {'label': 'Data Analysis', 'icon': Icons.bar_chart_outlined},
  {'label': 'Web Development', 'icon': Icons.language_outlined},
  {'label': 'Graphic Design', 'icon': Icons.palette_outlined},
  {'label': 'Content Writing', 'icon': Icons.article_outlined},
  {'label': 'Marketing', 'icon': Icons.campaign_outlined},
  {'label': 'Economics', 'icon': Icons.trending_up_rounded},
  {'label': 'Cooking', 'icon': Icons.restaurant_outlined},
  {'label': 'Cleaning', 'icon': Icons.cleaning_services_outlined},
  {'label': 'Babysitting', 'icon': Icons.child_care_outlined},
  {'label': 'Haircare', 'icon': Icons.content_cut_outlined},
  {'label': 'Fitness Coaching', 'icon': Icons.fitness_center_outlined},
];

// ─────────────────────────────────────────────
// PROFILE PAGE
// ─────────────────────────────────────────────

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ── Verification state ──────────────────────
  bool _emailVerified = true;
  bool _studentIdUploaded = false;
  bool _universityVerified = false;
  bool _isUploadingId = false;

  // ── Skills ──────────────────────────────────
  List<String> _skills = ['Mathematics', 'Tutoring', 'Python'];

  // ── Simulate ID upload & auto-verify ────────
  Future<void> _handleUploadStudentId() async {
    final confirmed = await _showUploadSheet();
    if (!confirmed) return;

    setState(() => _isUploadingId = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isUploadingId = false;
      _studentIdUploaded = true;
      _universityVerified = true;
    });
    _showVerifiedSnackbar();
  }

  Future<bool> _showUploadSheet() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                        color: const Color(0xFFDDDDDD),
                        borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 18),
                Row(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.badge_outlined,
                        color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text('Upload Student ID',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A1A1A))),
                  ),
                ]),
                const SizedBox(height: 10),
                const Text(
                  'Upload a clear photo of your student card. '
                  'Your university will be automatically verified '
                  'once approved.',
                  style: TextStyle(
                      fontSize: 13, color: Color(0xFF666666), height: 1.5),
                ),
                const SizedBox(height: 20),
                _UploadOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Take a photo',
                  onTap: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 10),
                _UploadOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Choose from gallery',
                  onTap: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 10),
                _UploadOption(
                  icon: Icons.upload_file_outlined,
                  label: 'Upload from files',
                  onTap: () => Navigator.pop(context, true),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Center(
                    child: Text('Cancel',
                        style: TextStyle(color: Color(0xFF888888))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return result ?? false;
  }

  void _showVerifiedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Row(children: [
        Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
        SizedBox(width: 8),
        Text('Student ID uploaded — university verified! ✅'),
      ]),
      backgroundColor: const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Add Skill sheet ──────────────────────────
  void _showAddSkillSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AddSkillSheet(
        currentSkills: List.from(_skills),
        onSave: (selected) {
          setState(() => _skills = selected);
        },
      ),
    );
  }

  // ── Remove skill ─────────────────────────────
  void _removeSkill(String skill) {
    setState(() => _skills.remove(skill));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: AppColors.textDark, size: 18),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('My Profile',
            style: TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
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
            // ── Profile header ─────────────────
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
                                fontSize: 40)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Student Name',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const Text('s21961082@mandela.ac.za',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Nelson Mandela University',
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ProfileStat(label: 'Jobs Done', value: '0'),
                      Container(
                          width: 1, height: 40, color: AppColors.inputBorder),
                      _ProfileStat(label: 'Rating', value: '-'),
                      Container(
                          width: 1, height: 40, color: AppColors.inputBorder),
                      _ProfileStat(label: 'Earned', value: 'R0'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Verification ───────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verification',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textDark)),
                  const SizedBox(height: 12),

                  _VerificationRow(
                    label: 'Email verified',
                    done: _emailVerified,
                  ),

                  _VerificationRow(
                    label: 'Student ID uploaded',
                    done: _studentIdUploaded,
                    isLoading: _isUploadingId,
                    onVerify:
                        _studentIdUploaded ? null : _handleUploadStudentId,
                  ),

                  _VerificationRow(
                    label: 'University verified',
                    done: _universityVerified,
                    subtitle: _universityVerified
                        ? null
                        : 'Auto-verified when student ID is uploaded',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Skills ─────────────────────────
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
                              fontSize: 16,
                              color: AppColors.textDark)),
                      GestureDetector(
                        onTap: _showAddSkillSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: AppColors.primary, size: 14),
                              SizedBox(width: 4),
                              Text('Add Skill',
                                  style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_skills.isEmpty)
                    GestureDetector(
                      onTap: _showAddSkillSheet,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFEEEEEE),
                              style: BorderStyle.solid),
                        ),
                        child: const Column(
                          children: [
                            Icon(Icons.add_circle_outline,
                                color: AppColors.textGrey, size: 32),
                            SizedBox(height: 8),
                            Text('Tap to add your skills',
                                style: TextStyle(
                                    color: AppColors.textGrey, fontSize: 13)),
                          ],
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills
                          .map((s) => _SkillChip(
                                label: s,
                                onRemove: () => _removeSkill(s),
                              ))
                          .toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Settings ────────────────────────
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
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: const Text('Log out',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          content:
                              const Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel',
                                  style:
                                      TextStyle(color: AppColors.textGrey)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                minimumSize: const Size(80, 36),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                context.go('/login');
                              },
                              child: const Text('Log out',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
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

// ─────────────────────────────────────────────
// ADD SKILL SHEET
// ─────────────────────────────────────────────

class _AddSkillSheet extends StatefulWidget {
  final List<String> currentSkills;
  final void Function(List<String>) onSave;

  const _AddSkillSheet({
    required this.currentSkills,
    required this.onSave,
  });

  @override
  State<_AddSkillSheet> createState() => _AddSkillSheetState();
}

class _AddSkillSheetState extends State<_AddSkillSheet> {
  late Set<String> _selected;
  final TextEditingController _customCtrl = TextEditingController();
  String _filter = '';

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.currentSkills);
    _customCtrl.addListener(
        () => setState(() => _filter = _customCtrl.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_filter.isEmpty) return _availableSkills;
    return _availableSkills
        .where((s) => (s['label'] as String).toLowerCase().contains(_filter))
        .toList();
  }

  void _toggleSkill(String label) {
    setState(() {
      if (_selected.contains(label)) {
        _selected.remove(label);
      } else {
        _selected.add(label);
      }
    });
  }

  void _addCustom() {
    final custom = _customCtrl.text.trim();
    if (custom.isEmpty) return;
    final formatted = custom[0].toUpperCase() + custom.substring(1);
    setState(() {
      _selected.add(formatted);
      _customCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.78,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Add Skills',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A))),
                ),
                if (_selected.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${_selected.length} selected',
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),

          // Search / custom input
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _customCtrl,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF1A1A1A)),
                      decoration: const InputDecoration(
                        hintText: 'Search or type a custom skill…',
                        hintStyle:
                            TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                        prefixIcon: Icon(Icons.search,
                            color: Color(0xFFAAAAAA), size: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 11),
                      ),
                    ),
                  ),
                ),
                if (_customCtrl.text.isNotEmpty &&
                    !_availableSkills.any((s) =>
                        (s['label'] as String).toLowerCase() ==
                        _customCtrl.text.trim().toLowerCase())) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _addCustom,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Add',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Skill grid
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No skills match your search',
                        style: TextStyle(
                            color: Color(0xFF888888), fontSize: 13)))
                : GridView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final skill = filtered[i];
                      final label = skill['label'] as String;
                      final icon = skill['icon'] as IconData;
                      final selected = _selected.contains(label);
                      return GestureDetector(
                        onTap: () => _toggleSkill(label),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withOpacity(0.08)
                                : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon,
                                  size: 26,
                                  color: selected
                                      ? AppColors.primary
                                      : const Color(0xFF888888)),
                              const SizedBox(height: 6),
                              Text(label,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: selected
                                          ? AppColors.primary
                                          : const Color(0xFF666666))),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Save button
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 0, 16, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(_selected.toList());
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  _selected.isEmpty
                      ? 'Save (no skills)'
                      : 'Save ${_selected.length} skill${_selected.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// UPLOAD OPTION TILE
// ─────────────────────────────────────────────

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UploadOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A))),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFFCCCCCC), size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// VERIFICATION ROW
// ─────────────────────────────────────────────

class _VerificationRow extends StatelessWidget {
  final String label;
  final bool done;
  final bool isLoading;
  final String? subtitle;
  final VoidCallback? onVerify;

  const _VerificationRow({
    required this.label,
    required this.done,
    this.isLoading = false,
    this.subtitle,
    this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppColors.primary),
                )
              else
                Icon(
                  done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: done ? Colors.green : AppColors.textGrey,
                  size: 20,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        color: done ? AppColors.textDark : AppColors.textGrey)),
              ),
              if (!done && !isLoading && onVerify != null)
                GestureDetector(
                  onTap: onVerify,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: const Text('Verify',
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              if (isLoading)
                const Text('Processing…',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textGrey)),
            ],
          ),
          if (subtitle != null && !done) ...[
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Text(subtitle!,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFAAAAAA),
                      fontStyle: FontStyle.italic)),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SKILL CHIP — with remove ×
// ─────────────────────────────────────────────

class _SkillChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _SkillChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 4, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  size: 11, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PROFILE STAT
// ─────────────────────────────────────────────

class _ProfileStat extends StatelessWidget {
  final String label, value;
  const _ProfileStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark)),
      Text(label,
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
    ]);
  }
}

// ─────────────────────────────────────────────
// SETTINGS TILE
// ─────────────────────────────────────────────

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isRed;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(icon, color: isRed ? AppColors.primary : AppColors.textGrey),
      title: Text(label,
          style: TextStyle(
              fontSize: 14,
              color: isRed ? AppColors.primary : AppColors.textDark)),
      trailing: isRed
          ? null
          : const Icon(Icons.chevron_right, color: AppColors.textGrey),
      onTap: onTap,
    );
  }
}