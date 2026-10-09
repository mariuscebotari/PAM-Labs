import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'product_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notes, color: Colors.black, size: 28),
          onPressed: () {},
        ),
        title: const Text(
          'GemStore',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black, size: 26),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildCategoriesSection(),
            const SizedBox(height: 24),
            _buildHeroBanner(),
            const SizedBox(height: 28),
            _buildSectionHeader('Feature Products', () {}),
            const SizedBox(height: 16),
            _buildFeatureProductsList(context),
            const SizedBox(height: 28),
            _buildHangoutBanner(),
            const SizedBox(height: 28),
            _buildSectionHeader('Recommended', () {}),
            const SizedBox(height: 16),
            _buildRecommendedList(context),
            const SizedBox(height: 28),
            _buildSectionHeader('Top Collection', () {}),
            const SizedBox(height: 16),
            _buildTopCollectionSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {'icon': Icons.female, 'label': 'Women'},
      {'icon': Icons.male, 'label': 'Men'},
      {'icon': Icons.watch, 'label': 'Accessories'},
      {'icon': Icons.auto_awesome, 'label': 'Beauty'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((cat) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Icon(
                cat['icon'] as IconData,
                size: 22,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cat['label'] as String,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.4), Colors.transparent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Autumn\nCollection\n2021',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(isActive: false),
                  _buildDot(isActive: true),
                  _buildDot(isActive: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 8 : 6,
      height: isActive ? 8 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.white : Colors.white54,
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onShowAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: onShowAll,
          child: const Text(
            'Show all',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureProductsList(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mockProducts.length,
        itemBuilder: (context, index) {
          final product = mockProducts[index];
          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHangoutBanner() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFBF8F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '| NEW COLLECTION',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 1.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'HANG OUT\n& PARTY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              width: 140,
              height: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=400',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendedProducts.length,
        itemBuilder: (context, index) {
          final product = recommendedProducts[index];
          return HorizontalProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopCollectionSection(BuildContext context) {
    return Column(
      children: [
        _buildCollectionBanner(
          subtitle: '| Sale up to 40%',
          title: 'FOR SLIM\n& BEAUTY',
          imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
          backgroundColor: const Color(0xFFF9F7F5),
        ),
        const SizedBox(height: 16),
        _buildCollectionBanner(
          subtitle: '| Summer Collection 2021',
          title: 'Most sexy\n& fabulous\ndesign',
          imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600',
          backgroundColor: const Color(0xFFF5F5F7),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildSmallCollectionCard(
                subtitle: 'T-Shirts',
                title: 'The\nOffice\nLife',
                imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=400',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSmallCollectionCard(
                subtitle: 'Dresses',
                title: 'Elegant\nDesign',
                imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCollectionBanner({
    required String subtitle,
    required String title,
    required String imageUrl,
    required Color backgroundColor,
  }) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              width: 140,
              height: double.infinity,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCollectionCard({
    required String subtitle,
    required String title,
    required String imageUrl,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            width: 90,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2D2D),
                    height: 1.2,
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
