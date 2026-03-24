import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// THEME COLORS
// ─────────────────────────────────────────────
class AppColors {
  static const primary = Color(0xFFE30613);
  static const primaryDark = Color(0xFFB0000E);
  static const textDark = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF888888);
  static const inputBorder = Color(0xFFE8E8E8);
  static const bgLight = Color(0xFFFAFAFA);
}

// ─────────────────────────────────────────────
// SIGNUP PAGE
// ─────────────────────────────────────────────
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  // Role: 'student' | 'buyer'
  String _role = '';
  bool _roleSelected = false;

  // Page controller for multi-step
  final _pageController = PageController();
  int _step = 0; // 0 = role, 1 = form

  // Shared form state
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _city = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;
  final _confirmPassword = TextEditingController();

  // Student-only
  String? _selectedInstitution;
  bool _showCustomInput = false;
  final _customInstitution = TextEditingController();

  // Buyer-only
  final _companyName = TextEditingController();
  String? _buyerType; // 'business' | 'parent' | 'ngo' | 'student'

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _pageController.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _city.dispose();
    _confirmPassword.dispose();
    _customInstitution.dispose();
    _companyName.dispose();
    super.dispose();
  }

  void _selectRole(String role) {
    setState(() {
      _role = role;
      _roleSelected = true;
    });
  }

  void _proceedToForm() {
    if (_role.isEmpty) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _step = 1);
  }

  void _goBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _step = 0);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_role == 'student') {
        // Navigate to banking details capture (per PRD)
        context.go('/home');
      } else {
        context.go('/home');
      }
    }
  }

  // ── Institutions list ──────────────────────
  static const List<Map<String, dynamic>> _institutions = [
    {'name': 'University of Cape Town (UCT)', 'domain': 'uct.ac.za'},
    {'name': 'University of the Witwatersrand (Wits)', 'domain': 'wits.ac.za'},
    {'name': 'Stellenbosch University (SU)', 'domain': 'sun.ac.za'},
    {'name': 'University of KwaZulu-Natal (UKZN)', 'domain': 'ukzn.ac.za'},
    {'name': 'University of Pretoria (UP)', 'domain': 'up.ac.za'},
    {'name': 'University of Johannesburg (UJ)', 'domain': 'uj.ac.za'},
    {'name': 'Tshwane University of Technology (TUT)', 'domain': 'tut.ac.za'},
    {'name': 'Cape Peninsula University of Technology (CPUT)', 'domain': 'cput.ac.za'},
    {'name': 'Durban University of Technology (DUT)', 'domain': 'dut.ac.za'},
    {'name': 'Nelson Mandela University (NMU)', 'domain': 'mandela.ac.za'},
    {'name': 'University of the Western Cape (UWC)', 'domain': 'uwc.ac.za'},
    {'name': 'University of the Free State (UFS)', 'domain': 'ufs.ac.za'},
    {'name': 'Rhodes University (RU)', 'domain': 'ru.ac.za'},
    {'name': 'North-West University (NWU)', 'domain': 'nwu.ac.za'},
    {'name': 'University of Limpopo (UL)', 'domain': 'ul.ac.za'},
    {'name': 'University of Fort Hare (UFH)', 'domain': 'ufh.ac.za'},
    {'name': 'University of Venda (UniVen)', 'domain': 'univen.ac.za'},
    {'name': 'Walter Sisulu University (WSU)', 'domain': 'wsu.ac.za'},
    {'name': 'Vaal University of Technology (VUT)', 'domain': 'vut.ac.za'},
    {'name': 'Mangosuthu University of Technology (MUT)', 'domain': 'mut.ac.za'},
    {'name': 'Central University of Technology (CUT)', 'domain': 'cut.ac.za'},
    {'name': 'Ekurhuleni East TVET College', 'domain': 'ekurhulenieast.edu.za'},
    {'name': 'Coastal KZN TVET College', 'domain': 'coastalkzn.edu.za'},
    {'name': 'College of Cape Town TVET', 'domain': 'cct.edu.za'},
    {'name': 'South West Gauteng TVET College', 'domain': 'swgc.edu.za'},
    {'name': 'Northlink TVET College', 'domain': 'northlink.edu.za'},
    {'name': 'Sedibeng TVET College', 'domain': 'sedibeng.edu.za'},
    {'name': 'Other (type below)', 'domain': ''},
  ];

  String? _getInstitutionDomain() {
    if (_selectedInstitution == null) return null;
    final match = _institutions.firstWhere(
      (i) => i['name'] == _selectedInstitution,
      orElse: () => {'domain': ''},
    );
    return match['domain'] as String?;
  }

  // ── Validators ────────────────────────────
  String? _validateName(String? v) {
    if (v == null || v.isEmpty) return 'Full name is required';
    if (v.trim().split(' ').length < 2) return 'Enter first and last name';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (_role == 'student') {
      final domain = _getInstitutionDomain();
      if (domain != null && domain.isNotEmpty) {
        if (!v.toLowerCase().endsWith('@$domain')) {
          return 'Use your student email ending in @$domain';
        }
        return null;
      }
      final re = RegExp(r'^[^@]+@[^@]+\.(ac\.za|edu\.za)$', caseSensitive: false);
      if (!re.hasMatch(v)) return 'Use your official student email (.ac.za or .edu.za)';
    } else {
      final re = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      if (!re.hasMatch(v)) return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Minimum 8 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _password.text) return 'Passwords do not match';
    return null;
  }

  // ── UI ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _RoleSelectionPage(
            selectedRole: _role,
            onSelectRole: _selectRole,
            onNext: _proceedToForm,
            onLogin: () => context.go('/login'),
          ),
          _FormPage(
            role: _role,
            formKey: _formKey,
            name: _name,
            email: _email,
            password: _password,
            confirmPassword: _confirmPassword,
            city: _city,
            obscure: _obscure,
            obscureConfirm: _obscureConfirm,
            onToggleObscure: () => setState(() => _obscure = !_obscure),
            onToggleObscureConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
            selectedInstitution: _selectedInstitution,
            showCustomInput: _showCustomInput,
            customInstitution: _customInstitution,
            institutions: _institutions,
            onInstitutionChanged: (v) => setState(() {
              _selectedInstitution = v;
              _showCustomInput = v == 'Other (type below)';
              _email.clear();
            }),
            getInstitutionDomain: _getInstitutionDomain,
            companyName: _companyName,
            buyerType: _buyerType,
            onBuyerTypeChanged: (v) => setState(() => _buyerType = v),
            validateName: _validateName,
            validateEmail: _validateEmail,
            validatePassword: _validatePassword,
            validateConfirm: _validateConfirm,
            onBack: _goBack,
            onSubmit: _submit,
            onLogin: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAGE 1 — ROLE SELECTION
// ─────────────────────────────────────────────
class _RoleSelectionPage extends StatelessWidget {
  final String selectedRole;
  final void Function(String) onSelectRole;
  final VoidCallback onNext;
  final VoidCallback onLogin;

  const _RoleSelectionPage({
    required this.selectedRole,
    required this.onSelectRole,
    required this.onNext,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Red hero section with diagonal wave ──
          SizedBox(
            height: 340,
            child: Stack(
              children: [
                // Red background
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // Decorative circles
                Positioned(
                  top: -40, right: -30,
                  child: Container(
                    width: 160, height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Positioned(
                  top: 60, right: 30,
                  child: Container(
                    width: 60, height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60, left: -20,
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),

                // Diagonal wave clip at bottom
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 80),
                    painter: _WavePainter(),
                  ),
                ),

                // Logo + tagline
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // G logo
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: const Center(
                            child: Text('G',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              )),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('GUDE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.5,
                          )),
                        const SizedBox(height: 6),
                        const Text(
                          'Sign up to get top-tier\ngoods/services at a low\nrate on Gudee.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Role cards ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Join as',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.5,
                  )),
                const SizedBox(height: 4),
                const Text('Choose how you want to use Gude',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        emoji: '🎓',
                        title: 'Sign up as\na Student',
                        subtitle: 'Sell skills, earn income,\nmanage your wallet',
                        selected: selectedRole == 'student',
                        onTap: () => onSelectRole('student'),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _RoleCard(
                        emoji: '🛒',
                        title: 'Sign up as\na Buyer',
                        subtitle: 'Hire students, buy\nservices & products',
                        selected: selectedRole == 'buyer',
                        onTap: () => onSelectRole('buyer'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Next button
                SizedBox(
                  width: double.infinity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedRole.isEmpty
                            ? const Color(0xFFDDDDDD)
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: selectedRole.isEmpty ? 0 : 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: selectedRole.isEmpty ? null : onNext,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedRole.isEmpty
                                ? 'Select a role to continue'
                                : 'Continue as ${selectedRole == 'student' ? 'Student' : 'Buyer'}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                          if (selectedRole.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, size: 18),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: const Color(0xFFF0F0F0))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    ),
                    Expanded(child: Container(height: 1, color: const Color(0xFFF0F0F0))),
                  ],
                ),

                const SizedBox(height: 16),

                // Social login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialBtn(icon: Icons.g_mobiledata_rounded, label: 'Google', onTap: () {}),
                    const SizedBox(width: 12),
                    _SocialBtn(icon: Icons.facebook_rounded, label: 'Facebook', onTap: () {}),
                    const SizedBox(width: 12),
                    _SocialBtn(icon: Icons.apple_rounded, label: 'Apple', onTap: () {}),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: onLogin,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROLE CARD WIDGET
// ─────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.06) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFEEEEEE),
            width: selected ? 2 : 1.5,
          ),
          boxShadow: selected
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.12), blurRadius: 16, offset: const Offset(0, 4))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary.withOpacity(0.12) : const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? AppColors.primary : const Color(0xFFCCCCCC),
                      width: 2,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: selected ? AppColors.primary : AppColors.textDark,
                height: 1.3,
              )),
            const SizedBox(height: 4),
            Text(subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGrey,
                height: 1.4,
              )),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAGE 2 — FORM
// ─────────────────────────────────────────────
class _FormPage extends StatelessWidget {
  final String role;
  final GlobalKey<FormState> formKey;
  final TextEditingController name, email, password, confirmPassword, city,
      customInstitution, companyName;
  final bool obscure, obscureConfirm, showCustomInput;
  final VoidCallback onToggleObscure, onToggleObscureConfirm, onBack, onSubmit, onLogin;
  final String? selectedInstitution, buyerType;
  final List<Map<String, dynamic>> institutions;
  final void Function(String?) onInstitutionChanged;
  final String? Function() getInstitutionDomain;
  final void Function(String?) onBuyerTypeChanged;
  final String? Function(String?) validateName, validateEmail, validatePassword,
      validateConfirm;

  const _FormPage({
    required this.role,
    required this.formKey,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.city,
    required this.customInstitution,
    required this.companyName,
    required this.obscure,
    required this.obscureConfirm,
    required this.showCustomInput,
    required this.onToggleObscure,
    required this.onToggleObscureConfirm,
    required this.onBack,
    required this.onSubmit,
    required this.onLogin,
    required this.selectedInstitution,
    required this.institutions,
    required this.onInstitutionChanged,
    required this.getInstitutionDomain,
    required this.buyerType,
    required this.onBuyerTypeChanged,
    required this.validateName,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isStudent = role == 'student';
    final domain = getInstitutionDomain();
    final emailHint = isStudent
        ? (domain != null && domain.isNotEmpty ? 'e.g. s1234@$domain' : 'your.name@university.ac.za')
        : 'your@email.com';

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Compact red header ──
          SizedBox(
            height: 220,
            child: Stack(
              children: [
                Container(
                  height: 185,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Circles
                Positioned(
                  top: -20, right: -20,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50, left: -10,
                  child: Container(
                    width: 70, height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),

                // Wave
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 55),
                    painter: _WavePainter(),
                  ),
                ),

                // Header content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onBack,
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 16),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // G logo inline
                            const Text('GUDE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              )),
                            Text(
                              isStudent ? 'Create Student Account' : 'Create Buyer Account',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(isStudent ? '🎓' : '🛒', style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                isStudent ? 'Student' : 'Buyer',
                                style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Form body ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tab row (Log In / Sign Up)
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
                    ),
                    child: Row(
                      children: [
                        _tab('Log In', false, onLogin),
                        _tab('Sign Up', true, () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Signup header
                  Text(
                    isStudent ? 'Signup' : 'Signup',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── SHARED FIELDS ──────────
                  _label('Full Name *'),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: name,
                    hint: 'Enter Name',
                    icon: Icons.person_outline,
                    validator: validateName,
                    capitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 14),

                  // ── STUDENT SPECIFIC ───────
                  if (isStudent) ...[
                    _label('University or college email *'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: email,
                      hint: emailHint,
                      icon: Icons.email_outlined,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (domain != null && domain.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text('Must end in @$domain',
                          style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
                      ),
                    ],
                    const SizedBox(height: 14),

                    _label('University / TVET College *'),
                    const SizedBox(height: 6),
                    _DropdownField(
                      value: selectedInstitution,
                      hint: 'Select your institution',
                      icon: Icons.school_outlined,
                      items: institutions.map((inst) => DropdownMenuItem<String>(
                        value: inst['name'] as String,
                        child: Text(inst['name'] as String,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13)),
                      )).toList(),
                      validator: (v) => v == null ? 'Please select your institution' : null,
                      onChanged: onInstitutionChanged,
                    ),

                    if (showCustomInput) ...[
                      const SizedBox(height: 10),
                      _inputField(
                        controller: customInstitution,
                        hint: 'Type your institution name',
                        icon: Icons.edit_outlined,
                        validator: (v) => (v == null || v.isEmpty) ? 'Please enter your institution' : null,
                        capitalization: TextCapitalization.words,
                      ),
                    ],
                    const SizedBox(height: 14),
                  ],

                  // ── BUYER SPECIFIC ─────────
                  if (!isStudent) ...[
                    _label('Email Address *'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: email,
                      hint: 'Enter email',
                      icon: Icons.email_outlined,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    _label('Buyer Type *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final type in [
                          {'key': 'business', 'label': '🏢 Business', },
                          {'key': 'parent', 'label': '👨‍👩‍👧 Parent'},
                          {'key': 'ngo', 'label': '🌍 NGO'},
                          {'key': 'student', 'label': '🎓 Student'},
                        ])
                          GestureDetector(
                            onTap: () => onBuyerTypeChanged(type['key']),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color: buyerType == type['key']
                                    ? AppColors.primary.withOpacity(0.08)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: buyerType == type['key']
                                      ? AppColors.primary
                                      : const Color(0xFFEEEEEE),
                                  width: buyerType == type['key'] ? 1.5 : 1,
                                ),
                              ),
                              child: Text(type['label']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: buyerType == type['key']
                                      ? AppColors.primary
                                      : AppColors.textGrey,
                                )),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _label('Company / Organisation Name (optional)'),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: companyName,
                      hint: 'e.g. Acme Corp',
                      icon: Icons.business_outlined,
                      capitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 14),
                  ],

                  // ── SHARED ─────────────────
                  _label('City *'),
                  const SizedBox(height: 6),
                  _inputField(
                    controller: city,
                    hint: 'Enter City',
                    icon: Icons.location_city_outlined,
                    validator: (v) => (v == null || v.isEmpty) ? 'City is required' : null,
                    capitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 14),

                  _label('Create Password *'),
                  const SizedBox(height: 6),
                  _PasswordField(
                    controller: password,
                    hint: 'Enter Password',
                    obscure: obscure,
                    onToggle: onToggleObscure,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 14),

                  _label('Confirm Password *'),
                  const SizedBox(height: 6),
                  _PasswordField(
                    controller: confirmPassword,
                    hint: 'Confirm Password',
                    obscure: obscureConfirm,
                    onToggle: onToggleObscureConfirm,
                    validator: validateConfirm,
                  ),
                  const SizedBox(height: 28),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: onSubmit,
                      child: Text(
                        isStudent ? 'Create Student Account' : 'Create Buyer Account',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: const Color(0xFFF0F0F0))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      ),
                      Expanded(child: Container(height: 1, color: const Color(0xFFF0F0F0))),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialBtn(icon: Icons.g_mobiledata_rounded, label: 'Google', onTap: () {}),
                      const SizedBox(width: 12),
                      _SocialBtn(icon: Icons.facebook_rounded, label: 'Facebook', onTap: () {}),
                      const SizedBox(width: 12),
                      _SocialBtn(icon: Icons.apple_rounded, label: 'Apple', onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: GestureDetector(
                      onTap: onLogin,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textGrey,
      letterSpacing: 0.2,
    ));

  Widget _tab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 2.5,
            ),
          ),
        ),
        child: Text(label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textGrey,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 15,
          )),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFBBBBBB), size: 20),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PASSWORD FIELD
// ─────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
        prefixIcon: const Icon(Icons.lock_outline_rounded, color: Color(0xFFBBBBBB), size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFFBBBBBB), size: 20,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DROPDOWN FIELD
// ─────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<String>> items;
  final String? Function(String?)? validator;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 13, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
        prefixIcon: Icon(icon, color: const Color(0xFFBBBBBB), size: 20),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
      items: items,
    );
  }
}

// ─────────────────────────────────────────────
// SOCIAL BUTTON
// ─────────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SocialBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
        ),
        child: Icon(icon, size: 22, color: const Color(0xFF444444)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WAVE PAINTER — diagonal wave between red + white
// ─────────────────────────────────────────────
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path();
    path.moveTo(0, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.1,
      size.width * 0.5, size.height * 0.45,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.8,
      size.width, size.height * 0.35,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}