import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

class StabilityPage extends StatefulWidget {
  const StabilityPage({super.key});

  @override
  State<StabilityPage> createState() => _StabilityPageState();
}

class _StabilityPageState extends State<StabilityPage> with TickerProviderStateMixin {
  int _score = 62; // 0-100
  String? _selectedMood;
  bool _checkinDone = false;
  late AnimationController _scoreAnim;
  late Animation<double> _scoreValue;

  final List<_Signal> _signals = [
    _Signal('Financial Health', 55, Icons.account_balance_wallet_outlined, 'R670 over budget this month'),
    _Signal('Marketplace Activity', 80, Icons.store_outlined, '3 active gigs this week'),
    _Signal('App Engagement', 70, Icons.phone_android_outlined, 'Active 5 of 7 days'),
    _Signal('Wellbeing Check-ins', 40, Icons.favorite_outline, 'Missed last 2 check-ins'),
  ];

  final _moods = [
    {'emoji': '😊', 'label': 'Doing well', 'value': 'well'},
    {'emoji': '😰', 'label': 'Stressed', 'value': 'stressed'},
    {'emoji': '😞', 'label': 'Struggling', 'value': 'struggling'},
    {'emoji': '🆘', 'label': 'Need help', 'value': 'help'},
  ];

  final _supportItems = [
    _SupportItem('Emergency Income', Icons.bolt_rounded, const Color(0xFFE30613), 'Find quick-paying gigs near you right now', '/marketplace'),
    _SupportItem('Budget Rescue', Icons.savings_outlined, const Color(0xFF3B82F6), 'Restructure your budget with our planner', '/wallet/budget'),
    _SupportItem('Food Support', Icons.fastfood_outlined, const Color(0xFF10B981), 'Affordable meals and food bank locations', null),
    _SupportItem('Tutoring Help', Icons.school_outlined, const Color(0xFF8B5CF6), 'Free peer tutoring and study groups', '/marketplace'),
    _SupportItem('Counseling', Icons.psychology_outlined, const Color(0xFFF59E0B), 'Talk to a campus counselor (free)', null),
    _SupportItem('Mentorship', Icons.people_outline, const Color(0xFFEC4899), 'Connect with a student mentor', null),
  ];

  @override
  void initState() {
    super.initState();
    _scoreAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scoreValue = Tween<double>(begin: 0, end: _score / 100).animate(
      CurvedAnimation(parent: _scoreAnim, curve: Curves.easeOutCubic));
    _scoreAnim.forward();
  }

  @override
  void dispose() {
    _scoreAnim.dispose();
    super.dispose();
  }

  Color get _scoreColor {
    if (_score >= 75) return const Color(0xFF10B981);
    if (_score >= 50) return const Color(0xFFF59E0B);
    if (_score >= 30) return const Color(0xFFEF4444);
    return const Color(0xFF7F1D1D);
  }

  String get _scoreLabel {
    if (_score >= 75) return 'Stable';
    if (_score >= 50) return 'Watch';
    if (_score >= 30) return 'At Risk';
    return 'Critical';
  }

  String get _scoreEmoji {
    if (_score >= 75) return '🟢';
    if (_score >= 50) return '🟡';
    if (_score >= 30) return '🟠';
    return '🔴';
  }

  String get _scoreMessage {
    if (_score >= 75) return 'You\'re doing great! Keep up the good work.';
    if (_score >= 50) return 'Some stress signals detected. Let\'s keep an eye on things.';
    if (_score >= 30) return 'You\'re showing signs of financial or academic stress. We\'re here to help.';
    return 'Critical signals detected. Please reach out for support immediately.';
  }

  void _submitCheckin(String mood) {
    setState(() {
      _selectedMood = mood;
      _checkinDone = true;
      if (mood == 'well') _score = (_score + 5).clamp(0, 100);
      if (mood == 'stressed') _score = (_score - 3).clamp(0, 100);
      if (mood == 'struggling') _score = (_score - 7).clamp(0, 100);
      if (mood == 'help') _score = (_score - 12).clamp(0, 100);
      _scoreAnim.reset();
      _scoreValue = Tween<double>(begin: _scoreValue.value, end: _score / 100).animate(
        CurvedAnimation(parent: _scoreAnim, curve: Curves.easeOutCubic));
      _scoreAnim.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Stability', style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800, fontSize: 20)),
            actions: [
              IconButton(icon: const Icon(Icons.info_outline, color: Color(0xFF777777)), onPressed: () => _showInfoDialog(context)),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Score Card ────────────────────────────────
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Student Stability Score', style: const TextStyle(fontSize: 12, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(_scoreEmoji, style: const TextStyle(fontSize: 22)),
                                    const SizedBox(width: 8),
                                    Text(_scoreLabel, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _scoreColor)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(_scoreMessage, style: const TextStyle(fontSize: 12, color: Color(0xFF666666), height: 1.4)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          AnimatedBuilder(
                            animation: _scoreAnim,
                            builder: (_, __) => _ScoreRing(value: _scoreValue.value, color: _scoreColor, score: (_scoreValue.value * 100).toInt()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: AnimatedBuilder(
                          animation: _scoreAnim,
                          builder: (_, __) => LinearProgressIndicator(
                            value: _scoreValue.value,
                            minHeight: 10,
                            backgroundColor: const Color(0xFFEEEEEE),
                            valueColor: AlwaysStoppedAnimation(_scoreColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _ScoreLegend(color: const Color(0xFF10B981), label: 'Stable 75+'),
                          _ScoreLegend(color: const Color(0xFFF59E0B), label: 'Watch 50+'),
                          _ScoreLegend(color: const Color(0xFFEF4444), label: 'At Risk 30+'),
                          _ScoreLegend(color: const Color(0xFF7F1D1D), label: 'Critical'),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Signal Breakdown ──────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: Text('Signal Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                  ),
                  child: Column(
                    children: _signals.map((s) => _SignalRow(signal: s)).toList(),
                  ),
                ),

                // ── Weekly Check-in ───────────────────────────
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: _checkinDone
                      ? Row(
                          children: [
                            const Text('✅', style: TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Check-in recorded!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                                  Text('Your stability score has been updated.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('📋 Weekly Check-in', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 6),
                            const Text('How are you doing this week?', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 14),
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 3.2,
                              children: _moods.map((m) => GestureDetector(
                                onTap: () => _submitCheckin(m['value'] as String),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white.withOpacity(0.4)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(m['emoji'] as String, style: const TextStyle(fontSize: 16)),
                                      const SizedBox(width: 6),
                                      Text(m['label'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                ),

                // ── Support Hub ───────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 22, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Support Hub', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
                      SizedBox(height: 2),
                      Text('Resources tailored to your current situation', style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
                    ],
                  ),
                ),
                GridView.count(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: _supportItems.map((item) => _SupportCard(
                    item: item,
                    onTap: item.route != null ? () => context.push(item.route!) : () => _showComingSoon(context, item.title),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('About Your Stability Score', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'Your Student Stability Score is calculated silently using:\n\n'
          '• Your wallet spending patterns\n'
          '• Marketplace activity and earnings\n'
          '• App engagement frequency\n'
          '• Your weekly check-in responses\n\n'
          'It is private to you and helps Gude suggest the right support at the right time. '
          'You can opt out in Settings.',
          style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF444444)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title — coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SUPPORTING WIDGETS
// ─────────────────────────────────────────────

class _Signal {
  final String label;
  final int score;
  final IconData icon;
  final String note;
  const _Signal(this.label, this.score, this.icon, this.note);
}

class _SignalRow extends StatelessWidget {
  final _Signal signal;
  const _SignalRow({required this.signal});

  Color get _color {
    if (signal.score >= 70) return const Color(0xFF10B981);
    if (signal.score >= 45) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: _color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(signal.icon, size: 18, color: _color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(signal.label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                    Text('${signal.score}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _color)),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: signal.score / 100,
                    minHeight: 5,
                    backgroundColor: const Color(0xFFEEEEEE),
                    valueColor: AlwaysStoppedAnimation(_color),
                  ),
                ),
                const SizedBox(height: 3),
                Text(signal.note, style: const TextStyle(fontSize: 11, color: Color(0xFF999999))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportItem {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final String? route;
  const _SupportItem(this.title, this.icon, this.color, this.description, this.route);
}

class _SupportCard extends StatelessWidget {
  final _SupportItem item;
  final VoidCallback onTap;
  const _SupportCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: item.color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(item.icon, size: 18, color: item.color),
            ),
            const Spacer(),
            Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A))),
            const SizedBox(height: 2),
            Text(item.description, style: const TextStyle(fontSize: 10, color: Color(0xFF999999), height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final double value;
  final Color color;
  final int score;
  const _ScoreRing({required this.value, required this.color, required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80, height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 8,
            color: const Color(0xFFEEEEEE),
          ),
          CircularProgressIndicator(
            value: value,
            strokeWidth: 8,
            color: color,
            strokeCap: StrokeCap.round,
          ),
          Text('$score', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
        ],
      ),
    );
  }
}

class _ScoreLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ScoreLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF888888))),
      ],
    );
  }
}