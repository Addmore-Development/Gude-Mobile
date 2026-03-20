import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeAnim  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.easeOut)));
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6, curve: Curves.elasticOut)));
    _controller.forward();

    // Go to onboarding after animation
    // TODO: after Firebase setup, check auth state here and redirect to /home if logged in
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      context.go(AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gudeRed,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Center(
                    child: Text('G',
                      style: TextStyle(fontSize: 52, fontWeight: FontWeight.w800,
                        color: AppColors.gudeRed, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Gude',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700,
                    color: AppColors.white, fontFamily: 'Poppins', letterSpacing: 1),
                ),
                const SizedBox(height: 6),
                const Text('The Student Economy',
                  style: TextStyle(fontSize: 14, color: Colors.white70,
                    fontFamily: 'Poppins', letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}