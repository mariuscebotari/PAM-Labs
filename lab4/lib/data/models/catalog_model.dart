import '../../domain/entities/catalog.dart';
import '../../domain/entities/product.dart';
import 'product_model.dart';

class CollectionBannerModel extends CollectionBannerEntity {
  const CollectionBannerModel({
    required super.title,
    required super.imageUrl,
    required super.label,
  });

  factory CollectionBannerModel.fromJson(Map<String, dynamic> json) {
    return CollectionBannerModel(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      label: (json['label'] ?? json['category'] ?? '') as String,
    );
  }
}

class StoreCategoryModel extends StoreCategoryEntity {
  const StoreCategoryModel({
    required super.id,
    required super.name,
    super.iconUrl,
  });

  factory StoreCategoryModel.fromJson(Map<String, dynamic> json) {
    return StoreCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['iconUrl'] as String?,
    );
  }
}

class CatalogModel extends CatalogEntity {
  const CatalogModel({
    required super.name,
    required super.banner,
    required super.products,
    required super.initialFavorites,
    required super.categories,
    required super.newCollection,
    required super.topCollections,
    required super.categoryPromos,
  });

  factory CatalogModel.fromApiJson(
    Map<String, dynamic> feedJson,
    Map<String, dynamic> detailsJson,
  ) {
    final detail = detailsJson['product'] as Map<String, dynamic>;
    final details = ProductDetailsModel.fromJson(detail);
    final products = <ProductModel>[];

    void add(List<dynamic> entries, ProductGroup group) {
      for (final entry in entries) {
        products.add(
          ProductModel.fromJson(
            entry as Map<String, dynamic>,
            group,
            details: entry['id'] == detail['id'] ? details : null,
          ),
        );
      }
    }

    add(feedJson['featureProducts'] as List, ProductGroup.featured);
    add(feedJson['recommended'] as List, ProductGroup.recommended);
    add(detail['similarProducts'] as List, ProductGroup.similar);

    return CatalogModel(
      name: (feedJson['storeName'] ?? 'GemStore') as String,
      banner: CollectionBannerModel.fromJson(
        feedJson['heroBanner'] as Map<String, dynamic>,
      ),
      categories: List.unmodifiable(
        (feedJson['categories'] as List).map(
          (e) => StoreCategoryModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
      newCollection: CollectionBannerModel.fromJson(
        feedJson['newCollection'] as Map<String, dynamic>,
      ),
      topCollections: List.unmodifiable(
        (feedJson['topCollections'] as List).map(
          (e) => CollectionBannerModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
      categoryPromos: List.unmodifiable(
        (feedJson['categoryPromos'] as List).map(
          (e) => CollectionBannerModel.fromJson(e as Map<String, dynamic>),
        ),
      ),
      products: List.unmodifiable(products),
      initialFavorites: {
        if ((detail['actions'] as Map<String, dynamic>?)?['isFavorite'] == true)
          detail['id'] as String,
      },
    );
  }
}
