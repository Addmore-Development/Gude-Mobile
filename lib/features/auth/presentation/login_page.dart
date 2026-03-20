import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';
import 'package:gude_mobile/shared/widgets/gude_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _error = false;

  void _login() {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      setState(() => _error = true);
      return;
    }
    setState(() => _error = false);
    context.go('/home');
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _tabs(context),
                  const SizedBox(height: 24),
                  _label('Email Address *'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Enter email'),
                  ),
                  const SizedBox(height: 16),
                  _label('Password *'),
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
                  if (_error)
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text('Combination of email and password is incorrect',
                        style: TextStyle(color: AppColors.primary, fontSize: 12)),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/forgot-password'),
                      child: const Text('Forgot Password ?',
                        style: TextStyle(color: AppColors.primary, fontSize: 13)),
                    ),
                  ),
                  ElevatedButton(onPressed: _login,
                    child: const Text('Log In',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
                  const SizedBox(height: 24),
                  _orDivider(),
                  const SizedBox(height: 16),
                  _socialRow(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(fontSize: 12, color: AppColors.textGrey));

  Widget _tabs(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.inputBorder))),
      child: Row(
        children: [
          _tab('Log In', true, () {}),
          _tab('Sign Up', false, () => context.go('/signup')),
        ],
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
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          )),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? AppColors.primary : AppColors.textGrey,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        )),
      ),
    );
  }

  Widget _orDivider() => const Row(children: [
    Expanded(child: Divider(color: AppColors.inputBorder)),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Text('Or', style: TextStyle(color: AppColors.textGrey))),
    Expanded(child: Divider(color: AppColors.inputBorder)),
  ]);

  Widget _socialRow() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _socialBtn('G', const Color(0xFFDB4437)),
      const SizedBox(width: 16),
      _socialBtn('f', const Color(0xFF1877F2)),
      const SizedBox(width: 16),
      _socialCircle(child: const Icon(Icons.apple, size: 22, color: Colors.black)),
    ],
  );

  Widget _socialBtn(String label, Color color) => _socialCircle(
    child: Text(label, style: TextStyle(
      color: color, fontSize: 18, fontWeight: FontWeight.bold)));

  Widget _socialCircle({required Widget child}) => Container(
    width: 48, height: 48,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.inputBorder),
    ),
    child: Center(child: child),
  );
}

