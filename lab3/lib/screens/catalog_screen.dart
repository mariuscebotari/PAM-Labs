import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/catalog_cubit.dart';
import '../models/catalog.dart';
import '../widgets/product_card.dart';
import '../widgets/status_panel.dart';
import 'home_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final TextEditingController _search;
  @override
  void initState() {
    super.initState();
    _search = TextEditingController(
      text: context.read<CatalogCubit>().state.query,
    );
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reset() {
    _search.clear();
    context.read<CatalogCubit>().resetFilters();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<CatalogCubit, CatalogState>(
    builder: (context, state) {
      final cubit = context.read<CatalogCubit>();
      return Scaffold(
        appBar: AppBar(
          title: Text(state.onlyFavorites ? 'Favorites' : 'All products'),
          actions: [
            IconButton(
              tooltip: 'Reload',
              onPressed: state.status == CatalogStatus.loading
                  ? null
                  : cubit.load,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: switch (state.status) {
          CatalogStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          CatalogStatus.error => StatusPanel(
            icon: Icons.error_outline,
            title: 'Unable to load catalog',
            message: state.error!,
            action: 'Retry',
            onAction: cubit.load,
          ),
          _ => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: RefreshIndicator(
                onRefresh: cubit.load,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _search,
                              onChanged: cubit.search,
                              decoration: InputDecoration(
                                hintText: 'Search products',
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: state.query.isEmpty
                                    ? null
                                    : IconButton(
                                        tooltip: 'Clear search',
                                        onPressed: () {
                                          _search.clear();
                                          cubit.search('');
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (final group in ProductGroup.values)
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: ChoiceChip(
                                        label: Text(group.label),
                                        selected: state.group == group,
                                        onSelected: (_) => cubit.filter(group),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                FilterChip(
                                  label: const Text('Favorites only'),
                                  selected: state.onlyFavorites,
                                  onSelected: cubit.showFavorites,
                                  avatar: const Icon(
                                    Icons.favorite_border,
                                    size: 18,
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: DropdownButton<ProductSort>(
                                    isExpanded: true,
                                    value: state.sort,
                                    underline: const SizedBox(),
                                    items: [
                                      for (final sort in ProductSort.values)
                                        DropdownMenuItem(
                                          value: sort,
                                          child: Text(sort.label),
                                        ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) cubit.sortBy(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('${state.visible.length} products'),
                          ],
                        ),
                      ),
                    ),
                    if (state.status == CatalogStatus.empty)
                      SliverToBoxAdapter(
                        child: StatusPanel(
                          icon: Icons.search_off,
                          title: 'No products found',
                          message: state.onlyFavorites
                              ? 'Add a favorite or change the filters.'
                              : 'Try another search or reset the filters.',
                          action: 'Reset filters',
                          onAction: () {
                            _reset();
                            cubit.showFavorites(false);
                          },
                        ),
                      ),
                    if (state.status == CatalogStatus.success)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 4, 24),
                        sliver: SliverLayoutBuilder(
                          builder: (context, constraints) => SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      constraints.crossAxisExtent > 800
                                      ? 4
                                      : constraints.crossAxisExtent > 550
                                      ? 3
                                      : 2,
                                  mainAxisExtent: 260,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 20,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => ProductCard(
                                product: state.visible[index],
                                onTap: () =>
                                    openProduct(context, state.visible[index]),
                              ),
                              childCount: state.visible.length,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        },
      );
    },
  );
}
