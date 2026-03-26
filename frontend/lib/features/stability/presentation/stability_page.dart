import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary = Color(0xFFE30613);
  static const dark = Color(0xFF1A1A1A);
  static const grey = Color(0xFF888888);
  static const green = Color(0xFF10B981);
  static const amber = Color(0xFFF59E0B);
  static const blue = Color(0xFF3B82F6);
  static const border = Color(0xFFEEEEEE);
  static const lightGrey = Color(0xFFF5F5F5);
}

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────
class _Signal {
  final String label, note, howItWorks;
  final int score;
  final IconData icon;
  bool expanded;
  _Signal(this.label, this.score, this.icon, this.note, this.howItWorks,
      {this.expanded = false});
}

class _SupportItem {
  final String title, description;
  final IconData icon;
  final Color color;
  final String? route;
  final String howItHelps;
  final String implementation;
  const _SupportItem(
      this.title, this.icon, this.color, this.description, this.route,
      {required this.howItHelps, required this.implementation});
}

class _CheckinRecord {
  final DateTime date;
  final String mood;
  final String moodLabel;
  final int scoreDelta;
  const _CheckinRecord({
    required this.date,
    required this.mood,
    required this.moodLabel,
    required this.scoreDelta,
  });
}

// ─────────────────────────────────────────────
// STABILITY PAGE
// ─────────────────────────────────────────────
class StabilityPage extends StatefulWidget {
  const StabilityPage({super.key});
  @override
  State<StabilityPage> createState() => _StabilityPageState();
}

class _StabilityPageState extends State<StabilityPage>
    with TickerProviderStateMixin {
  int _score = 62;
  bool _checkinDone = false;
  bool _scoreExpanded = false;
  bool _historyExpanded = false;

  late AnimationController _scoreAnim;
  late Animation<double> _scoreValue;

  final List<_CheckinRecord> _checkinHistory = [
    _CheckinRecord(
      date: DateTime.now().subtract(const Duration(days: 7)),
      mood: 'well',
      moodLabel: 'Doing well',
      scoreDelta: 5,
    ),
    _CheckinRecord(
      date: DateTime.now().subtract(const Duration(days: 14)),
      mood: 'stressed',
      moodLabel: 'A bit stressed',
      scoreDelta: -3,
    ),
    _CheckinRecord(
      date: DateTime.now().subtract(const Duration(days: 21)),
      mood: 'well',
      moodLabel: 'Doing well',
      scoreDelta: 5,
    ),
    _CheckinRecord(
      date: DateTime.now().subtract(const Duration(days: 28)),
      mood: 'struggling',
      moodLabel: 'Having a tough time',
      scoreDelta: -7,
    ),
  ];

  String get _scoreLabel {
    if (_score >= 75) return 'Thriving';
    if (_score >= 55) return 'Steady';
    if (_score >= 35) return 'Needs Attention';
    return "Let's Get You Support";
  }

  String get _scoreEmoji {
    if (_score >= 75) return '🟢';
    if (_score >= 55) return '🟡';
    if (_score >= 35) return '🟠';
    return '🔴';
  }

  String get _scoreMessage {
    if (_score >= 75)
      return 'You\'re doing great! Keep building those good habits.';
    if (_score >= 55)
      return 'You\'re on track — a few areas worth keeping an eye on.';
    if (_score >= 35)
      return 'Some signals suggest you could use a little extra support.';
    return 'We\'ve spotted some stress signals. You\'re not alone — let\'s help.';
  }

  Color get _scoreColor {
    if (_score >= 75) return _C.green;
    if (_score >= 55) return _C.amber;
    if (_score >= 35) return const Color(0xFFEF4444);
    return const Color(0xFFB91C1C);
  }

  static const String _overallExplanation =
      'Your Stability Score is calculated from four signals:\n\n'
      '• Financial Health — 35%\n'
      '  Based on your budget usage and spending patterns.\n\n'
      '• Marketplace Activity — 30%\n'
      '  How often you are earning through the marketplace.\n\n'
      '• App Engagement — 20%\n'
      '  How consistently you open and use the Gude app.\n\n'
      '• Wellbeing Check-ins — 15%\n'
      '  Your mood responses from weekly check-ins.\n\n'
      'Each signal has a score out of 100. The weighted average gives your final score. Higher scores reflect more financial stability and consistent engagement.';

  final List<_Signal> _signals = [
    _Signal(
        'Financial Health',
        55,
        Icons.account_balance_wallet_outlined,
        'R670 over budget this month',
        'This signal looks at your Gude Wallet spending against your set monthly budget. If you spend within budget, your score here increases. Overspending reduces it. Weight: 35% of your total score.'),
    _Signal(
        'Marketplace Activity',
        80,
        Icons.store_outlined,
        '3 active gigs this week',
        'This measures how frequently you list services or products, respond to buyers, and complete transactions. More marketplace activity signals financial hustle and stability. Weight: 30% of your total score.'),
    _Signal(
        'App Engagement',
        70,
        Icons.phone_android_outlined,
        'Active 5 of 7 days',
        'Consistent app usage signals that you are engaged with managing your finances and wellbeing. Weight: 20% of your total score.'),
    _Signal(
        'Wellbeing Check-ins',
        40,
        Icons.favorite_outline,
        'Missed last 2 check-ins',
        'Your responses to the weekly mood check-ins directly feed into this signal. Skipping check-ins lowers the signal due to missing data. Weight: 15% of your total score.'),
  ];

  final _moods = [
    {'emoji': '😊', 'label': 'Doing well', 'value': 'well'},
    {'emoji': '😰', 'label': 'A bit stressed', 'value': 'stressed'},
    {'emoji': '😞', 'label': 'Having a tough time', 'value': 'struggling'},
    {'emoji': '🆘', 'label': 'I need help', 'value': 'help'},
  ];

  final _supportItems = [
    const _SupportItem(
      'Quick Income',
      Icons.bolt_rounded,
      _C.primary,
      'Fast-paying gigs near you',
      '/marketplace',
      howItHelps:
          'As a student, unexpected expenses or a tight month can be stressful. Quick Income connects you to short-term, fast-paying gigs that match your skills — things like tutoring, delivery, data capturing, or graphic design tasks posted by people nearby.',
      implementation: '• Browse gigs posted within 5 km of your campus\n'
          '• Filter by skill: writing, design, tutoring, tech\n'
          '• Accept a gig and get paid directly to your Gude Wallet\n'
          '• Most gigs pay within 24–48 hours of completion\n'
          '• Your Marketplace Activity score improves with each completed gig',
    ),
    const _SupportItem(
      'Budget Help',
      Icons.savings_outlined,
      _C.blue,
      'Restructure your budget',
      '/wallet/budget',
      howItHelps:
          'Feeling like money runs out before the month ends? Budget Help gives you a personalised plan based on your actual Gude Wallet spending. It identifies where you are overspending and suggests realistic adjustments so you can stay on top of essentials like food, transport, and data.',
      implementation:
          '• Gude analyses your last 30 days of wallet transactions\n'
          '• You receive a breakdown: needs vs wants vs savings\n'
          '• Set new category limits with one tap\n'
          '• Weekly nudges remind you when you are close to a limit\n'
          '• Your Financial Health signal improves as you stay within budget',
    ),
    const _SupportItem(
      'Food Support',
      Icons.fastfood_outlined,
      _C.green,
      'Affordable meals & food banks',
      null,
      howItHelps:
          'Food insecurity is one of the biggest hidden challenges for students. Food Support helps you locate nearby campus food banks, soup kitchens, community meal programmes, and subsidised cafeterias so that going hungry never gets in the way of your studies.',
      implementation: '• Map of food banks and meal programmes within 10 km\n'
          '• Campus dining discounts for qualifying students\n'
          '• Weekly community meal schedules updated in real time\n'
          '• Anonymous access — no forms or judgement required\n'
          '• Share a location tip with fellow students directly in the app',
    ),
    const _SupportItem(
      'Peer Tutoring',
      Icons.school_outlined,
      const Color(0xFF8B5CF6),
      'Free peer tutoring groups',
      '/marketplace',
      howItHelps:
          'Falling behind in a module or struggling with a concept? Peer Tutoring connects you with fellow students who have already passed those courses and are willing to help — either for free as a community contribution or for a small fee through the marketplace.',
      implementation: '• Search by module code or subject area\n'
          '• Book a one-on-one or group session via the marketplace\n'
          '• Sessions can be in person or online via a shared link\n'
          '• Rate your tutor after each session to build trust scores\n'
          '• Earn income yourself by listing as a tutor in your strong subjects',
    ),
    const _SupportItem(
      'Talk to Someone',
      Icons.psychology_outlined,
      _C.amber,
      'Campus counselling services',
      null,
      howItHelps:
          'Sometimes the pressure of studies, finances, and life all builds up at once. Talk to Someone connects you to trained campus counsellors and peer support groups where you can speak freely, get coping strategies, and feel heard — without any stigma.',
      implementation:
          '• Direct booking with your institution\'s counselling centre\n'
          '• Anonymous peer support chat available 24/7\n'
          '• Crisis line numbers displayed for urgent situations\n'
          '• Weekly virtual group check-in sessions you can join\n'
          '• Your Wellbeing Check-in score improves when you engage with support',
    ),
    const _SupportItem(
      'Mentorship',
      Icons.people_outline,
      const Color(0xFFEC4899),
      'Connect with a student mentor',
      null,
      howItHelps:
          'Having someone a few years ahead of you who has navigated the same challenges can make a huge difference. Mentorship pairs you with a senior student or young professional who can guide you on academics, career choices, financial decisions, and life on campus.',
      implementation:
          '• Complete a short profile about your goals and challenges\n'
          '• Get matched with a mentor based on your field of study\n'
          '• Monthly one-on-one sessions via video or in person\n'
          '• Access a shared resource library curated by mentors\n'
          '• Become a mentor yourself once you reach your second year',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scoreAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _scoreValue = Tween<double>(begin: 0, end: _score / 100).animate(
        CurvedAnimation(parent: _scoreAnim, curve: Curves.easeOutCubic));
    _scoreAnim.forward();
  }

  @override
  void dispose() {
    _scoreAnim.dispose();
    super.dispose();
  }

  void _submitCheckin(String mood) {
    final labels = {
      'well': 'Doing well',
      'stressed': 'A bit stressed',
      'struggling': 'Having a tough time',
      'help': 'I need help',
    };
    int delta = mood == 'well'
        ? 5
        : mood == 'stressed'
            ? -3
            : mood == 'struggling'
                ? -7
                : -12;

    setState(() {
      _checkinDone = true;
      _checkinHistory.insert(
        0,
        _CheckinRecord(
          date: DateTime.now(),
          mood: mood,
          moodLabel: labels[mood] ?? mood,
          scoreDelta: delta,
        ),
      );
      _score = (_score + delta).clamp(0, 100);
      _scoreAnim.reset();
      _scoreValue = Tween<double>(begin: _scoreValue.value, end: _score / 100)
          .animate(
              CurvedAnimation(parent: _scoreAnim, curve: Curves.easeOutCubic));
      _scoreAnim.forward();
    });
  }

  void _showScoreExplanationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('How your score is calculated',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        content: SingleChildScrollView(
            child: Text(_overallExplanation,
                style: const TextStyle(
                    fontSize: 13, height: 1.6, color: Color(0xFF444444)))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Got it',
                  style: TextStyle(
                      color: _C.primary, fontWeight: FontWeight.w700)))
        ],
      ),
    );
  }

  void _showSupportDetail(_SupportItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SupportDetailSheet(item: item),
    );
  }

  String _moodEmoji(String mood) {
    switch (mood) {
      case 'well':
        return '😊';
      case 'stressed':
        return '😰';
      case 'struggling':
        return '😞';
      case 'help':
        return '🆘';
      default:
        return '😐';
    }
  }

  Color _moodColor(String mood) {
    switch (mood) {
      case 'well':
        return _C.green;
      case 'stressed':
        return _C.amber;
      case 'struggling':
        return const Color(0xFFEF4444);
      case 'help':
        return const Color(0xFFB91C1C);
      default:
        return _C.grey;
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return '$diff days ago';
    if (diff < 14) return '1 week ago';
    return '${(diff / 7).round()} weeks ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Stability',
              style: TextStyle(
                  color: _C.dark, fontWeight: FontWeight.w800, fontSize: 20)),
          actions: [
            IconButton(
                icon: const Icon(Icons.info_outline, color: Color(0xFF777777)),
                onPressed: _showScoreExplanationDialog)
          ],
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // ── Score Card ──────────────────────────────
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05), blurRadius: 12)
                    ]),
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: _showScoreExplanationDialog,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Stability Score',
                                        style: TextStyle(
                                            fontSize: 12, color: _C.grey)),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.help_outline_rounded,
                                        size: 13, color: _C.grey),
                                  ]),
                            ),
                            const SizedBox(height: 8),
                            Row(children: [
                              Text(_scoreEmoji,
                                  style: const TextStyle(fontSize: 22)),
                              const SizedBox(width: 8),
                              Flexible(
                                child: AnimatedBuilder(
                                  animation: _scoreAnim,
                                  builder: (_, __) => Text(
                                    _scoreLabel,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: _scoreColor),
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 6),
                            Text(_scoreMessage,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF666666),
                                    height: 1.4)),
                          ]),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _scoreExpanded = !_scoreExpanded),
                      child: AnimatedBuilder(
                        animation: _scoreAnim,
                        builder: (_, __) => _ScoreRing(
                          value: _scoreValue.value,
                          color: _scoreColor,
                          score: (_scoreValue.value * 100).round(),
                          expanded: _scoreExpanded,
                        ),
                      ),
                    ),
                  ]),
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
                      _ScoreLegend(color: _C.green, label: 'Thriving 75+'),
                      _ScoreLegend(color: _C.amber, label: 'Steady 55+'),
                      _ScoreLegend(
                          color: const Color(0xFFEF4444),
                          label: 'Attention 35+'),
                      _ScoreLegend(
                          color: const Color(0xFFB91C1C), label: 'Support'),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                    child: _scoreExpanded
                        ? Column(children: [
                            const SizedBox(height: 16),
                            const Divider(color: _C.border),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Score Breakdown',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _C.dark)),
                            ),
                            const SizedBox(height: 4),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Here's exactly how your score was calculated this week:",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: _C.grey,
                                      height: 1.4)),
                            ),
                            const SizedBox(height: 12),
                            _WeightedRow(
                                label: 'Financial Health',
                                score: _signals[0].score,
                                weight: 35,
                                color: _C.primary),
                            _WeightedRow(
                                label: 'Marketplace Activity',
                                score: _signals[1].score,
                                weight: 30,
                                color: _C.blue),
                            _WeightedRow(
                                label: 'App Engagement',
                                score: _signals[2].score,
                                weight: 20,
                                color: _C.green),
                            _WeightedRow(
                                label: 'Wellbeing Check-ins',
                                score: _signals[3].score,
                                weight: 15,
                                color: _C.amber),
                            const Divider(color: _C.border, height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Your Final Score',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: _C.dark)),
                                Text('$_score / 100',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: _scoreColor)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: _showScoreExplanationDialog,
                              child: const Text(
                                'Tap here to learn how each signal is measured →',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: _C.primary,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ])
                        : const SizedBox(height: 4),
                  ),
                  GestureDetector(
                    onTap: () =>
                        setState(() => _scoreExpanded = !_scoreExpanded),
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _scoreExpanded
                                  ? 'Hide breakdown'
                                  : 'See how this is calculated',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: _C.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              _scoreExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              size: 16,
                              color: _C.primary,
                            ),
                          ]),
                    ),
                  ),
                ]),
              ),

              // ── Weekly Check-in Card ────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: _checkinDone
                          ? Row(children: const [
                              Text('✅', style: TextStyle(fontSize: 28)),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Check-in recorded!',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15)),
                                      Text(
                                          'Your stability score has been updated.',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12)),
                                    ]),
                              ),
                            ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('📋 Weekly Check-in',
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 6),
                                const Text('How are you doing this week?',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 14),
                                Row(children: [
                                  Expanded(
                                      child: _MoodBtn(
                                          mood: _moods[0],
                                          onTap: _submitCheckin)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: _MoodBtn(
                                          mood: _moods[1],
                                          onTap: _submitCheckin)),
                                ]),
                                const SizedBox(height: 10),
                                Row(children: [
                                  Expanded(
                                      child: _MoodBtn(
                                          mood: _moods[2],
                                          onTap: _submitCheckin)),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: _MoodBtn(
                                          mood: _moods[3],
                                          onTap: _submitCheckin)),
                                ]),
                                const SizedBox(height: 12),
                                // ── Full check-in button ──────────────
                                GestureDetector(
                                  onTap: () =>
                                      context.push('/stability/checkin'),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.white.withOpacity(0.4)),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.checklist_rtl_rounded,
                                            color: Colors.white, size: 16),
                                        SizedBox(width: 8),
                                        Text(
                                          'Full Weekly Check-in →',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),

                    // ── Check-in History Dropdown ───────────
                    if (_checkinHistory.isNotEmpty)
                      GestureDetector(
                        onTap: () => setState(
                            () => _historyExpanded = !_historyExpanded),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Check-in History',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600)),
                                    Row(children: [
                                      Text(
                                        '${_checkinHistory.length} record${_checkinHistory.length != 1 ? 's' : ''}',
                                        style: const TextStyle(
                                            color: Colors.white60,
                                            fontSize: 11),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        _historyExpanded
                                            ? Icons.keyboard_arrow_up_rounded
                                            : Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white70,
                                        size: 18,
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                              AnimatedSize(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                child: _historyExpanded
                                    ? Column(
                                        children: [
                                          const Divider(
                                              color: Colors.white24, height: 1),
                                          ..._checkinHistory
                                              .take(6)
                                              .map((r) => _HistoryRow(
                                                    record: r,
                                                    moodEmoji:
                                                        _moodEmoji(r.mood),
                                                    moodColor:
                                                        _moodColor(r.mood),
                                                    dateLabel:
                                                        _formatDate(r.date),
                                                  ))
                                              .toList(),
                                          if (_checkinHistory.length > 6)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12, top: 4),
                                              child: Text(
                                                '+ ${_checkinHistory.length - 6} older records',
                                                style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 11),
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Support Hub ──────────────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 22, 16, 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Support Hub',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _C.dark)),
                      SizedBox(height: 2),
                      Text('Resources tailored to your situation',
                          style: TextStyle(fontSize: 12, color: _C.grey)),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    3,
                    (row) => Padding(
                      padding: EdgeInsets.only(bottom: row < 2 ? 12 : 0),
                      child: Row(children: [
                        Expanded(
                          child: _SupportCard(
                            item: _supportItems[row * 2],
                            onTap: () =>
                                _showSupportDetail(_supportItems[row * 2]),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SupportCard(
                            item: _supportItems[row * 2 + 1],
                            onTap: () =>
                                _showSupportDetail(_supportItems[row * 2 + 1]),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// CHECK-IN HISTORY ROW
// ─────────────────────────────────────────────
class _HistoryRow extends StatelessWidget {
  final _CheckinRecord record;
  final String moodEmoji;
  final Color moodColor;
  final String dateLabel;

  const _HistoryRow({
    required this.record,
    required this.moodEmoji,
    required this.moodColor,
    required this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = record.scoreDelta > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          Text(moodEmoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.moodLabel,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text(dateLabel,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withOpacity(0.25)
                  : Colors.red.withOpacity(0.25),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isPositive
                  ? '+${record.scoreDelta} pts'
                  : '${record.scoreDelta} pts',
              style: TextStyle(
                  color: isPositive
                      ? const Color(0xFF86EFAC)
                      : const Color(0xFFFCA5A5),
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SUPPORT DETAIL BOTTOM SHEET
// ─────────────────────────────────────────────
class _SupportDetailSheet extends StatelessWidget {
  final _SupportItem item;
  const _SupportDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  Row(children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(item.icon, color: item.color, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1A1A1A))),
                          Text(item.description,
                              style: const TextStyle(
                                  fontSize: 13, color: Color(0xFF888888))),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 20),
                  Row(children: [
                    Icon(Icons.lightbulb_outline_rounded,
                        color: item.color, size: 18),
                    const SizedBox(width: 8),
                    Text('How it helps you',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: item.color)),
                  ]),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: item.color.withOpacity(0.15)),
                    ),
                    child: Text(item.howItHelps,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF444444),
                            height: 1.6)),
                  ),
                  const SizedBox(height: 22),
                  Row(children: [
                    Icon(Icons.checklist_rounded, color: item.color, size: 18),
                    const SizedBox(width: 8),
                    Text('How it works',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: item.color)),
                  ]),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Text(item.implementation,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF444444),
                            height: 1.8)),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (item.route != null) {
                          context.push(item.route!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.title} — coming soon!'),
                              backgroundColor: _C.primary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: item.color,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        item.route != null ? 'Get Started' : 'Notify Me',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700),
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

// ─────────────────────────────────────────────
// SCORE RING
// ─────────────────────────────────────────────
class _ScoreRing extends StatelessWidget {
  final double value;
  final Color color;
  final int score;
  final bool expanded;

  const _ScoreRing({
    required this.value,
    required this.color,
    required this.score,
    required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 82,
            height: 82,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 9,
              color: const Color(0xFFEEEEEE),
            ),
          ),
          SizedBox(
            width: 82,
            height: 82,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: 9,
              color: color,
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: color,
                  height: 1.0,
                ),
              ),
              Text(
                '/100',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.7),
                  height: 1.2,
                ),
              ),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                size: 12,
                color: color.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// WEIGHTED ROW
// ─────────────────────────────────────────────
class _WeightedRow extends StatelessWidget {
  final String label;
  final int score, weight;
  final Color color;
  const _WeightedRow(
      {required this.label,
      required this.score,
      required this.weight,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final contribution = (score * weight / 100).round();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _C.dark))),
          Text('$score/100 × $weight% = ',
              style: const TextStyle(fontSize: 11, color: _C.grey)),
          Text('$contribution pts',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ]),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 5,
            backgroundColor: const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
// MOOD BUTTON
// ─────────────────────────────────────────────
class _MoodBtn extends StatelessWidget {
  final Map<String, String> mood;
  final void Function(String) onTap;
  const _MoodBtn({required this.mood, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => onTap(mood['value']!),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(mood['emoji']!, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Flexible(
                child: Text(mood['label']!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis)),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────
// SUPPORT CARD
// ─────────────────────────────────────────────
class _SupportCard extends StatelessWidget {
  final _SupportItem item;
  final VoidCallback onTap;
  const _SupportCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          height: 95,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
            ],
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 16, color: item.color),
            ),
            const Spacer(),
            Text(item.title,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: _C.dark)),
            const SizedBox(height: 2),
            Text(item.description,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF999999), height: 1.3),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
        ),
      );
}

// ─────────────────────────────────────────────
// SCORE LEGEND
// ─────────────────────────────────────────────
class _ScoreLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ScoreLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 9, color: Color(0xFF888888))),
      ]);
}
