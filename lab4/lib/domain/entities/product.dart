enum ProductGroup {
  all('Toate'),
  featured('Selecția noastră'),
  recommended('Recomandate'),
  similar('Produse similare');

  const ProductGroup(this.label);
  final String label;
}

class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.group,
    this.details,
  });

  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;
  final ProductGroup group;
  final ProductDetailsEntity? details;

  String get formattedPrice => '${price.toStringAsFixed(2)} $currency';
}

class ProductDetailsEntity {
  const ProductDetailsEntity({
    required this.description,
    required this.images,
    required this.sizes,
    required this.availability,
    required this.selectedSize,
    required this.selectedColor,
    required this.colors,
    required this.rating,
    required this.ratingCount,
    required this.reviewCount,
    required this.ratingBreakdown,
    required this.reviews,
  });

  final String description;
  final String selectedSize;
  final String selectedColor;
  final List<String> images;
  final List<String> sizes;
  final Map<String, bool> availability;
  final List<ProductColorEntity> colors;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final List<RatingShareEntity> ratingBreakdown;
  final List<ReviewEntity> reviews;
}

class ProductColorEntity {
  const ProductColorEntity({
    required this.id,
    required this.name,
    required this.value,
  });

  final String id;
  final String name;
  final int value;
}

class RatingShareEntity {
  const RatingShareEntity(this.stars, this.percentage);
  final int stars;
  final int percentage;
}

class ReviewEntity {
  const ReviewEntity({
    required this.author,
    required this.text,
    required this.avatarUrl,
    required this.createdAtLabel,
    required this.rating,
  });

  final String author;
  final String text;
  final String avatarUrl;
  final String createdAtLabel;
  final double rating;
}
