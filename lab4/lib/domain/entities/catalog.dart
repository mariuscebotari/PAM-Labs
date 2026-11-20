import 'product.dart';

class CollectionBannerEntity {
  const CollectionBannerEntity({
    required this.title,
    required this.imageUrl,
    required this.label,
  });

  final String title;
  final String imageUrl;
  final String label;
}

class StoreCategoryEntity {
  const StoreCategoryEntity({
    required this.id,
    required this.name,
    this.iconUrl,
  });

  final String id;
  final String name;
  final String? iconUrl;
}

class CatalogEntity {
  const CatalogEntity({
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
  final CollectionBannerEntity banner;
  final List<ProductEntity> products;
  final Set<String> initialFavorites;
  final List<StoreCategoryEntity> categories;
  final CollectionBannerEntity newCollection;
  final List<CollectionBannerEntity> topCollections;
  final List<CollectionBannerEntity> categoryPromos;
}
