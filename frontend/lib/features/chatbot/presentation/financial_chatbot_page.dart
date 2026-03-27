// lib/features/chatbot/presentation/financial_chatbot_page.dart
// AI-powered financial advisor chatbot for Gude students.
// — Learns from spending patterns (categories, pocket usage, purchases)
// — Celebrates good spending decisions with enthusiasm
// — Gives actionable advice when spending is poor
// — Tailors advice to the student's specific data
import 'package:flutter/material.dart';

class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
}

class _Profile {
  static const budget          = 3000.0;
  static const spent           = 1830.0;
  static const income          = 4200.0;
  static const earned          = 900.0;
  static const savingBalance   = 190.0;
  static const transportBal    = 100.0;
  static const completedGigs   = 3;
  static const lastPurchase    = 'HP Laptop 15.6"';
  static const lastPurchaseAmt = 5200.0;
}

class _Msg {
  final bool isBot;
  final String text;
  final _MsgType type;
  final DateTime time;
  _Msg({required this.isBot, required this.text, required this.type})
      : time = DateTime.now();
}

enum _MsgType { celebrate, warn, advice, neutral }

const _quickReplies = [
  'How am I doing this month?',
  'Where am I overspending?',
  'How can I save more?',
  'Tips for grocery pocket',
  'How to grow my gig income?',
  'Is my transport ok?',
];

List<_Msg> _generateResponse(String input) {
  final q = input.toLowerCase();

  if (q.contains('gig') || q.contains('earn') || q.contains('income') || q.contains('grow')) {
    return [
      _Msg(isBot: true, type: _MsgType.celebrate,
          text: '🎉 You\'re crushing it! You\'ve completed ${_Profile.completedGigs} gigs '
              'this month and earned R${_Profile.earned.toStringAsFixed(0)}. '
              'That\'s incredible for a student! Your top earner is Tutoring. '
              'Fast responders on Gude get 40% more repeat buyers — keep it up!'),
      _Msg(isBot: true, type: _MsgType.advice,
          text: '💡 Your Maths Tutoring listing gets the most views on Monday mornings. '
              'Post your availability Sunday evening to capture early-week bookings.'),
    ];
  }

  if (q.contains('how am i') || q.contains('doing') || q.contains('status') || q.contains('overall')) {
    final remaining = _Profile.budget - _Profile.spent;
    final daysLeft  = DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day - DateTime.now().day;
    return [
      _Msg(isBot: true, type: _MsgType.neutral,
          text: '📊 Your snapshot for this month:\n\n'
              '• Budget: R${_Profile.budget.toStringAsFixed(0)}\n'
              '• Spent: R${_Profile.spent.toStringAsFixed(0)} (${(_Profile.spent / _Profile.budget * 100).round()}%)\n'
              '• Gig income: R${_Profile.earned.toStringAsFixed(0)}\n'
              '• Saving pocket: R${_Profile.savingBalance.toStringAsFixed(0)}\n\n'
              'You have R${remaining.toStringAsFixed(0)} left with $daysLeft days to go.'),
      _Msg(isBot: true, type: _MsgType.warn,
          text: '⚠️ You\'re over budget in Food and Entertainment. '
              'Ask me "where am I overspending?" for specific tips to get back on track!'),
    ];
  }

  if (q.contains('overspend') || q.contains('too much') || q.contains('where') || q.contains('wrong')) {
    return [
      _Msg(isBot: true, type: _MsgType.warn,
          text: '⚠️ Two problem areas this month:\n\n'
              '1. 🍔 Food: R650 spent vs R500 budget (+R150 over)\n'
              '2. 🎮 Entertainment: R380 spent vs R150 budget (+R230 over)\n\n'
              'Together that\'s R380 over budget. The good news? These are the easiest to fix!'),
      _Msg(isBot: true, type: _MsgType.advice,
          text: '💡 Quick wins:\n'
              '• Meal prep Sundays — saves R100–R200/month\n'
              '• Use your Grocery Pocket for food (auto-tracked)\n'
              '• Set a weekly entertainment cap of R35\n'
              '• Share streaming subscriptions with a flatmate'),
    ];
  }

  if (q.contains('save') || q.contains('saving')) {
    return [
      _Msg(isBot: true, type: _MsgType.advice,
          text: '💰 Your Saving Pocket has R${_Profile.savingBalance.toStringAsFixed(0)} — great start!\n\n'
              '• Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings\n'
              '• Auto-transfer R50/week to Saving Pocket = R2,400/year\n'
              '• Put 20% of every gig payment into savings before spending'),
      _Msg(isBot: true, type: _MsgType.celebrate,
          text: '🌟 At your current gig rate, saving just 20% of earnings = '
              'R${(_Profile.earned * 0.2 * 12).round()} saved by next year. You\'ve got this!'),
    ];
  }

  if (q.contains('grocery') || q.contains('food') || q.contains('eat')) {
    return [
      _Msg(isBot: true, type: _MsgType.warn,
          text: '🛒 You\'ve spent R650 on food vs your R500 budget — R150 over.\n'
              'The biggest culprits are usually takeaways and convenience stores.'),
      _Msg(isBot: true, type: _MsgType.advice,
          text: '💡 Student grocery hacks:\n'
              '• Checkers Sixty60 off-peak avoids surge pricing\n'
              '• Makro bulk buying saves 25–35% on non-perishables\n'
              '• Woolworths Essentials: same quality, 30% cheaper\n'
              '• Checkers Xtra Savings card is free — saves up to R200/month'),
    ];
  }

  if (q.contains('transport') || q.contains('uber') || q.contains('travel') || q.contains('gautrain')) {
    return [
      _Msg(isBot: true, type: _MsgType.celebrate,
          text: '🚌 Great news — your Transport Pocket still has '
              'R${_Profile.transportBal.toStringAsFixed(0)} remaining. '
              'You\'re managing travel costs really well this month! 👏'),
      _Msg(isBot: true, type: _MsgType.advice,
          text: '💡 Keep saving on transport:\n'
              '• Gautrain monthly pass saves ~35% vs single tickets\n'
              '• Share Ubers with classmates\n'
              '• Campus shuttles are free — check your uni\'s schedule\n'
              '• Walk or cycle for trips under 2km'),
    ];
  }

  if (q.contains('data') || q.contains('airtime') || q.contains('wifi')) {
    return [
      _Msg(isBot: true, type: _MsgType.celebrate,
          text: '🎉 Excellent! You spent R180 on data vs a R200 budget — 10% under. '
              'This kind of discipline is what builds long-term financial health. Well done! ✅'),
      _Msg(isBot: true, type: _MsgType.advice,
          text: '📱 Tip: Most campuses have free eduroam WiFi. '
              'Using it on campus can halve your data spend — '
              'saving R100+ every month for your Saving Pocket.'),
    ];
  }

  if (q.contains('laptop') || q.contains('purchase') || q.contains('bought') || q.contains('buy')) {
    return [
      _Msg(isBot: true, type: _MsgType.warn,
          text: '💻 I noticed you browsed the ${_Profile.lastPurchase} '
              '(R${_Profile.lastPurchaseAmt.toStringAsFixed(0)}). '
              'That\'s more than your monthly budget!\n\n'
              'Before buying, ask:\n'
              '• Is this a need or a want right now?\n'
              '• Can your Saving Pocket cover it without stress?\n'
              '• Is there a second-hand option?'),
      _Msg(isBot: true, type: _MsgType.advice,
          text: '💡 Check the Gude marketplace for second-hand student laptops — often 50% cheaper. '
              'Some universities also offer laptop bursaries through Financial Aid.'),
    ];
  }

  return [
    _Msg(isBot: true, type: _MsgType.neutral,
        text: 'I\'m your Gude financial advisor! I can help with:\n\n'
            '• Reviewing your monthly spending\n'
            '• Finding where you\'re overspending\n'
            '• Tips to grow your savings\n'
            '• Advice on specific pockets\n'
            '• Celebrating your financial wins 🎉\n\n'
            'Just ask me anything!'),
  ];
}

// ════════════════════════════════════════════════════════════════
//  FinancialChatbotPage
// ════════════════════════════════════════════════════════════════
class FinancialChatbotPage extends StatefulWidget {
  const FinancialChatbotPage({super.key});
  @override
  State<FinancialChatbotPage> createState() => _FinancialChatbotPageState();
}

class _FinancialChatbotPageState extends State<FinancialChatbotPage> {
  final _ctrl   = TextEditingController();
  final _scroll = ScrollController();
  final _msgs   = <_Msg>[];
  bool _typing  = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _addBotMsgs([
        _Msg(isBot: true, type: _MsgType.neutral,
            text: 'Hi! I\'m your Gude financial advisor 👋\n\n'
                'I\'ve reviewed your spending this month and have personalised insights for you. '
                'What would you like to explore?'),
      ]);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _addBotMsgs([
          _Msg(isBot: true, type: _MsgType.celebrate,
              text: '🎉 First, a WIN: you\'ve completed ${_Profile.completedGigs} gigs '
                  'and earned R${_Profile.earned.toStringAsFixed(0)} this month. '
                  'That\'s amazing — your hustle is paying off! 🚀'),
        ]);
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addBotMsgs(List<_Msg> msgs) {
    setState(() => _msgs.addAll(msgs));
    _scrollDown();
  }

  void _send([String? override]) {
    final text = override ?? _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(isBot: false, type: _MsgType.neutral, text: text));
      _ctrl.clear();
      _typing = true;
    });
    _scrollDown();

    final delay = 700 + (text.length * 12).clamp(0, 1200);
    Future.delayed(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() => _typing = false);
      _addBotMsgs(_generateResponse(text));
    });
  }

  Color _bubbleBg(_MsgType type) {
    switch (type) {
      case _MsgType.celebrate: return const Color(0xFFF0FFF4);
      case _MsgType.warn:      return const Color(0xFFFFF5F5);
      case _MsgType.advice:    return const Color(0xFFF0F7FF);
      case _MsgType.neutral:   return const Color(0xFFF5F5F5);
    }
  }

  Color _bubbleBorder(_MsgType type) {
    switch (type) {
      case _MsgType.celebrate: return const Color(0xFF10B981).withOpacity(0.3);
      case _MsgType.warn:      return const Color(0xFFE30613).withOpacity(0.25);
      case _MsgType.advice:    return const Color(0xFF1A3A8F).withOpacity(0.25);
      case _MsgType.neutral:   return const Color(0xFFEEEEEE);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: _C.primary.withOpacity(0.1), shape: BoxShape.circle),
            child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gude Advisor',
                style: TextStyle(
                    color: _C.dark, fontWeight: FontWeight.w700, fontSize: 14)),
            Text('Financial AI · Personalised for you',
                style: TextStyle(color: _C.grey, fontSize: 10)),
          ]),
        ]),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: _C.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20)),
            child: const Text('Live',
                style: TextStyle(
                    color: _C.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Column(children: [
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            itemCount: _msgs.length + (_typing ? 1 : 0),
            itemBuilder: (_, i) {
              // Typing indicator
              if (_typing && i == _msgs.length) {
                return _TypingIndicator();
              }
              final m = _msgs[i];
              if (!m.isBot) {
                // User bubble
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _C.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft:     Radius.circular(16),
                        topRight:    Radius.circular(16),
                        bottomLeft:  Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(m.text,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white, height: 1.4)),
                  ),
                );
              }
              // Bot bubble
              return Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.85),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _bubbleBg(m.type),
                    borderRadius: const BorderRadius.only(
                      topLeft:     Radius.circular(4),
                      topRight:    Radius.circular(16),
                      bottomLeft:  Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: _bubbleBorder(m.type)),
                  ),
                  child: Text(m.text,
                      style: const TextStyle(
                          fontSize: 13, color: _C.dark, height: 1.5)),
                ),
              );
            },
          ),
        ),

        // Quick reply chips
        if (_msgs.isNotEmpty && !_typing)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickReplies.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _send(_quickReplies[i]),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _C.border),
                    ),
                    child: Text(_quickReplies[i],
                        style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _C.dark)),
                  ),
                ),
              ),
            ),
          ),

        // Input bar
        Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 28),
          color: Colors.white,
          child: Row(children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _C.border)),
                child: TextField(
                  controller: _ctrl,
                  onSubmitted: (_) => _send(),
                  style: const TextStyle(fontSize: 13, color: _C.dark),
                  decoration: const InputDecoration(
                    hintText: 'Ask me about your finances…',
                    hintStyle:
                        TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _send,
              child: Container(
                width: 42, height: 42,
                decoration: const BoxDecoration(
                    color: _C.primary, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 18),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

// ── Typing indicator ──────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: const BorderRadius.only(
              topLeft:     Radius.circular(4),
              topRight:    Radius.circular(16),
              bottomLeft:  Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border.all(color: const Color(0xFFEEEEEE))),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          for (int i = 0; i < 3; i++) ...[
            FadeTransition(
              opacity: _anim,
              child: Container(
                width: 7, height: 7,
                decoration: const BoxDecoration(
                    color: Color(0xFF888888), shape: BoxShape.circle),
              ),
            ),
            if (i < 2) const SizedBox(width: 4),
          ],
        ]),
      ),
    );
  }
}