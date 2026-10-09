import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int selectedColorIndex = 0;
  int selectedSizeIndex = 2; // Default selected 'L' as in Figma design
  bool isFavorite = false;
  bool isDescriptionExpanded = true;
  bool isReviewsExpanded = true;
  bool isSimilarExpanded = true;

  final Color primaryGreen = const Color(0xFF3A5A40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Area with Circular Backdrop Accent & Controls
            Stack(
              children: [
                Container(
                  height: 440,
                  width: double.infinity,
                  color: const Color(0xFFF9F9F9),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Circular background shape behind model image
                      Container(
                        width: 280,
                        height: 280,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF2E9E1),
                        ),
                      ),
                      // Product Model Image
                      widget.product.imageUrl.startsWith('assets/')
                          ? Image.asset(
                              widget.product.imageUrl,
                              fit: BoxFit.contain,
                              height: 400,
                            )
                          : Image.network(
                              widget.product.imageUrl,
                              fit: BoxFit.contain,
                              height: 400,
                            ),
                      // Carousel Indicator Dots at bottom of image
                      Positioned(
                        bottom: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildImageDot(isActive: true),
                            _buildImageDot(isActive: false),
                            _buildImageDot(isActive: false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Top Action Buttons (Back & Favorite)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          elevation: 2,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.arrow_back_ios_new,
                                  size: 16, color: Colors.black87),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Material(
                          elevation: 2,
                          shape: const CircleBorder(),
                          color: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Product Details Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1E20),
                        ),
                      ),
                      Text(
                        '\$ ${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1E20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rating Stars & Count
                  Row(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 16,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.product.reviewCount})',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Color & Size Selection Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Color Selection
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Color',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: List.generate(
                                widget.product.colors.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedColorIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedColorIndex == index
                                            ? Colors.black87
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor:
                                          widget.product.colors[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Size Selection
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Size',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: List.generate(
                                widget.product.sizes.length,
                                (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedSizeIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedSizeIndex == index
                                          ? const Color(0xFF333333)
                                          : const Color(0xFFF5F5F5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.product.sizes[index],
                                        style: TextStyle(
                                          color: selectedSizeIndex == index
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),

                  // Description Accordion
                  _buildAccordionHeader(
                    title: 'Description',
                    isExpanded: isDescriptionExpanded,
                    onTap: () {
                      setState(() {
                        isDescriptionExpanded = !isDescriptionExpanded;
                      });
                    },
                  ),
                  if (isDescriptionExpanded)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(text: widget.product.description),
                            const TextSpan(
                              text: ' Read more',
                              style: TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),

                  // Reviews Accordion
                  _buildAccordionHeader(
                    title: 'Reviews',
                    isExpanded: isReviewsExpanded,
                    onTap: () {
                      setState(() {
                        isReviewsExpanded = !isReviewsExpanded;
                      });
                    },
                  ),
                  if (isReviewsExpanded) _buildReviewsContent(),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),

                  // Similar Product Accordion
                  _buildAccordionHeader(
                    title: 'Similar Product',
                    isExpanded: isSimilarExpanded,
                    onTap: () {
                      setState(() {
                        isSimilarExpanded = !isSimilarExpanded;
                      });
                    },
                  ),
                  if (isSimilarExpanded)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                      child: SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: mockProducts.length,
                          itemBuilder: (context, index) {
                            final product = mockProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      product: product,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Action Bar ("Add To Cart")
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D2D2D),
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 20),
            label: const Text(
              'Add To Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageDot({required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 8 : 6,
      height: isActive ? 8 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black87 : Colors.grey.shade400,
      ),
    );
  }

  Widget _buildAccordionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1E20),
              ),
            ),
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Score & Distribution Breakdown
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  widget.product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1E20),
                  ),
                ),
                const Text(
                  'OUT OF 5',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 12,
                      color: primaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.product.reviewCount} ratings',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  _buildRatingBar(5, 0.80, '80%'),
                  _buildRatingBar(4, 0.12, '12%'),
                  _buildRatingBar(3, 0.05, '5%'),
                  _buildRatingBar(2, 0.03, '3%'),
                  _buildRatingBar(1, 0.00, '0%'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Reviews Count & Write Review Action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.product.reviews.length * 23 + 1} Reviews',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                const Text(
                  'WRITE A REVIEW',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(Icons.edit_outlined, size: 14, color: Colors.grey.shade600),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // List of Individual Reviews
        ...widget.product.reviews.map((review) => _buildReviewTile(review)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildRatingBar(int star, double percent, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text('$star', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(width: 4),
          Icon(Icons.star, size: 10, color: primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: const Color(0xFFEEEEEE),
                color: primaryGreen,
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTile(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(review.userImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF1D1E20),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 12,
                          color: primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.timeAgo,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
