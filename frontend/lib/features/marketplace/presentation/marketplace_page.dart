import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  static const amber     = Color(0xFFF59E0B);
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
class _Product {
  final String id, name, price, oldPrice, image, category, seller, sellerId, university;
  final double rating;
  final bool isNew, isSale;
  final String description;
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

class _Service {
  final String id, name, description, price, image, category, provider, providerId, university;
  final double rating;
  final int reviews;
  final bool isFeatured;
  const _Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.provider,
    required this.providerId,
    required this.university,
    required this.rating,
    required this.reviews,
    this.isFeatured = false,
  });
}

class _CartItem {
  final _Product product;
  int qty;
  _CartItem({required this.product, this.qty = 1});
}

class _Notification {
  final String id, text, time;
  bool read;
  _Notification({required this.id, required this.text, required this.time, this.read = false});
}

// ─────────────────────────────────────────────
// GLOBAL CART STATE (singleton)
// ─────────────────────────────────────────────
class MarketCart {
  static final MarketCart _inst = MarketCart._();
  factory MarketCart() => _inst;
  MarketCart._();

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
    final price = double.tryParse(
        i.product.price.replaceAll('R', '').replaceAll(',', '').trim()) ?? 0;
    return s + price * i.qty;
  });

  int get count => items.fold(0, (s, i) => s + i.qty);
}

// ─────────────────────────────────────────────
// SEED DATA
// ─────────────────────────────────────────────
const _products = [
  _Product(id:'p1', name:'HP Laptop 15.6"',     price:'R5,200',   oldPrice:'R6,500',  image:'💻', category:'Electronics', rating:4.5, isSale:true,  seller:'Precious Mhd', sellerId:'u2', university:'UCT', description:'Intel Core i5, 8GB RAM, 512GB SSD, Windows 11. Perfect for students.'),
  _Product(id:'p2', name:'iPhone 12 Pro Max',    price:'R12,500',  oldPrice:'R15,000', image:'📱', category:'Electronics', rating:4.8, isNew:true,   seller:'Sipho M.',     sellerId:'u3', university:'Wits', description:'128GB, Midnight Black. Excellent condition with charger and box.'),
  _Product(id:'p3', name:'SkullCandy Headphone', price:'R1,200',   oldPrice:'R1,800',  image:'🎧', category:'Electronics', rating:4.6, isNew:true,   seller:'Aisha K.',     sellerId:'u4', university:'UP', description:'Over-ear wireless, 40hr battery, foldable.'),
  _Product(id:'p4', name:'Study Mini Table',     price:'R780',     oldPrice:'R1,100',  image:'🪑', category:'Furniture',   rating:4.1,              seller:'Zanele D.',    sellerId:'u5', university:'UJ', description:'Portable laptop table with adjustable height.'),
  _Product(id:'p5', name:'Macbook 16',           price:'R18,900',  oldPrice:'R22,000', image:'💻', category:'Electronics', rating:4.9, isSale:true,  seller:'Keanu N.',     sellerId:'u6', university:'CPUT', description:'M1 Pro chip, 16GB RAM, 512GB SSD. Near-new condition.'),
  _Product(id:'p6', name:'Casio Calculator',     price:'R245',     oldPrice:'R350',    image:'🧮', category:'Stationery',  rating:4.9, isSale:true,  seller:'Ruan P.',      sellerId:'u7', university:'SU', description:'FX-991ZA PLUS. Perfect for university maths and science.'),
  _Product(id:'p7', name:'Russell Hobbs Air Fry',price:'R2,100',   oldPrice:'R2,800',  image:'🍳', category:'Appliances',  rating:4.2, isSale:true,  seller:'Fatima H.',    sellerId:'u8', university:'UKZN', description:'4.5L digital air fryer. Barely used.'),
  _Product(id:'p8', name:'Desktop Monitor 24"',  price:'R3,800',   oldPrice:'R4,500',  image:'🖥️', category:'Electronics', rating:4.4,              seller:'Ntando B.',    sellerId:'u9', university:'UWC', description:'Full HD IPS panel, 75Hz, HDMI & VGA.'),
];

const _services = [
  _Service(id:'s1', name:'Mathematics Tutoring',    description:'Grade 10–12 & university maths, stats, and calculus', price:'R120/hr',     image:'📐', category:'Academic',      provider:'Sipho M.',   providerId:'u3', university:'Wits', rating:4.9, reviews:34, isFeatured:true),
  _Service(id:'s2', name:'Essay Writing Coaching',  description:'Structure, grammar, referencing & academic writing',  price:'R100/hr',     image:'✍️', category:'Academic',      provider:'Aisha K.',   providerId:'u4', university:'UP',   rating:4.7, reviews:22),
  _Service(id:'s3', name:'Graphic Design',          description:'Logos, posters, social media content & branding',    price:'R200/job',    image:'🎨', category:'Creative',      provider:'Yusuf A.',   providerId:'u10',university:'TUT', rating:4.7, reviews:53, isFeatured:true),
  _Service(id:'s4', name:'Coding & Programming',    description:'Python, Java, C++, web dev and data science',        price:'R150/hr',     image:'💻', category:'Academic',      provider:'Keanu N.',   providerId:'u6', university:'CPUT',rating:4.8, reviews:41, isFeatured:true),
  _Service(id:'s5', name:'CV & Cover Letter',       description:'Professional CVs tailored to SA job market',         price:'R180/CV',     image:'📄', category:'Professional',  provider:'Priya S.',   providerId:'u11',university:'NMU', rating:4.8, reviews:62, isFeatured:true),
  _Service(id:'s6', name:'Photography',             description:'Events, portraits, product & campus photography',    price:'R350/session',image:'📷', category:'Creative',      provider:'Nandi M.',   providerId:'u12',university:'DUT', rating:4.9, reviews:37, isFeatured:true),
  _Service(id:'s7', name:'Video Editing',           description:'YouTube, reels, TikTok, corporate & event edits',   price:'R250/video',  image:'🎬', category:'Digital',       provider:'Thabo G.',   providerId:'u13',university:'VUT', rating:4.7, reviews:31),
  _Service(id:'s8', name:'IT & Tech Support',       description:'Laptop repair, software setup & virus removal',     price:'R120/hr',     image:'🔧', category:'Digital',       provider:'Imran R.',   providerId:'u14',university:'CUT', rating:4.7, reviews:29),
  _Service(id:'s9', name:'Home Cleaning',           description:'Student digs and apartment cleaning service',       price:'R150/visit',  image:'🧹', category:'Lifestyle',     provider:'Bongani L.', providerId:'u15',university:'MUT', rating:4.4, reviews:16),
  _Service(id:'s10',name:'Delivery & Errands',      description:'Campus deliveries, grocery runs & courier tasks',   price:'R50/trip',    image:'🛵', category:'Lifestyle',     provider:'Khanya M.',  providerId:'u16',university:'UFS', rating:4.2, reviews:44),
];

const _productCategories = ['All','Electronics','Furniture','Stationery','Appliances','Books','Clothes','Bags'];
const _serviceCategories = ['All','Academic','Creative','Digital','Professional','Lifestyle'];

const _banners = [
  {'title':'40% Off\nBlack Friday',    'sub':'From R6,000 – R9,294.99',   'emoji':'📺', 'color1':Color(0xFF1A1A1A), 'color2':Color(0xFF333333)},
  {'title':'Student Deals\nThis Week', 'sub':'Exclusive campus discounts', 'emoji':'🎒', 'color1':Color(0xFF0D47A1), 'color2':Color(0xFF1565C0)},
  {'title':'Flash Sale\n50% Off',      'sub':'Limited time — grab it fast','emoji':'⚡', 'color1':Color(0xFF880E4F), 'color2':Color(0xFFC62828)},
];

// ─────────────────────────────────────────────
// MARKETPLACE PAGE
// ─────────────────────────────────────────────
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedProductCategory = 'All';
  String _selectedServiceCategory = 'All';
  String _searchQuery             = '';
  String _sortBy                  = 'Most popular';
  int    _bannerIndex             = 0;
  String _selectedTab             = 'Marketplace';

  final _searchCtrl   = TextEditingController();
  final _pageCtrl     = PageController();
  final Set<String> _favourites    = {};
  final Set<String> _savedServices = {};
  final _cart = MarketCart();

  // User-created products (from create post page)
  final List<_Product> _userProducts = [];
  final List<_Service> _userServices = [];

  // Notifications
  final List<_Notification> _notifications = [
    _Notification(id:'n1', text:'Sipho M. replied to your message', time:'2 min ago'),
    _Notification(id:'n2', text:'Your order for HP Laptop was confirmed', time:'1 hr ago'),
    _Notification(id:'n3', text:'New service available: Music Lessons near you', time:'3 hrs ago', read:true),
    _Notification(id:'n4', text:'Price drop on Macbook 16 — now R18,900', time:'Yesterday', read:true),
  ];

  int get _unreadNotifCount => _notifications.where((n) => !n.read).length;

  List<_Product> get _allProducts => [..._userProducts, ..._products];

  List<_Product> get _filteredProducts => _allProducts.where((p) {
    final catMatch = _selectedProductCategory == 'All' || p.category == _selectedProductCategory;
    final qMatch = _searchQuery.isEmpty ||
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.category.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  List<_Service> get _allServices => [..._userServices, ..._services];

  List<_Service> get _filteredServices => _allServices.where((s) {
    final catMatch = _selectedServiceCategory == 'All' || s.category == _selectedServiceCategory;
    final qMatch = _searchQuery.isEmpty ||
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.provider.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  List<_Service> get _featuredServices => _allServices.where((s) => s.isFeatured).toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String v) => setState(() => _searchQuery = v);

  void _clearSearch() {
    _searchCtrl.clear();
    setState(() => _searchQuery = '');
  }

  // ── Open notifications sheet ──
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) => Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: _C.border, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notifications',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _C.dark)),
                  TextButton(
                    onPressed: () {
                      for (final n in _notifications) { n.read = true; }
                      setSt(() {});
                      setState(() {});
                    },
                    child: const Text('Mark all read',
                        style: TextStyle(color: _C.primary, fontSize: 12)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: _C.border),
                itemBuilder: (_, i) {
                  final n = _notifications[i];
                  return ListTile(
                    tileColor: n.read ? Colors.white : _C.primary.withOpacity(0.04),
                    leading: Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                          color: n.read ? _C.border : _C.primary,
                          shape: BoxShape.circle),
                    ),
                    title: Text(n.text,
                        style:
                            const TextStyle(fontSize: 13, color: _C.dark)),
                    subtitle: Text(n.time,
                        style:
                            const TextStyle(fontSize: 11, color: _C.grey)),
                    onTap: () {
                      setSt(() => n.read = true);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Open cart sheet ──
  void _showCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CartPage(
          cart: _cart,
          onUpdate: () => setState(() {}),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  // ── Open messaging ──
  void _openMessaging({String? sellerId, String? sellerName, String? context}) {
    // Navigate to messaging page passing optional seller info
    this.context.push('/messages',
        extra: {'sellerId': sellerId, 'sellerName': sellerName, 'context': context});
  }

  // ── Open create post ──
  void _openCreatePost() {
    context.push('/marketplace/create').then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isServices = _selectedTab == 'Services';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            _TopBar(
              searchCtrl:     _searchCtrl,
              onSearch:       _onSearch,
              onSearchSubmit: _onSearch,
              onClear:        _clearSearch,
              hasQuery:       _searchQuery.isNotEmpty,
              cartCount:      _cart.count,
              unreadNotif:    _unreadNotifCount,
              onNotifTap:     _showNotifications,
              onCartTap:      _showCart,
              onMsgTap:       () => _openMessaging(),
            ),

            // ── Tab row + sort ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _C.border))),
              child: Row(
                children: [
                  _tabPill('Marketplace', isServices),
                  const SizedBox(width: 8),
                  _tabPill('Services', !isServices),
                  const Spacer(),
                  const Text('Sort by: ',
                      style: TextStyle(fontSize: 12, color: _C.grey)),
                  _SortDropdown(
                    value: _sortBy,
                    onChanged: (v) => setState(() => _sortBy = v ?? _sortBy),
                  ),
                  const SizedBox(width: 6),
                  // Create post button
                  GestureDetector(
                    onTap: _openCreatePost,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _C.dark,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.white, size: 13),
                          SizedBox(width: 3),
                          Text('Post',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ──
            Expanded(
              child: isServices
                  ? _ServicesBody(
                      searchQuery:       _searchQuery,
                      filteredServices:  _filteredServices,
                      featuredServices:  _featuredServices,
                      savedServices:     _savedServices,
                      selectedCategory:  _selectedServiceCategory,
                      onCategoryChanged: (c) => setState(() => _selectedServiceCategory = c),
                      onSave: (id) => setState(() {
                        _savedServices.contains(id)
                            ? _savedServices.remove(id)
                            : _savedServices.add(id);
                      }),
                      onTap: (s) => _openServiceDetail(s),
                    )
                  : _MarketplaceBody(
                      searchQuery:       _searchQuery,
                      filteredProducts:  _filteredProducts,
                      allProducts:       _allProducts,
                      favourites:        _favourites,
                      selectedCategory:  _selectedProductCategory,
                      onCategoryChanged: (c) => setState(() => _selectedProductCategory = c),
                      bannerIndex:       _bannerIndex,
                      pageCtrl:          _pageCtrl,
                      onBannerChanged:   (i) => setState(() => _bannerIndex = i),
                      onFavourite: (id) => setState(() {
                        _favourites.contains(id)
                            ? _favourites.remove(id)
                            : _favourites.add(id);
                      }),
                      onAddToCart: (p) {
                        _cart.add(p);
                        setState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${p.name} added to cart'),
                          backgroundColor: _C.green,
                          duration: const Duration(seconds: 1),
                          action: SnackBarAction(
                            label: 'View Cart',
                            textColor: Colors.white,
                            onPressed: _showCart,
                          ),
                        ));
                      },
                      onTap: (p) => _openProductDetail(p),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openProductDetail(_Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ProductDetailPage(
          product: p,
          cart: _cart,
          onMessage: () => _openMessaging(
              sellerId: p.sellerId,
              sellerName: p.seller,
              context: p.name),
          onCartChanged: () => setState(() {}),
        ),
      ),
    ).then((_) => setState(() {}));
  }

  void _openServiceDetail(_Service s) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ServiceDetailPage(
          service: s,
          onMessage: () => _openMessaging(
              sellerId: s.providerId,
              sellerName: s.provider,
              context: s.name),
        ),
      ),
    );
  }

  Widget _tabPill(String label, bool otherSelected) {
    final isThisSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedTab = label;
        _searchQuery = '';
        _searchCtrl.clear();
      }),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isThisSelected ? _C.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isThisSelected ? Colors.white : _C.grey)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onSearchSubmit;
  final VoidCallback onClear, onNotifTap, onCartTap, onMsgTap;
  final bool hasQuery;
  final int cartCount, unreadNotif;

  const _TopBar({
    required this.searchCtrl,
    required this.onSearch,
    required this.onSearchSubmit,
    required this.onClear,
    required this.onNotifTap,
    required this.onCartTap,
    required this.onMsgTap,
    required this.hasQuery,
    required this.cartCount,
    required this.unreadNotif,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: _C.border))),
      child: Row(
        children: [
          const Text('Marketplace',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.dark)),
          const SizedBox(width: 10),

          // Search bar
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _C.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      onChanged: onSearch,
                      onSubmitted: onSearchSubmit,
                      style: const TextStyle(fontSize: 13, color: _C.dark),
                      decoration: const InputDecoration(
                        hintText: 'Search…',
                        hintStyle: TextStyle(
                            color: Color(0xFFAAAAAA), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                  if (hasQuery)
                    GestureDetector(
                      onTap: onClear,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.close_rounded,
                            size: 16, color: _C.grey),
                      ),
                    ),
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: _C.primary,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(7)),
                    ),
                    child: const Icon(Icons.search,
                        color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Icon cluster
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notifications
              _iconBtnWithBadge(
                icon: Icons.notifications_none_rounded,
                badge: unreadNotif,
                onTap: onNotifTap,
              ),
              const SizedBox(width: 5),
              // Messages
              _iconBtnWithBadge(
                icon: Icons.chat_bubble_outline_rounded,
                badge: 0,
                onTap: onMsgTap,
              ),
              const SizedBox(width: 5),
              // Cart
              _iconBtnWithBadge(
                icon: Icons.shopping_cart_outlined,
                badge: cartCount,
                onTap: onCartTap,
              ),
              const SizedBox(width: 5),
              // Profile
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: _C.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: _C.border),
                  ),
                  child: const Icon(Icons.person_rounded,
                      size: 17, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtnWithBadge({
    required IconData icon,
    required int badge,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _C.border),
              ),
              child: Icon(icon, size: 17, color: _C.grey),
            ),
            if (badge > 0)
              Positioned(
                top: -4, right: -4,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(
                      color: _C.primary, shape: BoxShape.circle),
                  child: Center(
                    child: Text(
                      badge > 9 ? '9+' : '$badge',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}

// ─────────────────────────────────────────────
// MARKETPLACE BODY (products)
// ─────────────────────────────────────────────
class _MarketplaceBody extends StatelessWidget {
  final String searchQuery;
  final List<_Product> filteredProducts;
  final List<_Product> allProducts;
  final Set<String> favourites;
  final String selectedCategory;
  final void Function(String) onCategoryChanged;
  final int bannerIndex;
  final PageController pageCtrl;
  final void Function(int) onBannerChanged;
  final void Function(String) onFavourite;
  final void Function(_Product) onAddToCart;
  final void Function(_Product) onTap;

  const _MarketplaceBody({
    required this.searchQuery,
    required this.filteredProducts,
    required this.allProducts,
    required this.favourites,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.bannerIndex,
    required this.pageCtrl,
    required this.onBannerChanged,
    required this.onFavourite,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final popular = allProducts.where((p) => p.rating >= 4.5).toList();
    final filteredPopular = searchQuery.isEmpty
        ? popular
        : popular.where((p) =>
            p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 14),
            _BannerCarousel(
              banners: _banners,
              currentIndex: bannerIndex,
              pageCtrl: pageCtrl,
              onPageChanged: onBannerChanged,
            ),
          ],
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                'Results for "$searchQuery"',
                style: const TextStyle(
                    fontSize: 13, color: _C.grey, fontStyle: FontStyle.italic),
              ),
            ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Categories',
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700, color: _C.dark)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView.separated(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? _C.primary : _C.lightGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(cat,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : _C.grey)),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${filteredProducts.length} Products',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
                const Text('View all',
                    style: TextStyle(
                        fontSize: 12, color: _C.primary, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _ProductGrid(
            products: filteredProducts,
            favourites: favourites,
            onFavourite: onFavourite,
            onAddToCart: onAddToCart,
            onTap: onTap,
          ),

          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Popular Products',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
            ),
            const SizedBox(height: 12),
            _ProductGrid(
              products: filteredPopular,
              favourites: favourites,
              onFavourite: onFavourite,
              onAddToCart: onAddToCart,
              onTap: onTap,
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SERVICES BODY
// ─────────────────────────────────────────────
class _ServicesBody extends StatelessWidget {
  final String searchQuery;
  final List<_Service> filteredServices;
  final List<_Service> featuredServices;
  final Set<String> savedServices;
  final String selectedCategory;
  final void Function(String) onCategoryChanged;
  final void Function(String) onSave;
  final void Function(_Service) onTap;

  const _ServicesBody({
    required this.searchQuery,
    required this.filteredServices,
    required this.featuredServices,
    required this.savedServices,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (searchQuery.isEmpty)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _C.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('STUDENT SERVICES',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 8),
                        const Text('Skills for hire,\nright on campus',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.2)),
                        const SizedBox(height: 4),
                        Text('${_services.length} services available now',
                            style: const TextStyle(
                                color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Text('🎓', style: TextStyle(fontSize: 56)),
                ],
              ),
            ),

          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text('Results for "$searchQuery"',
                  style: const TextStyle(
                      fontSize: 13, color: _C.grey, fontStyle: FontStyle.italic)),
            ),

          const SizedBox(height: 16),
          SizedBox(
            height: 34,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _serviceCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _serviceCategories[i];
                final sel = selectedCategory == cat;
                return GestureDetector(
                  onTap: () => onCategoryChanged(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: sel ? _C.primary : _C.lightGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(cat,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : _C.grey)),
                  ),
                );
              },
            ),
          ),

          if (searchQuery.isEmpty && selectedCategory == 'All') ...[
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('⭐ Featured Services',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700, color: _C.dark)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 190,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: featuredServices.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => _FeaturedServiceCard(
                  service: featuredServices[i],
                  isSaved: savedServices.contains(featuredServices[i].id),
                  onSave: () => onSave(featuredServices[i].id),
                  onTap: () => onTap(featuredServices[i]),
                ),
              ),
            ),
          ],

          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              searchQuery.isNotEmpty
                  ? '${filteredServices.length} results'
                  : selectedCategory == 'All'
                      ? 'All Services (${filteredServices.length})'
                      : '$selectedCategory (${filteredServices.length})',
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark),
            ),
          ),
          const SizedBox(height: 10),

          if (filteredServices.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: _C.grey),
                    SizedBox(height: 12),
                    Text('No services found',
                        style: TextStyle(color: _C.grey, fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredServices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _ServiceListCard(
                service: filteredServices[i],
                isSaved: savedServices.contains(filteredServices[i].id),
                onSave: () => onSave(filteredServices[i].id),
                onTap: () => onTap(filteredServices[i]),
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCT DETAIL PAGE
// ─────────────────────────────────────────────
class _ProductDetailPage extends StatefulWidget {
  final _Product product;
  final MarketCart cart;
  final VoidCallback onMessage;
  final VoidCallback onCartChanged;

  const _ProductDetailPage({
    required this.product,
    required this.cart,
    required this.onMessage,
    required this.onCartChanged,
  });

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Product Details',
            style: TextStyle(
                color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: _C.dark),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => _CartPage(
                            cart: widget.cart,
                            onUpdate: () => setState(() {})))),
              ),
              if (widget.cart.count > 0)
                Positioned(
                  top: 6, right: 6,
                  child: Container(
                    width: 16, height: 16,
                    decoration: const BoxDecoration(
                        color: _C.primary, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${widget.cart.count}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero
                  Container(
                    height: 260,
                    color: _C.lightGrey,
                    child: Center(
                        child: Text(p.image,
                            style: const TextStyle(fontSize: 100))),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p.name,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: _C.dark)),
                                  Text(p.category,
                                      style: const TextStyle(
                                          fontSize: 13, color: _C.grey)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share_outlined,
                                  color: _C.grey, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(p.price,
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: _C.primary)),
                            if (p.oldPrice.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(p.oldPrice,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: _C.grey,
                                      decoration: TextDecoration.lineThrough)),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),
                        Row(
                          children: [
                            ...List.generate(
                                5,
                                (i) => Icon(
                                      i < p.rating.floor()
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: 16,
                                      color: _C.amber,
                                    )),
                            const SizedBox(width: 6),
                            Text('${p.rating}',
                                style: const TextStyle(
                                    fontSize: 12, color: _C.grey)),
                          ],
                        ),

                        const SizedBox(height: 16),
                        const Text('Description',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _C.dark)),
                        const SizedBox(height: 6),
                        Text(p.description,
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF555555),
                                height: 1.5)),

                        const SizedBox(height: 16),
                        const Text('Seller',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _C.dark)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _C.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _C.border),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: _C.primary.withOpacity(0.15),
                                child: Text(
                                  p.seller.isNotEmpty
                                      ? p.seller[0].toUpperCase()
                                      : 'S',
                                  style: const TextStyle(
                                      color: _C.primary,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.seller,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700)),
                                    Text('${p.university} · Product Owner',
                                        style: const TextStyle(
                                            fontSize: 11, color: _C.grey)),
                                  ],
                                ),
                              ),
                              // Message seller button
                              TextButton.icon(
                                onPressed: widget.onMessage,
                                icon: const Icon(
                                    Icons.chat_bubble_outline_rounded,
                                    size: 15,
                                    color: _C.primary),
                                label: const Text('Chat',
                                    style: TextStyle(
                                        color: _C.primary, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Text('Verify this Product',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _C.dark)),
                        const SizedBox(height: 6),
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter serial number here...',
                            hintStyle: const TextStyle(
                                fontSize: 12, color: Color(0xFFAAAAAA)),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: _C.border)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: _C.border)),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: _C.border))),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: _C.border),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () =>
                              setState(() { if (_qty > 1) _qty--; }),
                          icon: const Icon(Icons.remove, size: 16)),
                      Text('$_qty',
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      IconButton(
                          onPressed: () => setState(() => _qty++),
                          icon: const Icon(Icons.add, size: 16)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      for (int i = 0; i < _qty; i++) {
                        widget.cart.add(widget.product);
                      }
                      widget.onCartChanged();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '$_qty × ${widget.product.name} added to cart'),
                          backgroundColor: _C.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text('Add to Cart ($_qty)',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
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
// SERVICE DETAIL PAGE
// ─────────────────────────────────────────────
class _ServiceDetailPage extends StatelessWidget {
  final _Service service;
  final VoidCallback onMessage;

  const _ServiceDetailPage({
    required this.service,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _C.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Service Details',
            style: TextStyle(
                color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Hero
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    color: _C.primary,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: Text(
                            service.image,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(service.provider,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        Text(service.university,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13)),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _C.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: _C.dark)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 14, color: _C.amber),
                                  const SizedBox(width: 4),
                                  Text(service.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.work_outline,
                                      size: 14, color: _C.grey),
                                  const SizedBox(width: 4),
                                  Text('${service.reviews} jobs completed',
                                      style: const TextStyle(
                                          color: _C.grey, fontSize: 13)),
                                ],
                              ),
                              const Divider(height: 24),
                              const Text('About this service',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              const SizedBox(height: 6),
                              Text(service.description,
                                  style: const TextStyle(
                                      color: _C.grey,
                                      fontSize: 13,
                                      height: 1.5)),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Rate',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14)),
                                  Text(service.price,
                                      style: const TextStyle(
                                          color: _C.primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 18)),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Portfolio
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _C.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Portfolio',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14)),
                              const SizedBox(height: 12),
                              GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                children: List.generate(
                                  6,
                                  (i) => Container(
                                    decoration: BoxDecoration(
                                      color: _C.primary.withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                        Icons.image_outlined,
                                        color: _C.primary),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onMessage,
                    icon: const Icon(Icons.message_outlined,
                        color: _C.primary),
                    label: const Text('Message',
                        style: TextStyle(color: _C.primary)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: _C.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.push(
                      '/marketplace/hire',
                      extra: {
                        'name': service.provider,
                        'title': service.name,
                        'university': service.university,
                        'price': service.price,
                        'rating': service.rating.toString(),
                        'jobs': service.reviews.toString(),
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Hire Student',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
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
// UNIFIED CART PAGE
// ─────────────────────────────────────────────
class _CartPage extends StatefulWidget {
  final MarketCart cart;
  final VoidCallback onUpdate;

  const _CartPage({required this.cart, required this.onUpdate});

  @override
  State<_CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<_CartPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  int _step = 0; // 0=cart 1=checkout 2=success
  final _voucherCtrl = TextEditingController();
  bool _showVoucher = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _voucherCtrl.dispose();
    super.dispose();
  }

  void _refresh() {
    widget.onUpdate();
    setState(() {});
  }

  String _fmt(double v) => 'R${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    if (_step == 2) return _successScreen(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _step == 0 ? 'My Cart' : 'Checkout',
          style: const TextStyle(
              color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          if (_step == 0)
            TextButton(
              onPressed: () => setState(() => _showVoucher = !_showVoucher),
              child: const Text('Apply Promo Code',
                  style: TextStyle(
                      color: _C.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
        ],
        bottom: _step == 0
            ? TabBar(
                controller: _tabs,
                labelColor: _C.primary,
                unselectedLabelColor: _C.grey,
                indicatorColor: _C.primary,
                tabs: const [Tab(text: 'My Cart'), Tab(text: 'Wishlist')],
              )
            : _stepIndicator(),
      ),
      body: _step == 0 ? _cartBody() : _checkoutBody(),
    );
  }

  PreferredSizeWidget _stepIndicator() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              Column(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: i <= _step - 1 ? _C.primary : _C.border,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: i < _step - 1
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : Icon(
                              [
                                Icons.local_shipping_outlined,
                                Icons.payment_outlined,
                                Icons.rate_review_outlined
                              ][i],
                              size: 14,
                              color: i == _step - 1
                                  ? Colors.white
                                  : _C.grey),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    ['Shipping', 'Payment', 'Review'][i],
                    style: TextStyle(
                        fontSize: 9,
                        color: i <= _step - 1 ? _C.primary : _C.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              if (i < 2)
                Container(
                  width: 28, height: 1,
                  color: i < _step - 1 ? _C.primary : _C.border,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _cartBody() {
    return TabBarView(
      controller: _tabs,
      children: [
        // Cart tab
        widget.cart.items.isEmpty
            ? _emptyCart()
            : Column(
                children: [
                  // Voucher
                  if (_showVoucher)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _voucherCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Enter voucher number',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _C.primary),
                            onPressed: () {},
                            child: const Text('Apply',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.cart.items.length,
                      itemBuilder: (_, i) {
                        final item = widget.cart.items[i];
                        return _CartItemTile(
                          item: item,
                          onRemove: () {
                            widget.cart.remove(item.product.id);
                            _refresh();
                          },
                          onQtyChange: (q) {
                            widget.cart.updateQty(item.product.id, q);
                            _refresh();
                          },
                        );
                      },
                    ),
                  ),

                  _orderSummary(),
                ],
              ),
        // Wishlist tab
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite_border,
                  size: 64, color: _C.border),
              const SizedBox(height: 12),
              const Text('No wishlist items yet',
                  style: TextStyle(color: _C.grey, fontSize: 14)),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Browse Marketplace',
                    style: TextStyle(color: _C.primary)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _emptyCart() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined,
                size: 72, color: _C.border),
            const SizedBox(height: 14),
            const Text('Your cart is empty',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _C.dark)),
            const SizedBox(height: 8),
            const Text('Browse the marketplace to add items',
                style: TextStyle(color: _C.grey, fontSize: 13)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: () => Navigator.pop(context),
              child: const Text('Explore Categories',
                  style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('Back', style: TextStyle(color: _C.grey)),
            ),
          ],
        ),
      );

  Widget _orderSummary() => Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order Info',
                style: TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14, color: _C.dark)),
            const SizedBox(height: 8),
            _row('Subtotal', _fmt(widget.cart.subtotal)),
            _row('Shipping Cost', 'R0.00'),
            const Divider(height: 14),
            _row('Total', _fmt(widget.cart.subtotal), bold: true),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => setState(() => _step = 1),
                child: Text(
                    'Checkout (${widget.cart.count})',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Center(
                child: Text('Back', style: TextStyle(color: _C.grey)),
              ),
            ),
          ],
        ),
      );

  Widget _checkoutBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping
                const Text('Fullname',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _field('Enter fullname'),
                const SizedBox(height: 10),
                const Text('Phone number',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                _field('Enter phone number'),
                const SizedBox(height: 14),
                const Text('Shipping Address',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _field('Province')),
                    const SizedBox(width: 10),
                    Expanded(child: _field('City')),
                  ],
                ),
                const SizedBox(height: 10),
                _field('Street address'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _field('Postal code')),
                    const SizedBox(width: 10),
                    Expanded(child: _field('Email address')),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Payment Method',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                const SizedBox(height: 12),
                for (final m in ['Gude Wallet', 'Credit/Debit Card', 'EFT / Instant Pay'])
                  _paymentTile(m, m == 'Gude Wallet'),

                const SizedBox(height: 14),
                // Review
                const Text('Order Summary',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                const SizedBox(height: 10),
                ...widget.cart.items.map(
                  (item) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                              color: _C.lightGrey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                              child: Text(item.product.image,
                                  style: const TextStyle(fontSize: 24))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              Text('×${item.qty}',
                                  style: const TextStyle(
                                      fontSize: 11, color: _C.grey)),
                            ],
                          ),
                        ),
                        Text(item.product.price,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: _C.primary)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      _row('Subtotal', _fmt(widget.cart.subtotal)),
                      const SizedBox(height: 4),
                      _row('Shipping', 'R0.00'),
                      const Divider(height: 14),
                      _row('Total', _fmt(widget.cart.subtotal), bold: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _C.primary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              widget.cart.clear();
              widget.onUpdate();
              setState(() => _step = 2);
            },
            child: const Text('Place Order',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }

  Widget _successScreen(BuildContext ctx) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 120, height: 120,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF0FFF4), shape: BoxShape.circle),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 56)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your order has been\nplaced successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _C.dark,
                      height: 1.3),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Thank you for shopping at Gude! Feel free to continue shopping and explore our wide range of products.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: _C.grey, height: 1.5),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.of(ctx)
                        .popUntil((r) => r.isFirst),
                    child: const Text('Continue Shopping',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(ctx).popUntil((r) => r.isFirst),
                  child: const Text('Back',
                      style: TextStyle(color: _C.grey)),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _paymentTile(String label, bool selected) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? _C.primary.withOpacity(0.05) : Colors.white,
          border: Border.all(color: selected ? _C.primary : _C.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              label.contains('Wallet')
                  ? Icons.account_balance_wallet_outlined
                  : label.contains('Card')
                      ? Icons.credit_card_outlined
                      : Icons.swap_horiz_rounded,
              color: selected ? _C.primary : _C.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: selected ? _C.primary : _C.dark)),
            const Spacer(),
            if (selected)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: _C.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6)),
                child: const Text('Selected',
                    style: TextStyle(
                        color: _C.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
          ],
        ),
      );

  Widget _row(String l, String r, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l,
                style: TextStyle(
                    color: bold ? _C.dark : _C.grey,
                    fontWeight:
                        bold ? FontWeight.w700 : FontWeight.normal,
                    fontSize: 13)),
            Text(r,
                style: TextStyle(
                    fontWeight:
                        bold ? FontWeight.w800 : FontWeight.w600,
                    color: bold ? _C.primary : _C.dark,
                    fontSize: 13)),
          ],
        ),
      );

  Widget _field(String hint) => Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _C.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _C.border)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );
}

// ─────────────────────────────────────────────
// CART ITEM TILE
// ─────────────────────────────────────────────
class _CartItemTile extends StatelessWidget {
  final _CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQtyChange;

  const _CartItemTile({
    required this.item,
    required this.onRemove,
    required this.onQtyChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              color: _C.lightGrey,
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(14)),
            ),
            child: Center(
              child: Text(item.product.image,
                  style: const TextStyle(fontSize: 36)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(item.product.price,
                          style: const TextStyle(
                              color: _C.primary, fontWeight: FontWeight.w800)),
                      if (item.product.oldPrice.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Text(item.product.oldPrice,
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: _C.grey,
                                fontSize: 11)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => onQtyChange(item.qty - 1),
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                              border: Border.all(color: _C.border),
                              borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.remove, size: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('${item.qty}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700)),
                      ),
                      GestureDetector(
                        onTap: () => onQtyChange(item.qty + 1),
                        child: Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                              color: _C.primary,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Icon(Icons.add,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Color(0xFFCCCCCC), size: 20),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BANNER CAROUSEL — reused from original
// ─────────────────────────────────────────────
class _BannerCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final int currentIndex;
  final PageController pageCtrl;
  final ValueChanged<int> onPageChanged;

  const _BannerCarousel({
    required this.banners,
    required this.currentIndex,
    required this.pageCtrl,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: pageCtrl,
              onPageChanged: onPageChanged,
              itemCount: banners.length,
              itemBuilder: (_, i) {
                final b = banners[i];
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [b['color1'] as Color, b['color2'] as Color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(b['title'] as String,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      height: 1.2)),
                              const SizedBox(height: 6),
                              Text(b['sub'] as String,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(b['emoji'] as String,
                            style: const TextStyle(fontSize: 64)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                banners.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: currentIndex == i ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: currentIndex == i
                        ? Colors.white
                        : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCT GRID
// ─────────────────────────────────────────────
class _ProductGrid extends StatelessWidget {
  final List<_Product> products;
  final Set<String> favourites;
  final ValueChanged<String> onFavourite;
  final ValueChanged<_Product> onAddToCart;
  final ValueChanged<_Product> onTap;

  const _ProductGrid({
    required this.products,
    required this.favourites,
    required this.onFavourite,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text('No products found',
              style: TextStyle(color: _C.grey, fontSize: 14)),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(
        product: products[i],
        isFav: favourites.contains(products[i].id),
        onFav: () => onFavourite(products[i].id),
        onAddToCart: () => onAddToCart(products[i]),
        onTap: () => onTap(products[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PRODUCT CARD
// ─────────────────────────────────────────────
class _ProductCard extends StatelessWidget {
  final _Product product;
  final bool isFav;
  final VoidCallback onFav, onAddToCart, onTap;
  const _ProductCard({
    required this.product,
    required this.isFav,
    required this.onFav,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _C.border),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(product.image,
                          style: const TextStyle(fontSize: 40)),
                    ),
                  ),
                  if (product.isNew || product.isSale)
                    Positioned(
                      top: 6, left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: product.isNew ? _C.green : _C.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.isNew ? 'NEW' : 'SALE',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: onFav,
                      child: Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4)
                          ],
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 15,
                          color: isFav ? _C.primary : _C.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.name,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _C.dark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (product.oldPrice.isNotEmpty)
                          Text(product.oldPrice,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: _C.grey,
                                  decoration: TextDecoration.lineThrough)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(product.price,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: _C.primary)),
                            ),
                            GestureDetector(
                              onTap: onAddToCart,
                              child: Container(
                                width: 24, height: 24,
                                decoration: BoxDecoration(
                                  color: _C.dark,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FEATURED SERVICE CARD
// ─────────────────────────────────────────────
class _FeaturedServiceCard extends StatelessWidget {
  final _Service service;
  final bool isSaved;
  final VoidCallback onSave, onTap;

  const _FeaturedServiceCard({
    required this.service,
    required this.isSaved,
    required this.onSave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: const BoxDecoration(
                color: _C.lightGrey,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Text(service.image,
                        style: const TextStyle(fontSize: 40)),
                  ),
                  Positioned(
                    top: 6, left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: _C.primary,
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(service.category,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Positioned(
                    top: 6, right: 6,
                    child: GestureDetector(
                      onTap: onSave,
                      child: Container(
                        width: 26, height: 26,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4)
                            ]),
                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 13,
                          color: isSaved ? _C.primary : _C.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _C.dark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(service.provider,
                      style: const TextStyle(fontSize: 10, color: _C.grey)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(service.price,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _C.primary)),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 11, color: _C.amber),
                          const SizedBox(width: 2),
                          Text(service.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _C.dark)),
                        ],
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
// SERVICE LIST CARD
// ─────────────────────────────────────────────
class _ServiceListCard extends StatelessWidget {
  final _Service service;
  final bool isSaved;
  final VoidCallback onSave, onTap;

  const _ServiceListCard({
    required this.service,
    required this.isSaved,
    required this.onSave,
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
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child:
                    Text(service.image, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(service.name,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _C.dark),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _C.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(service.category,
                            style: const TextStyle(
                                fontSize: 9,
                                color: _C.primary,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(service.description,
                      style: const TextStyle(
                          fontSize: 11, color: _C.grey, height: 1.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(service.university,
                            style: const TextStyle(
                                fontSize: 9,
                                color: _C.grey,
                                fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded,
                          size: 11, color: _C.amber),
                      const SizedBox(width: 2),
                      Text(service.rating.toStringAsFixed(1),
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _C.dark)),
                      const SizedBox(width: 2),
                      Text('(${service.reviews})',
                          style: const TextStyle(
                              fontSize: 10, color: _C.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onSave,
                  child: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    size: 18,
                    color: isSaved ? _C.primary : _C.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(service.price,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: _C.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SORT DROPDOWN
// ─────────────────────────────────────────────
class _SortDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  const _SortDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        style: const TextStyle(
            fontSize: 12, color: _C.dark, fontWeight: FontWeight.w500),
        icon: const Icon(Icons.keyboard_arrow_down_rounded,
            size: 16, color: _C.grey),
        onChanged: onChanged,
        items: const [
          DropdownMenuItem(value: 'Most popular', child: Text('Most popular')),
          DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low')),
          DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High')),
          DropdownMenuItem(value: 'Newest', child: Text('Newest')),
          DropdownMenuItem(value: 'Rating', child: Text('Rating')),
        ],
      ),
    );
  }
}