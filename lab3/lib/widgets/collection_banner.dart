import 'package:flutter/material.dart';

import '../models/catalog.dart';
import 'product_card.dart';

// Bannerul din lab2, reutilizat pentru NEW COLLECTION și Top Collection.
class CollectionBannerWidget extends StatelessWidget {
  const CollectionBannerWidget({
    super.key,
    required this.banner,
    this.height = 160,
    this.compact = false,
  });
  final CollectionBanner banner;
  final double height;
  final bool compact;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Container(
      height: compact ? 180 : height,
      color: const Color(0xFFFBF8F5),
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: constraints.maxWidth * (compact ? 0.55 : 0.40),
              child: buildCustomImage(banner.imageUrl),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: constraints.maxWidth * (compact ? 0.75 : 0.62),
                padding: EdgeInsets.all(compact ? 12 : 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFBF8F5),
                      const Color(0xFFFBF8F5).withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      banner.title,
                      maxLines: compact ? 4 : 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: compact ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D2D2D),
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
