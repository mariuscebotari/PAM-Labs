import '../../domain/entities/product.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.currency,
    required super.imageUrl,
    required super.group,
    super.details,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json,
    ProductGroup group, {
    ProductDetailsEntity? details,
  }) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      imageUrl: (json['imageUrl'] ?? json['mainImageUrl']) as String,
      group: group,
      details: details,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'currency': currency,
        'imageUrl': imageUrl,
      };
}

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.description,
    required super.images,
    required super.sizes,
    required super.availability,
    required super.selectedSize,
    required super.selectedColor,
    required super.colors,
    required super.rating,
    required super.ratingCount,
    required super.reviewCount,
    required super.ratingBreakdown,
    required super.reviews,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      description: json['description'] as String,
      images: List<String>.from(json['galleryImageUrls'] as List),
      sizes: List<String>.from(json['availableSizes'] as List),
      availability: Map<String, bool>.from(json['sizeAvailability'] as Map),
      selectedSize: json['selectedSize'] as String,
      selectedColor: json['selectedColor'] as String,
      colors: (json['availableColors'] as List)
          .map((e) => ProductColorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      ratingCount: json['ratingCount'] as int,
      reviewCount: json['reviewCount'] as int,
      ratingBreakdown: List.unmodifiable(
        (json['ratingBreakdown'] as List).map(
          (e) => RatingShareEntity(e['stars'] as int, e['percentage'] as int),
        ),
      ),
      reviews: (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProductColorModel extends ProductColorEntity {
  const ProductColorModel({
    required super.id,
    required super.name,
    required super.value,
  });

  factory ProductColorModel.fromJson(Map<String, dynamic> json) {
    final hexString = (json['value'] as String).replaceFirst('#', '');
    return ProductColorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      value: int.parse('FF$hexString', radix: 16),
    );
  }
}

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.author,
    required super.text,
    required super.avatarUrl,
    required super.createdAtLabel,
    required super.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      author: json['author'] as String,
      text: json['text'] as String,
      avatarUrl: json['avatarUrl'] as String,
      createdAtLabel: json['createdAtLabel'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
