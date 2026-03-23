import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/theme/app_theme.dart';

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
class _Listing {
  final String id;
  final String name;
  final String university;
  final String title;
  final String category;
  final String price;
  final double rating;
  final int jobs;
  final String description;
  final List<String> tags;
  final bool isFeatured;
  final String emoji;

  const _Listing({
    required this.id,
    required this.name,
    required this.university,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.jobs,
    required this.description,
    required this.tags,
    this.isFeatured = false,
    required this.emoji,
  });
}

const _categories = [
  {'label': 'All', 'icon': Icons.apps_rounded},
  {'label': 'Tutoring', 'icon': Icons.school_outlined},
  {'label': 'Design', 'icon': Icons.brush_outlined},
  {'label': 'Coding', 'icon': Icons.code_rounded},
  {'label': 'Photography', 'icon': Icons.camera_alt_outlined},
  {'label': 'Writing', 'icon': Icons.edit_outlined},
  {'label': 'Campus', 'icon': Icons.location_on_outlined},
  {'label': 'Items', 'icon': Icons.sell_outlined},
];

const _listings = [
  _Listing(
    id: '1',
    name: 'Aisha Mokoena',
    university: 'UCT',
    title: 'Mathematics & Stats Tutor',
    category: 'Tutoring',
    price: 'R150/hr',
    rating: 4.9,
    jobs: 34,
    description: 'BSc Mathematics student offering tutoring in Calculus, Statistics and Linear Algebra. Results guaranteed or next session free.',
    tags: ['Calculus', 'Statistics', 'Linear Algebra'],
    isFeatured: true,
    emoji: '📐',
  ),
  _Listing(
    id: '2',
    name: 'Sipho Dlamini',
    university: 'Wits',
    title: 'Logo & Brand Design',
    category: 'Design',
    price: 'R350/logo',
    rating: 4.8,
    jobs: 22,
    description: '3rd year Graphic Design student. Specialising in brand identity, logos, social media graphics and pitch deck design.',
    tags: ['Branding', 'Figma', 'Illustrator'],
    isFeatured: true,
    emoji: '🎨',
  ),
  _Listing(
    id: '3',
    name: 'Lebo Nkosi',
    university: 'TUT',
    title: 'Flutter & React Developer',
    category: 'Coding',
    price: 'R200/hr',
    rating: 5.0,
    jobs: 15,
    description: 'Final year IT student. I build mobile apps, websites and fix bugs fast. Available weekends and evenings.',
    tags: ['Flutter', 'React', 'Firebase'],
    emoji: '💻',
  ),
  _Listing(
    id: '4',
    name: 'Zandile Khumalo',
    university: 'DUT',
    title: 'Event Photography',
    category: 'Photography',
    price: 'R800/event',
    rating: 4.7,
    jobs: 41,
    description: 'Professional event photographer covering graduations, birthdays, campus events and portraits. Edited photos delivered in 48hrs.',
    tags: ['Events', 'Portraits', 'Editing'],
    emoji: '📸',
  ),
  _Listing(
    id: '5',
    name: 'Thando Sithole',
    university: 'NMU',
    title: 'Essay & Report Editing',
    category: 'Writing',
    price: 'R80/page',
    rating: 4.6,
    jobs: 58,
    description: 'English Literature student offering proofreading, editing and referencing help. Plagiarism-free and SASA compliant.',
    tags: ['Editing', 'Referencing', 'Proofreading'],
    emoji: '✍️',
  ),
  _Listing(
    id: '6',
    name: 'Mpho Radebe',
    university: 'UJ',
    title: 'Campus Grocery Delivery',
    category: 'Campus',
    price: 'R30/delivery',
    rating: 4.9,
    jobs: 87,
    description: 'Fast grocery and campus store delivery within UJ campuses. Order via chat. 30-min turnaround guaranteed.',
    tags: ['Delivery', 'Groceries', 'Fast'],
    emoji: '🛵',
  ),
  _Listing(
    id: '7',
    name: 'Keabetswe Mabe',
    university: 'UP',
    title: 'Second-hand Textbooks',
    category: 'Items',
    price: 'R80–R350',
    rating: 4.5,
    jobs: 29,
    description: 'Selling 2nd year Engineering textbooks in great condition. Thermodynamics, Statics, Circuits and more. Meet on campus.',
    tags: ['Textbooks', 'Engineering', 'Affordable'],
    emoji: '📚',
  ),
  _Listing(
    id: '8',
    name: 'Nadia Adams',
    university: 'CPUT',
    title: 'Accounting & Finance Tutor',
    category: 'Tutoring',
    price: 'R120/hr',
    rating: 4.8,
    jobs: 19,
    description: 'BCom Accounting student. Tutoring Financial Accounting, Management Accounting and Tax. Group sessions available at a discount.',
    tags: ['Accounting', 'Tax', 'Finance'],
    emoji: '📊',
  ),
];

// ─────────────────────────────────────────────
// MAIN MARKETPLACE PAGE
// ─────────────────────────────────────────────
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _chatOpen = false;
  final _searchController = TextEditingController();

  List<_Listing> get _filtered {
    return _listings.where((l) {
      final matchCat = _selectedCategory == 'All' || l.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          l.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          l.tags.any((t) => t.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                expandedHeight: 0,
                title: const Text('Marketplace',
                  style: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800, fontSize: 20)),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                    tooltip: 'Create listing',
                    onPressed: () => context.push('/marketplace/create'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.work_outline, color: Color(0xFF1A1A1A)),
                    tooltip: 'My jobs',
                    onPressed: () => context.push('/marketplace/jobs'),
                  ),
                ],
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search students, skills, services...',
                            hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Color(0xFFAAAAAA), size: 20),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Color(0xFFAAAAAA)),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    })
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),

                    // Category chips
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final cat = _categories[i];
                          final selected = _selectedCategory == cat['label'];
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat['label'] as String),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                              ),
                              child: Row(
                                children: [
                                  Icon(cat['icon'] as IconData,
                                    size: 14,
                                    color: selected ? Colors.white : const Color(0xFF777777)),
                                  const SizedBox(width: 5),
                                  Text(cat['label'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selected ? Colors.white : const Color(0xFF555555),
                                    )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Featured banner
                    if (_selectedCategory == 'All' && _searchQuery.isEmpty) ...[
                      const SizedBox(height: 18),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE30613), Color(0xFF8B0000)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('🔥 Top Rated This Week',
                                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                                    SizedBox(height: 4),
                                    Text('Hire verified students\nnear your campus',
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, height: 1.3)),
                                    SizedBox(height: 8),
                                    Text('34 new listings today',
                                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const Text('🎓', style: TextStyle(fontSize: 52)),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Results count
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _searchQuery.isNotEmpty
                                ? '${_filtered.length} results for "$_searchQuery"'
                                : _selectedCategory == 'All'
                                    ? 'All Listings (${_filtered.length})'
                                    : '$_selectedCategory (${_filtered.length})',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A)),
                          ),
                          const Icon(Icons.tune_rounded, size: 20, color: Color(0xFF777777)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Listings grid
              _filtered.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('🔍', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 12),
                            Text('No listings found for "$_searchQuery"',
                              style: const TextStyle(color: Color(0xFF999999), fontSize: 15)),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _ListingCard(
                            listing: _filtered[index],
                            onTap: () => context.push('/marketplace/listing', extra: {
                              'name': _filtered[index].name,
                              'title': _filtered[index].title,
                              'university': _filtered[index].university,
                              'price': _filtered[index].price,
                              'rating': _filtered[index].rating.toString(),
                              'jobs': _filtered[index].jobs.toString(),
                            }),
                          ),
                          childCount: _filtered.length,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.72,
                        ),
                      ),
                    ),
            ],
          ),

          // Chatbot FAB
          Positioned(
            right: 16,
            bottom: 90,
            child: GestureDetector(
              onTap: () => setState(() => _chatOpen = true),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE30613), Color(0xFFB0000E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: const Color(0xFFE30613).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 26),
              ),
            ),
          ),

          // Chatbot panel
          if (_chatOpen)
            _ChatbotPanel(onClose: () => setState(() => _chatOpen = false)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LISTING CARD
// ─────────────────────────────────────────────
class _ListingCard extends StatelessWidget {
  final _Listing listing;
  final VoidCallback onTap;
  const _ListingCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(child: Text(listing.emoji, style: const TextStyle(fontSize: 40))),
                  if (listing.isFeatured)
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('⭐ Top', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  Positioned(
                    top: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(listing.university,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A1A), height: 1.2),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(listing.name,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 12, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 3),
                      Text(listing.rating.toString(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1A1A1A))),
                      const SizedBox(width: 4),
                      Text('(${listing.jobs})',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(listing.price,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary)),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                      ),
                    ],
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
// CHATBOT PANEL
// ─────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isBot;
  const _ChatMessage({required this.text, required this.isBot});
}

class _ChatbotPanel extends StatefulWidget {
  final VoidCallback onClose;
  const _ChatbotPanel({required this.onClose});

  @override
  State<_ChatbotPanel> createState() => _ChatbotPanelState();
}

class _ChatbotPanelState extends State<_ChatbotPanel> with SingleTickerProviderStateMixin {
  final _msgController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _anim;
  late Animation<Offset> _slide;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: "👋 Hi! I'm Gude AI.\n\nI can help you:\n• Find discounts near your campus\n• Recommend services from students\n• Give you financial advice\n\nWhat do you need today?",
      isBot: true,
    ),
  ];

  bool _typing = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, isBot: false));
      _typing = true;
    });
    _msgController.clear();
    _scrollToBottom();

    // Simulate bot response
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _typing = false;
        _messages.add(_ChatMessage(text: _getBotReply(text), isBot: true));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getBotReply(String input) {
    final lower = input.toLowerCase();

    if (lower.contains('discount') || lower.contains('deal') || lower.contains('cheap') || lower.contains('save')) {
      return "🛒 Here are some deals near your campus this week:\n\n"
          "• Checkers: 30% off rice & pasta (Rondebosch)\n"
          "• PnP: Student card — 15% off fruit & veg\n"
          "• Hungry Lion: R49 student meal with ID\n"
          "• Clicks: Toiletries bundle R89 (save R40)\n\n"
          "💡 Tip: Show your student card at Checkers for an extra 5% off!";
    }
    if (lower.contains('budget') || lower.contains('money') || lower.contains('spend') || lower.contains('nsfas')) {
      return "💰 Financial Advice for Students:\n\n"
          "1. The 50/30/20 rule works well:\n"
          "   • 50% needs (food, transport)\n"
          "   • 30% wants\n"
          "   • 20% savings\n\n"
          "2. Set a weekly cash limit — withdraw once\n"
          "3. Use the Gude Budget Planner to track spending\n"
          "4. NSFAS allowances should be split on day 1\n\n"
          "Want me to help you set a budget?";
    }
    if (lower.contains('food') || lower.contains('hungry') || lower.contains('eat')) {
      return "🍽️ Affordable food options near campus:\n\n"
          "• Woolies Food: Daily 50% off at 18:00 (ready meals)\n"
          "• Campus canteen: Meal of the day ~R30-R45\n"
          "• Spar student night special: Thursdays R25 wrap\n"
          "• Look for student meal listings on the Marketplace\n\n"
          "💡 Buying in bulk with classmates saves 20-30%!";
    }
    if (lower.contains('tutor') || lower.contains('help') || lower.contains('study')) {
      return "📚 I found 8 tutors available this week:\n\n"
          "• Aisha M. — Maths & Stats (UCT) R150/hr ⭐4.9\n"
          "• Nadia A. — Accounting (CPUT) R120/hr ⭐4.8\n"
          "• Group sessions from R60/person\n\n"
          "Tip: Book 3+ sessions and most tutors offer a 15% discount. Want me to connect you?";
    }
    if (lower.contains('earn') || lower.contains('income') || lower.contains('job') || lower.contains('gig')) {
      return "💼 Ways to earn on Gude right now:\n\n"
          "• Create a skill listing (takes 2 mins)\n"
          "• Emergency gigs paying R50–R200 today\n"
          "• Delivery runs on campus: R30–R80/trip\n"
          "• Tutoring: avg R120–R200/hr\n\n"
          "Most students earn R500–R2000 extra per month. Want help creating your first listing?";
    }
    return "I can help with:\n\n"
        "💰 Type 'budget tips' for financial advice\n"
        "🛒 Type 'deals near me' for local discounts\n"
        "🍽️ Type 'food' for affordable eating options\n"
        "📚 Type 'tutor' to find study help\n"
        "💼 Type 'earn money' for income ideas\n\n"
        "What would you like help with?";
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.72,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle + header
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFE30613), Color(0xFFB0000E)]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Gude AI', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1A1A1A))),
                          Text('Financial & campus assistant', style: TextStyle(fontSize: 11, color: Color(0xFF999999))),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF777777)),
                        onPressed: widget.onClose,
                      ),
                    ],
                  ),
                ),

                // Messages
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_typing ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (_typing && i == _messages.length) {
                        return _TypingIndicator();
                      }
                      final msg = _messages[i];
                      return _MessageBubble(message: msg);
                    },
                  ),
                ),

                // Quick chips
                if (_messages.length <= 2)
                  SizedBox(
                    height: 38,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      children: [
                        'deals near me', 'budget tips', 'earn money', 'cheap food',
                      ].map((q) => GestureDetector(
                        onTap: () => _sendMessage(q),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(q, style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                        ),
                      )).toList(),
                    ),
                  ),

                // Input
                Container(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _msgController,
                            onSubmitted: _sendMessage,
                            textInputAction: TextInputAction.send,
                            decoration: const InputDecoration(
                              hintText: 'Ask anything...',
                              hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _sendMessage(_msgController.text),
                        child: Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: message.isBot ? const Color(0xFFF5F5F5) : AppColors.primary,
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

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) => Container(
            margin: EdgeInsets.only(left: i > 0 ? 4 : 0),
            width: 7, height: 7,
            decoration: const BoxDecoration(color: Color(0xFFBBBBBB), shape: BoxShape.circle),
          )),
        ),
      ),
    );
  }
}