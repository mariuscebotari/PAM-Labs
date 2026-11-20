import '../../domain/entities/catalog.dart';
import '../../domain/entities/product.dart';

enum CatalogStatus { loading, success, empty, error }

enum ProductSort {
  original('Implicit'),
  priceAscending('Preț crescător'),
  priceDescending('Preț descrescător'),
  name('Name A–Z');

  const ProductSort(this.label);
  final String label;
}

class CatalogState {
  CatalogState({
    this.status = CatalogStatus.loading,
    this.catalog,
    this.query = '',
    this.group = ProductGroup.all,
    this.sort = ProductSort.original,
    Set<String> favorites = const {},
    this.onlyFavorites = false,
    List<ProductEntity> visible = const [],
    this.error,
  })  : favorites = Set.unmodifiable(favorites),
        visible = List.unmodifiable(visible);

  final CatalogStatus status;
  final CatalogEntity? catalog;
  final String query;
  final ProductGroup group;
  final ProductSort sort;
  final Set<String> favorites;
  final bool onlyFavorites;
  final List<ProductEntity> visible;
  final String? error;
}
