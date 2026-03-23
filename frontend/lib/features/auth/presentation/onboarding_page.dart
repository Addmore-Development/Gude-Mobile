import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  final _pages = [
    _OBData('Student Wallet', 'Unlock the key to a better student life with smart budgeting tools.', Icons.account_balance_wallet_outlined),
    _OBData('Marketplace', 'Sell your skills, buy what you need — all within the student community.', Icons.storefront_outlined),
    _OBData('Wellness', 'Track your mental and physical wellbeing while staying on top of studies.', Icons.favorite_outline),
    _OBData('Finance Games', 'Learn financial literacy through fun, interactive games and challenges.', Icons.sports_esports_outlined),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) {
                  final d = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200, height: 200,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF0F4FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(d.icon, size: 80, color: AppColors.primary),
                        ),
                        const SizedBox(height: 40),
                        Text(d.title, style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        )),
                        const SizedBox(height: 16),
                        Text(d.description, textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15, color: AppColors.textGrey, height: 1.5,
                          )),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _page == i ? AppColors.primary : AppColors.inputBorder,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(
                      _page == _pages.length - 1 ? 'Get Started' : 'Next',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Skip',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
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

class _OBData {
  final String title, description;
  final IconData icon;
  _OBData(this.title, this.description, this.icon);
}

