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
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────
class _Product {
  final String id, name, price, oldPrice, image, category;
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
  });
}

const _products = [
  _Product(id:'1', name:'Hp Laptop',            price:'R5,200.00',  image:'💻', category:'Electronics', rating:4.5, isSale:true,  oldPrice:'R6,500.00'),
  _Product(id:'2', name:'Ear Pod',               price:'R350.00',    image:'🎧', category:'Electronics', rating:4.3),
  _Product(id:'3', name:'Iphone 12 Pro Max',     price:'R12,500.00', image:'📱', category:'Electronics', rating:4.8, isNew:true),
  _Product(id:'4', name:'Study Mini Table',      price:'R780.00',    image:'🪑', category:'Furniture',   rating:4.1),
  _Product(id:'5', name:'Macbook 16',            price:'R18,900.00', image:'💻', category:'Electronics', rating:4.9, isSale:true,  oldPrice:'R22,000.00'),
  _Product(id:'6', name:'Desktop Monitor',       price:'R5,200.00',  image:'🖥️', category:'Electronics', rating:4.4),
  _Product(id:'7', name:'SkullCandy Headphone',  price:'R1,200.00',  image:'🎵', category:'Electronics', rating:4.6, isNew:true),
  _Product(id:'8', name:'Russell Hobbs Air Fry', price:'R2,100.00',  image:'🍳', category:'Electronics', rating:4.2, isSale:true),
];

const _categories = ['All','Electronics','Bags','Books','Cosmetics','Shoes','Watches','Clothes'];

const _banners = [
  {'title':'40% Off\nBlack Friday',  'sub':'From R6000.00–R9,294.99',     'emoji':'📺', 'color1':Color(0xFF1A1A1A), 'color2':Color(0xFF333333)},
  {'title':'Student Deals\nThis Week','sub':'Exclusive campus discounts',  'emoji':'🎒', 'color1':Color(0xFF0D47A1), 'color2':Color(0xFF1565C0)},
  {'title':'Flash Sale\n50% Off',    'sub':'Limited time — grab it fast',  'emoji':'⚡', 'color1':Color(0xFF880E4F), 'color2':Color(0xFFC62828)},
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
  String _selectedCategory = 'All';
  String _searchQuery      = '';
  String _sortBy           = 'Most popular';
  int    _bannerIndex      = 0;
  String _selectedTab      = 'Marketplace';
  final _searchCtrl        = TextEditingController();
  final _pageCtrl          = PageController();
  final Set<String> _favourites = {};

  List<_Product> get _filtered => _products.where((p) {
    final catMatch = _selectedCategory == 'All' || p.category == _selectedCategory;
    final qMatch   = _searchQuery.isEmpty ||
        p.name.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────
            _TopBar(
              searchCtrl: _searchCtrl,
              onSearch:       (v) => setState(() => _searchQuery = v),
              onSearchSubmit: (v) => setState(() => _searchQuery = v),
            ),

            // ── Tab row + Sort ────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _C.border)),
              ),
              child: Row(
                children: [
                  _tabPill('Marketplace'),
                  const SizedBox(width: 8),
                  _tabPill('Services'),
                  const Spacer(),
                  const Text('Sort by: ',
                      style: TextStyle(fontSize: 12, color: _C.grey)),
                  _SortDropdown(
                    value: _sortBy,
                    onChanged: (v) => setState(() => _sortBy = v ?? _sortBy),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ───────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner carousel
                    const SizedBox(height: 14),
                    _BannerCarousel(
                      banners:      _banners,
                      currentIndex: _bannerIndex,
                      pageCtrl:     _pageCtrl,
                      onPageChanged: (i) => setState(() => _bannerIndex = i),
                    ),

                    // Categories
                    const SizedBox(height: 18),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Categories',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _C.dark)),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 34,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final cat = _categories[i];
                          final sel = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
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

                    // All Products header
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${_filtered.length} Products',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: _C.dark)),
                          GestureDetector(
                            onTap: () {},
                            child: const Text('View all',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _C.primary,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Products grid — 2 columns
                    _ProductGrid(
                      products:    _filtered,
                      favourites:  _favourites,
                      onFavourite: (id) => setState(() {
                        _favourites.contains(id)
                            ? _favourites.remove(id)
                            : _favourites.add(id);
                      }),
                      onTap: (p) => context.push('/marketplace/listing', extra: {
                        'name': 'Student', 'title': p.name,
                        'university': 'UCT', 'price': p.price,
                        'rating': p.rating.toString(), 'jobs': '10',
                      }),
                    ),

                    // Popular Products header
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Popular Products',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _C.dark)),
                    ),
                    const SizedBox(height: 12),

                    _ProductGrid(
                      products:   _products.where((p) => p.rating >= 4.5).toList(),
                      favourites: _favourites,
                      onFavourite: (id) => setState(() {
                        _favourites.contains(id)
                            ? _favourites.remove(id)
                            : _favourites.add(id);
                      }),
                      onTap: (p) => context.push('/marketplace/listing', extra: {
                        'name': 'Student', 'title': p.name,
                        'university': 'UCT', 'price': p.price,
                        'rating': p.rating.toString(), 'jobs': '10',
                      }),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabPill(String label) {
    final sel = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: sel ? _C.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: sel ? Colors.white : _C.grey)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// TOP BAR  (no overflow — icons in a fixed Row)
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onSearchSubmit;
  const _TopBar({
    required this.searchCtrl,
    required this.onSearch,
    required this.onSearchSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _C.border)),
      ),
      child: Row(
        children: [
          // Title
          const Text('Marketplace',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.dark)),
          const SizedBox(width: 12),

          // Search — takes all remaining space
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
                        hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: _C.primary,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(7)),
                    ),
                    child: const Icon(Icons.search, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Fixed-width icon cluster — won't overflow
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _iconBtn(Icons.notifications_none_rounded),
              const SizedBox(width: 6),
              _iconBtn(Icons.shopping_cart_outlined),
              const SizedBox(width: 6),
              // Avatar
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: _C.lightGrey,
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.border),
                ),
                child: const Icon(Icons.person_rounded, size: 17, color: _C.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon) => Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: _C.lightGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _C.border),
        ),
        child: Icon(icon, size: 17, color: _C.grey),
      );
}

// ─────────────────────────────────────────────
// BANNER CAROUSEL
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
                                      color: Colors.white70, fontSize: 11)),
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

          // Arrows
          Positioned(
            left: 6, top: 0, bottom: 16,
            child: Center(
              child: GestureDetector(
                onTap: () => pageCtrl.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                child: _arrowCircle(Icons.chevron_left),
              ),
            ),
          ),
          Positioned(
            right: 6, top: 0, bottom: 16,
            child: Center(
              child: GestureDetector(
                onTap: () => pageCtrl.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                child: _arrowCircle(Icons.chevron_right),
              ),
            ),
          ),

          // Dots
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(banners.length, (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: currentIndex == i ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: currentIndex == i ? Colors.white : Colors.white38,
                  borderRadius: BorderRadius.circular(3),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrowCircle(IconData icon) => Container(
        width: 26, height: 26,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      );
}

// ─────────────────────────────────────────────
// PRODUCT GRID  — 2 columns, proper aspect ratio
// ─────────────────────────────────────────────
class _ProductGrid extends StatelessWidget {
  final List<_Product> products;
  final Set<String> favourites;
  final ValueChanged<String> onFavourite;
  final ValueChanged<_Product> onTap;

  const _ProductGrid({
    required this.products,
    required this.favourites,
    required this.onFavourite,
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
        crossAxisCount:  2,      // ← 2 columns fits all phones
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75, // tall enough for image + info
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(
        product: products[i],
        isFav:   favourites.contains(products[i].id),
        onFav:   () => onFavourite(products[i].id),
        onTap:   () => onTap(products[i]),
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
  final VoidCallback onFav, onTap;
  const _ProductCard({
    required this.product,
    required this.isFav,
    required this.onFav,
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
            // Image area
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _C.lightGrey,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10)),
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
                          color: product.isNew
                              ? const Color(0xFF10B981)
                              : _C.primary,
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

            // Info area
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
                              onTap: onTap,
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
          DropdownMenuItem(value: 'Most popular',      child: Text('Most popular')),
          DropdownMenuItem(value: 'Price: Low to High',child: Text('Price: Low to High')),
          DropdownMenuItem(value: 'Price: High to Low',child: Text('Price: High to Low')),
          DropdownMenuItem(value: 'Newest',            child: Text('Newest')),
          DropdownMenuItem(value: 'Rating',            child: Text('Rating')),
        ],
      ),
    );
  }
}