import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/catalog_cubit.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.productId});
  final String productId;
  @override
  Widget build(BuildContext context) => BlocBuilder<CatalogCubit, CatalogState>(
    buildWhen: (previous, next) => previous.favorites != next.favorites,
    builder: (context, state) {
      final favorite = state.favorites.contains(productId);
      return IconButton.filledTonal(
        tooltip: favorite ? 'Remove from favorites' : 'Add to favorites',
        style: IconButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () => context.read<CatalogCubit>().toggleFavorite(productId),
        icon: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: favorite ? Colors.redAccent : Colors.black87,
        ),
      );
    },
  );
}
