import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:gude_mobile/core/theme/app_theme.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();
  bool _loading = false;

  final List<Map<String, String>> _messages = [
    {
      'role': 'assistant',
      'text':
          "?? Hi! I'm your Gude financial assistant.\n\nI can help you with:\n� ?? Budgeting your NSFAS allowance\n� ?? Understanding your spending\n� ?? Setting savings goals\n� ?? Making smart money decisions\n\nWhat would you like help with today?",
    },
  ];

  final List<String> _quickReplies = [
    'How do I budget my NSFAS?',
    'Help me save for a laptop',
    'Why am I overspending?',
    'Best ways to cut costs',
    'Should I buy or rent textbooks?',
  ];

  // Replace with your actual Anthropic API key
  static const _apiKey = '########################################';

  static const _systemPrompt = '''
You are Gude, a smart and friendly financial assistant for South African university and TVET students.
You help students:
- Budget their NSFAS (National Student Financial Aid Scheme) allowances
- Track and reduce spending
- Make smart financial decisions on a student budget
- Save towards goals like laptops, accommodation deposits, and registration fees
- Understand concepts like EFTs, banking, and saving in simple terms

Keep responses concise, practical, and encouraging. Use South African context (Rands, local stores like Shoprite, Checkers, Pick n Pay, transport like taxis and Uber). 
When giving budgeting advice, be specific with numbers.
Use emojis sparingly to make responses friendly but professional.
Always end with a follow-up question or suggestion to keep the conversation helpful.
''';

  Future<void> _send([String? quickReply]) async {
    final text = quickReply ?? _input.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _loading = true;
    });
    _input.clear();
    _scrollDown();

    try {
      // Build message history for context
      final history = _messages
          .where((m) => m['role'] != 'assistant' || _messages.indexOf(m) > 0)
          .map((m) => {'role': m['role'], 'content': m['text']})
          .toList();

      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-6',
          'max_tokens': 1024,
          'system': _systemPrompt,
          'messages': history,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['content'][0]['text'] as String;
        setState(() => _messages.add({'role': 'assistant', 'text': reply}));
      } else {
        setState(() => _messages.add({
              'role': 'assistant',
              'text':
                  "Sorry, I'm having trouble connecting right now. Please check your internet and try again.",
            }));
      }
    } catch (e) {
      setState(() => _messages.add({
            'role': 'assistant',
            'text':
                "I couldn't connect to the server. Please make sure you have internet access.",
          }));
    }

    setState(() => _loading = false);
    _scrollDown();
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_outlined,
                  color: Colors.white, size: 20)),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Gude Assistant',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Financial AI � Online',
                style: TextStyle(fontSize: 11, color: Colors.white70)),
          ]),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => setState(() {
              _messages.clear();
              _messages.add({
                'role': 'assistant',
                'text':
                    "Chat cleared! How can I help you with your finances today? ??",
              });
            }),
          ),
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.go('/login')),
        ],
      ),
      body: Column(children: [
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _scroll,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _messages.length + (_loading ? 1 : 0),
            itemBuilder: (_, i) {
              if (i == _messages.length) return const _TypingIndicator();
              final m = _messages[i];
              final isUser = m['role'] == 'user';
              return _ChatBubble(text: m['text']!, isUser: isUser);
            },
          ),
        ),

        // Quick replies (only show at start)
        if (_messages.length <= 1)
          Container(
            height: 44,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              children: _quickReplies
                  .map((q) => GestureDetector(
                        onTap: () => _send(q),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.primary),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(q,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColors.primary)),
                        ),
                      ))
                  .toList(),
            ),
          ),

        // Input bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _input,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Ask about budgeting, saving, spending...',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: AppColors.textGrey),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _loading ? null : () => _send(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _loading ? Colors.grey.shade300 : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _loading ? Icons.hourglass_empty : Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.smart_toy_outlined,
                    color: Colors.white, size: 16)),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Text(text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isUser ? Colors.white : AppColors.textDark,
                    height: 1.5,
                  )),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 16)),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();
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
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
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
      child: Row(children: [
        Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
                color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.smart_toy_outlined,
                color: Colors.white, size: 16)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(
              children: List.generate(
                  3,
                  (i) => AnimatedBuilder(
                        animation: _anim,
                        builder: (_, __) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(
                                i == 1 ? _anim.value : 1 - _anim.value + 0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ))),
        ),
      ]),
    );
  }
}
