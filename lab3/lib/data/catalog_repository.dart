import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/catalog.dart';

class CatalogRepository {
  CatalogRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;
  Future<Catalog> load() async {
    final source = await _bundle.loadString('lab v1.json');
    return Catalog.fromJson(jsonDecode(source) as Map<String, dynamic>);
  }
}
