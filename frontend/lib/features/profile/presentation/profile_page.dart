// lib/features/profile/presentation/profile_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/services/user_role_service.dart';

// Expanded skills list with categories
const List<Map<String, dynamic>> _availableSkills = [
  {
    'label': 'Mathematics',
    'icon': Icons.calculate_outlined,
    'category': 'Academic'
  },
  {'label': 'Physics', 'icon': Icons.science_outlined, 'category': 'Academic'},
  {
    'label': 'Chemistry',
    'icon': Icons.science_outlined,
    'category': 'Academic'
  },
  {'label': 'Biology', 'icon': Icons.biotech_outlined, 'category': 'Academic'},
  {
    'label': 'Accounting',
    'icon': Icons.receipt_long_outlined,
    'category': 'Academic'
  },
  {
    'label': 'Economics',
    'icon': Icons.trending_up_rounded,
    'category': 'Academic'
  },
  {
    'label': 'Statistics',
    'icon': Icons.bar_chart_outlined,
    'category': 'Academic'
  },
  {
    'label': 'Computer Science',
    'icon': Icons.computer_outlined,
    'category': 'Academic'
  },
  {
    'label': 'Tutoring',
    'icon': Icons.menu_book_outlined,
    'category': 'Tutoring'
  },
  {'label': 'Mentorship', 'icon': Icons.people_outline, 'category': 'Tutoring'},
  {
    'label': 'Study Coaching',
    'icon': Icons.school_outlined,
    'category': 'Tutoring'
  },
  {'label': 'Exam Prep', 'icon': Icons.quiz_outlined, 'category': 'Tutoring'},
  {'label': 'Python', 'icon': Icons.code_rounded, 'category': 'Technical'},
  {'label': 'JavaScript', 'icon': Icons.code_rounded, 'category': 'Technical'},
  {
    'label': 'Web Development',
    'icon': Icons.language_outlined,
    'category': 'Technical'
  },
  {
    'label': 'Mobile Development',
    'icon': Icons.phone_android_outlined,
    'category': 'Technical'
  },
  {
    'label': 'Data Analysis',
    'icon': Icons.bar_chart_outlined,
    'category': 'Technical'
  },
  {
    'label': 'Machine Learning',
    'icon': Icons.psychology_outlined,
    'category': 'Technical'
  },
  {
    'label': 'Graphic Design',
    'icon': Icons.brush_outlined,
    'category': 'Creative'
  },
  {
    'label': 'Photography',
    'icon': Icons.camera_alt_outlined,
    'category': 'Creative'
  },
  {
    'label': 'Video Editing',
    'icon': Icons.movie_filter_outlined,
    'category': 'Creative'
  },
  {
    'label': 'Content Writing',
    'icon': Icons.article_outlined,
    'category': 'Creative'
  },
  {'label': 'Music', 'icon': Icons.music_note_outlined, 'category': 'Creative'},
  {
    'label': 'Translation',
    'icon': Icons.translate_outlined,
    'category': 'Language'
  },
  {
    'label': 'Public Speaking',
    'icon': Icons.mic_outlined,
    'category': 'Language'
  },
  {
    'label': 'Writing',
    'icon': Icons.edit_note_outlined,
    'category': 'Language'
  },
  {
    'label': 'Campus Help',
    'icon': Icons.school_outlined,
    'category': 'Services'
  },
  {
    'label': 'Delivery',
    'icon': Icons.delivery_dining_outlined,
    'category': 'Services'
  },
  {
    'label': 'Social Media',
    'icon': Icons.smartphone_outlined,
    'category': 'Services'
  },
  {
    'label': 'Marketing',
    'icon': Icons.campaign_outlined,
    'category': 'Services'
  },
  {
    'label': 'Cleaning',
    'icon': Icons.cleaning_services_outlined,
    'category': 'Services'
  },
  {
    'label': 'Babysitting',
    'icon': Icons.child_care_outlined,
    'category': 'Services'
  },
  {
    'label': 'Haircare',
    'icon': Icons.content_cut_outlined,
    'category': 'Services'
  },
  {
    'label': 'Fitness Coaching',
    'icon': Icons.fitness_center_outlined,
    'category': 'Services'
  },
  {
    'label': 'Cooking',
    'icon': Icons.restaurant_outlined,
    'category': 'Services'
  },
];

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Profile data
  String _name = 'Student Name';
  String _email = 'student@university.ac.za';
  String _university = 'Nelson Mandela University';
  bool _isEditing = false;

  // Profile picture (simulated — in production use image_picker)
  bool _hasProfilePic = false;
  String _profilePicEmoji = '🧑‍🎓';
  final List<String> _avatarOptions = [
    '🧑‍🎓',
    '👨‍💻',
    '👩‍🎨',
    '🧑‍🔬',
    '👨‍🏫',
    '👩‍💼',
    '🧑‍🎤',
    '👨‍🍳'
  ];

  // Verification state
  bool _emailVerified = true;
  bool _studentIdUploaded = false;
  bool _universityVerified = false;
  bool _isUploadingId = false;

  // Skills — these are searchable by other students/institutions
  List<String> _skills = ['Mathematics', 'Tutoring', 'Python'];

  // About bio — visible on profile and in search results
  String _bio = '';
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = _name;
    _universityController.text = _university;
    _bioController.text = _bio;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _universityController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // ── Profile picture picker ──────────────────────────────────────────
  void _showProfilePicOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 16),
              const Text('Profile Picture',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A1A))),
              const SizedBox(height: 6),
              const Text('Choose an avatar or upload a photo',
                  style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
              const SizedBox(height: 16),
              // Avatar grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: _avatarOptions.length,
                itemBuilder: (_, i) {
                  final emoji = _avatarOptions[i];
                  final selected = _profilePicEmoji == emoji;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _profilePicEmoji = emoji;
                        _hasProfilePic = true;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profile picture updated!'),
                            backgroundColor: Color(0xFF10B981)),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.1)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2),
                      ),
                      child: Center(
                          child: Text(emoji,
                              style: const TextStyle(fontSize: 28))),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),
              // Upload from gallery option
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Photo upload — connect image_picker in production'),
                        backgroundColor: AppColors.primary),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Row(children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.photo_library_outlined,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text('Upload from gallery',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A))),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded,
                        color: Color(0xFFCCCCCC), size: 20),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Upload Student ID ───────────────────────────────────────────────
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
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                            color: const Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.circular(2)))),
                const SizedBox(height: 18),
                Row(children: [
                  Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.badge_outlined,
                          color: AppColors.primary, size: 22)),
                  const SizedBox(width: 12),
                  const Expanded(
                      child: Text('Upload Student ID',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A)))),
                ]),
                const SizedBox(height: 10),
                const Text(
                    'Upload a clear photo of your student card. Your university will be automatically verified once approved.',
                    style: TextStyle(
                        fontSize: 13, color: Color(0xFF666666), height: 1.5)),
                const SizedBox(height: 20),
                _UploadOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Take a photo',
                    onTap: () => Navigator.pop(context, true)),
                const SizedBox(height: 10),
                _UploadOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Choose from gallery',
                    onTap: () => Navigator.pop(context, true)),
                const SizedBox(height: 10),
                _UploadOption(
                    icon: Icons.upload_file_outlined,
                    label: 'Upload from files',
                    onTap: () => Navigator.pop(context, true)),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Center(
                      child: Text('Cancel',
                          style: TextStyle(color: Color(0xFF888888)))),
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

  void _showAddSkillSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AddSkillSheet(
        currentSkills: List.from(_skills),
        onSave: (selected) => setState(() => _skills = selected),
      ),
    );
  }

  void _removeSkill(String skill) => setState(() => _skills.remove(skill));

  void _toggleEditMode() {
    if (_isEditing) {
      setState(() {
        _name = _nameController.text.trim().isEmpty
            ? _name
            : _nameController.text.trim();
        _university = _universityController.text.trim().isEmpty
            ? _university
            : _universityController.text.trim();
        _bio = _bioController.text.trim();
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF10B981)),
      );
    } else {
      setState(() => _isEditing = true);
    }
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
            icon: Icon(_isEditing ? Icons.save_outlined : Icons.edit_outlined,
                color: AppColors.textDark),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile header ──────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Profile picture with camera overlay
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: _showProfilePicOptions,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: _hasProfilePic
                                ? Colors.transparent
                                : AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2),
                          ),
                          child: Center(
                            child: _hasProfilePic
                                ? Text(_profilePicEmoji,
                                    style: const TextStyle(fontSize: 44))
                                : Text(_name[0].toUpperCase(),
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40)),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showProfilePicOptions,
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
                  // Name (editable)
                  if (_isEditing)
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark),
                      decoration: const InputDecoration(
                          hintText: 'Your name',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                      textAlign: TextAlign.center,
                    )
                  else
                    Text(_name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark)),
                  // Email
                  Text(_email,
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  // University chip (editable)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: _isEditing
                        ? IntrinsicWidth(
                            child: TextField(
                            controller: _universityController,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                hintText: 'University name',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 4)),
                          ))
                        : Text(_university,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),
                  // Stats
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

            // ── About Me (bio) ──────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('About Me',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textDark)),
                      if (!_isEditing)
                        GestureDetector(
                          onTap: _toggleEditMode,
                          child: const Text('Edit',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                      'This bio is visible to other students and institutions when they search for your skills.',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFFAAAAAA), height: 1.4)),
                  const SizedBox(height: 10),
                  if (_isEditing)
                    TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText:
                            'Tell others about yourself, your skills, and what you can help with...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                      ),
                    )
                  else
                    Text(
                      _bio.isEmpty
                          ? 'No bio added yet. Tap edit to add one!'
                          : _bio,
                      style: TextStyle(
                          fontSize: 13,
                          color: _bio.isEmpty
                              ? AppColors.textGrey
                              : const Color(0xFF444444),
                          height: 1.5),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Verification ────────────────────────────────
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
                      label: 'Email verified', done: _emailVerified),
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

            // ── Skills & Expertise ──────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Skills & Expertise',
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
                              ]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                      'Other students and institutions can find you by searching these skills.',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFFAAAAAA), height: 1.4)),
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
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                        ),
                        child: const Column(children: [
                          Icon(Icons.add_circle_outline,
                              color: AppColors.textGrey, size: 32),
                          SizedBox(height: 8),
                          Text('Tap to add your skills',
                              style: TextStyle(
                                  color: AppColors.textGrey, fontSize: 13)),
                        ]),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills
                          .map((s) => _SkillChip(
                              label: s, onRemove: () => _removeSkill(s)))
                          .toList(),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Settings ────────────────────────────────────
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _SettingsTile(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      onTap: () {}),
                  _SettingsTile(
                      icon: Icons.lock_outline,
                      label: 'Privacy & Security',
                      onTap: () {}),
                  _SettingsTile(
                      icon: Icons.help_outline,
                      label: 'Help & Support',
                      onTap: () {}),
                  _SettingsTile(
                    icon: Icons.logout,
                    label: 'Log Out',
                    isRed: true,
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
                                        TextStyle(color: AppColors.textGrey))),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  minimumSize: const Size(80, 36)),
                              onPressed: () {
                                UserRoleService().clear();
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

// ─── Helpers ─────────────────────────────────────────────────────────

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _UploadOption(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFEEEEEE))),
        child: Row(children: [
          Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A))),
          const Spacer(),
          const Icon(Icons.chevron_right_rounded,
              color: Color(0xFFCCCCCC), size: 20),
        ]),
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  final String label;
  final bool done;
  final bool isLoading;
  final String? subtitle;
  final VoidCallback? onVerify;
  const _VerificationRow(
      {required this.label,
      required this.done,
      this.isLoading = false,
      this.subtitle,
      this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          if (isLoading)
            const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.primary))
          else
            Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
                color: done ? Colors.green : AppColors.textGrey, size: 20),
          const SizedBox(width: 12),
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      color: done ? AppColors.textDark : AppColors.textGrey))),
          if (!done && !isLoading && onVerify != null)
            GestureDetector(
              onTap: onVerify,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: AppColors.primary.withOpacity(0.3))),
                child: const Text('Verify',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          if (isLoading)
            const Text('Processing…',
                style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
        ]),
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
      ]),
    );
  }
}

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
      child: Row(mainAxisSize: MainAxisSize.min, children: [
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
                shape: BoxShape.circle),
            child: const Icon(Icons.close_rounded,
                size: 11, color: AppColors.primary),
          ),
        ),
      ]),
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark)),
      Text(label,
          style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
    ]);
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isRed;
  const _SettingsTile(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isRed = false});

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

// ─── Add Skill Sheet ──────────────────────────────────────────────────
class _AddSkillSheet extends StatefulWidget {
  final List<String> currentSkills;
  final void Function(List<String>) onSave;
  const _AddSkillSheet({required this.currentSkills, required this.onSave});

  @override
  State<_AddSkillSheet> createState() => _AddSkillSheetState();
}

class _AddSkillSheetState extends State<_AddSkillSheet> {
  late Set<String> _selected;
  final TextEditingController _customCtrl = TextEditingController();
  String _filter = '';
  String _selectedCategory = 'All';

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

  List<String> get _skillCategories {
    final cats =
        _availableSkills.map((s) => s['category'] as String).toSet().toList();
    return ['All', ...cats];
  }

  List<Map<String, dynamic>> get _filtered {
    var skills = _availableSkills;
    if (_selectedCategory != 'All') {
      skills = skills.where((s) => s['category'] == _selectedCategory).toList();
    }
    if (_filter.isEmpty) return skills;
    return skills
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
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, scrollCtrl) => Column(
        children: [
          Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(children: [
              const Expanded(
                  child: Text('Add Skills',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A)))),
              if (_selected.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Text('${_selected.length} selected',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700)),
                ),
            ]),
          ),
          // Category filter
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _skillCategories
                    .map((cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (sel) => setState(
                                () => _selectedCategory = sel ? cat : 'All'),
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                                color: _selectedCategory == cat
                                    ? AppColors.primary
                                    : AppColors.textGrey,
                                fontWeight: _selectedCategory == cat
                                    ? FontWeight.w600
                                    : FontWeight.normal),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _customCtrl,
                    style:
                        const TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)),
                    decoration: const InputDecoration(
                        hintText: 'Search or type a custom skill…',
                        hintStyle:
                            TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                        prefixIcon: Icon(Icons.search,
                            color: Color(0xFFAAAAAA), size: 18),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 11)),
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
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text('Add',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ]),
          ),
          // Skill grid
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No skills match your search',
                        style:
                            TextStyle(color: Color(0xFF888888), fontSize: 13)))
                : GridView.builder(
                    controller: scrollCtrl,
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.0),
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
                                width: 1.5),
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
                              ]),
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
                        borderRadius: BorderRadius.circular(12))),
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
