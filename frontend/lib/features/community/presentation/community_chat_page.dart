// ═══════════════════════════════════════════════════════════════
// community_chat_page.dart
//
// Every registered student is auto-joined to:
//   1. Their university community chat
//   2. Their city community chat
//
// This file delivers:
//   - CommunityChatPage  (channel list — shows both rooms)
//   - ChatRoomPage       (messages inside a room)
//   - CommunityChat      (global singleton state)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────
// COLORS
// ─────────────────────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
  static const bubble    = Color(0xFFF0F0F0);
}

// ─────────────────────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────────────────────
class ChatMessage {
  final String id;
  final String senderName;
  final String senderInitials;
  final Color  senderColor;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.senderInitials,
    required this.senderColor,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class ChatRoom {
  final String id;
  String name;
  final String subtitle;
  final String emoji;
  final String type; // 'university' | 'city'
  int unreadCount;
  final List<ChatMessage> messages;

  ChatRoom({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.emoji,
    required this.type,
    this.unreadCount = 0,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];
}

// ─────────────────────────────────────────────────────────────
// GLOBAL COMMUNITY CHAT STATE (singleton)
// In production this would be backed by a real-time DB
// (Firebase Realtime / Supabase / Socket.io)
// ─────────────────────────────────────────────────────────────
class CommunityChat {
  static final CommunityChat _inst = CommunityChat._();
  factory CommunityChat() => _inst;
  CommunityChat._() { _init(); }

  // The two rooms the current student belongs to (set at login/signup)
  String universityName = 'Nelson Mandela University';
  String cityName       = 'Port Elizabeth';

  late final List<ChatRoom> rooms;

  void _init() {
    final now = DateTime.now();
    rooms = [
      ChatRoom(
        id:       'uni',
        name:     universityName,
        subtitle: 'University community',
        emoji:    '🎓',
        type:     'university',
        unreadCount: 3,
        messages: [
          _msg('m1', 'Sipho M.',       'SM', const Color(0xFF3B82F6),
              'Anyone going to the SRC meeting tomorrow?',
              now.subtract(const Duration(minutes: 45)), false),
          _msg('m2', 'Aisha K.',       'AK', const Color(0xFF10B981),
              'Yes! What time does it start?',
              now.subtract(const Duration(minutes: 40)), false),
          _msg('m3', 'Sipho M.',       'SM', const Color(0xFF3B82F6),
              '10am in the main hall',
              now.subtract(const Duration(minutes: 38)), false),
          _msg('m4', 'You',            'ME', _C.primary,
              'I\'ll be there. Are notes being taken?',
              now.subtract(const Duration(minutes: 30)), true),
          _msg('m5', 'Zanele D.',      'ZD', const Color(0xFF8B5CF6),
              'I\'ll take notes and share them in the group after 👍',
              now.subtract(const Duration(minutes: 25)), false),
          _msg('m6', 'Ruan P.',        'RP', const Color(0xFFF59E0B),
              'Anyone selling Data Science textbooks? Need Sem 2 ones',
              now.subtract(const Duration(minutes: 10)), false),
          _msg('m7', 'Fatima H.',      'FH', const Color(0xFFEC4899),
              'I have the one by Müller – R180, still in good condition',
              now.subtract(const Duration(minutes: 8)), false),
        ],
      ),
      ChatRoom(
        id:       'city',
        name:     cityName,
        subtitle: 'City community',
        emoji:    '📍',
        type:     'city',
        unreadCount: 1,
        messages: [
          _msg('c1', 'Keanu N.',   'KN', const Color(0xFF0EA5E9),
              'Guys anyone know a cheap place to print near Central?',
              now.subtract(const Duration(hours: 2)), false),
          _msg('c2', 'Precious M.','PM', const Color(0xFFE879F9),
              'Walmer stationers is R0.40/page, cheapest I\'ve found',
              now.subtract(const Duration(hours: 1, minutes: 55)), false),
          _msg('c3', 'You',        'ME', _C.primary,
              'Thanks! Been looking for ages',
              now.subtract(const Duration(hours: 1, minutes: 50)), true),
          _msg('c4', 'Ntando B.',  'NB', const Color(0xFF34D399),
              'Taxi rank on Bird St is safer after 6pm FYI 🙏',
              now.subtract(const Duration(minutes: 40)), false),
          _msg('c5', 'Keanu N.',   'KN', const Color(0xFF0EA5E9),
              'Good to know, thanks bro',
              now.subtract(const Duration(minutes: 35)), false),
        ],
      ),
    ];
  }

  static ChatMessage _msg(
    String id,
    String name,
    String initials,
    Color color,
    String text,
    DateTime ts,
    bool isMe,
  ) =>
      ChatMessage(
        id: id,
        senderName: name,
        senderInitials: initials,
        senderColor: color,
        text: text,
        timestamp: ts,
        isMe: isMe,
      );

  /// Call this with values from the user's profile after signup/login
  void configureForUser({required String university, required String city}) {
    universityName = university;
    cityName       = city;
    rooms[0].name  = university;
    rooms[1].name  = city;
  }

  void sendMessage(String roomId, String text) {
    final room = rooms.firstWhere((r) => r.id == roomId);
    room.messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: 'You',
      senderInitials: 'ME',
      senderColor: _C.primary,
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    ));
  }

  void markRead(String roomId) {
    rooms.firstWhere((r) => r.id == roomId).unreadCount = 0;
  }
}

// ─────────────────────────────────────────────────────────────
// COMMUNITY CHAT PAGE  (channel list)
// ─────────────────────────────────────────────────────────────
class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage> {
  final _chat = CommunityChat();

  int get _totalUnread =>
      _chat.rooms.fold(0, (s, r) => s + r.unreadCount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: _C.border)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Community',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: _C.dark,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  if (_totalUnread > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _C.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_totalUnread unread',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info banner ────────────────────────────────
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'re auto-joined 🎉',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Connected to your university & city community the moment you signed up.',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('🤝', style: TextStyle(fontSize: 36)),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Section label ──────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Communities',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _C.dark),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Room list ──────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _chat.rooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final room = _chat.rooms[i];
                  return _RoomCard(
                    room: room,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatRoomPage(room: room),
                        ),
                      );
                      setState(() {}); // refresh unread counts
                    },
                  );
                },
              ),
            ),

            // ── Coming soon section ────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _ComingSoonSection(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ROOM CARD
// ─────────────────────────────────────────────────────────────
class _RoomCard extends StatelessWidget {
  final ChatRoom room;
  final VoidCallback onTap;

  const _RoomCard({required this.room, required this.onTap});

  String get _lastMessagePreview {
    if (room.messages.isEmpty) return 'No messages yet. Say hello! 👋';
    final last = room.messages.last;
    final who  = last.isMe ? 'You' : last.senderName.split(' ').first;
    return '$who: ${last.text}';
  }

  String get _lastTime {
    if (room.messages.isEmpty) return '';
    final diff = DateTime.now().difference(room.messages.last.timestamp);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: room.type == 'university'
                    ? _C.primary.withOpacity(0.1)
                    : const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(room.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.dark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: room.type == 'university'
                          ? _C.primary.withOpacity(0.08)
                          : const Color(0xFF3B82F6).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      room.subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: room.type == 'university'
                            ? _C.primary
                            : const Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _lastMessagePreview,
                    style: TextStyle(
                      fontSize: 12,
                      color: room.unreadCount > 0 ? _C.dark : _C.grey,
                      fontWeight: room.unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _lastTime,
                  style: const TextStyle(fontSize: 11, color: _C.grey),
                ),
                const SizedBox(height: 6),
                if (room.unreadCount > 0)
                  Container(
                    width: 22, height: 22,
                    decoration: const BoxDecoration(
                        color: _C.primary, shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        '${room.unreadCount}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// COMING SOON SECTION
// ─────────────────────────────────────────────────────────────
class _ComingSoonSection extends StatelessWidget {
  const _ComingSoonSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _C.lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.group_add_outlined,
                color: Color(0xFFF59E0B), size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('More communities coming',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                Text('Interest groups, study rooms & more',
                    style: TextStyle(fontSize: 11, color: _C.grey)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text('Soon',
                style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFFF59E0B),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// CHAT ROOM PAGE
// ─────────────────────────────────────────────────────────────
class ChatRoomPage extends StatefulWidget {
  final ChatRoom room;
  const ChatRoomPage({super.key, required this.room});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final _input      = TextEditingController();
  final _scroll     = ScrollController();
  bool  _canSend    = false;

  @override
  void initState() {
    super.initState();
    CommunityChat().markRead(widget.room.id);
    _input.addListener(() => setState(() => _canSend = _input.text.trim().isNotEmpty));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    CommunityChat().sendMessage(widget.room.id, text);
    _input.clear();
    setState(() {});
    Future.delayed(const Duration(milliseconds: 80), _scrollToBottom);
    HapticFeedback.lightImpact();
  }

  void _scrollToBottom() {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  bool _showDateDivider(int i) {
    if (i == 0) return true;
    final prev = widget.room.messages[i - 1].timestamp;
    final curr = widget.room.messages[i].timestamp;
    return prev.day != curr.day;
  }

  String _formatDate(DateTime dt) {
    final now  = DateTime.now();
    final diff = now.difference(dt).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final msgs = widget.room.messages;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: _C.dark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: widget.room.type == 'university'
                    ? _C.primary.withOpacity(0.1)
                    : const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(widget.room.emoji,
                    style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.room.name,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _C.dark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${msgs.length} messages · ${widget.room.subtitle}',
                    style: const TextStyle(fontSize: 10, color: _C.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: _C.grey, size: 20),
            onPressed: () => _showRoomInfo(context),
          ),
        ],
      ),

      body: Column(
        children: [
          // ── Messages ──────────────────────────────────────
          Expanded(
            child: msgs.isEmpty
                ? const Center(
                    child: Text('Be the first to say hello! 👋',
                        style: TextStyle(color: _C.grey, fontSize: 14)))
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    itemCount: msgs.length,
                    itemBuilder: (_, i) {
                      final msg = msgs[i];
                      return Column(
                        children: [
                          if (_showDateDivider(i))
                            _DateDivider(label: _formatDate(msg.timestamp)),
                          _MessageBubble(
                            msg: msg,
                            time: _formatTime(msg.timestamp),
                            showAvatar: !msg.isMe &&
                                (i == 0 ||
                                    msgs[i - 1].senderName != msg.senderName),
                          ),
                        ],
                      );
                    },
                  ),
          ),

          // ── Input bar ─────────────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
                12, 10, 12, MediaQuery.of(context).padding.bottom + 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: _C.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _C.border),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            controller: _input,
                            textCapitalization: TextCapitalization.sentences,
                            minLines: 1,
                            maxLines: 4,
                            style: const TextStyle(
                                fontSize: 14, color: _C.dark),
                            decoration: const InputDecoration(
                              hintText: 'Message the community…',
                              hintStyle: TextStyle(
                                  color: Color(0xFFAAAAAA), fontSize: 14),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: _canSend ? _C.primary : _C.lightGrey,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: _canSend ? Colors.white : _C.grey,
                      size: 18,
                    ),
                    onPressed: _canSend ? _send : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRoomInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(
                  color: _C.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text(widget.room.emoji,
                style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(widget.room.name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w800, color: _C.dark)),
            const SizedBox(height: 4),
            Text(widget.room.subtitle,
                style: const TextStyle(fontSize: 13, color: _C.grey)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(children: [
                Icon(Icons.shield_outlined, color: _C.grey, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Be respectful. No spam, hate speech, or personal attacks. Violations will result in removal from the community.',
                    style: TextStyle(fontSize: 12, color: _C.grey, height: 1.5),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MESSAGE BUBBLE
// ─────────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final String time;
  final bool showAvatar;

  const _MessageBubble({
    required this.msg,
    required this.time,
    required this.showAvatar,
  });

  @override
  Widget build(BuildContext context) {
    if (msg.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(time, style: const TextStyle(fontSize: 10, color: _C.grey)),
            const SizedBox(width: 6),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _C.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 13, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (or spacer)
          showAvatar
              ? Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    color: msg.senderColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      msg.senderInitials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              : const SizedBox(width: 30),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showAvatar)
                  Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 2),
                    child: Text(
                      msg.senderName,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: msg.senderColor),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(color: _C.border),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                        color: _C.dark, fontSize: 13, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(time, style: const TextStyle(fontSize: 10, color: _C.grey)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DATE DIVIDER
// ─────────────────────────────────────────────────────────────
class _DateDivider extends StatelessWidget {
  final String label;
  const _DateDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: _C.border)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _C.border),
              ),
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _C.grey),
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: _C.border)),
        ],
      ),
    );
  }
}