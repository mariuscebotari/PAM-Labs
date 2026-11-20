import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../models/catalog_model.dart';
import '../models/product_model.dart';

abstract class CatalogRemoteDataSource {
  Future<CatalogModel> getFeedCatalog();
  Future<ProductDetailsModel> getFeedDetails();
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  CatalogRemoteDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const String feedUrl =
      'https://test-api-jlbn.onrender.com/lab2026/v1/feed';
  static const String detailsUrl =
      'https://test-api-jlbn.onrender.com/lab2026/v1/feed/details';

  @override
  Future<CatalogModel> getFeedCatalog() async {
    try {
      final feedResponse = await _client.get(Uri.parse(feedUrl));
      final detailsResponse = await _client.get(Uri.parse(detailsUrl));

      if (feedResponse.statusCode == 200 && detailsResponse.statusCode == 200) {
        final feedJson =
            jsonDecode(feedResponse.body) as Map<String, dynamic>;
        final detailsJson =
            jsonDecode(detailsResponse.body) as Map<String, dynamic>;

        return CatalogModel.fromApiJson(feedJson, detailsJson);
      } else {
        throw ServerException(
          'Serverul a returnat codul HTTP ${feedResponse.statusCode}',
        );
      }
    } on ServerException {
      rethrow;
    } on ParseException {
      rethrow;
    } on FormatException {
      throw ParseException('Eroare la procesarea răspunsului JSON de la server.');
    } catch (e) {
      throw NetworkException(
        'Nu s-a putut stabili conexiunea cu serverul. Verifică conexiunea la internet (Wi-Fi).',
      );
    }
  }

  @override
  Future<ProductDetailsModel> getFeedDetails() async {
    try {
      final response = await _client.get(Uri.parse(detailsUrl));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ProductDetailsModel.fromJson(
          json['product'] as Map<String, dynamic>,
        );
      } else {
        throw ServerException(
          'Serverul a returnat codul HTTP ${response.statusCode}',
        );
      }
    } on ServerException {
      rethrow;
    } on ParseException {
      rethrow;
    } on FormatException {
      throw ParseException('Eroare la procesarea răspunsului JSON de la server.');
    } catch (e) {
      throw NetworkException(
        'Nu s-a putut stabili conexiunea cu serverul. Verifică conexiunea la internet (Wi-Fi).',
      );
    }
  }
}
