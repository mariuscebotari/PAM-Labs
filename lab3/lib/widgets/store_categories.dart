import 'package:flutter/material.dart';

import '../models/catalog.dart';

class StoreCategories extends StatelessWidget {
  const StoreCategories({super.key, required this.categories});
  final List<StoreCategory> categories;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final category in categories)
        Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Icon(
                  switch (category.id) {
                    'women' => Icons.female,
                    'men' => Icons.male,
                    'accessories' => Icons.watch,
                    _ => Icons.auto_awesome,
                  },
                  size: 22,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}
