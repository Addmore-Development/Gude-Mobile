import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text('G', style: TextStyle(
                  color: Colors.white, fontSize: 48,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ),
            const SizedBox(height: 16),
            const Text('GUDE', style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold,
              letterSpacing: 4, color: AppColors.textDark,
            )),
          ],
        ),
      ),
    );
  }
}

