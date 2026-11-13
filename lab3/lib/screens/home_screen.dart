import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/catalog_cubit.dart';
import '../models/catalog.dart';
import '../widgets/product_card.dart';
import '../widgets/collection_banner.dart';
import '../widgets/store_categories.dart';
import '../widgets/status_panel.dart';
import 'catalog_screen.dart';
import 'product_detail.dart';

// Pagina Home din lab2, alimentată acum de CatalogCubit și JSON.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _catalog(
    BuildContext context, {
    ProductGroup group = ProductGroup.all,
    bool favorites = false,
  }) {
    final cubit = context.read<CatalogCubit>();
    cubit.resetFilters();
    cubit.filter(group);
    cubit.showFavorites(favorites);
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const CatalogScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CatalogCubit, CatalogState>(
    builder: (context, state) {
      final catalog = state.catalog;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            tooltip: 'Browse products',
            icon: const Icon(Icons.notes, color: Colors.black, size: 28),
            onPressed: catalog == null ? null : () => _catalog(context),
          ),
          title: Text(
            catalog?.name ?? 'GemStore',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 22,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Favorites',
              icon: Badge(
                isLabelVisible: state.favorites.isNotEmpty,
                label: Text('${state.favorites.length}'),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                  size: 26,
                ),
              ),
              onPressed: catalog == null
                  ? null
                  : () => _catalog(context, favorites: true),
            ),
          ],
        ),
        body: state.status == CatalogStatus.loading
            ? const Center(child: CircularProgressIndicator())
            : state.status == CatalogStatus.error
            ? StatusPanel(
                icon: Icons.error_outline,
                title: 'Unable to load catalog',
                message: state.error!,
                action: 'Retry',
                onAction: context.read<CatalogCubit>().load,
              )
            : catalog!.products.isEmpty
            ? StatusPanel(
                icon: Icons.inventory_2_outlined,
                title: 'No products yet',
                message: 'The catalog is empty.',
                action: 'Reload',
                onAction: context.read<CatalogCubit>().load,
              )
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: RefreshIndicator(
                    onRefresh: context.read<CatalogCubit>().load,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          StoreCategories(categories: catalog.categories),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () =>
                                _catalog(context, group: ProductGroup.featured),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    buildCustomImage(catalog.banner.imageUrl),
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withValues(alpha: 0.4),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: SizedBox(
                                          width: 180,
                                          child: Text(
                                            catalog.banner.title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _header(
                            'Feature Products',
                            () =>
                                _catalog(context, group: ProductGroup.featured),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 240,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (final product in catalog.products.where(
                                  (p) => p.group == ProductGroup.featured,
                                ))
                                  ProductCard(
                                    product: product,
                                    onTap: () => openProduct(context, product),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          CollectionBannerWidget(
                            banner: catalog.newCollection,
                            height: 140,
                          ),
                          const SizedBox(height: 28),
                          _header(
                            'Recommended',
                            () => _catalog(
                              context,
                              group: ProductGroup.recommended,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (final product in catalog.products.where(
                                  (p) => p.group == ProductGroup.recommended,
                                ))
                                  HorizontalProductCard(
                                    product: product,
                                    onTap: () => openProduct(context, product),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          _header('Top Collection', () => _catalog(context)),
                          const SizedBox(height: 16),
                          for (final banner in catalog.topCollections) ...[
                            CollectionBannerWidget(banner: banner),
                            const SizedBox(height: 16),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (
                                var i = 0;
                                i < catalog.categoryPromos.length;
                                i++
                              ) ...[
                                if (i > 0) const SizedBox(width: 12),
                                Expanded(
                                  child: CollectionBannerWidget(
                                    banner: catalog.categoryPromos[i],
                                    compact: true,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            onPressed: () => _catalog(context),
                            icon: const Icon(Icons.search),
                            label: const Text('Browse all products'),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      );
    },
  );

  Widget _header(String title, VoidCallback onShowAll) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      TextButton(
        onPressed: onShowAll,
        child: const Text(
          'Show all',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );
}

void openProduct(BuildContext context, Product product) => Navigator.push<void>(
  context,
  MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
);
