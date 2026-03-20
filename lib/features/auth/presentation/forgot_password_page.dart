import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';
import 'package:gude_mobile/shared/widgets/gude_header.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();
  bool _obscure1 = true, _obscure2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GudeHeader(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Forgot Password', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )),
                  const SizedBox(height: 8),
                  const Text(
                    "We'll send instructions on how to reset your password to your email.",
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text('Email Address *',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  TextField(controller: _email,
                    decoration: const InputDecoration(hintText: 'Enter email')),
                  const SizedBox(height: 16),
                  const Text('Create New Password *',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _newPass, obscureText: _obscure1,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure1
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                          color: AppColors.textGrey, size: 20),
                        onPressed: () => setState(() => _obscure1 = !_obscure1),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Confirm New Password *',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _confirmPass, obscureText: _obscure2,
                    decoration: InputDecoration(
                      hintText: 'Enter Password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure2
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                          color: AppColors.textGrey, size: 20),
                        onPressed: () => setState(() => _obscure2 = !_obscure2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Create',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go('/login'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppColors.inputBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel',
                      style: TextStyle(color: AppColors.textDark, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

