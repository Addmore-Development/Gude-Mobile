// lib/features/marketplace/presentation/marketplace_page.dart
//
// KEY CHANGES FROM PREVIOUS VERSION:
//  1. "Post" button REMOVED from the sort/action row
//  2. Notification bell → navigates to /notifications (full page, not pop-up)
//  3. Wishlist heart → navigates to /wishlist (full page, not pop-up)
//  4. "Skills & Services" tab added so buyers can find students by skill
//  5. Pixel / overflow fixes on grid cards
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/state/financial_health.dart';

// ─── Colors ─────────────────────────────────────────────────────────
class _C {
  static const primary   = Color(0xFFE30613);
  static const dark      = Color(0xFF1A1A1A);
  static const grey      = Color(0xFF888888);
  static const lightGrey = Color(0xFFF5F5F5);
  static const border    = Color(0xFFEEEEEE);
  static const green     = Color(0xFF10B981);
  static const amber     = Color(0xFFF59E0B);
}

// ─── Models ─────────────────────────────────────────────────────────
class _Product {
  final String id, name, price, oldPrice, image, category,
      seller, sellerId, university, description;
  final double rating;
  final bool isNew, isSale;
  const _Product({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice = '',
    required this.image,
    required this.category,
    required this.rating,
    this.isNew = false,
    this.isSale = false,
    this.seller = 'Student',
    this.sellerId = '',
    this.university = '',
    this.description = '',
  });
}

class _StudentService {
  final String id, studentName, initials, skill, bio,
      university, price, avatarEmoji;
  final double rating;
  final int jobsDone;
  final Color avatarColor;
  const _StudentService({
    required this.id,
    required this.studentName,
    required this.initials,
    required this.skill,
    required this.bio,
    required this.university,
    required this.price,
    required this.avatarEmoji,
    required this.rating,
    required this.jobsDone,
    required this.avatarColor,
  });
}

class _CartItem {
  final _Product product;
  int qty;
  _CartItem({required this.product, this.qty = 1});
}

// ─── Global singletons ──────────────────────────────────────────────
class _Cart {
  static final _Cart _i = _Cart._();
  factory _Cart() => _i;
  _Cart._();
  final List<_CartItem> items = [];
  void add(_Product p) {
    final ex = items.where((i) => i.product.id == p.id).firstOrNull;
    if (ex != null) { ex.qty++; } else { items.add(_CartItem(product: p)); }
  }
  void remove(String id) => items.removeWhere((i) => i.product.id == id);
  void updateQty(String id, int qty) {
    final item = items.where((i) => i.product.id == id).firstOrNull;
    if (item == null) return;
    if (qty <= 0) { remove(id); } else { item.qty = qty; }
  }
  void clear() => items.clear();
  double get subtotal => items.fold(0, (s, i) {
    final p = double.tryParse(i.product.price.replaceAll('R', '').replaceAll(',', '').trim()) ?? 0;
    return s + p * i.qty;
  });
  int get count => items.fold(0, (s, i) => s + i.qty);
}

class _Wishlist {
  static final _Wishlist _i = _Wishlist._();
  factory _Wishlist() => _i;
  _Wishlist._();
  final Set<String> _ids = {};
  bool has(String id) => _ids.contains(id);
  void toggle(String id) => _ids.contains(id) ? _ids.remove(id) : _ids.add(id);
  int get count => _ids.length;
}

// ─── Seed data ──────────────────────────────────────────────────────
const _products = [
  _Product(id:'p1', name:'HP Laptop 15.6"',      price:'R5200',  oldPrice:'R6500',  image:'💻', category:'Electronics', rating:4.5, isSale:true,  seller:'Precious M.',  sellerId:'u2', university:'UCT',  description:'Intel Core i5, 8GB RAM, 512GB SSD.'),
  _Product(id:'p2', name:'iPhone 12 Pro Max',     price:'R12500', oldPrice:'R15000', image:'📱', category:'Electronics', rating:4.8, isNew:true,   seller:'Sipho M.',     sellerId:'u3', university:'Wits', description:'128GB, Midnight Black. Excellent condition.'),
  _Product(id:'p3', name:'SkullCandy Headphones', price:'R1200',  oldPrice:'R1800',  image:'🎧', category:'Electronics', rating:4.6, isNew:true,   seller:'Aisha K.',     sellerId:'u4', university:'UP',   description:'Over-ear wireless, 40hr battery.'),
  _Product(id:'p4', name:'Study Mini Table',      price:'R780',   oldPrice:'R1100',  image:'🪑', category:'Furniture',   rating:4.1,               seller:'Zanele D.',    sellerId:'u5', university:'UJ',   description:'Portable laptop table with adjustable height.'),
  _Product(id:'p5', name:'Macbook 16',            price:'R18900', oldPrice:'R22000', image:'💻', category:'Electronics', rating:4.9, isSale:true,  seller:'Keanu N.',     sellerId:'u6', university:'CPUT', description:'M1 Pro chip, 16GB RAM, 512GB SSD.'),
  _Product(id:'p6', name:'Casio Calculator',      price:'R245',   oldPrice:'R350',   image:'🧮', category:'Stationery',  rating:4.9, isSale:true,  seller:'Ruan P.',      sellerId:'u7', university:'SU',   description:'FX-991ZA PLUS — perfect for science.'),
  _Product(id:'p7', name:'Air Fryer 4.5L',        price:'R2100',  oldPrice:'R2800',  image:'🍳', category:'Appliances',  rating:4.2, isSale:true,  seller:'Fatima H.',    sellerId:'u8', university:'UKZN', description:'Digital, barely used.'),
  _Product(id:'p8', name:'Monitor 24" FHD',       price:'R3800',  oldPrice:'R4500',  image:'🖥️', category:'Electronics', rating:4.4,               seller:'Ntando B.',    sellerId:'u9', university:'UWC',  description:'Full HD IPS, 75Hz, HDMI & VGA.'),
];

const _services = [
  _StudentService(id:'s1', studentName:'Priya S.',   initials:'PS', skill:'CV Writing',    bio:'I help students craft professional CVs and cover letters.',           university:'UCT',  price:'R180', avatarEmoji:'📄', rating:4.9, jobsDone:24, avatarColor:Color(0xFF8B5CF6)),
  _StudentService(id:'s2', studentName:'Yusuf A.',   initials:'YA', skill:'Graphic Design', bio:'Brand identities, social media graphics and print design.',           university:'Wits', price:'R200', avatarEmoji:'🎨', rating:4.8, jobsDone:18, avatarColor:Color(0xFFEC4899)),
  _StudentService(id:'s3', studentName:'Nandi M.',   initials:'NM', skill:'Photography',    bio:'Event, product and portrait photography — any occasion.',             university:'UP',   price:'R350', avatarEmoji:'📷', rating:4.7, jobsDone:32, avatarColor:Color(0xFF3B82F6)),
  _StudentService(id:'s4', studentName:'Keanu N.',   initials:'KN', skill:'Coding / Python',bio:'Tutoring, debugging, and project help for Python and web dev.',     university:'CPUT', price:'R150', avatarEmoji:'💻', rating:4.9, jobsDone:41, avatarColor:Color(0xFF10B981)),
  _StudentService(id:'s5', studentName:'Thabo G.',   initials:'TG', skill:'Video Editing',  bio:'Reels, YouTube edits, promos — fast turnaround.',                    university:'UJ',   price:'R250', avatarEmoji:'🎬', rating:4.6, jobsDone:15, avatarColor:Color(0xFFF59E0B)),
  _StudentService(id:'s6', studentName:'Lindiwe M.', initials:'LM', skill:'Tutoring',       bio:'Maths, Science and Accounting up to first-year university level.',    university:'UKZN', price:'R120', avatarEmoji:'📚', rating:4.8, jobsDone:56, avatarColor:Color(0xFF0EA5E9)),
];

const _skillFilters = ['All','Tutoring','Design','Coding','Photography','Writing','Video Editing','Marketing','Accounting'];

const _productCategories = ['All','Electronics','Furniture','Stationery','Appliances','Books','Clothes','Bags'];

const _banners = [
  {'title':'40% Off\nBlack Friday',    'sub':'From R6,000 – R9,294.99',   'emoji':'📺', 'c1':Color(0xFF1A1A1A), 'c2':Color(0xFF333333)},
  {'title':'Student Deals\nThis Week', 'sub':'Exclusive campus discounts', 'emoji':'🎒', 'c1':Color(0xFF0D47A1), 'c2':Color(0xFF1565C0)},
  {'title':'Flash Sale\n50% Off',      'sub':'Limited time — grab it fast','emoji':'⚡', 'c1':Color(0xFF880E4F), 'c2':Color(0xFFC62828)},
];

// ─── Main page ───────────────────────────────────────────────────────
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});
  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Products tab state
  String _selectedCategory = 'All';
  String _searchQuery      = '';
  String _sortBy           = 'Most popular';
  int    _bannerIndex      = 0;
  final _searchCtrl = TextEditingController();
  final _pageCtrl   = PageController();
  final _cart    = _Cart();
  final _wishlist = _Wishlist();

  // Services tab state
  String _selectedSkill = 'All';

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  List<_Product> get _filteredProducts => _products.where((p) {
    final catMatch = _selectedCategory == 'All' || p.category == _selectedCategory;
    final qMatch   = _searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  List<_StudentService> get _filteredServices => _services.where((s) {
    return _selectedSkill == 'All' || s.skill == _selectedSkill ||
        s.skill.toLowerCase().contains(_selectedSkill.toLowerCase());
  }).toList();

  // ── Navigation helpers (full-page instead of pop-up) ──────────────
  void _goNotifications() => context.push('/notifications');
  void _goWishlist()      => context.push('/wishlist');
  void _goCart() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _CartPage(cart: _cart, onUpdate: () => setState(() {})),
    )).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ─────────────────────────────────────────────────
          _TopBar(
            searchCtrl: _searchCtrl,
            onSearchChanged: (v) => setState(() => _searchQuery = v),
            onSearchTap: () => _showSearchSheet(),
            notifCount: 2,               // replace with real count
            wishlistCount: _wishlist.count,
            cartCount: _cart.count,
            onNotifTap: _goNotifications,   // ← full page
            onWishlistTap: _goWishlist,     // ← full page
            onCartTap: _goCart,
          ),

          // ── Tab bar — Products | Skills & Services ──────────────────
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabCtrl,
              labelColor: _C.primary,
              unselectedLabelColor: _C.grey,
              indicatorColor: _C.primary,
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              tabs: const [Tab(text: 'Products'), Tab(text: 'Skills & Services')],
            ),
          ),

          // ── Tab bodies ───────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                // ── Tab 0: Products ──────────────────────────────────
                _ProductsTab(
                  searchQuery: _searchQuery,
                  selectedCategory: _selectedCategory,
                  sortBy: _sortBy,
                  bannerIndex: _bannerIndex,
                  pageCtrl: _pageCtrl,
                  filteredProducts: _filteredProducts,
                  wishlist: _wishlist,
                  cart: _cart,
                  onCategoryChanged: (c) => setState(() => _selectedCategory = c),
                  onSortChanged: (v) => setState(() => _sortBy = v ?? _sortBy),
                  onBannerPageChanged: (i) => setState(() => _bannerIndex = i),
                  onFavourite: (id) => setState(() => _wishlist.toggle(id)),
                  onAddToCart: (p) {
                    _cart.add(p);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${p.name} added to cart'),
                      backgroundColor: _C.green,
                      duration: const Duration(seconds: 1),
                    ));
                  },
                  onProductTap: (p) => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => _ProductDetailPage(product: p, cart: _cart, wishlist: _wishlist, onCartChanged: () => setState(() {})),
                  )).then((_) => setState(() {})),
                ),

                // ── Tab 1: Skills & Services ─────────────────────────
                _ServicesTab(
                  selectedSkill: _selectedSkill,
                  filteredServices: _filteredServices,
                  onSkillChanged: (s) => setState(() => _selectedSkill = s),
                  onMessageSeller: (service) => context.push('/messages'),
                  onHire: (service) => context.push('/marketplace/hire',
                      extra: {'name': service.studentName, 'title': service.skill, 'university': service.university, 'price': service.price, 'rating': '${service.rating}', 'jobs': '${service.jobsDone}'}),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 48,
            decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _searchQuery = v),
              onSubmitted: (_) => Navigator.pop(context),
              decoration: const InputDecoration(hintText: 'Search products or skills…', hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14), prefixIcon: Icon(Icons.search, color: _C.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(height: 16),
          const Align(alignment: Alignment.centerLeft, child: Text('Popular Searches', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _C.dark))),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: ['Laptop', 'iPhone', 'Calculator', 'Tutoring', 'Design', 'Coding'].map((q) =>
            GestureDetector(
              onTap: () { setState(() => _searchQuery = q); Navigator.pop(context); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: _C.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: _C.primary.withOpacity(0.2))),
                child: Text(q, style: const TextStyle(fontSize: 12, color: _C.primary, fontWeight: FontWeight.w600)),
              ),
            )).toList()),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }
}

// ─── Top bar ─────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSearchTap, onNotifTap, onWishlistTap, onCartTap;
  final int notifCount, wishlistCount, cartCount;

  const _TopBar({
    required this.searchCtrl,
    required this.onSearchChanged,
    required this.onSearchTap,
    required this.notifCount,
    required this.wishlistCount,
    required this.cartCount,
    required this.onNotifTap,
    required this.onWishlistTap,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: _C.border))),
      child: Row(children: [
        const Text('Marketplace', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _C.dark)),
        const SizedBox(width: 8),
        // Search bar
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 36,
              decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.border)),
              child: Row(children: [
                Expanded(child: TextField(
                  controller: searchCtrl,
                  onChanged: onSearchChanged,
                  style: const TextStyle(fontSize: 12, color: _C.dark),
                  decoration: const InputDecoration(
                    hintText: 'Search products & services…',
                    hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                  ),
                )),
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: _C.primary, borderRadius: BorderRadius.horizontal(right: Radius.circular(7))),
                  child: const Icon(Icons.search, color: Colors.white, size: 16),
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Notifications → full page (no pop-up)
        _IconBadge(icon: Icons.notifications_none_rounded, badge: notifCount, onTap: onNotifTap),
        const SizedBox(width: 3),
        // Wishlist → full page (no pop-up)
        _IconBadge(icon: Icons.favorite_border_rounded,   badge: wishlistCount, onTap: onWishlistTap),
        const SizedBox(width: 3),
        _IconBadge(icon: Icons.shopping_cart_outlined,    badge: cartCount, onTap: onCartTap),
        // ── POST BUTTON REMOVED ──────────────────────────────────────
        // Students and buyers do not need to post jobs from marketplace.
      ]),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final int badge;
  final VoidCallback onTap;
  const _IconBadge({required this.icon, required this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.border)),
          child: Icon(icon, size: 15, color: _C.grey),
        ),
        if (badge > 0)
          Positioned(top: -4, right: -4, child: Container(
            width: 15, height: 15,
            decoration: const BoxDecoration(color: _C.primary, shape: BoxShape.circle),
            child: Center(child: Text(badge > 9 ? '9+' : '$badge', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800))),
          )),
      ]),
    );
  }
}

// ─── Products tab ────────────────────────────────────────────────────
class _ProductsTab extends StatelessWidget {
  final String searchQuery, selectedCategory, sortBy;
  final int bannerIndex;
  final PageController pageCtrl;
  final List<_Product> filteredProducts;
  final _Wishlist wishlist;
  final _Cart cart;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String?> onSortChanged;
  final ValueChanged<int> onBannerPageChanged;
  final ValueChanged<String> onFavourite;
  final ValueChanged<_Product> onAddToCart, onProductTap;

  const _ProductsTab({
    required this.searchQuery,
    required this.selectedCategory,
    required this.sortBy,
    required this.bannerIndex,
    required this.pageCtrl,
    required this.filteredProducts,
    required this.wishlist,
    required this.cart,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onBannerPageChanged,
    required this.onFavourite,
    required this.onAddToCart,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Banner carousel
        if (searchQuery.isEmpty) ...[
          const SizedBox(height: 12),
          _BannerCarousel(banners: _banners, currentIndex: bannerIndex, pageCtrl: pageCtrl, onPageChanged: onBannerPageChanged),
        ],
        if (searchQuery.isNotEmpty)
          Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: Text('Results for "$searchQuery"', style: const TextStyle(fontSize: 13, color: _C.grey, fontStyle: FontStyle.italic))),

        // Sort row — POST BUTTON REMOVED
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
          child: Row(children: [
            Text('${filteredProducts.length} Products', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
            const Spacer(),
            _SortDropdown(value: sortBy, onChanged: onSortChanged),
            // ── No Post button here ──────────────────────────────────
          ]),
        ),

        // Category chips
        const SizedBox(height: 10),
        SizedBox(height: 34, child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: _productCategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final cat = _productCategories[i];
            final sel = selectedCategory == cat;
            return GestureDetector(
              onTap: () => onCategoryChanged(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(color: sel ? _C.primary : _C.lightGrey, borderRadius: BorderRadius.circular(6)),
                child: Text(cat, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : _C.grey)),
              ),
            );
          },
        )),

        // Product grid — fixed pixel distribution
        const SizedBox(height: 14),
        filteredProducts.isEmpty
            ? const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('No products found', style: TextStyle(color: _C.grey, fontSize: 14))))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // PIXEL FIX: symmetric padding so both columns have equal margins
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  // PIXEL FIX: childAspectRatio tuned so price/button never clips
                  childAspectRatio: 0.65,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (_, i) => _ProductCard(
                  product: filteredProducts[i],
                  isFav: wishlist.has(filteredProducts[i].id),
                  onFav: () => onFavourite(filteredProducts[i].id),
                  onAddToCart: () => onAddToCart(filteredProducts[i]),
                  onTap: () => onProductTap(filteredProducts[i]),
                ),
              ),
        const SizedBox(height: 40),
      ]),
    );
  }
}

// ─── Skills & Services tab ────────────────────────────────────────────
// Buyers can filter students by skill. Students see peers offering services.
class _ServicesTab extends StatelessWidget {
  final String selectedSkill;
  final List<_StudentService> filteredServices;
  final ValueChanged<String> onSkillChanged;
  final ValueChanged<_StudentService> onMessageSeller, onHire;

  const _ServicesTab({
    required this.selectedSkill,
    required this.filteredServices,
    required this.onSkillChanged,
    required this.onMessageSeller,
    required this.onHire,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Info banner for buyers
      Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.25)),
        ),
        child: Row(children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 16),
          const SizedBox(width: 8),
          const Expanded(child: Text('Browse student profiles by skill. Tap a card to hire or message directly.', style: TextStyle(fontSize: 12, color: Color(0xFF1E3A5F), height: 1.4))),
        ]),
      ),

      // Skill filter chips
      const SizedBox(height: 12),
      SizedBox(height: 34, child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _skillFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final skill = _skillFilters[i];
          final sel = selectedSkill == skill;
          return GestureDetector(
            onTap: () => onSkillChanged(skill),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: sel ? _C.primary : _C.lightGrey, borderRadius: BorderRadius.circular(6)),
              child: Text(skill, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : _C.grey)),
            ),
          );
        },
      )),

      const SizedBox(height: 12),

      // Service cards list
      Expanded(
        child: filteredServices.isEmpty
            ? const Center(child: Text('No services match this skill', style: TextStyle(color: _C.grey, fontSize: 14)))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                itemCount: filteredServices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _ServiceCard(
                  service: filteredServices[i],
                  onMessage: () => onMessageSeller(filteredServices[i]),
                  onHire: () => onHire(filteredServices[i]),
                ),
              ),
      ),
    ]);
  }
}

class _ServiceCard extends StatelessWidget {
  final _StudentService service;
  final VoidCallback onMessage, onHire;
  const _ServiceCard({required this.service, required this.onMessage, required this.onHire});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          // Avatar
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: service.avatarColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text(service.avatarEmoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(service.studentName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
            const SizedBox(height: 2),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: service.avatarColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(service.skill, style: TextStyle(fontSize: 11, color: service.avatarColor, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              Text(service.university, style: const TextStyle(fontSize: 11, color: _C.grey)),
            ]),
          ])),
          // Price
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(service.price, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _C.primary)),
            const Text('per session', style: TextStyle(fontSize: 10, color: _C.grey)),
          ]),
        ]),
        const SizedBox(height: 10),
        Text(service.bio, style: const TextStyle(fontSize: 12, color: Color(0xFF555555), height: 1.5), maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 10),
        Row(children: [
          // Stars
          Row(children: List.generate(5, (i) => Icon(i < service.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded, size: 14, color: _C.amber))),
          const SizedBox(width: 4),
          Text('${service.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.dark)),
          const SizedBox(width: 8),
          Text('${service.jobsDone} jobs done', style: const TextStyle(fontSize: 11, color: _C.grey)),
          const Spacer(),
          // Message button
          GestureDetector(
            onTap: onMessage,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.border)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.chat_bubble_outline_rounded, size: 13, color: _C.grey),
                SizedBox(width: 4),
                Text('Message', style: TextStyle(fontSize: 12, color: _C.grey, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          // Hire button
          GestureDetector(
            onTap: onHire,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(8)),
              child: const Text('Hire', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
        ]),
      ]),
    );
  }
}

// ─── Product card ─────────────────────────────────────────────────────
class _ProductCard extends StatefulWidget {
  final _Product product;
  final bool isFav;
  final VoidCallback onFav, onAddToCart, onTap;
  const _ProductCard({super.key, required this.product, required this.isFav, required this.onFav, required this.onAddToCart, required this.onTap});
  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scale = Tween<double>(begin: 1, end: 1.3).chain(CurveTween(curve: Curves.elasticOut)).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _handleAdd() {
    setState(() => _added = true);
    _ctrl.forward().then((_) => _ctrl.reverse().then((_) { if (mounted) setState(() => _added = false); }));
    widget.onAddToCart();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        // PIXEL FIX: no fixed height — let childAspectRatio control sizing
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.border),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image area
          AspectRatio(
            aspectRatio: 1.1,
            child: Stack(children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
                child: Center(child: Text(widget.product.image, style: const TextStyle(fontSize: 40))),
              ),
              if (widget.product.isNew || widget.product.isSale)
                Positioned(top: 6, left: 6, child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: widget.product.isNew ? _C.green : _C.primary, borderRadius: BorderRadius.circular(4)),
                  child: Text(widget.product.isNew ? 'NEW' : 'SALE', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                )),
              Positioned(top: 6, right: 6, child: GestureDetector(
                onTap: widget.onFav,
                child: Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                  child: Icon(widget.isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 15, color: widget.isFav ? _C.primary : _C.grey),
                ),
              )),
            ]),
          ),

          // Info area
          Expanded(
            child: Padding(
              // PIXEL FIX: consistent padding so text never clips
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                // Product name
                Text(
                  widget.product.name,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _C.dark),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Price row + add button
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (widget.product.oldPrice.isNotEmpty)
                    Text(widget.product.oldPrice, style: const TextStyle(fontSize: 10, color: _C.grey, decoration: TextDecoration.lineThrough)),
                  Row(children: [
                    Flexible(child: Text(widget.product.price, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _C.primary), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 4),
                    // PIXEL FIX: ScaleTransition wraps only the button — not whole row
                    ScaleTransition(
                      scale: _scale,
                      child: GestureDetector(
                        onTap: _handleAdd,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 28, height: 28,
                          decoration: BoxDecoration(color: _added ? _C.green : _C.dark, borderRadius: BorderRadius.circular(8)),
                          child: Icon(_added ? Icons.check_rounded : Icons.add_shopping_cart_rounded, color: Colors.white, size: 14),
                        ),
                      ),
                    ),
                  ]),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Banner carousel ──────────────────────────────────────────────────
class _BannerCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final int currentIndex;
  final PageController pageCtrl;
  final ValueChanged<int> onPageChanged;
  const _BannerCarousel({required this.banners, required this.currentIndex, required this.pageCtrl, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(alignment: Alignment.bottomCenter, children: [
        SizedBox(height: 140, child: PageView.builder(
          controller: pageCtrl,
          onPageChanged: onPageChanged,
          itemCount: banners.length,
          itemBuilder: (_, i) {
            final b = banners[i];
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [b['c1'] as Color, b['c2'] as Color], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                Expanded(child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 0, 18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(b['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
                    const SizedBox(height: 5),
                    Text(b['sub'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ]),
                )),
                Padding(padding: const EdgeInsets.only(right: 14), child: Text(b['emoji'] as String, style: const TextStyle(fontSize: 52))),
              ]),
            );
          },
        )),
        Positioned(bottom: 10, child: Row(children: List.generate(banners.length, (i) =>
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: currentIndex == i ? 16 : 6, height: 6,
            decoration: BoxDecoration(color: currentIndex == i ? Colors.white : Colors.white38, borderRadius: BorderRadius.circular(3)),
          )))),
      ]),
    );
  }
}

// ─── Sort dropdown ────────────────────────────────────────────────────
class _SortDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(child: DropdownButton<String>(
      value: value,
      style: const TextStyle(fontSize: 11, color: _C.dark, fontWeight: FontWeight.w500),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: _C.grey),
      onChanged: onChanged,
      items: const [
        DropdownMenuItem(value: 'Most popular', child: Text('Most popular')),
        DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low')),
        DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High')),
        DropdownMenuItem(value: 'Newest', child: Text('Newest')),
        DropdownMenuItem(value: 'Rating', child: Text('Rating')),
      ],
    ));
  }
}

// ─── Product detail page ──────────────────────────────────────────────
class _ProductDetailPage extends StatefulWidget {
  final _Product product;
  final _Cart cart;
  final _Wishlist wishlist;
  final VoidCallback onCartChanged;
  const _ProductDetailPage({required this.product, required this.cart, required this.wishlist, required this.onCartChanged});
  @override
  State<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<_ProductDetailPage> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18), onPressed: () => Navigator.pop(context)),
        title: const Text('Product Details', style: TextStyle(color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)), centerTitle: true,
      ),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 240, color: _C.lightGrey, child: Center(child: Text(p.image, style: const TextStyle(fontSize: 96)))),
          Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _C.dark)),
            Text(p.category, style: const TextStyle(fontSize: 13, color: _C.grey)),
            const SizedBox(height: 10),
            Row(children: [
              Text(p.price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _C.primary)),
              if (p.oldPrice.isNotEmpty) ...[const SizedBox(width: 8), Text(p.oldPrice, style: const TextStyle(fontSize: 14, color: _C.grey, decoration: TextDecoration.lineThrough))],
            ]),
            const SizedBox(height: 8),
            Row(children: List.generate(5, (i) => Icon(i < p.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded, size: 16, color: _C.amber))),
            const SizedBox(height: 12),
            Text('Sold by: ${p.seller} · ${p.university}', style: const TextStyle(fontSize: 12, color: _C.grey)),
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
            const SizedBox(height: 6),
            Text(p.description, style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5)),
            const SizedBox(height: 80),
          ])),
        ]))),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _C.border))),
          child: Row(children: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: _C.border), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                IconButton(onPressed: () => setState(() { if (_qty > 1) _qty--; }), icon: const Icon(Icons.remove, size: 16)),
                Text('$_qty', style: const TextStyle(fontWeight: FontWeight.w700)),
                IconButton(onPressed: () => setState(() => _qty++), icon: const Icon(Icons.add, size: 16)),
              ]),
            ),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                for (int i = 0; i < _qty; i++) widget.cart.add(widget.product);
                widget.onCartChanged();
                Navigator.pop(context);
              },
              child: Text('Add to Cart ($_qty)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            )),
          ]),
        ),
      ]),
    );
  }
}

// ─── Cart page ────────────────────────────────────────────────────────
class _CartPage extends StatefulWidget {
  final _Cart cart;
  final VoidCallback onUpdate;
  const _CartPage({required this.cart, required this.onUpdate});
  @override
  State<_CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<_CartPage> {
  int _step = 0;
  String _payment = 'Gude Wallet';
  void _refresh() { widget.onUpdate(); setState(() {}); }
  String _fmt(double v) => 'R${v.toStringAsFixed(2)}';

  void _placeOrder() {
    FinancialHealth.recordSpend(widget.cart.subtotal, 'Marketplace Purchase');
    widget.cart.clear();
    widget.onUpdate();
    setState(() => _step = 2);
  }

  @override
  Widget build(BuildContext context) {
    if (_step == 2) return _successScreen(context);
    return Scaffold(
      backgroundColor: _C.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text(_step == 0 ? 'My Cart' : 'Checkout', style: const TextStyle(color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)), centerTitle: true,
      ),
      body: _step == 0 ? _cartBody() : _checkoutBody(),
    );
  }

  Widget _cartBody() {
    if (widget.cart.items.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.shopping_cart_outlined, size: 72, color: _C.border),
        const SizedBox(height: 14),
        const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _C.dark)),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: _C.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Browse Products', style: TextStyle(color: Colors.white))),
      ]));
    }
    return Column(children: [
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: widget.cart.items.length,
        itemBuilder: (_, i) {
          final item = widget.cart.items[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              Container(width: 80, height: 80, decoration: const BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.horizontal(left: Radius.circular(14))), child: Center(child: Text(item.product.image, style: const TextStyle(fontSize: 36)))),
              Expanded(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.product.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700), maxLines: 2, overflow: TextOverflow.ellipsis),
                Text(item.product.price, style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Row(children: [
                  GestureDetector(onTap: () { widget.cart.updateQty(item.product.id, item.qty - 1); _refresh(); }, child: Container(width: 24, height: 24, decoration: BoxDecoration(border: Border.all(color: _C.border), borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.remove, size: 14))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text('${item.qty}', style: const TextStyle(fontWeight: FontWeight.w700))),
                  GestureDetector(onTap: () { widget.cart.updateQty(item.product.id, item.qty + 1); _refresh(); }, child: Container(width: 24, height: 24, decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.add, size: 14, color: Colors.white))),
                ]),
              ]))),
              IconButton(icon: const Icon(Icons.delete_outline, color: Color(0xFFCCCCCC), size: 20), onPressed: () { widget.cart.remove(item.product.id); _refresh(); }),
            ]),
          );
        },
      )),
      Container(padding: const EdgeInsets.all(16), color: Colors.white, child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)), Text(_fmt(widget.cart.subtotal), style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w800, fontSize: 16))]),
        const SizedBox(height: 14),
        SizedBox(width: double.infinity, child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          onPressed: () => setState(() => _step = 1),
          child: Text('Checkout (${widget.cart.count})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        )),
      ])),
    ]);
  }

  Widget _checkoutBody() => Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
      const SizedBox(height: 10),
      ...['Gude Wallet', 'Credit/Debit Card', 'EFT / Instant Pay'].map((m) =>
        GestureDetector(
          onTap: () => setState(() => _payment = m),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _payment == m ? _C.primary.withOpacity(0.05) : Colors.white,
              border: Border.all(color: _payment == m ? _C.primary : _C.border, width: _payment == m ? 2 : 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              Icon(m.contains('Wallet') ? Icons.account_balance_wallet_outlined : m.contains('Card') ? Icons.credit_card_outlined : Icons.swap_horiz_rounded, color: _payment == m ? _C.primary : _C.grey, size: 20),
              const SizedBox(width: 12),
              Text(m, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _payment == m ? _C.primary : _C.dark)),
              const Spacer(),
              Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _payment == m ? _C.primary : _C.border, width: 2)), child: _payment == m ? Container(margin: const EdgeInsets.all(3), decoration: const BoxDecoration(color: _C.primary, shape: BoxShape.circle)) : null),
            ]),
          ),
        )),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal', style: TextStyle(color: _C.grey, fontSize: 13)), Text(_fmt(widget.cart.subtotal), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping', style: TextStyle(color: _C.grey, fontSize: 13)), const Text('R0.00', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
        const Divider(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Text(_fmt(widget.cart.subtotal), style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w800, fontSize: 13))]),
      ])),
    ]))),
    Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _C.primary, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: _placeOrder,
        child: Text('Place Order · ${_fmt(widget.cart.subtotal)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
      ),
    ),
  ]);

  Widget _successScreen(BuildContext ctx) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
      const Spacer(flex: 2),
      Container(width: 120, height: 120, decoration: const BoxDecoration(color: Color(0xFFF0FFF4), shape: BoxShape.circle), child: const Center(child: Text('🎉', style: TextStyle(fontSize: 56)))),
      const SizedBox(height: 24),
      const Text('Order placed!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _C.dark)),
      const Spacer(),
      SizedBox(width: double.infinity, child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () => Navigator.of(ctx).popUntil((r) => r.isFirst),
        child: const Text('Continue Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      )),
    ]))),
  );
}
