// lib/features/onboarding/presentation/onboarding_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/widgets/gude_logo.dart';

// ─────────────────────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────────────────────
class _PageData {
  final String title;
  final String description;
  final String illustration; // emoji stand-in; swap for Image.asset
  final Color  bgTint;

  const _PageData({
    required this.title,
    required this.description,
    required this.illustration,
    required this.bgTint,
  });
}

const _pages = [
  _PageData(
    title:       'Student Wallet',
    description: 'Unlock the key to a better student life with smart budgeting tools and real-time spend tracking.',
    illustration: '💰',
    bgTint:      Color(0xFFFFF3F3),
  ),
  _PageData(
    title:       'Marketplace',
    description: 'Sell your skills, buy what you need — all within the student community at unbeatable prices.',
    illustration: '🛍️',
    bgTint:      Color(0xFFFFF3F3),
  ),
  _PageData(
    title:       'Wellness',
    description: 'Track your mental and physical wellbeing while staying on top of your studies and goals.',
    illustration: '🧘',
    bgTint:      Color(0xFFFFF3F3),
  ),
  _PageData(
    title:       'Finance Games',
    description: 'Learn financial literacy through fun, interactive games and challenges designed for students.',
    illustration: '🎮',
    bgTint:      Color(0xFFFFF3F3),
  ),
];

// ─────────────────────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────────────────────
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final _pageCtrl = PageController();
  int _current = 0;

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim =
        CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int i) {
    _fadeCtrl.reset();
    _fadeCtrl.forward();
    setState(() => _current = i);
  }

  void _next() {
    if (_current < _pages.length - 1) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GudeLockup(logoSize: 28, textColor: const Color(0xFF1A1A1A)),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF888888),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Color(0xFFEEEEEE))),
                    ),
                    child: const Text('Skip',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),

            // ── Page view ───────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (_, i) => _OnboardSlide(
                  data: _pages[i],
                  screenHeight: size.height,
                ),
              ),
            ),

            // ── Bottom controls ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _current == i ? 22 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _current == i
                              ? const Color(0xFFE30613)
                              : const Color(0xFFDDDDDD),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Next / Get Started button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page counter text
                      Text(
                        '${_current + 1} / ${_pages.length}',
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFFAAAAAA)),
                      ),

                      // Arrow button
                      GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
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

// ─────────────────────────────────────────────────────────────
// INDIVIDUAL SLIDE
// ─────────────────────────────────────────────────────────────
class _OnboardSlide extends StatelessWidget {
  final _PageData data;
  final double screenHeight;

  const _OnboardSlide({required this.data, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Illustration area — swap emoji for Image.asset in production
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: data.bgTint,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  data.illustration,
                  style: TextStyle(fontSize: screenHeight * 0.15),
                ),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.6,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),

          // Description
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}