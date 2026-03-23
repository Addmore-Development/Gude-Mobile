import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';
import 'package:gude_app/shared/widgets/gude_header.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _institution = TextEditingController();
  final _city = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Full name is required';
    if (value.trim().split(' ').length < 2) return 'Enter first and last name';
    return null;
  }

  String? _validateInstitution(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your university or TVET college name';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      context.go('/home');
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
                        _tab('Log In', false, () => context.go('/login')),
                        _tab('Sign Up', true, () {}),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    _label('Full Name *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _name,
                      validator: _validateName,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'Enter first and last name',
                        prefixIcon: Icon(Icons.person_outline,
                          color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label('University / TVET College *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _institution,
                      validator: _validateInstitution,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Nelson Mandela University',
                        prefixIcon: Icon(Icons.school_outlined,
                          color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.15)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                            size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'UJ · TUT · NMU · UCT · Wits · UKZN · UFS · SU · NWU · DUT · CPUT · UL · TVET College',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textGrey,
                              )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label('Student Email *'),
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
                    const SizedBox(height: 6),
                    const Text(
                      'Must be your official student email ending in .ac.za',
                      style: TextStyle(fontSize: 11, color: AppColors.textGrey),
                    ),
                    const SizedBox(height: 16),
                    _label('City *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _city,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                        v == null || v.isEmpty ? 'City is required' : null,
                      decoration: const InputDecoration(
                        hintText: 'e.g. Port Elizabeth',
                        prefixIcon: Icon(Icons.location_city_outlined,
                          color: AppColors.textGrey, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _label('Create Password *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        hintText: 'Minimum 8 characters',
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
                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: _signup,
                      child: const Text('Create Account',
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/login'),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: AppColors.textGrey),
                            children: [
                              TextSpan(
                                text: 'Log In',
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
}
