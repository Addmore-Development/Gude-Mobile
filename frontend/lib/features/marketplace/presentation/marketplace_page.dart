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
// PRODUCT DATA MODEL
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

// ─────────────────────────────────────────────
// SERVICE DATA MODEL
// ─────────────────────────────────────────────
class _Service {
  final String id, name, description, price, image, category, provider, university;
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
    required this.university,
    required this.rating,
    required this.reviews,
    this.isFeatured = false,
  });
}

// ─────────────────────────────────────────────
// PRODUCT DATA
// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
// SERVICES DATA
// ─────────────────────────────────────────────
const _services = [
  // Academic / School-related
  _Service(id:'s1', name:'Mathematics Tutoring', description:'Grade 10–12 & university maths, stats, and calculus', price:'R120/hr', image:'📐', category:'Academic', provider:'Sipho M.', university:'UCT', rating:4.9, reviews:34, isFeatured:true),
  _Service(id:'s2', name:'Essay Writing Coaching', description:'Structure, grammar, referencing & academic writing', price:'R100/hr', image:'✍️', category:'Academic', provider:'Aisha K.', university:'Wits', rating:4.7, reviews:22),
  _Service(id:'s3', name:'Physics & Chemistry Tutoring', description:'High school and first-year university level', price:'R130/hr', image:'⚗️', category:'Academic', provider:'Lebo T.', university:'UP', rating:4.8, reviews:19, isFeatured:true),
  _Service(id:'s4', name:'Accounting Tutoring', description:'Financial accounting, management accounting & tax', price:'R110/hr', image:'🧾', category:'Academic', provider:'Zanele D.', university:'UJ', rating:4.6, reviews:15),
  _Service(id:'s5', name:'Assignment & Report Help', description:'Editing, proofreading, and formatting assistance', price:'R80/hr', image:'📝', category:'Academic', provider:'Ruan P.', university:'SU', rating:4.5, reviews:28),
  _Service(id:'s6', name:'Coding & Programming Help', description:'Python, Java, C++, web dev and data science', price:'R150/hr', image:'💻', category:'Academic', provider:'Keanu N.', university:'CPUT', rating:4.8, reviews:41, isFeatured:true),
  _Service(id:'s7', name:'Study Group Facilitation', description:'Organised group study sessions for any subject', price:'R60/hr', image:'👥', category:'Academic', provider:'Fatima H.', university:'UKZN', rating:4.4, reviews:12),
  _Service(id:'s8', name:'English Language Support', description:'ESL coaching, pronunciation, and comprehension', price:'R90/hr', image:'🗣️', category:'Academic', provider:'Ntando B.', university:'UWC', rating:4.6, reviews:18),
  // Non-academic / General services
  _Service(id:'s9', name:'Graphic Design', description:'Logos, posters, social media content & branding', price:'R200/job', image:'🎨', category:'Creative', provider:'Yusuf A.', university:'TUT', rating:4.7, reviews:53),
  _Service(id:'s10', name:'Photography', description:'Events, portraits, product & campus photography', price:'R350/session', image:'📷', category:'Creative', provider:'Nandi M.', university:'DUT', rating:4.9, reviews:37, isFeatured:true),
  _Service(id:'s11', name:'Social Media Management', description:'Content creation, posting schedules & analytics', price:'R500/month', image:'📱', category:'Digital', provider:'Cara V.', university:'Rhodes', rating:4.5, reviews:24),
  _Service(id:'s12', name:'Video Editing', description:'YouTube, reels, TikTok, corporate & event edits', price:'R250/video', image:'🎬', category:'Digital', provider:'Thabo G.', university:'VUT', rating:4.7, reviews:31),
  _Service(id:'s13', name:'CV & Cover Letter Writing', description:'Professional CVs tailored to SA job market', price:'R180/CV', image:'📄', category:'Professional', provider:'Priya S.', university:'NMU', rating:4.8, reviews:62, isFeatured:true),
  _Service(id:'s14', name:'Cooking & Meal Prep', description:'Healthy affordable student meals, batch cooking', price:'R90/session', image:'🍱', category:'Lifestyle', provider:'Amahle Z.', university:'WSU', rating:4.3, reviews:9),
  _Service(id:'s15', name:'Home Cleaning', description:'Student digs and apartment cleaning service', price:'R150/visit', image:'🧹', category:'Lifestyle', provider:'Bongani L.', university:'MUT', rating:4.4, reviews:16),
  _Service(id:'s16', name:'Music Lessons', description:'Guitar, piano, drums & vocal training for all levels', price:'R110/hr', image:'🎸', category:'Creative', provider:'Dylan F.', university:'SU', rating:4.6, reviews:20),
  _Service(id:'s17', name:'Delivery & Errands', description:'Campus deliveries, grocery runs & courier tasks', price:'R50/trip', image:'🛵', category:'Lifestyle', provider:'Khanya M.', university:'UFS', rating:4.2, reviews:44),
  _Service(id:'s18', name:'IT & Tech Support', description:'Laptop repair, software setup & virus removal', price:'R120/hr', image:'🔧', category:'Digital', provider:'Imran R.', university:'CUT', rating:4.7, reviews:29),
];

const _productCategories = ['All','Electronics','Bags','Books','Cosmetics','Shoes','Watches','Clothes'];
const _serviceCategories = ['All','Academic','Creative','Digital','Professional','Lifestyle'];

const _banners = [
  {'title':'40% Off\nBlack Friday',   'sub':'From R6000.00–R9,294.99',    'emoji':'📺', 'color1':Color(0xFF1A1A1A), 'color2':Color(0xFF333333)},
  {'title':'Student Deals\nThis Week','sub':'Exclusive campus discounts',  'emoji':'🎒', 'color1':Color(0xFF0D47A1), 'color2':Color(0xFF1565C0)},
  {'title':'Flash Sale\n50% Off',     'sub':'Limited time — grab it fast', 'emoji':'⚡', 'color1':Color(0xFF880E4F), 'color2':Color(0xFFC62828)},
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
  final _searchCtrl               = TextEditingController();
  final _pageCtrl                 = PageController();
  final Set<String> _favourites   = {};
  final Set<String> _savedServices = {};

  // ── Filtered products using live search query ──
  List<_Product> get _filteredProducts => _products.where((p) {
    final catMatch = _selectedProductCategory == 'All' ||
        p.category == _selectedProductCategory;
    final qMatch = _searchQuery.isEmpty ||
        p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        p.category.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  // ── Filtered services using live search query ──
  List<_Service> get _filteredServices => _services.where((s) {
    final catMatch = _selectedServiceCategory == 'All' ||
        s.category == _selectedServiceCategory;
    final qMatch = _searchQuery.isEmpty ||
        s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        s.provider.toLowerCase().contains(_searchQuery.toLowerCase());
    return catMatch && qMatch;
  }).toList();

  List<_Service> get _featuredServices =>
      _services.where((s) => s.isFeatured).toList();

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

  @override
  Widget build(BuildContext context) {
    final isServices = _selectedTab == 'Services';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────
            _TopBar(
              searchCtrl: _searchCtrl,
              onSearch:       _onSearch,
              onSearchSubmit: _onSearch,
              onClear:        _clearSearch,
              hasQuery:       _searchQuery.isNotEmpty,
            ),

            // ── Tab row + Sort ────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: _C.border)),
              ),
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
                ],
              ),
            ),

            // ── Scrollable body ───────────────────
            Expanded(
              child: isServices
                  ? _ServicesBody(
                      searchQuery:             _searchQuery,
                      filteredServices:        _filteredServices,
                      featuredServices:        _featuredServices,
                      savedServices:           _savedServices,
                      selectedCategory:        _selectedServiceCategory,
                      onCategoryChanged:       (c) => setState(() => _selectedServiceCategory = c),
                      onSave:                  (id) => setState(() {
                        _savedServices.contains(id)
                            ? _savedServices.remove(id)
                            : _savedServices.add(id);
                      }),
                      onTap:                   (s) => context.push('/marketplace/listing', extra: {
                        'name': s.provider, 'title': s.name,
                        'university': s.university, 'price': s.price,
                        'rating': s.rating.toString(), 'jobs': s.reviews.toString(),
                      }),
                    )
                  : _MarketplaceBody(
                      searchQuery:              _searchQuery,
                      filteredProducts:         _filteredProducts,
                      allProducts:              _products,
                      favourites:               _favourites,
                      selectedCategory:         _selectedProductCategory,
                      onCategoryChanged:        (c) => setState(() => _selectedProductCategory = c),
                      bannerIndex:              _bannerIndex,
                      pageCtrl:                 _pageCtrl,
                      onBannerChanged:          (i) => setState(() => _bannerIndex = i),
                      onFavourite:              (id) => setState(() {
                        _favourites.contains(id)
                            ? _favourites.remove(id)
                            : _favourites.add(id);
                      }),
                      onTap:                    (p) => context.push('/marketplace/listing', extra: {
                        'name': 'Student', 'title': p.name,
                        'university': 'UCT', 'price': p.price,
                        'rating': p.rating.toString(), 'jobs': '10',
                      }),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabPill(String label, bool otherSelected) {
    final sel = !otherSelected || label == _selectedTab;
    final isThisSelected = _selectedTab == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedTab = label;
        _searchQuery = '';
        _searchCtrl.clear();
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final popularProducts = allProducts.where((p) => p.rating >= 4.5).toList();
    final filteredPopular = searchQuery.isEmpty
        ? popularProducts
        : popularProducts.where((p) =>
            p.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner only when not searching
          if (searchQuery.isEmpty) ...[
            const SizedBox(height: 14),
            _BannerCarousel(
              banners:      _banners,
              currentIndex: bannerIndex,
              pageCtrl:     pageCtrl,
              onPageChanged: onBannerChanged,
            ),
          ],

          // Search result indicator
          if (searchQuery.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                'Results for "$searchQuery"',
                style: const TextStyle(
                    fontSize: 13,
                    color: _C.grey,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],

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
              itemCount: _productCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _productCategories[i];
                final sel = selectedCategory == cat;
                return GestureDetector(
                  onTap: () => onCategoryChanged(cat),
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

          // Products header
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${filteredProducts.length} Products',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _C.dark)),
                const Text('View all',
                    style: TextStyle(
                        fontSize: 12,
                        color: _C.primary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          _ProductGrid(
            products:    filteredProducts,
            favourites:  favourites,
            onFavourite: onFavourite,
            onTap:       onTap,
          ),

          // Popular Products — only when not searching
          if (searchQuery.isEmpty) ...[
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
              products:    filteredPopular,
              favourites:  favourites,
              onFavourite: onFavourite,
              onTap:       onTap,
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
          // Featured banner (only when not searching)
          if (searchQuery.isEmpty) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
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
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5)),
                        ),
                        const SizedBox(height: 8),
                        const Text('Skills for hire,\nright on campus',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                height: 1.2)),
                        const SizedBox(height: 4),
                        const Text('18 services available now',
                            style: TextStyle(
                                color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                  ),
                  const Text('🎓', style: TextStyle(fontSize: 56)),
                ],
              ),
            ),
          ],

          // Search result indicator
          if (searchQuery.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                'Results for "$searchQuery"',
                style: const TextStyle(
                    fontSize: 13,
                    color: _C.grey,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],

          // Category chips
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

          // Featured services row (only when not searching and showing All)
          if (searchQuery.isEmpty && selectedCategory == 'All') ...[
            const SizedBox(height: 18),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text('⭐ Featured Services',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _C.dark)),
                ],
              ),
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
                  onTap:  () => onTap(featuredServices[i]),
                ),
              ),
            ),
          ],

          // All services list
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  searchQuery.isNotEmpty
                      ? '${filteredServices.length} results'
                      : selectedCategory == 'All'
                          ? 'All Services (${filteredServices.length})'
                          : '$selectedCategory (${filteredServices.length})',
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _C.dark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          if (filteredServices.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.search_off_rounded,
                        size: 48, color: _C.grey),
                    const SizedBox(height: 12),
                    Text(
                      searchQuery.isNotEmpty
                          ? 'No services match "$searchQuery"'
                          : 'No services in this category',
                      style: const TextStyle(color: _C.grey, fontSize: 14),
                    ),
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
                service:  filteredServices[i],
                isSaved:  savedServices.contains(filteredServices[i].id),
                onSave:   () => onSave(filteredServices[i].id),
                onTap:    () => onTap(filteredServices[i]),
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FEATURED SERVICE CARD (horizontal scroll)
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
            // Image area
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
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
                      style: const TextStyle(
                          fontSize: 10, color: _C.grey)),
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
                              size: 11, color: Color(0xFFF59E0B)),
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
// SERVICE LIST CARD (vertical list)
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
            // Emoji icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _C.lightGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(service.image,
                    style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 12),
            // Info
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
                          fontSize: 11,
                          color: _C.grey,
                          height: 1.3),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // University badge
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
                          size: 11, color: Color(0xFFF59E0B)),
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
            // Price + save
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
// TOP BAR — with clear button when typing
// ─────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onSearchSubmit;
  final VoidCallback onClear;
  final bool hasQuery;

  const _TopBar({
    required this.searchCtrl,
    required this.onSearch,
    required this.onSearchSubmit,
    required this.onClear,
    required this.hasQuery,
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
          const Text('Marketplace',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.dark)),
          const SizedBox(width: 12),

          // Search bar — takes all remaining space
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
                      style:
                          const TextStyle(fontSize: 13, color: _C.dark),
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
                  // Clear button when query is active
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
          const SizedBox(width: 8),

          // Icon cluster
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _iconBtn(Icons.notifications_none_rounded),
              const SizedBox(width: 6),
              _iconBtn(Icons.shopping_cart_outlined),
              const SizedBox(width: 6),
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: _C.lightGrey,
                  shape: BoxShape.circle,
                  border: Border.all(color: _C.border),
                ),
                child: const Icon(Icons.person_rounded,
                    size: 17, color: _C.grey),
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
                      colors: [
                        b['color1'] as Color,
                        b['color2'] as Color
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20, 20, 0, 20),
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
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                  banners.length,
                  (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin:
                            const EdgeInsets.symmetric(horizontal: 3),
                        width: currentIndex == i ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: currentIndex == i
                              ? Colors.white
                              : Colors.white38,
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
// PRODUCT GRID
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
        crossAxisCount:  2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
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
                                  decoration:
                                      TextDecoration.lineThrough)),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                                  borderRadius:
                                      BorderRadius.circular(6),
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
          DropdownMenuItem(
              value: 'Most popular', child: Text('Most popular')),
          DropdownMenuItem(
              value: 'Price: Low to High',
              child: Text('Price: Low to High')),
          DropdownMenuItem(
              value: 'Price: High to Low',
              child: Text('Price: High to Low')),
          DropdownMenuItem(value: 'Newest', child: Text('Newest')),
          DropdownMenuItem(value: 'Rating', child: Text('Rating')),
        ],
      ),
    );
  }
}