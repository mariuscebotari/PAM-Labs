import 'package:flutter/material.dart' show Color;

enum ProductGroup {
  all('Toate'),
  featured('Selecția noastră'),
  recommended('Recomandate'),
  similar('Produse similare');

  const ProductGroup(this.label);
  final String label;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.group,
    this.details,
  });
  final String id, name, currency, imageUrl;
  final double price;
  final ProductGroup group;
  final ProductDetails? details;
  // Interfața modelelor din lab2 este păstrată pentru widgeturile reutilizate.
  String get title => name;
  String get description =>
      details?.description ?? 'No additional description available.';
  double get rating => details?.rating ?? 0;
  int get reviewCount => details?.ratingCount ?? 0;
  List<Color> get colors =>
      details?.colors.map((c) => Color(c.value)).toList() ?? [];
  List<String> get sizes => details?.sizes ?? [];
  List<Review> get reviews => details?.reviews ?? [];
  String get formattedPrice => '${price.toStringAsFixed(2)} $currency';
  factory Product.fromJson(
    Map<String, dynamic> json,
    ProductGroup group, {
    ProductDetails? details,
  }) => Product(
    id: json['id'] as String,
    name: json['name'] as String,
    price: (json['price'] as num).toDouble(),
    currency: json['currency'] as String,
    imageUrl: (json['imageUrl'] ?? json['mainImageUrl']) as String,
    group: group,
    details: details,
  );
}

class ProductDetails {
  ProductDetails.fromJson(Map<String, dynamic> json)
    : description = json['description'] as String,
      images = List<String>.from(json['galleryImageUrls'] as List),
      sizes = List<String>.from(json['availableSizes'] as List),
      availability = Map<String, bool>.from(json['sizeAvailability'] as Map),
      selectedSize = json['selectedSize'] as String,
      selectedColor = json['selectedColor'] as String,
      colors = (json['availableColors'] as List)
          .map((e) => ProductColor.fromJson(e))
          .toList(),
      rating = (json['rating'] as num).toDouble(),
      ratingCount = json['ratingCount'] as int,
      reviewCount = json['reviewCount'] as int,
      ratingBreakdown = List.unmodifiable(
        (json['ratingBreakdown'] as List).map(
          (e) => RatingShare(e['stars'] as int, e['percentage'] as int),
        ),
      ),
      reviews = (json['reviews'] as List)
          .map((e) => Review.fromJson(e))
          .toList();
  final String description, selectedSize, selectedColor;
  final List<String> images, sizes;
  final Map<String, bool> availability;
  final List<ProductColor> colors;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final List<RatingShare> ratingBreakdown;
  final List<Review> reviews;
}

class ProductColor {
  ProductColor.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String,
      value = int.parse(
        'FF${(json['value'] as String).substring(1)}',
        radix: 16,
      );
  final String id, name;
  final int value;
}

class Review {
  Review.fromJson(Map<String, dynamic> json)
    : author = json['author'] as String,
      text = json['text'] as String,
      userImage = json['avatarUrl'] as String,
      timeAgo = json['createdAtLabel'] as String,
      rating = (json['rating'] as num).toDouble();
  final String author, text;
  final String userImage, timeAgo;
  String get userName => author;
  String get comment => text;
  final double rating;
}

class CollectionBanner {
  CollectionBanner.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String,
      imageUrl = json['imageUrl'] as String,
      label = (json['label'] ?? json['category'] ?? '') as String;
  final String title, imageUrl;
  final String label;
}

class RatingShare {
  const RatingShare(this.stars, this.percentage);
  final int stars, percentage;
}

class StoreCategory {
  StoreCategory.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      name = json['name'] as String;
  final String id, name;
}

class Catalog {
  const Catalog({
    required this.name,
    required this.banner,
    required this.products,
    required this.initialFavorites,
    required this.categories,
    required this.newCollection,
    required this.topCollections,
    required this.categoryPromos,
  });
  final String name;
  final CollectionBanner banner;
  final List<Product> products;
  final Set<String> initialFavorites;
  final List<StoreCategory> categories;
  final CollectionBanner newCollection;
  final List<CollectionBanner> topCollections, categoryPromos;
  factory Catalog.fromJson(Map<String, dynamic> json) {
    final home = json['homePage'] as Map<String, dynamic>;
    final detail = json['productPage']['product'] as Map<String, dynamic>;
    final details = ProductDetails.fromJson(detail);
    final products = <Product>[];
    void add(List<dynamic> entries, ProductGroup group) {
      for (final entry in entries) {
        products.add(
          Product.fromJson(
            entry as Map<String, dynamic>,
            group,
            details: entry['id'] == detail['id'] ? details : null,
          ),
        );
      }
    }

    add(home['featureProducts'] as List, ProductGroup.featured);
    add(home['recommended'] as List, ProductGroup.recommended);
    add(detail['similarProducts'] as List, ProductGroup.similar);
    return Catalog(
      name: home['storeName'] as String,
      banner: CollectionBanner.fromJson(home['heroBanner']),
      categories: List.unmodifiable(
        (home['categories'] as List).map((e) => StoreCategory.fromJson(e)),
      ),
      newCollection: CollectionBanner.fromJson(home['newCollection']),
      topCollections: List.unmodifiable(
        (home['topCollections'] as List).map(
          (e) => CollectionBanner.fromJson(e),
        ),
      ),
      categoryPromos: List.unmodifiable(
        (home['categoryPromos'] as List).map(
          (e) => CollectionBanner.fromJson(e),
        ),
      ),
      products: List.unmodifiable(products),
      initialFavorites: {
        if (detail['actions']['isFavorite'] == true) detail['id'] as String,
      },
    );
  }
}
