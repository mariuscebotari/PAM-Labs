import '../../domain/entities/catalog.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_datasource.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  const CatalogRepositoryImpl({required CatalogRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final CatalogRemoteDataSource _remoteDataSource;

  @override
  Future<CatalogEntity> getCatalog() async {
    return await _remoteDataSource.getFeedCatalog();
  }

  @override
  Future<ProductDetailsEntity> getProductDetails(String productId) async {
    return await _remoteDataSource.getFeedDetails();
  }
}
