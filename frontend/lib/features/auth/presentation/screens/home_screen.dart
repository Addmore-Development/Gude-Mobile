import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// GUDE HOME SCREEN
// Font: Poppins — Regular 14 (body), SemiBold 24 (headings)
// Colors: #FF3B3C (red), #232323 (heading), #000000 (body), #FFFFFF (white)
// ─────────────────────────────────────────────────────────────────────────────

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _HeroSection(),
            _FeaturesSection(),
            _HowItWorksSection(),
            _StabilityScoreSection(),
            _TestimonialsSection(),
            _CtaBannerSection(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HERO
// ─────────────────────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Red background with wave clip
        ClipPath(
          clipper: _HeroClipper(),
          child: Container(
            color: const Color(0xFFFF3B3C),
            padding: const EdgeInsets.only(bottom: 64),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Nav ──
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'G',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFFF3B3C),
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'GUDE',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Headline + illustration row ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Live badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.35),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF7EF7A0),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      "SA'S STUDENT PLATFORM",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Earn.\nSave.\nStay in school.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'The all-in-one app helping South African students build income and beat the dropout crisis.',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.8),
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Illustration
                        _HeroIllustration(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── CTA Buttons ──
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFFFF3B3C),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Get Started',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Stats Row ──
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.22),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: _StatItem(
                                number: '12K+', label: 'Students'),
                          ),
                          _StatDivider(),
                          Expanded(
                            child: _StatItem(
                                number: 'R2.4M', label: 'Earned'),
                          ),
                          _StatDivider(),
                          Expanded(
                            child: _StatItem(
                                number: '340+', label: 'Gigs Posted'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SVG-like illustration using Flutter primitives — student with phone/wallet
    return SizedBox(
      width: 110,
      height: 140,
      child: CustomPaint(painter: _StudentIllustrationPainter()),
    );
  }
}

class _StudentIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withOpacity(0.95);
    final whiteFaint = Paint()..color = Colors.white.withOpacity(0.18);
    final accent = Paint()..color = Colors.white.withOpacity(0.6);
    final skin = Paint()..color = const Color(0xFFF5CBA7);
    final dark = Paint()..color = const Color(0xFF3D2314);
    final red = Paint()..color = const Color(0xFFFF6B6B);

    // Background circle
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.45),
        size.width * 0.42, whiteFaint);

    // Phone body
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.2, size.width * 0.5,
          size.height * 0.55),
      const Radius.circular(10),
    );
    canvas.drawRRect(phoneRect, white);

    // Phone screen
    final screenPaint = Paint()..color = const Color(0xFFFFECEC);
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.26, size.width * 0.4,
          size.height * 0.42),
      const Radius.circular(6),
    );
    canvas.drawRRect(screenRect, screenPaint);

    // Screen content lines (wallet UI simulation)
    final linePaint = Paint()
      ..color = const Color(0xFFFF3B3C).withOpacity(0.4)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(size.width * 0.38, size.height * 0.32),
        Offset(size.width * 0.62, size.height * 0.32),
        linePaint);

    final linePaint2 = Paint()
      ..color = const Color(0xFFFF3B3C).withOpacity(0.2)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(size.width * 0.38, size.height * 0.38),
        Offset(size.width * 0.58, size.height * 0.38),
        linePaint2);

    // Mini bar chart on screen
    final barRed = Paint()..color = const Color(0xFFFF3B3C).withOpacity(0.7);
    final barGrey = Paint()..color = const Color(0xFFFF3B3C).withOpacity(0.25);
    final barW = size.width * 0.055;
    final barBaseY = size.height * 0.59;

    final bars = [0.4, 0.65, 0.5, 0.8, 0.55, 0.7];
    for (int i = 0; i < bars.length; i++) {
      final bh = bars[i] * size.height * 0.2;
      final bx = size.width * 0.37 + i * (barW + size.width * 0.015);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(bx, barBaseY - bh, barW, bh),
          const Radius.circular(2),
        ),
        i > 2 ? barRed : barGrey,
      );
    }

    // Coin / R symbol floating
    canvas.drawCircle(
        Offset(size.width * 0.15, size.height * 0.35), 14, white);
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'R',
        style: TextStyle(
          color: Color(0xFFFF3B3C),
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas,
        Offset(size.width * 0.15 - 5, size.height * 0.35 - 8));

    // Star / sparkle
    canvas.drawCircle(
        Offset(size.width * 0.85, size.height * 0.18), 6, white);
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.72), 4, accent);
    canvas.drawCircle(
        Offset(size.width * 0.08, size.height * 0.65), 5, accent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  const _StatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.25),
    );
  }
}

class _HeroClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 48);
    path.quadraticBezierTo(
      size.width * 0.25, size.height,
      size.width * 0.5, size.height - 24,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height - 48,
      size.width, size.height - 16,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// FEATURES
// ─────────────────────────────────────────────────────────────────────────────

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  static const _features = [
    _FeatureData(
      icon: Icons.account_balance_wallet_outlined,
      iconColor: Color(0xFFFF3B3C),
      iconBg: Color(0xFFFFF0F0),
      title: 'Student Wallet',
      desc: 'Track NSFAS funds, budget smart, set savings goals.',
      tag: 'Finance',
      tagColor: Color(0xFFFF3B3C),
      tagBg: Color(0xFFFFF0F0),
    ),
    _FeatureData(
      icon: Icons.storefront_outlined,
      iconColor: Color(0xFF16A34A),
      iconBg: Color(0xFFF0FFF4),
      title: 'Marketplace',
      desc: 'Sell your skills — tutoring, design, coding and more.',
      tag: 'Earn',
      tagColor: Color(0xFF16A34A),
      tagBg: Color(0xFFF0FFF4),
    ),
    _FeatureData(
      icon: Icons.track_changes_outlined,
      iconColor: Color(0xFF2563EB),
      iconBg: Color(0xFFEFF6FF),
      title: 'Stability Score',
      desc: 'Early support and intervention when you need it most.',
      tag: 'Wellbeing',
      tagColor: Color(0xFF2563EB),
      tagBg: Color(0xFFEFF6FF),
    ),
    _FeatureData(
      icon: Icons.rocket_launch_outlined,
      iconColor: Color(0xFFEA580C),
      iconBg: Color(0xFFFFF7ED),
      title: 'Quick Gigs',
      desc: 'Micro internships and fast-paying campus jobs.',
      tag: 'Opportunity',
      tagColor: Color(0xFFEA580C),
      tagBg: Color(0xFFFFF7ED),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'What Gude Does',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF232323),
                ),
              ),
              Text(
                'Explore →',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF3B3C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: _features.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _FeatureCard(data: _features[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String desc;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  const _FeatureData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.desc,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  const _FeatureCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            data.title,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF232323),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: Color(0xFF777777),
              height: 1.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: data.tagBg,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              data.tag,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: data.tagColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOW IT WORKS
// ─────────────────────────────────────────────────────────────────────────────

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  static const _steps = [
    _StepData(
      num: '1',
      title: 'Sign up as a Student',
      desc: 'Verify your student status with your university ID. Takes 2 minutes.',
      isActive: true,
    ),
    _StepData(
      num: '2',
      title: 'List your skills or browse gigs',
      desc: 'Tutoring, design, coding, editing — turn your talents into income.',
      isActive: true,
    ),
    _StepData(
      num: '3',
      title: 'Get paid to your Gude Wallet',
      desc: 'Money lands in your wallet instantly. Budget, save, or withdraw.',
      isActive: true,
    ),
    _StepData(
      num: '4',
      title: 'Stay supported, stay enrolled',
      desc: 'Your Stability Score monitors your wellbeing and unlocks help when needed.',
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How It Works',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF232323),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: const Color(0xFFEEEEEE), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Column(
              children: List.generate(_steps.length, (i) {
                return _StepRow(
                  data: _steps[i],
                  isLast: i == _steps.length - 1,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  final String num;
  final String title;
  final String desc;
  final bool isActive;
  const _StepData(
      {required this.num,
      required this.title,
      required this.desc,
      required this.isActive});
}

class _StepRow extends StatelessWidget {
  final _StepData data;
  final bool isLast;
  const _StepRow({required this.data, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number + line
          SizedBox(
            width: 34,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: data.isActive
                        ? const Color(0xFFFF3B3C)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: data.isActive
                        ? null
                        : Border.all(
                            color: const Color(0xFFFF3B3C).withOpacity(0.3),
                            width: 1.5),
                    boxShadow: data.isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFFFF3B3C).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      data.num,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: data.isActive
                            ? Colors.white
                            : const Color(0xFFFF3B3C),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFF3B3C).withOpacity(0.4),
                            const Color(0xFFFF3B3C).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                if (isLast) const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF232323),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.desc,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF777777),
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STABILITY SCORE
// ─────────────────────────────────────────────────────────────────────────────

class _StabilityScoreSection extends StatelessWidget {
  const _StabilityScoreSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Safety Net',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF232323),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFF3B3C),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF3B3C).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: -30,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STUDENT STABILITY SCORE',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.65),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Know when to ask for help — before it\'s too late.',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  '82',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'STABLE',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white.withOpacity(0.75),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      // Bar chart
                      SizedBox(
                        height: 40,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final h in [
                              0.4, 0.65, 0.5, 0.8, 0.55, 0.7,
                              0.45, 0.6, 0.5, 0.45, 0.38, 0.32
                            ]) ...[
                              Expanded(
                                child: Container(
                                  height: 40 * h,
                                  decoration: BoxDecoration(
                                    color: h >= 0.5
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '🟢 Financially stable · Marketplace active · Check-in due',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TESTIMONIALS
// ─────────────────────────────────────────────────────────────────────────────

class _TestimonialsSection extends StatelessWidget {
  const _TestimonialsSection();

  static const _reviews = [
    _ReviewData(
      initials: 'TM',
      avatarColor: Color(0xFFFF3B3C),
      name: 'Thabo M.',
      uni: 'Wits University · 3rd Year',
      text:
          '"I paid my February rent with money I made from tutoring on Gude. I never thought that was possible as a student."',
    ),
    _ReviewData(
      initials: 'KD',
      avatarColor: Color(0xFF8B5CF6),
      name: 'Kuhle D.',
      uni: 'UCT · 2nd Year',
      text:
          '"Gude told me I was spending too fast before month-end. The budget alert literally saved me from going hungry."',
    ),
    _ReviewData(
      initials: 'LN',
      avatarColor: Color(0xFF0EA5E9),
      name: 'Lerato N.',
      uni: 'TUT · Honours',
      text:
          '"Got 3 design gigs in my first week. Building a portfolio while earning — this is exactly what SA students needed."',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with consistent padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'What Students Say',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF232323),
                  ),
                ),
                Text(
                  'All Reviews →',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF3B3C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Horizontally scrollable cards
          SizedBox(
            height: 176,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              clipBehavior: Clip.none,
              itemCount: _reviews.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) =>
                  _ReviewCard(data: _reviews[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewData {
  final String initials;
  final Color avatarColor;
  final String name;
  final String uni;
  final String text;
  const _ReviewData({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.uni,
    required this.text,
  });
}

class _ReviewCard extends StatelessWidget {
  final _ReviewData data;
  const _ReviewCard({required this.data});

  @override
  Widget build(BuildContext context) {
    // Card is a fixed fraction of screen width to ensure full visibility + hint of next card
    final cardWidth =
        MediaQuery.of(context).size.width * 0.72;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stars
          Row(
            children: List.generate(
              5,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(Icons.star_rounded,
                    color: Color(0xFFFFB800), size: 14),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Review text
          Expanded(
            child: Text(
              data.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Author
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: data.avatarColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    data.initials,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF232323),
                    ),
                  ),
                  Text(
                    data.uni,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CTA BANNER
// ─────────────────────────────────────────────────────────────────────────────

class _CtaBannerSection extends StatelessWidget {
  const _CtaBannerSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B3C),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF3B3C).withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Decorative blobs
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Illustration row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Don't be the",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.2,
                              ),
                            ),
                            const Text(
                              '1 in 3',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              'who drops out.',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _CtaIllustration(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '12,000+ students already on the platform. Every day without Gude is income left on the table.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Checklist
                  ...[
                    'Free to sign up. No hidden fees.',
                    'Earn from Day 1 — post your first listing in minutes.',
                    'Built for SA students. Understands NSFAS.',
                  ].map((text) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: const EdgeInsets.only(top: 1),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.9),
                                  height: 1.45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 22),
                  // CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF3B3C),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Join the Student Economy →',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

class _CtaIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 110,
      child: CustomPaint(painter: _CtaIllustrationPainter()),
    );
  }
}

class _CtaIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final white = Paint()..color = Colors.white.withOpacity(0.9);
    final whiteFaint = Paint()..color = Colors.white.withOpacity(0.15);
    final accent = Paint()..color = Colors.white.withOpacity(0.5);

    // Background glow circle
    canvas.drawCircle(
        Offset(size.width * 0.55, size.height * 0.5),
        size.width * 0.42,
        whiteFaint);

    // Graduation cap
    final capPaint = Paint()..color = Colors.white;
    // Board
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.2, size.height * 0.35,
            size.width * 0.6, size.height * 0.1),
        const Radius.circular(4),
      ),
      capPaint,
    );
    // Triangle top
    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.lineTo(size.width * 0.18, size.height * 0.38);
    path.lineTo(size.width * 0.82, size.height * 0.38);
    path.close();
    canvas.drawPath(path, capPaint);

    // Tassel
    final tasselPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(size.width * 0.78, size.height * 0.42),
        Offset(size.width * 0.78, size.height * 0.6),
        tasselPaint);
    canvas.drawCircle(
        Offset(size.width * 0.78, size.height * 0.62), 5, accent);

    // Money / rising arrows
    final arrowPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final x = size.width * (0.22 + i * 0.2);
      final h = size.height * (0.18 + i * 0.04);
      canvas.drawLine(
        Offset(x, size.height * 0.9),
        Offset(x, size.height * 0.9 - h),
        arrowPaint,
      );
      final arrowHead = Path();
      arrowHead.moveTo(x - 5, size.height * 0.9 - h + 8);
      arrowHead.lineTo(x, size.height * 0.9 - h);
      arrowHead.lineTo(x + 5, size.height * 0.9 - h + 8);
      canvas.drawPath(arrowHead, arrowPaint);
    }

    // Sparkles
    canvas.drawCircle(
        Offset(size.width * 0.1, size.height * 0.25), 4, accent);
    canvas.drawCircle(
        Offset(size.width * 0.9, size.height * 0.15), 5, accent);
    canvas.drawCircle(
        Offset(size.width * 0.88, size.height * 0.78), 3, white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}