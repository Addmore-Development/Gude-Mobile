import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/shared/widgets/gude_header.dart';

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
  bool _error = false;

  static final _saEmailRegex = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.ac\.za$',
    caseSensitive: false,
  );

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!_saEmailRegex.hasMatch(value)) {
      return 'Use your student email e.g. s21961082@mandela.ac.za';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void _login() {
    setState(() => _error = false);
    if (_formKey.currentState!.validate()) {
      context.go('/home');
    } else {
      setState(() => _error = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GudeHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.inputBorder))),
                      child: Row(children: [
                        _tab('Log In', true, () {}),
                        _tab('Sign Up', false, () => context.go('/signup')),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    _label('Email Address *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _email,
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'e.g. s21961082@mandela.ac.za',
                        prefixIcon: Icon(Icons.email_outlined,
                          color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label('Password *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        prefixIcon: const Icon(Icons.lock_outline,
                          color: AppColors.textGrey, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                            color: AppColors.textGrey, size: 20),
                          onPressed: () =>
                            setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                    if (_error) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Combination of email and password is incorrect',
                        style: TextStyle(
                          color: AppColors.primary, fontSize: 12)),
                    ],
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.go('/forgot-password'),
                        child: const Text('Forgot Password ?',
                          style: TextStyle(
                            color: AppColors.primary, fontSize: 13)),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Log In',
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 24),
                    const Row(children: [
                      Expanded(child: Divider(color: AppColors.inputBorder)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Or',
                          style: TextStyle(color: AppColors.textGrey))),
                      Expanded(child: Divider(color: AppColors.inputBorder)),
                    ]),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialCircle(child: Text('G',
                          style: const TextStyle(
                            color: Color(0xFFDB4437),
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                        const SizedBox(width: 16),
                        _socialCircle(child: Text('f',
                          style: const TextStyle(
                            color: Color(0xFF1877F2),
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                        const SizedBox(width: 16),
                        _socialCircle(child: const Icon(
                          Icons.apple, size: 22, color: Colors.black)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/signup'),
                        child: RichText(
                          text: const TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: AppColors.textGrey),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                )),
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
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textGrey,
    ));

  Widget _tab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          )),
        ),
        child: Text(label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textGrey,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 15,
          )),
      ),
    );
  }

  Widget _socialCircle({required Widget child}) => Container(
    width: 48, height: 48,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Center(child: child),
  );
}
