import 'package:flutter/material.dart';

class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const blue      = Color(0xFF3B82F6);
  static const green     = Color(0xFF10B981);
}

// ─────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────
class _Room {
  final String id;
  final String name;
  final String emoji;
  final String lastMsg;
  final String time;
  final int memberCount;
  final int unread;
  final Color color;

  const _Room({
    required this.id,
    required this.name,
    required this.emoji,
    required this.lastMsg,
    required this.time,
    required this.memberCount,
    this.unread = 0,
    required this.color,
  });
}

class _ServicePost {
  final String id;
  final String authorName;
  final String authorInitials;
  final Color authorColor;
  final String category;
  final Color categoryColor;
  final String title;
  final String body;
  final String budget;
  final String timeAgo;
  final int replies;
  bool bookmarked;

  _ServicePost({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.authorColor,
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.body,
    required this.budget,
    required this.timeAgo,
    this.replies = 0,
    this.bookmarked = false,
  });
}

class _RoomMessage {
  final String senderId;
  final String senderName;
  final String senderInitials;
  final String text;
  final DateTime time;

  const _RoomMessage({
    required this.senderId,
    required this.senderName,
    required this.senderInitials,
    required this.text,
    required this.time,
  });
}

// ─────────────────────────────────────────────────────────────
// SEED DATA
// ─────────────────────────────────────────────────────────────
const _rooms = [
  _Room(
    id: 'uct',
    name: 'UCT Students',
    emoji: '🎓',
    lastMsg: 'Anyone have the econ notes from yesterday?',
    time: '2m',
    memberCount: 1240,
    unread: 5,
    color: Color(0xFF3B82F6),
  ),
  _Room(
    id: 'wits',
    name: 'Wits Students',
    emoji: '📚',
    lastMsg: 'Study group at library at 3pm — join?',
    time: '15m',
    memberCount: 980,
    unread: 2,
    color: Color(0xFF8B5CF6),
  ),
  _Room(
    id: 'cpt',
    name: 'Cape Town Hub',
    emoji: '🌍',
    lastMsg: 'Free event at the Grand Parade Saturday!',
    time: '1h',
    memberCount: 3200,
    unread: 0,
    color: Color(0xFF10B981),
  ),
  _Room(
    id: 'jozi',
    name: 'Johannesburg Hub',
    emoji: '🏙️',
    lastMsg: 'Anyone selling a second-hand bike?',
    time: '3h',
    memberCount: 4100,
    unread: 1,
    color: Color(0xFFF59E0B),
  ),
  _Room(
    id: 'nsfas',
    name: 'NSFAS Support',
    emoji: '💳',
    lastMsg: 'August allowances confirmed for most unis.',
    time: '5h',
    memberCount: 8700,
    unread: 0,
    color: Color(0xFFE30613),
  ),
];

List<_ServicePost> _buildPosts() {
  return [
    _ServicePost(
      id: 'p1',
      authorName: 'Thabo Nkosi',
      authorInitials: 'TN',
      authorColor: const Color(0xFF3B82F6),
      category: 'Tutoring',
      categoryColor: const Color(0xFF8B5CF6),
      title: 'Need a Maths 101 tutor ASAP',
      body: 'Struggling with calculus and linear algebra. Need someone who can explain concepts clearly. Available weekends and evenings.',
      budget: 'R80–120/hr',
      timeAgo: '5 min ago',
      replies: 3,
    ),
    _ServicePost(
      id: 'p2',
      authorName: 'Ama Dube',
      authorInitials: 'AD',
      authorColor: const Color(0xFF10B981),
      category: 'Design',
      categoryColor: const Color(0xFFEC4899),
      title: 'Looking for a logo designer for my small biz',
      body: 'I run a student catering service and need a clean, modern logo. Must include my brand colors (green + gold). Quick turnaround appreciated.',
      budget: 'R200–350',
      timeAgo: '22 min ago',
      replies: 7,
    ),
    _ServicePost(
      id: 'p3',
      authorName: 'Sipho Dlamini',
      authorInitials: 'SD',
      authorColor: const Color(0xFF8B5CF6),
      category: 'Coding',
      categoryColor: const Color(0xFF3B82F6),
      title: 'Need help debugging a Python Flask app',
      body: 'Have a final-year project deadline on Friday. The API keeps returning 500 errors on POST requests. 1–2 hours of help needed.',
      budget: 'R100–150',
      timeAgo: '1h ago',
      replies: 2,
    ),
    _ServicePost(
      id: 'p4',
      authorName: 'Lindiwe Moyo',
      authorInitials: 'LM',
      authorColor: const Color(0xFFF59E0B),
      category: 'Writing',
      categoryColor: const Color(0xFF059669),
      title: 'Essay proofreader needed (2000 words)',
      body: 'I need someone to proofread and lightly edit a sociology essay. Must be fluent in academic English. Needed by tomorrow morning.',
      budget: 'R80',
      timeAgo: '2h ago',
      replies: 5,
    ),
    _ServicePost(
      id: 'p5',
      authorName: 'Kabelo Sithole',
      authorInitials: 'KS',
      authorColor: const Color(0xFFE30613),
      category: 'Photography',
      categoryColor: const Color(0xFF06B6D4),
      title: 'Student photographer for graduation pics',
      body: 'Graduating next month and want professional-style photos on campus. Looking for someone with a DSLR. Can do it on the day.',
      budget: 'R300–500',
      timeAgo: '3h ago',
      replies: 11,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────
// COMMUNITY CHAT PAGE
// ─────────────────────────────────────────────────────────────
class CommunityChatPage extends StatefulWidget {
  const CommunityChatPage({super.key});

  @override
  State<CommunityChatPage> createState() => _CommunityChatPageState();
}

class _CommunityChatPageState extends State<CommunityChatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final List<_ServicePost> _posts = _buildPosts();

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalUnread = _rooms.fold<int>(0, (s, r) => s + r.unread);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          const Text('Community',
              style: TextStyle(
                  color: _C.dark,
                  fontWeight: FontWeight.w800,
                  fontSize: 18)),
          if (totalUnread > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: _C.primary,
                  borderRadius: BorderRadius.circular(12)),
              child: Text('$totalUnread',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ]),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: _C.dark),
              onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: _C.primary,
          unselectedLabelColor: _C.grey,
          indicatorColor: _C.primary,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: '💬 Group Rooms'),
            Tab(text: '🛎 Service Feed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _RoomList(rooms: _rooms, onTap: _openRoom),
          _ServiceFeed(
            posts: _posts,
            onPostService: () => _showPostSheet(context),
            onToggleBookmark: (id) => setState(() {
              final p = _posts.firstWhere((p) => p.id == id);
              p.bookmarked = !p.bookmarked;
            }),
            onReply: (post) => _openServiceThread(context, post),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabCtrl,
        builder: (_, __) {
          final onFeed = _tabCtrl.index == 1;
          return FloatingActionButton.extended(
            backgroundColor: _C.primary,
            foregroundColor: Colors.white,
            icon: Icon(onFeed ? Icons.add_rounded : Icons.group_add_rounded,
                size: 20),
            label: Text(onFeed ? 'Post Request' : 'Join Room',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13)),
            onPressed: onFeed
                ? () => _showPostSheet(context)
                : () => _showJoinSheet(context),
          );
        },
      ),
    );
  }

  void _openRoom(_Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _RoomChatPage(room: room)),
    );
  }

  void _showPostSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _PostServiceSheet(
        onSubmit: (post) {
          setState(() => _posts.insert(0, post));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Discover Rooms',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.dark)),
          const SizedBox(height: 4),
          const Text('Rooms are matched by your university and city.',
              style: TextStyle(fontSize: 13, color: _C.grey)),
          const SizedBox(height: 16),
          ..._rooms.map((r) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                      color: r.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                      child: Text(r.emoji,
                          style: const TextStyle(fontSize: 20))),
                ),
                title: Text(r.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: _C.dark)),
                subtitle: Text('${r.memberCount} members',
                    style: const TextStyle(
                        fontSize: 12, color: _C.grey)),
                trailing: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Join',
                      style: TextStyle(
                          color: _C.primary,
                          fontWeight: FontWeight.w700)),
                ),
              )),
        ]),
      ),
    );
  }

  void _openServiceThread(BuildContext context, _ServicePost post) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => _ServiceThreadPage(post: post)),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ROOM LIST TAB
// ─────────────────────────────────────────────────────────────
class _RoomList extends StatelessWidget {
  final List<_Room> rooms;
  final void Function(_Room) onTap;

  const _RoomList({required this.rooms, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: rooms.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, indent: 72, color: _C.border),
      itemBuilder: (_, i) {
        final r = rooms[i];
        return InkWell(
          onTap: () => onTap(r),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                    color: r.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14)),
                child: Center(
                    child:
                        Text(r.emoji, style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Text(r.name,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _C.dark)),
                        ),
                        Text(r.time,
                            style: TextStyle(
                                fontSize: 11,
                                color:
                                    r.unread > 0 ? _C.primary : _C.grey)),
                      ]),
                      const SizedBox(height: 3),
                      Row(children: [
                        Expanded(
                          child: Text(r.lastMsg,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: r.unread > 0 ? _C.dark : _C.grey,
                                  fontWeight: r.unread > 0
                                      ? FontWeight.w600
                                      : FontWeight.normal)),
                        ),
                        if (r.unread > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: _C.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: Text('${r.unread}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700)),
                          ),
                      ]),
                      const SizedBox(height: 2),
                      Text('${r.memberCount} members',
                          style: const TextStyle(
                              fontSize: 10, color: _C.grey)),
                    ]),
              ),
            ]),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SERVICE FEED TAB
// ─────────────────────────────────────────────────────────────
class _ServiceFeed extends StatelessWidget {
  final List<_ServicePost> posts;
  final VoidCallback onPostService;
  final void Function(String id) onToggleBookmark;
  final void Function(_ServicePost) onReply;

  const _ServiceFeed({
    required this.posts,
    required this.onPostService,
    required this.onToggleBookmark,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final p = posts[i];
        return _ServiceCard(
          post: p,
          onBookmark: () => onToggleBookmark(p.id),
          onReply: () => onReply(p),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final _ServicePost post;
  final VoidCallback onBookmark;
  final VoidCallback onReply;

  const _ServiceCard({
    required this.post,
    required this.onBookmark,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header row
        Row(children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: post.authorColor.withOpacity(0.15),
            child: Text(post.authorInitials,
                style: TextStyle(
                    color: post.authorColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.authorName,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _C.dark)),
                  Text(post.timeAgo,
                      style: const TextStyle(
                          fontSize: 11, color: _C.grey)),
                ]),
          ),
          // Category badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: post.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Text(post.category,
                style: TextStyle(
                    fontSize: 10,
                    color: post.categoryColor,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onBookmark,
            child: Icon(
              post.bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              color: post.bookmarked ? _C.primary : _C.grey,
              size: 20,
            ),
          ),
        ]),
        const SizedBox(height: 10),

        // Title
        Text(post.title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _C.dark,
                height: 1.3)),
        const SizedBox(height: 6),

        // Body
        Text(post.body,
            style: const TextStyle(
                fontSize: 13, color: _C.grey, height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),

        // Footer
        Row(children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              const Icon(Icons.payments_outlined,
                  color: _C.green, size: 14),
              const SizedBox(width: 4),
              Text(post.budget,
                  style: const TextStyle(
                      fontSize: 12,
                      color: _C.green,
                      fontWeight: FontWeight.w700)),
            ]),
          ),
          const Spacer(),
          // Reply count
          GestureDetector(
            onTap: onReply,
            child: Row(children: [
              const Icon(Icons.chat_bubble_outline_rounded,
                  color: _C.grey, size: 16),
              const SizedBox(width: 4),
              Text('${post.replies} replies',
                  style: const TextStyle(
                      fontSize: 12, color: _C.grey)),
            ]),
          ),
          const SizedBox(width: 12),
          // Offer button
          GestureDetector(
            onTap: onReply,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Offer Help',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GROUP ROOM CHAT PAGE
// ─────────────────────────────────────────────────────────────
class _RoomChatPage extends StatefulWidget {
  final _Room room;
  const _RoomChatPage({super.key, required this.room});

  @override
  State<_RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<_RoomChatPage> {
  final _msgCtrl    = TextEditingController();
  final _scrollCtrl = ScrollController();
  late List<_RoomMessage> _messages;

  // NOTE: NOT const — _ts() calls DateTime.now() at runtime
  static List<_RoomMessage> _buildSeedMessages() => [
    _RoomMessage(senderId: 'u1', senderName: 'Thabo N.', senderInitials: 'TN', text: 'Hey everyone! Anyone have lecture notes from yesterday?', time: _ts(30)),
    _RoomMessage(senderId: 'u2', senderName: 'Ama D.', senderInitials: 'AD', text: 'I missed that one too 😅 will share when I get them.', time: _ts(25)),
    _RoomMessage(senderId: 'u3', senderName: 'Sipho K.', senderInitials: 'SK', text: 'I have them! Will upload to the group drive shortly.', time: _ts(20)),
    _RoomMessage(senderId: 'u1', senderName: 'Thabo N.', senderInitials: 'TN', text: 'You\'re a lifesaver 🙏', time: _ts(18)),
    _RoomMessage(senderId: 'u4', senderName: 'Lindiwe M.', senderInitials: 'LM', text: 'Study group at the library at 3pm today? 5th floor.', time: _ts(10)),
    _RoomMessage(senderId: 'u2', senderName: 'Ama D.', senderInitials: 'AD', text: 'I\'m in! 👍', time: _ts(8)),
  ];

  static DateTime _ts(int minutesAgo) =>
      DateTime.now().subtract(Duration(minutes: minutesAgo));

  @override
  void initState() {
    super.initState();
    _messages = _buildSeedMessages();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_RoomMessage(
        senderId: 'me',
        senderName: 'You',
        senderInitials: 'ME',
        text: text,
        time: DateTime.now(),
      ));
      _msgCtrl.clear();
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollToBottom());
  }

  String _fmt(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  // Color per sender id for variety
  Color _senderColor(String id) {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF06B6D4),
    ];
    return colors[id.hashCode.abs() % colors.length];
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: widget.room.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text(widget.room.emoji,
                    style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.room.name,
                style: const TextStyle(
                    color: _C.dark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
            Text('${widget.room.memberCount} members',
                style: const TextStyle(
                    color: _C.grey, fontSize: 11)),
          ]),
        ]),
        actions: [
          IconButton(
              icon: const Icon(Icons.people_outline_rounded,
                  color: _C.dark, size: 22),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert_rounded,
                  color: _C.dark, size: 22),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Room banner
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: widget.room.color.withOpacity(0.06),
            child: Row(children: [
              Icon(Icons.info_outline_rounded,
                  color: widget.room.color, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Group chat — be respectful & helpful 🤝',
                  style: TextStyle(
                      color: widget.room.color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                final isMe = msg.senderId == 'me';
                final color = _senderColor(msg.senderId);
                final showSender = !isMe &&
                    (i == 0 ||
                        _messages[i - 1].senderId != msg.senderId);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe) ...[
                        CircleAvatar(
                          radius: 13,
                          backgroundColor: color.withOpacity(0.15),
                          child: Text(msg.senderInitials,
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 8)),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            if (showSender)
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 3, left: 4),
                                child: Text(msg.senderName,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: color)),
                              ),
                            Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context)
                                          .size
                                          .width *
                                      0.70),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? _C.primary
                                    : const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(14),
                                  topRight: const Radius.circular(14),
                                  bottomLeft:
                                      Radius.circular(isMe ? 14 : 4),
                                  bottomRight:
                                      Radius.circular(isMe ? 4 : 14),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(msg.text,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: isMe
                                                ? Colors.white
                                                : _C.dark,
                                            height: 1.4)),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(_fmt(msg.time),
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: isMe
                                              ? Colors.white60
                                              : _C.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _C.border))),
            child: Row(children: [
              IconButton(
                  icon: const Icon(Icons.attach_file_rounded,
                      color: _C.grey, size: 20),
                  onPressed: () {}),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _C.border)),
                  child: TextField(
                    controller: _msgCtrl,
                    onSubmitted: (_) => _send(),
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Message the group…',
                      hintStyle: TextStyle(
                          color: Color(0xFFAAAAAA), fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _send,
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                      color: _C.primary, shape: BoxShape.circle),
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

// ─────────────────────────────────────────────────────────────
// SERVICE THREAD PAGE (replies to a service request post)
// ─────────────────────────────────────────────────────────────
class _ServiceThreadPage extends StatefulWidget {
  final _ServicePost post;
  const _ServiceThreadPage({super.key, required this.post});

  @override
  State<_ServiceThreadPage> createState() => _ServiceThreadPageState();
}

class _ServiceThreadPageState extends State<_ServiceThreadPage> {
  final _replyCtrl = TextEditingController();
  final List<Map<String, String>> _replies = const [
    {'name': 'Zanele K.', 'initials': 'ZK', 'text': 'I can help with this! DM me for details.', 'time': '5m ago'},
    {'name': 'Bongani S.', 'initials': 'BS', 'text': 'Available this weekend — sending you a message now.', 'time': '12m ago'},
  ];

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Service Request',
            style: TextStyle(
                color: _C.dark,
                fontWeight: FontWeight.w800,
                fontSize: 16)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Original post
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _C.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              p.authorColor.withOpacity(0.15),
                          child: Text(p.authorInitials,
                              style: TextStyle(
                                  color: p.authorColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11)),
                        ),
                        const SizedBox(width: 8),
                        Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(p.authorName,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _C.dark)),
                              Text(p.timeAgo,
                                  style: const TextStyle(
                                      fontSize: 11, color: _C.grey)),
                            ]),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: p.categoryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(p.category,
                              style: TextStyle(
                                  fontSize: 10,
                                  color: p.categoryColor,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Text(p.title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _C.dark)),
                      const SizedBox(height: 8),
                      Text(p.body,
                          style: const TextStyle(
                              fontSize: 13, color: _C.grey, height: 1.5)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.payments_outlined,
                              color: _C.green, size: 14),
                          const SizedBox(width: 4),
                          Text(p.budget,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: _C.green,
                                  fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                const Text('Replies',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                const SizedBox(height: 10),

                ..._replies.map((r) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _C.border),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor:
                                  _C.primary.withOpacity(0.12),
                              child: Text(r['initials']!,
                                  style: const TextStyle(
                                      color: _C.primary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 10)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(r['name']!,
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: _C.dark)),
                                      const Spacer(),
                                      Text(r['time']!,
                                          style: const TextStyle(
                                              fontSize: 11, color: _C.grey)),
                                    ]),
                                    const SizedBox(height: 4),
                                    Text(r['text']!,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: _C.grey,
                                            height: 1.4)),
                                  ]),
                            ),
                          ]),
                    )),
              ],
            ),
          ),

          // Reply input
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _C.border))),
            child: Row(children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _C.border)),
                  child: TextField(
                    controller: _replyCtrl,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      hintText: 'Write a reply or offer…',
                      hintStyle: TextStyle(
                          color: Color(0xFFAAAAAA), fontSize: 13),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  if (_replyCtrl.text.trim().isEmpty) return;
                  setState(() => _replyCtrl.clear());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reply sent!'),
                      backgroundColor: _C.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  width: 40, height: 40,
                  decoration: const BoxDecoration(
                      color: _C.primary, shape: BoxShape.circle),
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

// ─────────────────────────────────────────────────────────────
// POST SERVICE SHEET
// ─────────────────────────────────────────────────────────────
class _PostServiceSheet extends StatefulWidget {
  final void Function(_ServicePost post) onSubmit;
  const _PostServiceSheet({required this.onSubmit});

  @override
  State<_PostServiceSheet> createState() => _PostServiceSheetState();
}

class _PostServiceSheetState extends State<_PostServiceSheet> {
  final _titleCtrl  = TextEditingController();
  final _bodyCtrl   = TextEditingController();
  final _budgetCtrl = TextEditingController();
  String _category = 'Tutoring';

  static const _categories = [
    'Tutoring', 'Design', 'Coding', 'Writing',
    'Photography', 'Marketing', 'Admin', 'Other',
  ];

  static const _catColors = {
    'Tutoring':     Color(0xFF8B5CF6),
    'Design':       Color(0xFFEC4899),
    'Coding':       Color(0xFF3B82F6),
    'Writing':      Color(0xFF059669),
    'Photography':  Color(0xFF06B6D4),
    'Marketing':    Color(0xFFF59E0B),
    'Admin':        Color(0xFF6B7280),
    'Other':        Color(0xFF9CA3AF),
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Post a Service Request',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _C.dark)),
            const SizedBox(height: 4),
            const Text('Other students will see this and offer to help.',
                style: TextStyle(fontSize: 13, color: _C.grey)),
            const SizedBox(height: 18),

            // Category chips
            const Text('Category',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _C.grey)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _categories.map((c) {
                final sel = _category == c;
                final col = _catColors[c] ?? _C.grey;
                return GestureDetector(
                  onTap: () => setState(() => _category = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? col.withOpacity(0.12) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: sel ? col : const Color(0xFFEEEEEE),
                          width: sel ? 1.5 : 1),
                    ),
                    child: Text(c,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: sel
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: sel ? col : _C.grey)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            const Text('Title',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _C.grey)),
            const SizedBox(height: 6),
            _Field(
                controller: _titleCtrl,
                hint: 'e.g. Need a Maths tutor for exam prep'),

            const SizedBox(height: 12),
            const Text('Description',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _C.grey)),
            const SizedBox(height: 6),
            _Field(
              controller: _bodyCtrl,
              hint: 'Describe what you need in detail…',
              maxLines: 3,
            ),

            const SizedBox(height: 12),
            const Text('Budget (optional)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _C.grey)),
            const SizedBox(height: 6),
            _Field(
              controller: _budgetCtrl,
              hint: 'e.g. R80–120/hr',
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (_titleCtrl.text.trim().isEmpty) return;
                  widget.onSubmit(_ServicePost(
                    id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                    authorName: 'You',
                    authorInitials: 'ME',
                    authorColor: _C.primary,
                    category: _category,
                    categoryColor: _catColors[_category] ?? _C.grey,
                    title: _titleCtrl.text.trim(),
                    body: _bodyCtrl.text.trim(),
                    budget: _budgetCtrl.text.trim().isEmpty
                        ? 'Negotiable'
                        : _budgetCtrl.text.trim(),
                    timeAgo: 'Just now',
                    replies: 0,
                  ));
                },
                child: const Text('Post Request',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const _Field({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style:
          const TextStyle(fontSize: 14, color: _C.dark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFFAFAFA),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _C.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: _C.primary, width: 1.5),
        ),
      ),
    );
  }
}