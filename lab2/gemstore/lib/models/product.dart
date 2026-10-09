import 'package:flutter/material.dart';

class Review {
  final String userName;
  final String userImage;
  final String timeAgo;
  final double rating;
  final String comment;

  Review({
    required this.userName,
    required this.userImage,
    required this.timeAgo,
    required this.rating,
    required this.comment,
  });
}

class Product {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<Color> colors;
  final List<String> sizes;
  final List<Review> reviews;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.colors,
    required this.sizes,
    this.reviews = const [],
  });
}

final List<Review> defaultReviews = [
  Review(
    userName: 'Jennifer Rose',
    userImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    timeAgo: '5m ago',
    rating: 5.0,
    comment:
        'I love it. Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!',
  ),
  Review(
    userName: 'Kelly Rihana',
    userImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
    timeAgo: '9m ago',
    rating: 5.0,
    comment:
        'I\'m very happy with order, It was delivered on and good quality. Recommended!',
  ),
];

final List<Product> mockProducts = [
  Product(
    id: '1',
    title: 'Sportwear Set',
    price: 80.00,
    description:
        'Sportswear is no longer under culture, it is no longer indie or cobbled together as it once was. Sport is fashion today. The top is oversized in fit and style, may need to size down.',
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
    rating: 4.9,
    reviewCount: 83,
    colors: [
      const Color(0xFFE8C5A8),
      Colors.black,
      const Color(0xFFE56B6F),
    ],
    sizes: ['S', 'M', 'L'],
    reviews: defaultReviews,
  ),
  Product(
    id: '2',
    title: 'Turtleneck Sweater',
    price: 39.99,
    description:
        'Warm, cozy turtleneck sweater crafted from premium knit fabric. Ideal for cold autumn and winter days.',
    imageUrl:
        'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600',
    rating: 4.7,
    reviewCount: 45,
    colors: [
      Colors.white,
      Colors.black,
      Colors.grey,
    ],
    sizes: ['S', 'M', 'L', 'XL'],
    reviews: defaultReviews,
  ),
  Product(
    id: '3',
    title: 'Long Sleeve Dress',
    price: 45.00,
    description:
        'Elegant long sleeve dress featuring a subtle floral print and lightweight fabric.',
    imageUrl:
        'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600',
    rating: 4.8,
    reviewCount: 62,
    colors: [
      Colors.black,
      const Color(0xFF8B0000),
    ],
    sizes: ['S', 'M', 'L'],
    reviews: defaultReviews,
  ),
  Product(
    id: '4',
    title: 'Rise Crop Hoodie',
    price: 43.00,
    description:
        'Stylish cropped hoodie with adjustable drawstring. Designed for active workouts and casual wear.',
    imageUrl:
        'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600',
    rating: 4.6,
    reviewCount: 29,
    colors: [
      Colors.grey,
      Colors.black,
    ],
    sizes: ['S', 'M', 'L'],
    reviews: defaultReviews,
  ),
  Product(
    id: '5',
    title: 'Gym Crop Top',
    price: 39.99,
    description:
        'Breathable athletic crop top with ergonomic stitching for maximum comfort during training.',
    imageUrl:
        'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?w=600',
    rating: 4.9,
    reviewCount: 112,
    colors: [
      const Color(0xFF9E7B9B),
      Colors.black,
    ],
    sizes: ['S', 'M', 'L'],
    reviews: defaultReviews,
  ),
];

final List<Product> recommendedProducts = [
  Product(
    id: 'r1',
    title: 'White fashion hoodie',
    price: 29.00,
    description: 'Casual white hoodie for everyday wear.',
    imageUrl:
        'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?w=600',
    rating: 4.8,
    reviewCount: 34,
    colors: [Colors.white, Colors.black],
    sizes: ['S', 'M', 'L'],
    reviews: defaultReviews,
  ),
  Product(
    id: 'r2',
    title: 'Cotton T-Shirt',
    price: 30.00,
    description: 'Soft 100% organic cotton black t-shirt.',
    imageUrl:
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=600',
    rating: 4.9,
    reviewCount: 51,
    colors: [Colors.black, Colors.white],
    sizes: ['S', 'M', 'L'],
    reviews: defaultReviews,
  ),
];
