import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';
import 'package:gude_mobile/shared/widgets/gude_header.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _city = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const GudeHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.inputBorder))),
                    child: Row(children: [
                      _tab('Log In', false, () => context.go('/login')),
                      _tab('Sign Up', true, () {}),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  _field('Full Name', 'Enter Name', _name),
                  const SizedBox(height: 16),
                  _field('University or college email', 'Enter email', _email,
                    type: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _field('City', 'Enter City', _city),
                  const SizedBox(height: 16),
                  const Text('Create Password *',
                    style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _password,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                          color: AppColors.textGrey, size: 20),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/marketplace'),
                    child: const Text('Create Account',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(
            color: selected ? AppColors.primary : Colors.transparent, width: 2))),
        child: Text(label, style: TextStyle(
          color: selected ? AppColors.primary : AppColors.textGrey,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        )),
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController c,
      {TextInputType type = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        const SizedBox(height: 6),
        TextField(controller: c, keyboardType: type,
          decoration: InputDecoration(hintText: hint)),
      ],
    );
  }
}

