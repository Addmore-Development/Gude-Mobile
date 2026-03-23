import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});
  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final _search = TextEditingController();
  int _selectedCategory = 0;

  final _categories = [
    'All', 'Tutoring', 'Design', 'Coding', 'Campus Services', 'Micro Internships',
  ];

  final _listings = [
    {'name': 'Thabo M.', 'title': 'Maths Tutoring', 'university': 'UCT', 'price': 'R150/hr', 'rating': '4.9', 'jobs': '24'},
    {'name': 'Amara K.', 'title': 'Graphic Design', 'university': 'Wits', 'price': 'R200/hr', 'rating': '4.7', 'jobs': '18'},
    {'name': 'Sipho N.', 'title': 'Web Development', 'university': 'UJ', 'price': 'R250/hr', 'rating': '5.0', 'jobs': '31'},
    {'name': 'Lerato D.', 'title': 'Assignment Editing', 'university': 'UNISA', 'price': 'R100/hr', 'rating': '4.8', 'jobs': '42'},
    {'name': 'Nandi Z.', 'title': 'Photography', 'university': 'DUT', 'price': 'R300/hr', 'rating': '4.6', 'jobs': '15'},
    {'name': 'Karabo L.', 'title': 'Accounting Help', 'university': 'UCT', 'price': 'R180/hr', 'rating': '4.9', 'jobs': '28'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearch(),
            _buildCategories(),
            Expanded(child: _buildListings()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/marketplace/create'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Listing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      color: Colors.white,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Marketplace', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                Text('Find student talent or sell your skills', style: TextStyle(fontSize: 13, color: AppColors.textGrey)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        controller: _search,
        decoration: InputDecoration(
          hintText: 'Search skills, services...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
          filled: true,
          fillColor: const Color(0xFFF5F5F7),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 44,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (_, i) {
          final selected = _selectedCategory == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_categories[i],
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textGrey,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListings() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _listings.length,
      itemBuilder: (_, i) {
        final l = _listings[i];
        return GestureDetector(
          onTap: () => context.push('/marketplace/listing', extra: l),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(l['name']![0],
                    style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l['title']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textDark)),
                      const SizedBox(height: 4),
                      Text('${l['name']} • ${l['university']}', style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFC107), size: 14),
                          const SizedBox(width: 4),
                          Text(l['rating']!, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                          const SizedBox(width: 12),
                          const Icon(Icons.work_outline, size: 14, color: AppColors.textGrey),
                          const SizedBox(width: 4),
                          Text('${l['jobs']} jobs', style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(l['price']!, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Hire', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
