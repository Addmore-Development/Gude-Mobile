import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────
// USER PROFILE — collected progressively from chat
// ─────────────────────────────────────────────────────────
class _UserProfile {
  String? name;
  String? university;
  String? city;
  String? studyField;
  String? budgetLevel; // 'tight' | 'okay' | 'comfortable'
  String? primaryNeed; // 'earn' | 'save' | 'food' | 'study' | 'wellbeing'
  List<String> interests = [];
  int chatTurns = 0;
}

// ─────────────────────────────────────────────────────────
// BOTTOM NAV SHELL  (replaces any existing bottom_nav_shell.dart)
// ─────────────────────────────────────────────────────────
class BottomNavShell extends StatefulWidget {
  final Widget child;
  const BottomNavShell({super.key, required this.child});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> with SingleTickerProviderStateMixin {
  bool _chatOpen = false;
  late AnimationController _slideAnim;
  late Animation<Offset> _slideOffset;
  final _userProfile = _UserProfile();

  static const _tabs = [
    _NavTab('/home', Icons.home_outlined, Icons.home_rounded, 'Home'),
    _NavTab('/marketplace', Icons.storefront_outlined, Icons.storefront_rounded, 'Market'),
    _NavTab('/wallet', Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Wallet'),
    _NavTab('/support', Icons.support_agent_outlined, Icons.support_agent_rounded, 'Support'),
    _NavTab('/stability', Icons.monitor_heart_outlined, Icons.monitor_heart_rounded, 'Stability'),
  ];

  @override
  void initState() {
    super.initState();
    _slideAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _slideOffset = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideAnim, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _slideAnim.dispose();
    super.dispose();
  }

  void _openChat() {
    setState(() => _chatOpen = true);
    _slideAnim.forward();
  }

  void _closeChat() {
    _slideAnim.reverse().then((_) => setState(() => _chatOpen = false));
  }

  int _currentIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (loc.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final idx = _currentIndex(context);
    return Scaffold(
      body: Stack(
        children: [
          widget.child,

          // Global chatbot FAB — always visible
          Positioned(
            right: 16,
            bottom: 80,
            child: GestureDetector(
              onTap: _openChat,
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE30613), Color(0xFF8B0000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFE30613).withOpacity(0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 26),
              ),
            ),
          ),

          // Chatbot overlay
          if (_chatOpen)
            GestureDetector(
              onTap: _closeChat,
              child: Container(color: Colors.black.withOpacity(0.35)),
            ),
          if (_chatOpen)
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: SlideTransition(
                position: _slideOffset,
                child: _ChatbotPanel(
                  onClose: _closeChat,
                  userProfile: _userProfile,
                  onProfileUpdate: () => setState(() {}),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final selected = i == idx;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.go(tab.path),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            selected ? tab.activeIcon : tab.icon,
                            key: ValueKey(selected),
                            size: 22,
                            color: selected ? AppColors.primary : const Color(0xFFAAAAAA),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                            color: selected ? AppColors.primary : const Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavTab(this.path, this.icon, this.activeIcon, this.label);
}

// ─────────────────────────────────────────────────────────
// CHATBOT PANEL
// ─────────────────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isBot;
  const _ChatMessage({required this.text, required this.isBot});
}

class _ChatbotPanel extends StatefulWidget {
  final VoidCallback onClose;
  final _UserProfile userProfile;
  final VoidCallback onProfileUpdate;

  const _ChatbotPanel({
    required this.onClose,
    required this.userProfile,
    required this.onProfileUpdate,
  });

  @override
  State<_ChatbotPanel> createState() => _ChatbotPanelState();
}

class _ChatbotPanelState extends State<_ChatbotPanel> {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  bool _typing = false;

  late List<_ChatMessage> _messages;

  // Onboarding question state
  int _onboardingStep = 0; // 0=name, 1=uni, 2=need, 3=done
  bool get _onboardingComplete => _onboardingStep >= 3 || widget.userProfile.chatTurns > 6;

  @override
  void initState() {
    super.initState();
    _messages = [_ChatMessage(text: _openingMessage(), isBot: true)];
  }

  String _openingMessage() {
    if (widget.userProfile.name != null) {
      return '👋 Welcome back, ${widget.userProfile.name}!\n\nWhat can I help you with today?';
    }
    return '👋 Hi! I\'m Gude AI — your campus assistant.\n\nI help with:\n• Deals & discounts near campus\n• Financial advice & budgeting\n• Finding income opportunities\n• Study & wellness support\n\nFirst — what\'s your name?';
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _typing = true;
      widget.userProfile.chatTurns++;
    });
    _msgController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final reply = _processMessage(text);
      setState(() {
        _typing = false;
        _messages.add(_ChatMessage(text: reply, isBot: true));
      });
      widget.onProfileUpdate();
      _scrollToBottom();
    });
  }

  String _processMessage(String input) {
    final lower = input.toLowerCase().trim();

    // ── Onboarding flow ────────────────────────────────
    if (!_onboardingComplete) {
      if (_onboardingStep == 0) {
        // Collect name
        final name = input.trim().split(' ').first;
        widget.userProfile.name = name;
        _onboardingStep = 1;
        return 'Nice to meet you, $name! 🎓\n\nWhich university or college are you at?';
      }
      if (_onboardingStep == 1) {
        // Collect university
        widget.userProfile.university = input.trim();
        _onboardingStep = 2;
        return 'Great — ${input.trim()}! 💪\n\nWhat\'s your biggest challenge right now?\n\n'
            'Reply with a number:\n1️⃣  I need to earn money\n2️⃣  I\'m struggling to budget\n3️⃣  I need affordable food\n4️⃣  I need study help\n5️⃣  I\'m feeling stressed';
      }
      if (_onboardingStep == 2) {
        // Collect primary need
        if (lower.contains('1') || lower.contains('earn') || lower.contains('money') || lower.contains('income')) {
          widget.userProfile.primaryNeed = 'earn';
          _onboardingStep = 3;
          return '💼 Got it — let\'s get you earning!\n\nWith your skills, you could make R500–R2000 extra per month on the Gude marketplace.\n\nWhat skills do you have? (e.g. tutoring, design, coding, photography, writing)';
        }
        if (lower.contains('2') || lower.contains('budget') || lower.contains('spend')) {
          widget.userProfile.primaryNeed = 'save';
          _onboardingStep = 3;
          return '💰 Budgeting is key!\n\nI\'ve noted your focus. Check the Wallet tab to set up your budget planner.\n\nTell me more — is your NSFAS running out before month end?';
        }
        if (lower.contains('3') || lower.contains('food') || lower.contains('hungry')) {
          widget.userProfile.primaryNeed = 'food';
          _onboardingStep = 3;
          return '🍽️ Food security matters.\n\nHere are some options:\n• Campus canteen meal of the day ~R30–R45\n• Woolies Food: 50% off at 18:00 daily\n• Spar student night special: Thursdays\n• Food banks at most campuses\n\nWant me to find listings on the marketplace too?';
        }
        if (lower.contains('4') || lower.contains('study') || lower.contains('tutor')) {
          widget.userProfile.primaryNeed = 'study';
          _onboardingStep = 3;
          return '📚 Study support unlocked!\n\nI found tutors on the marketplace who can help. Most charge R80–R150/hr, and group sessions can be as low as R40/person.\n\nWhat subject are you struggling with?';
        }
        if (lower.contains('5') || lower.contains('stress') || lower.contains('mental') || lower.contains('well')) {
          widget.userProfile.primaryNeed = 'wellbeing';
          _onboardingStep = 3;
          return '💙 I hear you. You\'re not alone.\n\nYour Stability tab has weekly check-ins and connects you to campus counselors for free.\n\nWould you like me to point you to the Support Hub right now?';
        }
        _onboardingStep = 3;
        return 'Got it! I\'ve noted your needs. Ask me anything — deals, budgeting, income, food, or support. I\'m always here. 💪';
      }
    }

    // ── General conversation ───────────────────────────
    if (lower.contains('discount') || lower.contains('deal') || lower.contains('cheap') || lower.contains('save')) {
      final city = widget.userProfile.city ?? 'your area';
      return '🛒 Deals near $city this week:\n\n'
          '• Checkers: 30% off rice & pasta\n'
          '• PnP: 15% off with student card\n'
          '• Hungry Lion: R49 student meal with ID\n'
          '• Clicks: Toiletries bundle R89 (save R40)\n\n'
          '💡 Show your student card at Checkers for an extra 5% off!';
    }
    if (lower.contains('budget') || lower.contains('nsfas') || lower.contains('allowance')) {
      return '💰 Smart budgeting for students:\n\n'
          '1. Split NSFAS on day 1:\n   • 50% for needs (food/transport)\n   • 30% for wants\n   • 20% savings\n\n'
          '2. Withdraw cash once a week — limits impulse spending\n'
          '3. Use the Gude Budget Planner in the Wallet tab\n\n'
          'Want me to walk you through setting up your budget?';
    }
    if (lower.contains('food') || lower.contains('hungry') || lower.contains('eat')) {
      return '🍽️ Affordable eating options:\n\n'
          '• Woolies Food: 50% off ready meals at 18:00\n'
          '• Campus canteen: Meal of the day R30–R45\n'
          '• Spar: Student night special Thursdays R25 wrap\n'
          '• Buying in bulk with classmates saves 20–30%\n\n'
          'Check the Marketplace — students also sell home-cooked meals!';
    }
    if (lower.contains('earn') || lower.contains('job') || lower.contains('gig') || lower.contains('income')) {
      return '💼 Earn on Gude right now:\n\n'
          '• Create a skill listing (takes 2 mins)\n'
          '• Emergency gigs paying R50–R200 today\n'
          '• Campus delivery runs: R30–R80/trip\n'
          '• Tutoring: avg R120–R200/hr\n\n'
          'Most students earn R500–R2000 extra per month. Tap the + button on the Marketplace to get started!';
    }
    if (lower.contains('tutor') || lower.contains('study') || lower.contains('help') && lower.contains('exam')) {
      return '📚 Tutors available this week:\n\n'
          '• Aisha M. — Maths & Stats (UCT) R150/hr ⭐4.9\n'
          '• Nadia A. — Accounting (CPUT) R120/hr ⭐4.8\n'
          '• Lebo N. — IT & Coding (TUT) R200/hr ⭐5.0\n'
          '• Group sessions from R60/person\n\n'
          'Book 3+ sessions for a 15% discount. Find them on the Marketplace!';
    }
    if (lower.contains('stress') || lower.contains('mental') || lower.contains('depress') || lower.contains('anxious') || lower.contains('struggling')) {
      return '💙 I hear you — and it\'s okay to not be okay.\n\n'
          'Here\'s what can help right now:\n\n'
          '• Check the Stability tab for your wellness score\n'
          '• Free campus counseling is always available\n'
          '• The Support Hub connects you to peer mentors\n\n'
          'You\'re not alone. Gude is here. Would you like to do a quick check-in?';
    }
    if (lower.contains('dropout') || lower.contains('quit') || lower.contains('leave') && lower.contains('school')) {
      return '🛑 Please don\'t give up.\n\n'
          'Gude exists specifically to help students like you stay in school.\n\n'
          'Right now I can help you:\n'
          '✅ Find emergency income (today)\n'
          '✅ Sort out your budget\n'
          '✅ Connect to free campus support\n\n'
          'What\'s the biggest thing pushing you toward leaving?';
    }

    // Collect interests
    final interestWords = ['design', 'code', 'coding', 'photography', 'writing', 'tutoring', 'math', 'accounting'];
    for (final word in interestWords) {
      if (lower.contains(word) && !widget.userProfile.interests.contains(word)) {
        widget.userProfile.interests.add(word);
      }
    }

    return 'I can help with:\n\n'
        '🛒  "deals near me" — campus discounts\n'
        '💰  "budget tips" — financial advice\n'
        '🍽️  "cheap food" — affordable eating\n'
        '💼  "earn money" — income ideas\n'
        '📚  "find a tutor" — study help\n'
        '💙  "I\'m stressed" — wellness support\n\n'
        'What do you need today?';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 120), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<String> get _quickReplies {
    if (!_onboardingComplete) return [];
    switch (widget.userProfile.primaryNeed) {
      case 'earn': return ['How do I create a listing?', 'What gigs pay today?', 'Budget tips'];
      case 'save': return ['Budget tips', 'NSFAS advice', 'Cheap food near me'];
      case 'food': return ['Cheap food near me', 'Food banks on campus', 'Earn money'];
      case 'study': return ['Find a tutor', 'Study groups', 'I\'m stressed'];
      default: return ['Deals near me', 'Budget tips', 'Earn money', 'Find a tutor'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      height: MediaQuery.of(context).size.height * 0.74,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 36, height: 4,
            decoration: BoxDecoration(color: const Color(0xFFDDDDDD), borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
            child: Row(children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE30613), Color(0xFFB0000E)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Gude AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A1A))),
                  Text(
                    widget.userProfile.name != null
                        ? 'Personalised for ${widget.userProfile.name}'
                        : 'Campus & financial assistant',
                    style: const TextStyle(fontSize: 11, color: Color(0xFF999999)),
                  ),
                ],
              )),
              IconButton(icon: const Icon(Icons.close_rounded, color: Color(0xFF777777)), onPressed: widget.onClose),
            ]),
          ),

          const Divider(height: 1, color: Color(0xFFF0F0F0)),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (_typing && i == _messages.length) return _TypingDots();
                return _Bubble(message: _messages[i]);
              },
            ),
          ),

          // Quick replies
          if (_quickReplies.isNotEmpty)
            SizedBox(
              height: 36,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: _quickReplies.map((q) => GestureDetector(
                  onTap: () => _send(q),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                    ),
                    child: Text(q, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                  ),
                )).toList(),
              ),
            ),

          // Input bar
          Container(
            padding: EdgeInsets.fromLTRB(12, 8, 12, bottomPad + 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
            ),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _msgController,
                    onSubmitted: _send,
                    textInputAction: TextInputAction.send,
                    decoration: const InputDecoration(
                      hintText: 'Ask anything...',
                      hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _send(_msgController.text),
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 17),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _ChatMessage message;
  const _Bubble({required this.message});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: message.isBot ? const Color(0xFFF4F4F4) : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isBot ? 4 : 16),
            bottomRight: Radius.circular(message.isBot ? 16 : 4),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 13,
            color: message.isBot ? const Color(0xFF1A1A1A) : Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _TypingDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(color: const Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            margin: EdgeInsets.only(left: i > 0 ? 5 : 0),
            width: 7, height: 7,
            decoration: const BoxDecoration(color: Color(0xFFCCCCCC), shape: BoxShape.circle),
          )),
        ),
      ),
    );
  }
}