import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_app/core/state/financial_health.dart';

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
    required this.id, required this.name, required this.price,
    this.oldPrice = '', required this.image, required this.category,
    required this.rating, this.isNew = false, this.isSale = false,
    this.seller = 'Student', this.sellerId = '', this.university = '',
    this.description = '',
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
// GLOBAL CART STATE
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
    final price = double.tryParse(i.product.price.replaceAll('R', '').replaceAll(',', '').trim()) ?? 0;
    return s + price * i.qty;
  });
  int get count => items.fold(0, (s, i) => s + i.qty);
}

// ─────────────────────────────────────────────
// GLOBAL WISHLIST STATE
// ─────────────────────────────────────────────
class MarketWishlist {
  static final MarketWishlist _inst = MarketWishlist._();
  factory MarketWishlist() => _inst;
  MarketWishlist._();
  final Set<String> _productIds = {};
  bool hasProduct(String id) => _productIds.contains(id);
  void toggleProduct(String id) {
    if (_productIds.contains(id)) { _productIds.remove(id); } else { _productIds.add(id); }
  }
  List<String> get productIds => List.unmodifiable(_productIds);
}

// ─────────────────────────────────────────────
// SEED DATA (Products only - services removed)
// ─────────────────────────────────────────────
const _products = [
  _Product(id:'p1', name:'HP Laptop 15.6"',      price:'R5200',  oldPrice:'R6500',  image:'💻', category:'Electronics', rating:4.5, isSale:true,  seller:'Precious Mhd', sellerId:'u2', university:'UCT',  description:'Intel Core i5, 8GB RAM, 512GB SSD, Windows 11. Perfect for students.'),
  _Product(id:'p2', name:'iPhone 12 Pro Max',     price:'R12500', oldPrice:'R15000', image:'📱', category:'Electronics', rating:4.8, isNew:true,   seller:'Sipho M.',     sellerId:'u3', university:'Wits', description:'128GB, Midnight Black. Excellent condition with charger and box.'),
  _Product(id:'p3', name:'SkullCandy Headphones', price:'R1200',  oldPrice:'R1800',  image:'🎧', category:'Electronics', rating:4.6, isNew:true,   seller:'Aisha K.',     sellerId:'u4', university:'UP',   description:'Over-ear wireless, 40hr battery, foldable.'),
  _Product(id:'p4', name:'Study Mini Table',      price:'R780',   oldPrice:'R1100',  image:'🪑', category:'Furniture',   rating:4.1,               seller:'Zanele D.',    sellerId:'u5', university:'UJ',   description:'Portable laptop table with adjustable height.'),
  _Product(id:'p5', name:'Macbook 16',            price:'R18900', oldPrice:'R22000', image:'💻', category:'Electronics', rating:4.9, isSale:true,  seller:'Keanu N.',     sellerId:'u6', university:'CPUT', description:'M1 Pro chip, 16GB RAM, 512GB SSD. Near-new condition.'),
  _Product(id:'p6', name:'Casio Calculator',      price:'R245',   oldPrice:'R350',   image:'🧮', category:'Stationery',  rating:4.9, isSale:true,  seller:'Ruan P.',      sellerId:'u7', university:'SU',   description:'FX-991ZA PLUS. Perfect for university maths and science.'),
  _Product(id:'p7', name:'Russell Hobbs Air Fry', price:'R2100',  oldPrice:'R2800',  image:'🍳', category:'Appliances',  rating:4.2, isSale:true,  seller:'Fatima H.',    sellerId:'u8', university:'UKZN', description:'4.5L digital air fryer. Barely used.'),
  _Product(id:'p8', name:'Desktop Monitor 24"',   price:'R3800',  oldPrice:'R4500',  image:'🖥️', category:'Electronics', rating:4.4,               seller:'Ntando B.',    sellerId:'u9', university:'UWC',  description:'Full HD IPS panel, 75Hz, HDMI & VGA.'),
];

const _productCategories = ['All','Electronics','Furniture','Stationery','Appliances','Books','Clothes','Bags'];

const _banners = [
  {'title':'40% Off\nBlack Friday',    'sub':'From R6,000 – R9,294.99',   'emoji':'📺', 'color1':Color(0xFF1A1A1A), 'color2':Color(0xFF333333)},
  {'title':'Student Deals\nThis Week', 'sub':'Exclusive campus discounts', 'emoji':'🎒', 'color1':Color(0xFF0D47A1), 'color2':Color(0xFF1565C0)},
  {'title':'Flash Sale\n50% Off',      'sub':'Limited time — grab it fast','emoji':'⚡', 'color1':Color(0xFF880E4F), 'color2':Color(0xFFC62828)},
];

// ─────────────────────────────────────────────
// MARKETPLACE PAGE  (Products only — Services tab removed)
// ─────────────────────────────────────────────
class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});
  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedCategory = 'All';
  String _searchQuery      = '';
  String _sortBy           = 'Most popular';
  int    _bannerIndex      = 0;

  final _searchCtrl = TextEditingController();
  final _pageCtrl   = PageController();
  final _cart       = MarketCart();
  final _wishlist   = MarketWishlist();

  final List<_Notification> _notifications = [
    _Notification(id:'n1', text:'Sipho M. replied to your message', time:'2 min ago'),
    _Notification(id:'n2', text:'Your order for HP Laptop was confirmed', time:'1 hr ago'),
    _Notification(id:'n3', text:'Price drop on Macbook 16 — now R18,900', time:'Yesterday', read:true),
  ];

  int get _unreadNotifCount => _notifications.where((n) => !n.read).length;

  List<_Product> get _filteredProducts => _products.where((p) {
    final catMatch = _selectedCategory == 'All' || p.category == _selectedCategory;
    final qMatch   = _searchQuery.isEmpty ||
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.category.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  List<_Product> get _popularProducts => _products.where((p) => p.rating >= 4.5).toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _showCart() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _CartPage(cart: _cart, onUpdate: () => setState(() {})),
    )).then((_) => setState(() {}));
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(builder: (ctx, setSt) => DraggableScrollableSheet(
        expand: false, initialChildSize: 0.55, maxChildSize: 0.85,
        builder: (_, sc) => Column(children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: _C.border, borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _C.dark)),
              TextButton(onPressed: () { for (final n in _notifications) { n.read = true; } setSt(() {}); setState(() {}); },
                child: const Text('Mark all read', style: TextStyle(color: _C.primary, fontSize: 12))),
            ]),
          ),
          Expanded(child: ListView.separated(
            controller: sc,
            itemCount: _notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: _C.border),
            itemBuilder: (_, i) {
              final n = _notifications[i];
              return ListTile(
                tileColor: n.read ? Colors.white : _C.primary.withOpacity(0.04),
                leading: Container(width: 8, height: 8, decoration: BoxDecoration(color: n.read ? _C.border : _C.primary, shape: BoxShape.circle)),
                title: Text(n.text, style: const TextStyle(fontSize: 13, color: _C.dark)),
                subtitle: Text(n.time, style: const TextStyle(fontSize: 11, color: _C.grey)),
                onTap: () { setSt(() => n.read = true); setState(() {}); },
              );
            },
          )),
        ]),
      )),
    );
  }

  void _showWishlist() {
    final wishProducts = _products.where((p) => _wishlist.hasProduct(p.id)).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(builder: (ctx, setSt) => DraggableScrollableSheet(
        expand: false, initialChildSize: 0.6, maxChildSize: 0.9,
        builder: (_, sc) => Column(children: [
          const SizedBox(height: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: _C.border, borderRadius: BorderRadius.circular(2))),
          const Padding(padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Align(alignment: Alignment.centerLeft, child: Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: _C.dark)))),
          Expanded(child: wishProducts.isEmpty
            ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.favorite_border, size: 64, color: _C.border),
                SizedBox(height: 12),
                Text('No wishlist items yet', style: TextStyle(color: _C.grey, fontSize: 14)),
              ]))
            : ListView.separated(
                controller: sc,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: wishProducts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final p = wishProducts[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
                    child: Row(children: [
                      Container(width: 56, height: 56, decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text(p.image, style: const TextStyle(fontSize: 28)))),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(p.price, style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w800)),
                      ])),
                      Row(children: [
                        GestureDetector(
                          onTap: () { _cart.add(p); setState(() {}); setSt(() {}); Navigator.pop(ctx); },
                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: _C.primary, borderRadius: BorderRadius.circular(8)),
                            child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)))),
                        const SizedBox(width: 6),
                        GestureDetector(onTap: () { _wishlist.toggleProduct(p.id); setState(() {}); setSt(() {}); },
                          child: const Icon(Icons.delete_outline, color: _C.grey, size: 18)),
                      ]),
                    ]),
                  );
                },
              )),
        ]),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ──────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
            decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: _C.border))),
            child: Row(children: [
              const Text('Marketplace', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _C.dark)),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showSearchSheet(),
                  child: Container(height: 36,
                    decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.border)),
                    child: Row(children: [
                      Expanded(child: TextField(controller: _searchCtrl, onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(fontSize: 12, color: _C.dark),
                        decoration: const InputDecoration(hintText: 'Search products…', hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 9)))),
                      Container(width: 36, height: 36,
                        decoration: BoxDecoration(color: _C.primary, borderRadius: const BorderRadius.horizontal(right: Radius.circular(7))),
                        child: const Icon(Icons.search, color: Colors.white, size: 16)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _iconBtnWithBadge(icon: Icons.notifications_none_rounded, badge: _unreadNotifCount, onTap: _showNotifications),
              const SizedBox(width: 3),
              _iconBtnWithBadge(icon: Icons.favorite_border_rounded, badge: _wishlist.productIds.length, onTap: _showWishlist),
              const SizedBox(width: 3),
              _iconBtnWithBadge(icon: Icons.shopping_cart_outlined, badge: _cart.count, onTap: _showCart),
            ]),
          ),

          // ── Sort + Post row ──────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _C.border))),
            child: Row(children: [
              const Text('Products', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
              const Spacer(),
              _SortDropdown(value: _sortBy, onChanged: (v) => setState(() => _sortBy = v ?? _sortBy)),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => context.push('/marketplace/create'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: _C.dark, borderRadius: BorderRadius.circular(6)),
                  child: const Row(children: [
                    Icon(Icons.add, color: Colors.white, size: 13),
                    SizedBox(width: 3),
                    Text('Post', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
            ]),
          ),

          // ── Body ─────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Banner carousel
                if (_searchQuery.isEmpty) ...[
                  const SizedBox(height: 12),
                  _BannerCarousel(banners: _banners, currentIndex: _bannerIndex, pageCtrl: _pageCtrl, onPageChanged: (i) => setState(() => _bannerIndex = i)),
                ],
                if (_searchQuery.isNotEmpty)
                  Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text('Results for "$_searchQuery"', style: const TextStyle(fontSize: 13, color: _C.grey, fontStyle: FontStyle.italic))),

                // Categories
                const SizedBox(height: 14),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Categories', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: _C.dark))),
                const SizedBox(height: 8),
                SizedBox(height: 34, child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _productCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = _productCategories[i];
                    final sel = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(color: sel ? _C.primary : _C.lightGrey, borderRadius: BorderRadius.circular(6)),
                        child: Text(cat, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? Colors.white : _C.grey)),
                      ),
                    );
                  },
                )),

                // Products grid
                const SizedBox(height: 14),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('${_filteredProducts.length} Products', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark))),
                const SizedBox(height: 10),
                _ProductGrid(
                  products: _filteredProducts, wishlist: _wishlist,
                  onFavourite: (id) => setState(() => _wishlist.toggleProduct(id)),
                  onAddToCart: (p) { _cart.add(p); setState(() {}); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p.name} added to cart'), backgroundColor: _C.green, duration: const Duration(seconds: 1))); },
                  onTap: (p) => Navigator.push(context, MaterialPageRoute(builder: (_) => _ProductDetailPage(product: p, cart: _cart, wishlist: _wishlist, onMessage: () {}, onCartChanged: () => setState(() {})))).then((_) => setState(() {})),
                ),

                // Popular products
                if (_searchQuery.isEmpty) ...[
                  const SizedBox(height: 8),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Popular Products', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark))),
                  const SizedBox(height: 10),
                  _ProductGrid(
                    products: _popularProducts, wishlist: _wishlist,
                    onFavourite: (id) => setState(() => _wishlist.toggleProduct(id)),
                    onAddToCart: (p) { _cart.add(p); setState(() {}); },
                    onTap: (p) => Navigator.push(context, MaterialPageRoute(builder: (_) => _ProductDetailPage(product: p, cart: _cart, wishlist: _wishlist, onMessage: () {}, onCartChanged: () => setState(() {})))).then((_) => setState(() {})),
                  ),
                ],
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  void _showSearchSheet() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16, left: 16, right: 16, top: 16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(height: 48, decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
            child: TextField(autofocus: true, onChanged: (v) => setState(() => _searchQuery = v), onSubmitted: (_) => Navigator.pop(context),
              decoration: const InputDecoration(hintText: 'Search products…', hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 14), prefixIcon: Icon(Icons.search, color: _C.grey), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14)))),
          const SizedBox(height: 16),
          const Align(alignment: Alignment.centerLeft, child: Text('Popular Searches', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: _C.dark))),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: ['Laptop', 'iPhone', 'Calculator', 'Furniture', 'Headphones'].map((q) =>
            GestureDetector(onTap: () { setState(() => _searchQuery = q); Navigator.pop(context); },
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: _C.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(20), border: Border.all(color: _C.primary.withOpacity(0.2))),
                child: Text(q, style: const TextStyle(fontSize: 12, color: _C.primary, fontWeight: FontWeight.w600))))).toList()),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  Widget _iconBtnWithBadge({required IconData icon, required int badge, required VoidCallback onTap}) =>
    GestureDetector(onTap: onTap, child: Stack(clipBehavior: Clip.none, children: [
      Container(width: 30, height: 30, decoration: BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.circular(8), border: Border.all(color: _C.border)),
        child: Icon(icon, size: 15, color: _C.grey)),
      if (badge > 0) Positioned(top: -4, right: -4, child: Container(width: 15, height: 15,
        decoration: const BoxDecoration(color: _C.primary, shape: BoxShape.circle),
        child: Center(child: Text(badge > 9 ? '9+' : '$badge', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800))))),
    ]));
}

// ─────────────────────────────────────────────
// PRODUCT GRID & CARD (unchanged from original)
// ─────────────────────────────────────────────
class _ProductGrid extends StatelessWidget {
  final List<_Product> products;
  final MarketWishlist wishlist;
  final ValueChanged<String> onFavourite;
  final ValueChanged<_Product> onAddToCart, onTap;
  const _ProductGrid({required this.products, required this.wishlist, required this.onFavourite, required this.onAddToCart, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No products found', style: TextStyle(color: _C.grey, fontSize: 14))));
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.68),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(product: products[i], isFav: wishlist.hasProduct(products[i].id), onFav: () => onFavourite(products[i].id), onAddToCart: () => onAddToCart(products[i]), onTap: () => onTap(products[i])),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final _Product product;
  final bool isFav;
  final VoidCallback onFav, onAddToCart, onTap;
  const _ProductCard({required this.product, required this.isFav, required this.onFav, required this.onAddToCart, required this.onTap});
  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _addAnim;
  late Animation<double> _scaleAnim;
  bool _justAdded = false;
  @override
  void initState() {
    super.initState();
    _addAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.elasticOut)).animate(_addAnim);
  }
  @override
  void dispose() { _addAnim.dispose(); super.dispose(); }
  void _handleAdd() {
    setState(() => _justAdded = true);
    _addAnim.forward().then((_) => _addAnim.reverse().then((_) { if (mounted) setState(() => _justAdded = false); }));
    widget.onAddToCart();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onTap, child: Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: _C.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AspectRatio(aspectRatio: 1.1, child: Stack(children: [
          Container(width: double.infinity, decoration: const BoxDecoration(color: _C.lightGrey, borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
            child: Center(child: Text(widget.product.image, style: const TextStyle(fontSize: 36)))),
          if (widget.product.isNew || widget.product.isSale)
            Positioned(top: 6, left: 6, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: widget.product.isNew ? _C.green : _C.primary, borderRadius: BorderRadius.circular(4)),
              child: Text(widget.product.isNew ? 'NEW' : 'SALE', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)))),
          Positioned(top: 6, right: 6, child: GestureDetector(onTap: widget.onFav,
            child: Container(width: 28, height: 28, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
              child: Icon(widget.isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded, size: 15, color: widget.isFav ? _C.primary : _C.grey)))),
        ])),
        Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(9, 6, 9, 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.product.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _C.dark), maxLines: 2, overflow: TextOverflow.ellipsis),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (widget.product.oldPrice.isNotEmpty)
              Text(widget.product.oldPrice, style: const TextStyle(fontSize: 10, color: _C.grey, decoration: TextDecoration.lineThrough)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Flexible(child: Text(widget.product.price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _C.primary), overflow: TextOverflow.ellipsis)),
              ScaleTransition(scale: _scaleAnim, child: GestureDetector(onTap: _handleAdd,
                child: AnimatedContainer(duration: const Duration(milliseconds: 250), width: 28, height: 28,
                  decoration: BoxDecoration(color: _justAdded ? _C.green : _C.dark, borderRadius: BorderRadius.circular(8)),
                  child: Icon(_justAdded ? Icons.check_rounded : Icons.add_shopping_cart_rounded, color: Colors.white, size: 14)))),
            ]),
          ]),
        ]))),
      ]),
    ));
  }
}

// ─────────────────────────────────────────────
// BANNER CAROUSEL
// ─────────────────────────────────────────────
class _BannerCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> banners;
  final int currentIndex;
  final PageController pageCtrl;
  final ValueChanged<int> onPageChanged;
  const _BannerCarousel({required this.banners, required this.currentIndex, required this.pageCtrl, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Stack(alignment: Alignment.bottomCenter, children: [
      SizedBox(height: 140, child: PageView.builder(controller: pageCtrl, onPageChanged: onPageChanged, itemCount: banners.length, itemBuilder: (_, i) {
        final b = banners[i];
        return Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [b['color1'] as Color, b['color2'] as Color], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(14)),
          child: Row(children: [
            Expanded(child: Padding(padding: const EdgeInsets.fromLTRB(18, 18, 0, 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(b['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2)),
              const SizedBox(height: 5),
              Text(b['sub'] as String, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ]))),
            Padding(padding: const EdgeInsets.only(right: 14), child: Text(b['emoji'] as String, style: const TextStyle(fontSize: 56))),
          ]));
      })),
      Positioned(bottom: 10, child: Row(children: List.generate(banners.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: 3), width: currentIndex == i ? 16 : 6, height: 6, decoration: BoxDecoration(color: currentIndex == i ? Colors.white : Colors.white38, borderRadius: BorderRadius.circular(3)))))),
    ]));
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
    return DropdownButtonHideUnderline(child: DropdownButton<String>(value: value, style: const TextStyle(fontSize: 11, color: _C.dark, fontWeight: FontWeight.w500), icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: _C.grey), onChanged: onChanged, items: const [
      DropdownMenuItem(value: 'Most popular', child: Text('Most popular')),
      DropdownMenuItem(value: 'Price: Low to High', child: Text('Price: Low')),
      DropdownMenuItem(value: 'Price: High to Low', child: Text('Price: High')),
      DropdownMenuItem(value: 'Newest', child: Text('Newest')),
      DropdownMenuItem(value: 'Rating', child: Text('Rating')),
    ]));
  }
}

// ─────────────────────────────────────────────
// PRODUCT DETAIL PAGE (unchanged)
// ─────────────────────────────────────────────
class _ProductDetailPage extends StatefulWidget {
  final _Product product;
  final MarketCart cart;
  final MarketWishlist wishlist;
  final VoidCallback onMessage, onCartChanged;
  const _ProductDetailPage({required this.product, required this.cart, required this.wishlist, required this.onMessage, required this.onCartChanged});
  @override
  State<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<_ProductDetailPage> {
  int _qty = 1;
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18), onPressed: () => Navigator.pop(context)),
        title: const Text('Product Details', style: TextStyle(color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)), centerTitle: true),
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
            const SizedBox(height: 16),
            const Text('Description', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _C.dark)),
            const SizedBox(height: 6),
            Text(p.description, style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.5)),
            const SizedBox(height: 80),
          ])),
        ]))),
        Container(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _C.border))),
          child: Row(children: [
            Container(decoration: BoxDecoration(border: Border.all(color: _C.border), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                IconButton(onPressed: () => setState(() { if (_qty > 1) _qty--; }), icon: const Icon(Icons.remove, size: 16)),
                Text('$_qty', style: const TextStyle(fontWeight: FontWeight.w700)),
                IconButton(onPressed: () => setState(() => _qty++), icon: const Icon(Icons.add, size: 16)),
              ])),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () { for (int i = 0; i < _qty; i++) { widget.cart.add(widget.product); } widget.onCartChanged(); Navigator.pop(context); },
              child: Text('Add to Cart ($_qty)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
          ])),
      ]));
  }
}

// ─────────────────────────────────────────────
// CART PAGE (unchanged from original)
// ─────────────────────────────────────────────
class _CartPage extends StatefulWidget {
  final MarketCart cart;
  final VoidCallback onUpdate;
  const _CartPage({required this.cart, required this.onUpdate});
  @override
  State<_CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<_CartPage> {
  int _step = 0;
  String _paymentMethod = 'Gude Wallet';
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
    return Scaffold(backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: _C.dark, size: 18), onPressed: () => Navigator.pop(context)),
        title: Text(_step == 0 ? 'My Cart' : 'Checkout', style: const TextStyle(color: _C.dark, fontWeight: FontWeight.w700, fontSize: 16)), centerTitle: true),
      body: _step == 0 ? _cartBody() : _checkoutBody());
  }

  Widget _cartBody() => widget.cart.items.isEmpty
    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.shopping_cart_outlined, size: 72, color: _C.border),
        const SizedBox(height: 14),
        const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _C.dark)),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: _C.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Browse Products', style: TextStyle(color: Colors.white))),
      ]))
    : Column(children: [
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: widget.cart.items.length, itemBuilder: (_, i) {
          final item = widget.cart.items[i];
          return Container(margin: const EdgeInsets.only(bottom: 12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
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
            ]));
        })),
        Container(padding: const EdgeInsets.all(16), color: Colors.white, child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)), Text(_fmt(widget.cart.subtotal), style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w800, fontSize: 16))]),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => setState(() => _step = 1), child: Text('Checkout (${widget.cart.count})', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
        ])),
      ]);

  Widget _checkoutBody() => Column(children: [
    Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Payment Method', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _C.dark)),
      const SizedBox(height: 10),
      ...['Gude Wallet', 'Credit/Debit Card', 'EFT / Instant Pay'].map((m) => GestureDetector(onTap: () => setState(() => _paymentMethod = m), child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: _paymentMethod == m ? _C.primary.withOpacity(0.05) : Colors.white, border: Border.all(color: _paymentMethod == m ? _C.primary : _C.border, width: _paymentMethod == m ? 2 : 1), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Icon(m.contains('Wallet') ? Icons.account_balance_wallet_outlined : m.contains('Card') ? Icons.credit_card_outlined : Icons.swap_horiz_rounded, color: _paymentMethod == m ? _C.primary : _C.grey, size: 20),
          const SizedBox(width: 12),
          Text(m, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: _paymentMethod == m ? _C.primary : _C.dark)),
          const Spacer(),
          Container(width: 20, height: 20, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: _paymentMethod == m ? _C.primary : _C.border, width: 2)), child: _paymentMethod == m ? Container(margin: const EdgeInsets.all(3), decoration: const BoxDecoration(color: _C.primary, shape: BoxShape.circle)) : null),
        ])))),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal', style: TextStyle(color: _C.grey, fontSize: 13)), Text(_fmt(widget.cart.subtotal), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping', style: TextStyle(color: _C.grey, fontSize: 13)), const Text('R0.00', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))]),
        const Divider(height: 14),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), Text(_fmt(widget.cart.subtotal), style: const TextStyle(color: _C.primary, fontWeight: FontWeight.w800, fontSize: 13))]),
      ])),
    ]))),
    Container(padding: const EdgeInsets.fromLTRB(16, 12, 16, 24), color: Colors.white,
      child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _C.primary, minimumSize: const Size(double.infinity, 52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: _placeOrder, child: Text('Place Order · ${_fmt(widget.cart.subtotal)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)))),
  ]);

  Widget _successScreen(BuildContext ctx) => Scaffold(backgroundColor: Colors.white, body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: Column(children: [
    const Spacer(flex: 2),
    Container(width: 120, height: 120, decoration: const BoxDecoration(color: Color(0xFFF0FFF4), shape: BoxShape.circle), child: const Center(child: Text('🎉', style: TextStyle(fontSize: 56)))),
    const SizedBox(height: 24),
    const Text('Order placed successfully!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _C.dark)),
    const Spacer(),
    SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _C.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), onPressed: () => Navigator.of(ctx).popUntil((r) => r.isFirst), child: const Text('Continue Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
    const SizedBox(height: 10),
    TextButton(onPressed: () => Navigator.of(ctx).popUntil((r) => r.isFirst), child: const Text('Back', style: TextStyle(color: _C.grey))),
  ]))));
}