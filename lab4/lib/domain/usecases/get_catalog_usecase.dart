import '../entities/catalog.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogUseCase {
  const GetCatalogUseCase(this._repository);
  final CatalogRepository _repository;

  Future<CatalogEntity> call() => _repository.getCatalog();
}
