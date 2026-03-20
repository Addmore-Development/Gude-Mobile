import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Marketplace',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textDark),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const CreateListingPage())),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Listing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search students, skills, services...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Categories
            const Text('Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              )),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryCard(icon: Icons.person_outline,
                    label: 'Hire a\nStudent', color: Color(0xFF6C63FF)),
                  _CategoryCard(icon: Icons.school_outlined,
                    label: 'Tutoring', color: Color(0xFFE8453C)),
                  _CategoryCard(icon: Icons.location_city_outlined,
                    label: 'Campus\nServices', color: Color(0xFF00C896)),
                  _CategoryCard(icon: Icons.menu_book_outlined,
                    label: 'Academic\nHelp', color: Color(0xFFFF9800)),
                  _CategoryCard(icon: Icons.sell_outlined,
                    label: 'Sell\nItems', color: Color(0xFF2196F3)),
                  _CategoryCard(icon: Icons.work_outline,
                    label: 'Micro\nInternships', color: Color(0xFF9C27B0)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Featured listings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Nearby Listings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  )),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all',
                    style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _demoListings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final l = _demoListings[i];
                return _ListingCard(listing: l,
                  onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => ListingDetailPage(listing: l))));
              },
            ),
          ],
        ),
      ),
    );
  }
}

const _demoListings = [
  _Listing(name: 'Thabo Nkosi', university: 'University of Johannesburg',
    service: 'Mathematics Tutoring', price: 'R150/hr',
    rating: 4.8, jobs: 23, category: 'Tutoring'),
  _Listing(name: 'Ayanda Dlamini', university: 'TUT',
    service: 'Graphic Design & Branding', price: 'R200/hr',
    rating: 4.9, jobs: 41, category: 'Design'),
  _Listing(name: 'Sipho Molefe', university: 'Wits University',
    service: 'Assignment Editing & Proofreading', price: 'R100/hr',
    rating: 4.6, jobs: 15, category: 'Academic Help'),
  _Listing(name: 'Lerato Khumalo', university: 'Nelson Mandela University',
    service: 'Python & Data Science Tutoring', price: 'R180/hr',
    rating: 4.7, jobs: 31, category: 'Tutoring'),
];

class _Listing {
  final String name, university, service, price, category;
  final double rating;
  final int jobs;
  const _Listing({
    required this.name, required this.university, required this.service,
    required this.price, required this.rating, required this.jobs,
    required this.category,
  });
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _CategoryCard({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textDark,
              fontWeight: FontWeight.w500,
            )),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final _Listing listing;
  final VoidCallback onTap;
  const _ListingCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04),
              blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(listing.name[0],
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.service,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.textDark,
                    )),
                  const SizedBox(height: 2),
                  Text(listing.name,
                    style: const TextStyle(
                      fontSize: 12, color: AppColors.textGrey)),
                  const SizedBox(height: 2),
                  Text(listing.university,
                    style: const TextStyle(
                      fontSize: 11, color: AppColors.textGrey)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFB800), size: 14),
                      const SizedBox(width: 2),
                      Text('${listing.rating}',
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                      const SizedBox(width: 8),
                      Text('${listing.jobs} jobs',
                        style: const TextStyle(
                          fontSize: 11, color: AppColors.textGrey)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(listing.price,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          )),
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

// Listing Detail Page
class ListingDetailPage extends StatelessWidget {
  final _Listing listing;
  const ListingDetailPage({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Listing Detail',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(listing.name[0],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      )),
                  ),
                  const SizedBox(height: 12),
                  Text(listing.name,
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold,
                      color: AppColors.textDark)),
                  Text(listing.university,
                    style: const TextStyle(
                      fontSize: 13, color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFB800), size: 16),
                      const SizedBox(width: 4),
                      Text('${listing.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text('• ${listing.jobs} completed jobs',
                        style: const TextStyle(
                          fontSize: 13, color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Text(listing.service,
                    style: const TextStyle(
                      fontSize: 14, color: AppColors.textGrey, height: 1.5)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Price',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16, color: AppColors.textDark)),
                      Text(listing.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_outlined,
                          color: AppColors.primary, size: 16),
                        SizedBox(width: 8),
                        Text('Verified student seller',
                          style: TextStyle(
                            fontSize: 13, color: AppColors.textGrey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => HireStudentPage(listing: listing))),
                    child: const Text('Hire Student',
                      style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Message',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16, fontWeight: FontWeight.w600)),
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

// Hire Student Page
class HireStudentPage extends StatefulWidget {
  final _Listing listing;
  const HireStudentPage({super.key, required this.listing});
  @override
  State<HireStudentPage> createState() => _HireStudentPageState();
}

class _HireStudentPageState extends State<HireStudentPage> {
  final _desc = TextEditingController();
  final _budget = TextEditingController();
  final _deadline = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Hire Student',
          style: TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(widget.listing.name[0],
                      style: const TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.listing.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(widget.listing.service,
                        style: const TextStyle(
                          fontSize: 12, color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _fieldLabel('Job Description'),
            const SizedBox(height: 6),
            TextField(
              controller: _desc,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe what you need done...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _fieldLabel('Budget (ZAR)'),
            const SizedBox(height: 6),
            TextField(
              controller: _budget,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. R500',
                prefixIcon: Icon(Icons.attach_money,
                  color: AppColors.textGrey, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            _fieldLabel('Deadline'),
            const SizedBox(height: 6),
            TextField(
              controller: _deadline,
              decoration: const InputDecoration(
                hintText: 'e.g. 3 days from now',
                prefixIcon: Icon(Icons.calendar_today_outlined,
                  color: AppColors.textGrey, size: 20),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                    title: const Text('Request Sent!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    content: Text(
                      'Your job request has been sent to ${widget.listing.name}. '
                      'You will be notified when they respond.',
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Submit Request',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(text,
    style: const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textGrey));
}

// Create Listing Page
class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});
  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

class _CreateListingPageState extends State<CreateListingPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  String _selectedCategory = 'Tutoring';
  final _categories = [
    'Tutoring', 'Design', 'Coding', 'Academic Help',
    'Campus Services', 'Sell Items', 'Micro Internships',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Listing',
          style: TextStyle(
            color: AppColors.textDark, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Title *'),
            const SizedBox(height: 6),
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                hintText: 'e.g. Mathematics Tutoring'),
            ),
            const SizedBox(height: 16),
            _label('Category *'),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              ),
              items: _categories.map((c) => DropdownMenuItem(
                value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            const SizedBox(height: 16),
            _label('Description *'),
            const SizedBox(height: 6),
            TextField(
              controller: _desc,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your service in detail...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.inputBorder),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            _label('Price (ZAR/hr) *'),
            const SizedBox(height: 6),
            TextField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 150',
                prefixIcon: Icon(Icons.attach_money,
                  color: AppColors.textGrey, size: 20),
              ),
            ),
            const SizedBox(height: 16),
            _label('Portfolio / Proof of skill'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.inputBorder,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.upload_file_outlined,
                      color: AppColors.textGrey, size: 32),
                    SizedBox(height: 8),
                    Text('Tap to upload portfolio',
                      style: TextStyle(
                        color: AppColors.textGrey, fontSize: 13)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Listing created successfully!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: const Text('Submit Listing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
    style: const TextStyle(
      fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textGrey));
}
