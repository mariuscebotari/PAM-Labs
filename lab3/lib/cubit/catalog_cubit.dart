import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/catalog_repository.dart';
import '../models/catalog.dart';

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
    List<Product> visible = const [],
    this.error,
  }) : favorites = Set.unmodifiable(favorites),
       visible = List.unmodifiable(visible);
  final CatalogStatus status;
  final Catalog? catalog;
  final String query;
  final ProductGroup group;
  final ProductSort sort;
  final Set<String> favorites;
  final bool onlyFavorites;
  final List<Product> visible;
  final String? error;
}

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit(this._repository) : super(CatalogState());
  final CatalogRepository _repository;
  bool _loading = false;
  final Map<String, int> _cart = {};
  int get cartItemCount =>
      _cart.values.fold(0, (total, quantity) => total + quantity);
  void addToCart(Product product, {String? size, String? color}) {
    final key = '${product.id}|${size ?? ''}|${color ?? ''}';
    _cart.update(key, (quantity) => quantity + 1, ifAbsent: () => 1);
  }

  Future<void> load() async {
    if (_loading || isClosed) return;
    _loading = true;
    final previous = state;
    emit(CatalogState());
    try {
      final catalog = await _repository.load();
      if (isClosed) return;
      _update(
        catalog: catalog,
        favorites: previous.catalog == null
            ? catalog.initialFavorites
            : previous.favorites,
        query: previous.query,
        group: previous.group,
        sort: previous.sort,
        onlyFavorites: previous.onlyFavorites,
      );
    } catch (_) {
      if (!isClosed) {
        emit(
          CatalogState(
            status: CatalogStatus.error,
            error: 'Catalogul nu a putut fi încărcat. Verifică fișierul JSON și încearcă din nou.',
          ),
        );
      }
    } finally {
      _loading = false;
    }
  }

  void search(String query) => _update(query: query);
  void filter(ProductGroup group) => _update(group: group);
  void sortBy(ProductSort sort) => _update(sort: sort);
  void showFavorites(bool value) => _update(onlyFavorites: value);
  void resetFilters() =>
      _update(query: '', group: ProductGroup.all, sort: ProductSort.original);
  void toggleFavorite(String id) {
    final favorites = {...state.favorites};
    if (!favorites.add(id)) favorites.remove(id);
    _update(favorites: favorites);
  }

  void _update({
    Catalog? catalog,
    String? query,
    ProductGroup? group,
    ProductSort? sort,
    Set<String>? favorites,
    bool? onlyFavorites,
  }) {
    final data = catalog ?? state.catalog;
    if (data == null) return;
    final q = query ?? state.query;
    final g = group ?? state.group;
    final s = sort ?? state.sort;
    final f = favorites ?? state.favorites;
    final only = onlyFavorites ?? state.onlyFavorites;
    final products = data.products
        .where(
          (p) =>
              p.name.toLowerCase().contains(q.trim().toLowerCase()) &&
              (g == ProductGroup.all || p.group == g) &&
              (!only || f.contains(p.id)),
        )
        .toList();
    switch (s) {
      case ProductSort.original:
        break;
      case ProductSort.priceAscending:
        products.sort((a, b) => a.price.compareTo(b.price));
      case ProductSort.priceDescending:
        products.sort((a, b) => b.price.compareTo(a.price));
      case ProductSort.name:
        products.sort((a, b) => a.name.compareTo(b.name));
    }
    emit(
      CatalogState(
        status: products.isEmpty ? CatalogStatus.empty : CatalogStatus.success,
        catalog: data,
        query: q,
        group: g,
        sort: s,
        favorites: f,
        onlyFavorites: only,
        visible: products,
      ),
    );
  }
}
