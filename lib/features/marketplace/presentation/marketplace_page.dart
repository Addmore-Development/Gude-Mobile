import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gude_mobile/core/theme/app_theme.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});
  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'Electronics', 'Bags', 'Books'];

  final List<Map<String, dynamic>> _products = [
    {'name': 'Macbook Pro 16', 'price': 20.90,  'oldPrice': null,  'badge': '15%', 'sold': true},
    {'name': 'Meitorp',        'price': 2500.90, 'oldPrice': null,  'badge': null,  'sold': false},
    {'name': 'iPhone 14',      'price': 999.00,  'oldPrice': 1200.0,'badge': '20%', 'sold': false},
    {'name': 'AirPods Pro',    'price': 299.00,  'oldPrice': 399.0, 'badge': null,  'sold': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(backgroundColor: AppColors.primary,
            child: Icon(Icons.person, color: Colors.white, size: 18)),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
          Stack(children: [
            IconButton(icon: const Icon(Icons.shopping_bag_outlined), onPressed: () => context.go('/cart')),
            Positioned(top: 8, right: 8,
              child: Container(width: 8, height: 8,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))),
          ]),
          IconButton(icon: const Icon(Icons.logout, color: AppColors.textDark),
            onPressed: () => context.go('/login')),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Banner
          Container(
            margin: const EdgeInsets.all(16),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('BLACK FRIDAY', style: TextStyle(color: Colors.white, fontSize: 11, letterSpacing: 1)),
                const Text('20% off', style: TextStyle(color: Colors.yellow, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('all products', style: TextStyle(color: Colors.white, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                  child: const Text('Shop Now', style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
              ])),
              const Text('%', style: TextStyle(color: Colors.orange, fontSize: 48, fontWeight: FontWeight.bold)),
            ]),
          ),
          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search goods and services',
                prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
                suffixIcon: const Icon(Icons.tune, color: AppColors.textGrey),
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Categories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: List.generate(_categories.length, (i) => GestureDetector(
                onTap: () => setState(() => _selectedCategory = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _selectedCategory == i ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _selectedCategory == i ? AppColors.primary : AppColors.inputBorder),
                  ),
                  child: Text(_categories[i],
                    style: TextStyle(
                      color: _selectedCategory == i ? Colors.white : AppColors.textGrey,
                      fontWeight: FontWeight.w500, fontSize: 13,
                    )),
                ),
              ))),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${_products.length} Products', style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(children: [
                const Text('Filter', style: TextStyle(color: AppColors.textGrey, fontSize: 13)),
                const Icon(Icons.tune, size: 16, color: AppColors.textGrey),
              ]),
            ]),
          ),
          const SizedBox(height: 12),
          // Products grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.75,
              crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            itemCount: _products.length,
            itemBuilder: (_, i) => _ProductCard(product: _products[i]),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Popular Product', style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('View all >', style: TextStyle(color: AppColors.primary))),
            ]),
          ),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Stack(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Center(child: Icon(Icons.laptop_mac, size: 60, color: Colors.grey)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product['name'], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              Row(children: [
                Text('R${product['price']}',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                if (product['oldPrice'] != null) ...[
                  const SizedBox(width: 4),
                  Text('R${product['oldPrice']}',
                    style: const TextStyle(decoration: TextDecoration.lineThrough,
                      color: AppColors.textGrey, fontSize: 11)),
                ],
              ]),
            ]),
          ),
        ]),
        if (product['badge'] != null)
          Positioned(top: 8, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
              child: Text(product['badge'], style: const TextStyle(color: Colors.white, fontSize: 10)),
            )),
        if (product['sold'] == true)
          Positioned(top: 8, right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(4)),
              child: const Text('Sold Out', style: TextStyle(color: Colors.white, fontSize: 10)),
            )),
        Positioned(top: 8, right: product['sold'] == true ? 60 : 8,
          child: const Icon(Icons.favorite_border, size: 18, color: AppColors.textGrey)),
        Positioned(bottom: 8, right: 8,
          child: Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          )),
      ]),
    );
  }
}
