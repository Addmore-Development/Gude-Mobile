import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary = Color(0xFFE30613);
  static const dark = Color(0xFF1A1A1A);
  static const grey = Color(0xFF888888);
  static const border = Color(0xFFE0E0E0);
  static const inputBg = Color(0xFFFAFAFA);
  static const errorRed = Color(0xFFE30613);
}

// ─────────────────────────────────────────────
// LOGIN PAGE
// ─────────────────────────────────────────────
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _obscure = true;
  bool _rememberMe = false;
  bool _hasError = false;
  bool _emailError = false;
  bool _passwordError = false;
  String? _emailValidationError;

  String _role = 'student';

  // Validate student email (must end with .ac.za or .edu.za)
  bool _isValidStudentEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    final re = RegExp(r'^[^@]+@[^@]+\.(ac\.za|edu\.za)$', caseSensitive: false);
    return re.hasMatch(trimmed);
  }

  void _login() {
    setState(() {
      _emailError = _email.text.trim().isEmpty;
      _passwordError = _password.text.isEmpty;
      _emailValidationError = null;

      // Strict student email validation
      if (_role == 'student' && !_emailError) {
        if (!_isValidStudentEmail(_email.text)) {
          _emailValidationError =
              'Use your official student email ending in .ac.za or .edu.za';
          _emailError = true;
        }
      }

      _hasError = _emailError || _passwordError;
    });

    if (!_hasError) {
      if (_role == 'buyer') {
        context.go('/buyer/marketplace');
      } else {
        context.go('/home');
      }
    }
  }

  void _clearEmailErrors() {
    setState(() {
      _emailError = false;
      _emailValidationError = null;
      _hasError = _hasError && _passwordError; // keep password error if any
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Back button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.go('/onboarding'),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_rounded,
                            size: 14, color: _C.dark),
                        SizedBox(width: 4),
                        Text('back',
                            style: TextStyle(
                                fontSize: 13,
                                color: _C.dark,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _C.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('G',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: -0.5)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('GUDE',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: _C.dark,
                          letterSpacing: -0.5)),
                ],
              ),

              const SizedBox(height: 20),
              const Text('Welcome Back',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _C.dark,
                      letterSpacing: -0.5)),
              const SizedBox(height: 6),
              const Text('Log in to your account',
                  style: TextStyle(fontSize: 13, color: _C.grey)),
              const SizedBox(height: 24),

              // Role Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('I am logging in as',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _C.grey)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleCard(
                            emoji: '🎓',
                            label: 'Student',
                            selected: _role == 'student',
                            onTap: () {
                              setState(() => _role = 'student');
                              _clearEmailErrors();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RoleCard(
                            emoji: '🛒',
                            label: 'Buyer',
                            selected: _role == 'buyer',
                            onTap: () {
                              setState(() => _role = 'buyer');
                              _clearEmailErrors();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Email Address'),
                      const SizedBox(height: 6),
                      _inputField(
                        controller: _email,
                        hint: _role == 'student'
                            ? 'your.name@university.ac.za'
                            : 'username or email address',
                        hasError: _emailError,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: _clearEmailErrors,
                      ),

                      // Error messages
                      if (_emailError) ...[
                        const SizedBox(height: 4),
                        _errorText(
                            _emailValidationError ?? 'Email is required'),
                      ],

                      const SizedBox(height: 14),

                      // Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _label('Password'),
                          GestureDetector(
                            onTap: () => context.go('/forgot-password'),
                            child: const Text('Forgot password?',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _C.primary,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _passwordField(),
                      if (_passwordError) _errorText('Enter your password'),

                      // Generic login error
                      if (_hasError && !_emailError && !_passwordError) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _C.errorRed.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Combination of email and password is incorrect',
                            style: TextStyle(fontSize: 12, color: _C.errorRed),
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v ?? false),
                              activeColor: _C.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Keep me logged in',
                              style: TextStyle(fontSize: 12, color: _C.grey)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _C.dark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _login,
                          child: Text(
                            _role == 'buyer'
                                ? 'Log in as Buyer'
                                : 'Log in as Student',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Google Sign In
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _C.dark,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side:
                                const BorderSide(color: _C.border, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          icon: const Text('G',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFDB4437))),
                          label: const Text('Log in with Google',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => context.go('/signup'),
                          child: RichText(
                            text: const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(fontSize: 13, color: _C.grey),
                              children: [
                                TextSpan(
                                  text: 'Sign up',
                                  style: TextStyle(
                                      color: _C.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w500, color: _C.grey),
      );

  Widget _errorText(String msg) => Text(
        msg,
        style: const TextStyle(fontSize: 11, color: _C.errorRed),
      );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    bool hasError = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: _C.dark),
      onChanged: (_) => onChanged?.call(),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
        filled: true,
        fillColor: hasError ? _C.errorRed.withOpacity(0.04) : _C.inputBg,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: hasError ? _C.errorRed : _C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: hasError ? _C.errorRed : _C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: hasError ? _C.errorRed : _C.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _password,
      obscureText: _obscure,
      style: const TextStyle(fontSize: 14, color: _C.dark),
      onChanged: (_) => setState(() {
        _passwordError = false;
        _hasError = false;
      }),
      decoration: InputDecoration(
        hintText: 'Enter Password',
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
        filled: true,
        fillColor: _passwordError ? _C.errorRed.withOpacity(0.04) : _C.inputBg,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18,
            color: const Color(0xFFBBBBBB),
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: _passwordError ? _C.errorRed : _C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: _passwordError ? _C.errorRed : _C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: _passwordError ? _C.errorRed : _C.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// ROLE CARD
// ─────────────────────────────────────────────
class _RoleCard extends StatelessWidget {
  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color:
              selected ? _C.primary.withOpacity(0.06) : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _C.primary : _C.border,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _C.primary : Colors.transparent,
                border: Border.all(
                  color: selected ? _C.primary : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? _C.primary : _C.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
