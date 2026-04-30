// lib/features/coach/presentation/coach_chat_page.dart
// Coach Chat Screen — PDF section 2.5
// Chat bubbles (AI + user) · Suggested prompts · Input bar
// Challenges: "Survive till month-end", "NSFAS delay survival plan", "R0 to R500"

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Colours ─────────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
  static const amber     = Color(0xFFF59E0B);
}

// ── Message model ────────────────────────────────────────────
class _Msg {
  final String text;
  final bool isAi;
  final DateTime time;
  const _Msg({required this.text, required this.isAi, required this.time});
}

// ── Suggested prompts (PDF 2.5) ──────────────────────────────
const _suggestions = [
  ('Can I afford takeout?',         '🍔'),
  ('Help me save R500',             '💰'),
  ('Survive till month-end',        '📅'),
  ('NSFAS delay survival plan',     '⏳'),
  ('R0 to R500 savings challenge',  '🚀'),
  ('How do I reduce transport cost?','🚌'),
  ('Am I overspending?',            '📊'),
  ('Set a new savings goal',        '🎯'),
];

// ── AI responses (keyword-based) ─────────────────────────────
String _aiReply(String input) {
  final q = input.toLowerCase();
  if (q.contains('takeout') || q.contains('afford')) {
    return '🍔 Based on your current balance of R1,250 with 12 days left, '
        'takeout might stretch your food budget. You\'ve already spent R650 on '
        'food this month vs a R800 budget. I\'d recommend cooking once today '
        'to save around R80. Want me to suggest a cheap meal plan?';
  }
  if (q.contains('nsfas') || q.contains('delay')) {
    return '⏳ NSFAS Delay Survival Plan activated!\n\n'
        '1. Cut non-essential spend immediately\n'
        '2. Reduce food budget to R30/day (rice, eggs, bread)\n'
        '3. Pause entertainment spend\n'
        '4. Use campus facilities (library, gym) — they\'re already paid\n'
        '5. Alert your res about the delay if rent is due\n\n'
        'Your emergency fund has R500. This can last ~10 days with discipline. 💪';
  }
  if (q.contains('save') && q.contains('500') || q.contains('r0 to r500')) {
    return '🚀 R0 to R500 Challenge!\n\n'
        'Week 1: Skip 1 takeout = +R80\n'
        'Week 2: Walk instead of Uber twice = +R90\n'
        'Week 3: Cancel 1 subscription = +R60\n'
        'Week 4: Sell something on Gude Marketplace = +R150+\n\n'
        'That\'s already R380! Add R120 from your monthly surplus and you\'re done. 🎉';
  }
  if (q.contains('survive') || q.contains('month-end')) {
    return '📅 Survive Till Month-End Mode!\n\n'
        'You have R1,250 for 12 days = R104/day budget.\n\n'
        '✅ Food: Max R40/day\n'
        '✅ Transport: Max R30/day\n'
        '✅ Data: You have 5 days left — ration it\n'
        '❌ No entertainment spend this week\n\n'
        'You CAN make it. Want daily check-ins? 💪';
  }
  if (q.contains('transport')) {
    return '🚌 Your transport spend is R420 vs a R300 budget — 40% over!\n\n'
        'Tips to cut down:\n'
        '• Gautrain > Uber for long distances (saves ~R60/trip)\n'
        '• Walk routes under 2km\n'
        '• Carpool with classmates\n'
        '• Check if your campus has a shuttle service\n\n'
        'Saving R120 on transport can fund half your data budget.';
  }
  if (q.contains('overspend') || q.contains('budget')) {
    return '📊 Budget snapshot:\n\n'
        '🔴 Food: R650/R800 — 81% used\n'
        '🔴 Transport: R420/R300 — OVER\n'
        '🟡 Entertainment: R380/R150 — WAY over\n'
        '🟢 Data: R180/R200 — on track\n'
        '🟢 Textbooks: R150/R300 — great!\n\n'
        'Entertainment is your biggest leak. Cut 1 streaming service and you save R99/month.';
  }
  if (q.contains('goal') || q.contains('saving')) {
    return '🎯 You currently have 4 savings goals:\n\n'
        '💻 Laptop: R3,200/R5,200 (61%)\n'
        '🏠 Accommodation: R2,800/R4,500 (62%)\n'
        '🍎 Food & Groceries: R650/R1,200 (54%)\n'
        '🆘 Emergency: R500/R3,000 (17%)\n\n'
        'I recommend boosting your Emergency Fund — it\'s only 17% funded. '
        'Even R100/month gets you to R1,000 in 5 months.';
  }
  return '🤖 Great question! Based on your spending patterns, here\'s what I\'d suggest:\n\n'
      'Your current financial health score is 62/100 — Steady. '
      'You have R1,250 left for 12 days, which works out to about R104/day. '
      'Focus on reducing food and entertainment costs this week.\n\n'
      'Want me to break down a specific category?';
}

// ════════════════════════════════════════════════════════════
//  CoachChatPage
// ════════════════════════════════════════════════════════════
class CoachChatPage extends StatefulWidget {
  const CoachChatPage({super.key});
  @override
  State<CoachChatPage> createState() => _CoachChatPageState();
}

class _CoachChatPageState extends State<CoachChatPage> {
  final _inputCtrl   = TextEditingController();
  final _scrollCtrl  = ScrollController();
  bool  _isTyping    = false;

  final List<_Msg> _messages = [
    _Msg(
      text: '👋 Hey! I\'m your Gude Financial Coach.\n\n'
          'I can help you budget smarter, save more and survive the month. '
          'Ask me anything about your money, or pick a suggestion below!',
      isAi: true,
      time: DateTime.now().subtract(const Duration(minutes: 2)),
    ),
  ];

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send(String text) async {
    if (text.trim().isEmpty) return;
    _inputCtrl.clear();

    setState(() {
      _messages.add(_Msg(text: text.trim(), isAi: false, time: DateTime.now()));
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI "typing" delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() {
      _isTyping = false;
      _messages.add(_Msg(text: _aiReply(text), isAi: true, time: DateTime.now()));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF3A3A3A)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gude Coach',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _C.dark)),
              Text('AI Financial Coach • Always on',
                  style: TextStyle(fontSize: 10, color: _C.grey)),
            ],
          ),
        ]),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _C.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              Container(
                width: 6, height: 6,
                decoration: const BoxDecoration(
                    color: _C.green, shape: BoxShape.circle),
              ),
              const SizedBox(width: 5),
              const Text('Online',
                  style: TextStyle(
                      fontSize: 11,
                      color: _C.green,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Chat messages ────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _messages.length) {
                  return const _TypingBubble();
                }
                final msg = _messages[i];
                return _ChatBubble(msg: msg);
              },
            ),
          ),

          // ── Suggested prompts ────────────────────────────
          Container(
            height: 40,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _suggestions.length,
              itemBuilder: (_, i) {
                final (label, emoji) = _suggestions[i];
                return GestureDetector(
                  onTap: () => _send(label),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _C.border),
                    ),
                    child: Row(children: [
                      Text(emoji,
                          style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 5),
                      Text(label,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _C.dark)),
                    ]),
                  ),
                );
              },
            ),
          ),

          // ── Input bar ────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  MediaQuery.of(context).padding.bottom +
                  8,
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: _C.lightGrey,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: _C.border),
                  ),
                  child: TextField(
                    controller: _inputCtrl,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _send,
                    style: const TextStyle(fontSize: 14, color: _C.dark),
                    decoration: const InputDecoration(
                      hintText: 'Ask your coach anything...',
                      hintStyle: TextStyle(color: _C.grey, fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _send(_inputCtrl.text),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: _C.dark,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Chat Bubble
// ─────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final _Msg msg;
  const _ChatBubble({required this.msg});

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final isAi = msg.isAi;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAi) ...[
            Container(
              width: 32, height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF1A1A1A), Color(0xFF3A3A3A)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text('🤖', style: TextStyle(fontSize: 15))),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isAi
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.72,
                  ),
                  decoration: BoxDecoration(
                    color: isAi ? Colors.white : _C.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isAi ? 4 : 16),
                      bottomRight: Radius.circular(isAi ? 16 : 4),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                        fontSize: 13,
                        color: isAi ? _C.dark : Colors.white,
                        height: 1.5),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatTime(msg.time),
                  style: const TextStyle(fontSize: 10, color: _C.grey),
                ),
              ],
            ),
          ),
          if (!isAi) ...[
            Container(
              width: 32, height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: _C.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text('😊', style: TextStyle(fontSize: 15))),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Typing indicator
// ─────────────────────────────────────────────
class _TypingBubble extends StatefulWidget {
  const _TypingBubble();
  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32, height: 32,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF3A3A3A)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 15))),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6)
              ],
            ),
            child: Row(children: [
              _Dot(anim: _anim, delay: 0),
              const SizedBox(width: 4),
              _Dot(anim: _anim, delay: 0.2),
              const SizedBox(width: 4),
              _Dot(anim: _anim, delay: 0.4),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Animation<double> anim;
  final double delay;
  const _Dot({required this.anim, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final v = ((anim.value - delay).clamp(0.0, 1.0));
        return Container(
          width: 7, height: 7,
          decoration: BoxDecoration(
            color: Color.lerp(
                const Color(0xFFCCCCCC), _C.grey, v),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}