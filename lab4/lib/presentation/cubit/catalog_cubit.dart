import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_catalog_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  CatalogCubit({
    required GetCatalogUseCase getCatalogUseCase,
    required GetProductDetailsUseCase getProductDetailsUseCase,
  })  : _getCatalogUseCase = getCatalogUseCase,
        _getProductDetailsUseCase = getProductDetailsUseCase,
        super(CatalogState());

  final GetCatalogUseCase _getCatalogUseCase;
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  Future<void> loadCatalog() async {
    emit(CatalogState(status: CatalogStatus.loading));
    try {
      final catalog = await _getCatalogUseCase();
      final favorites = Set<String>.from(catalog.initialFavorites);
      final visible = _filterAndSort(
        catalog.products,
        query: state.query,
        group: state.group,
        sort: state.sort,
        favorites: favorites,
        onlyFavorites: state.onlyFavorites,
      );
      emit(
        CatalogState(
          status: CatalogStatus.success,
          catalog: catalog,
          favorites: favorites,
          query: state.query,
          group: state.group,
          sort: state.sort,
          onlyFavorites: state.onlyFavorites,
          visible: visible,
        ),
      );
    } catch (e) {
      emit(
        CatalogState(
          status: CatalogStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<ProductDetailsEntity?> loadProductDetails(String productId) async {
    try {
      return await _getProductDetailsUseCase(productId);
    } catch (_) {
      return null;
    }
  }

  void setQuery(String query) {
    emitState(query: query);
  }

  void setGroup(ProductGroup group) {
    emitState(group: group);
  }

  void setSort(ProductSort sort) {
    emitState(sort: sort);
  }

  void setOnlyFavorites(bool onlyFavorites) {
    emitState(onlyFavorites: onlyFavorites);
  }

  void toggleFavorite(String productId) {
    final favorites = Set<String>.from(state.favorites);
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    emitState(favorites: favorites);
  }

  void emitState({
    String? query,
    ProductGroup? group,
    ProductSort? sort,
    Set<String>? favorites,
    bool? onlyFavorites,
  }) {
    final catalog = state.catalog;
    if (catalog == null) return;

    final newQuery = query ?? state.query;
    final newGroup = group ?? state.group;
    final newSort = sort ?? state.sort;
    final newFavorites = favorites ?? state.favorites;
    final newOnlyFavorites = onlyFavorites ?? state.onlyFavorites;

    final visible = _filterAndSort(
      catalog.products,
      query: newQuery,
      group: newGroup,
      sort: newSort,
      favorites: newFavorites,
      onlyFavorites: newOnlyFavorites,
    );

    emit(
      CatalogState(
        status: CatalogStatus.success,
        catalog: catalog,
        query: newQuery,
        group: newGroup,
        sort: newSort,
        favorites: newFavorites,
        onlyFavorites: newOnlyFavorites,
        visible: visible,
      ),
    );
  }

  List<ProductEntity> _filterAndSort(
    List<ProductEntity> products, {
    required String query,
    required ProductGroup group,
    required ProductSort sort,
    required Set<String> favorites,
    required bool onlyFavorites,
  }) {
    var list = products.where((p) {
      if (onlyFavorites && !favorites.contains(p.id)) {
        return false;
      }
      if (group != ProductGroup.all && p.group != group) {
        return false;
      }
      if (query.isNotEmpty) {
        final matchesName = p.name.toLowerCase().contains(query.toLowerCase());
        final matchesId = p.id.toLowerCase().contains(query.toLowerCase());
        if (!matchesName && !matchesId) return false;
      }
      return true;
    }).toList();

    switch (sort) {
      case ProductSort.priceAscending:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSort.priceDescending:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSort.name:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSort.original:
        break;
    }

    return list;
  }
}
