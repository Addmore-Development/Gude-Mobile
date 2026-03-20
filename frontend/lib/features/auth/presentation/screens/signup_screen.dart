import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../controllers/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/gude_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey       = GlobalKey<FormState>();
  final _nameCtrl      = TextEditingController();
  final _emailCtrl     = TextEditingController();
  final _phoneCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _confirmCtrl   = TextEditingController();
  bool _agreedToTerms  = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    FocusScope.of(context).unfocus();

    final success = await ref.read(authProvider.notifier).signUp(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      fullName: _nameCtrl.text.trim(),
    );

    if (!mounted) return;
    if (success) {
      context.go(AppRoutes.studentVerify);
    } else {
      final error = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? AppStrings.genericError),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size      = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Red Header ────────────────────────────────────
            Container(
              width: double.infinity,
              height: size.height * 0.22,
              decoration: const BoxDecoration(
                color: AppColors.gudeRed,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                        onPressed: () => context.go(AppRoutes.onboarding),
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        AppStrings.signUp,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const Text(
                        'Join the Student Economy 🎓',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Form ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),

                    // Full Name
                    AuthTextField(
                      label: AppStrings.fullName,
                      hint: AppStrings.fullNameHint,
                      controller: _nameCtrl,
                      keyboardType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textHint, size: 20),
                      validator: Validators.fullName,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AuthTextField(
                      label: AppStrings.emailLabel,
                      hint: AppStrings.emailHint,
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint, size: 20),
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 16),

                    // Phone
                    AuthTextField(
                      label: AppStrings.phoneNumber,
                      hint: AppStrings.phoneHint,
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textHint, size: 20),
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AuthTextField(
                      label: AppStrings.passwordLabel,
                      hint: AppStrings.passwordHint,
                      controller: _passwordCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textHint, size: 20),
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    AuthTextField(
                      label: AppStrings.confirmPassword,
                      hint: 'Re-enter your password',
                      controller: _confirmCtrl,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textHint, size: 20),
                      validator: (v) => Validators.confirmPassword(v, _passwordCtrl.text),
                    ),
                    const SizedBox(height: 20),

                    // Terms checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                          activeColor: AppColors.gudeRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Expanded(
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                              children: [
                                TextSpan(text: 'I agree to Gude\'s '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: TextStyle(
                                    color: AppColors.gudeRed,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(
                                    color: AppColors.gudeRed,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Create Account Button
                    GudeButton(
                      label: AppStrings.createAccount,
                      onPressed: _submit,
                      isLoading: authState.isLoading,
                    ),
                    const SizedBox(height: 24),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          AppStrings.alreadyHaveAcc,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.login),
                          child: const Text(
                            AppStrings.logIn,
                            style: TextStyle(
                              color: AppColors.gudeRed,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
