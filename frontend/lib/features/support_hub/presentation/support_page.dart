import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
}

// ─────────────────────────────────────────────
// DATA
// ─────────────────────────────────────────────
const _faqs = [
  _FAQ('How do I hire a student?',
      'Browse the Marketplace, tap a listing you like, then press "Hire". You can review the student\'s profile, ratings, and agree on a price before confirming.'),
  _FAQ('How do I get paid for my work?',
      'Payments are deposited into your Gude Wallet once a job is marked complete. You can withdraw to your bank account from the Wallet tab.'),
  _FAQ('What if I\'m not satisfied with the work?',
      'Raise a dispute within 48 hours of job completion. Our team will review the evidence and mediate a fair outcome.'),
  _FAQ('How do I verify my student status?',
      'Go to Profile → Verify Student, then upload your current student card or a recent proof of enrolment. Verification usually takes 1–2 business days.'),
  _FAQ('Is my payment information secure?',
      'Yes. All transactions are encrypted and we never store full card details. Payments are processed through a PCI-DSS compliant provider.'),
  _FAQ('How do I cancel or reschedule a job?',
      'Open the job from your dashboard and tap "Manage Job". You can request a reschedule or cancellation — note that late cancellations may incur a small fee.'),
];

class _FAQ {
  final String q, a;
  const _FAQ(this.q, this.a);
}

// ─────────────────────────────────────────────
// PAGE
// ─────────────────────────────────────────────
class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  int? _expandedFaq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ── Chatbot FAB — bottom right, above nav bar ──
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: FloatingActionButton(
          onPressed: _openChat,
          backgroundColor: _C.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.smart_toy_rounded,
              color: Colors.white, size: 26),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ─────────────────────────────
            SliverToBoxAdapter(
              child: _Header(),
            ),

            // ── Quick contact cards ────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Get in touch',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _C.dark)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.chat_bubble_outline_rounded,
                            label: 'Live Chat',
                            sub: 'Avg. 2 min reply',
                            color: _C.primary,
                            onTap: _openChat,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.email_outlined,
                            label: 'Email Us',
                            sub: 'support@gude.co.za',
                            color: const Color(0xFF6366F1),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.phone_outlined,
                            label: 'Call Us',
                            sub: '+27 10 500 0000',
                            color: _C.green,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ContactCard(
                            icon: Icons.article_outlined,
                            label: 'Help Docs',
                            sub: 'Browse guides',
                            color: const Color(0xFFF59E0B),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Popular topics ─────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Popular topics',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _C.dark)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        _TopicChip('Payments'),
                        _TopicChip('Hiring'),
                        _TopicChip('Account'),
                        _TopicChip('Disputes'),
                        _TopicChip('Verification'),
                        _TopicChip('Withdrawals'),
                        _TopicChip('Safety'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── FAQ header ─────────────────────────
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Text('Frequently Asked Questions',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
              ),
            ),

            // ── FAQ list ───────────────────────────
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _FaqTile(
                  faq: _faqs[i],
                  isExpanded: _expandedFaq == i,
                  onTap: () => setState(
                      () => _expandedFaq = _expandedFaq == i ? null : i),
                ),
                childCount: _faqs.length,
              ),
            ),

            // ── Still need help banner ─────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A1A1A), Color(0xFF333333)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Still need help?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            const Text(
                                'Our support team is available\nMon–Fri, 8am–6pm SAST.',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    height: 1.4)),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: _openChat,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 9),
                                decoration: BoxDecoration(
                                  color: _C.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Start a chat',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text('🎧',
                          style: TextStyle(fontSize: 56)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ChatSheet(),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _C.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Support Hub',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: _C.dark)),
          const SizedBox(height: 4),
          const Text('How can we help you today?',
              style: TextStyle(fontSize: 13, color: _C.grey)),
          const SizedBox(height: 14),
          // Search bar
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: _C.lightGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _C.border),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: _C.grey, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: const TextStyle(fontSize: 13, color: _C.dark),
                    decoration: const InputDecoration(
                      hintText: 'Search for help…',
                      hintStyle:
                          TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
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

// ─────────────────────────────────────────────
// CONTACT CARD
// ─────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _C.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _C.dark)),
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 10, color: _C.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
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
// TOPIC CHIP
// ─────────────────────────────────────────────
class _TopicChip extends StatelessWidget {
  final String label;
  const _TopicChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: _C.lightGrey,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border),
      ),
      child: Text(label,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _C.dark)),
    );
  }
}

// ─────────────────────────────────────────────
// FAQ TILE
// ─────────────────────────────────────────────
class _FaqTile extends StatelessWidget {
  final _FAQ faq;
  final bool isExpanded;
  final VoidCallback onTap;

  const _FaqTile({
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: isExpanded
              ? _C.primary.withOpacity(0.03)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isExpanded ? _C.primary.withOpacity(0.3) : _C.border),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(faq.q,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isExpanded ? _C.primary : _C.dark)),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: isExpanded ? _C.primary : _C.grey),
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Text(faq.a,
                    style: const TextStyle(
                        fontSize: 12,
                        color: _C.grey,
                        height: 1.6)),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CHAT BOTTOM SHEET
// ─────────────────────────────────────────────
class _ChatSheet extends StatefulWidget {
  const _ChatSheet();

  @override
  State<_ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<_ChatSheet> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _msgs = <_Msg>[
    const _Msg(
        text: 'Hi there! 👋 I\'m the Gude support bot. How can I help you today?',
        isBot: true),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _msgs.add(_Msg(text: text, isBot: false));
      _ctrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _msgs.add(const _Msg(
            text: 'Thanks for reaching out! A human agent will follow up shortly. Is there anything else I can help with?',
            isBot: true));
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 10),
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: _C.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Row(
                children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: _C.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_rounded,
                        color: _C.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gude Support',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _C.dark)),
                      Text('Usually replies in minutes',
                          style: TextStyle(fontSize: 11, color: _C.grey)),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close_rounded,
                        color: _C.grey, size: 22),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: _C.border),

            // Messages
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.all(16),
                itemCount: _msgs.length,
                itemBuilder: (_, i) => _BubbleTile(msg: _msgs[i]),
              ),
            ),

            // Input
            Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: _C.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: _C.lightGrey,
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(color: _C.border),
                      ),
                      child: TextField(
                        controller: _ctrl,
                        onSubmitted: (_) => _send(),
                        style: const TextStyle(
                            fontSize: 13, color: _C.dark),
                        decoration: const InputDecoration(
                          hintText: 'Type a message…',
                          hintStyle: TextStyle(
                              color: Color(0xFFAAAAAA), fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 42, height: 42,
                      decoration: BoxDecoration(
                        color: _C.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 18),
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

class _Msg {
  final String text;
  final bool isBot;
  const _Msg({required this.text, required this.isBot});
}

class _BubbleTile extends StatelessWidget {
  final _Msg msg;
  const _BubbleTile({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isBot ? _C.lightGrey : _C.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(msg.isBot ? 4 : 14),
            bottomRight: Radius.circular(msg.isBot ? 14 : 4),
          ),
        ),
        child: Text(msg.text,
            style: TextStyle(
                fontSize: 13,
                color: msg.isBot ? _C.dark : Colors.white,
                height: 1.4)),
      ),
    );
  }
}