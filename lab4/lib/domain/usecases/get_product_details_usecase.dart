import '../entities/product.dart';
import '../repositories/catalog_repository.dart';

class GetProductDetailsUseCase {
  const GetProductDetailsUseCase(this._repository);
  final CatalogRepository _repository;

  Future<ProductDetailsEntity> call(String productId) =>
      _repository.getProductDetails(productId);
}
