import '../entities/catalog.dart';
import '../entities/product.dart';

abstract class CatalogRepository {
  Future<CatalogEntity> getCatalog();
  Future<ProductDetailsEntity> getProductDetails(String productId);
}
