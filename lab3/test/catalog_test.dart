import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gem_store/cubit/catalog_cubit.dart';
import 'package:gem_store/data/catalog_repository.dart';
import 'package:gem_store/models/catalog.dart';

class MemoryBundle extends CachingAssetBundle {
  MemoryBundle(this.source);
  final String source;
  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(Uint8List.fromList(utf8.encode(source)));
}

void main() {
  final source = File('lab v1.json').readAsStringSync();
  late CatalogCubit cubit;
  setUp(
    () => cubit = CatalogCubit(CatalogRepository(bundle: MemoryBundle(source))),
  );
  tearDown(() => cubit.close());

  test('JSON real: 8 produse, detaliile p003 și favorita inițială', () async {
    final statuses = <CatalogStatus>[];
    final subscription = cubit.stream.listen((s) => statuses.add(s.status));
    await cubit.load();
    await Future<void>.delayed(Duration.zero);
    expect(statuses, [CatalogStatus.loading, CatalogStatus.success]);
    expect(cubit.state.visible, hasLength(8));
    expect(cubit.state.favorites, {'p003'});
    final product = cubit.state.visible.singleWhere((p) => p.id == 'p003');
    expect(product.details!.availability, {'S': false, 'M': false, 'L': true});
    expect(product.details!.reviews, hasLength(2));
    await subscription.cancel();
  });

  test(
    'Căutarea ignoră spațiile și literele mari; filtrele se combină',
    () async {
      await cubit.load();
      cubit.search('  CROP  ');
      expect(cubit.state.visible, hasLength(2));
      cubit.filter(ProductGroup.featured);
      expect(cubit.state.status, CatalogStatus.empty);
      cubit.resetFilters();
      expect(cubit.state.visible, hasLength(8));
      cubit.filter(ProductGroup.recommended);
      expect(cubit.state.visible.map((p) => p.id), ['p004', 'p005']);
    },
  );

  test(
    'Sortarea prețurilor în ambele direcții și sortarea după nume',
    () async {
      await cubit.load();
      cubit.sortBy(ProductSort.priceAscending);
      expect(cubit.state.visible.first.id, 'p004');
      expect(cubit.state.visible.last.id, 'p003');
      cubit.sortBy(ProductSort.priceDescending);
      expect(cubit.state.visible.first.id, 'p003');
      cubit.sortBy(ProductSort.name);
      expect(cubit.state.visible.first.name, 'Cotton T-shirt');
    },
  );

  test('Eliminarea ultimei favorite produce Empty; reîncărcarea păstrează selecția', () async {
    await cubit.load();
    cubit.showFavorites(true);
    expect(cubit.state.visible.single.id, 'p003');
    cubit.toggleFavorite('p003');
    expect(cubit.state.status, CatalogStatus.empty);
    await cubit.load();
    expect(cubit.state.favorites, isEmpty);
    expect(cubit.state.status, CatalogStatus.empty);
    cubit.showFavorites(false);
    cubit.toggleFavorite('p001');
    cubit.showFavorites(true);
    expect(cubit.state.visible.single.id, 'p001');
  });

  test('JSON invalid produce Error fără excepție necontrolată', () async {
    final invalid = CatalogCubit(
      CatalogRepository(bundle: MemoryBundle('{invalid')),
    );
    await invalid.load();
    expect(invalid.state.status, CatalogStatus.error);
    expect(invalid.state.error, isNotEmpty);
    await invalid.close();
  });

  test('Un catalog fără produse produce Empty', () async {
    final json = jsonDecode(source) as Map<String, dynamic>;
    json['homePage']['featureProducts'] = [];
    json['homePage']['recommended'] = [];
    json['productPage']['product']['similarProducts'] = [];
    final empty = CatalogCubit(
      CatalogRepository(bundle: MemoryBundle(jsonEncode(json))),
    );
    await empty.load();
    expect(empty.state.status, CatalogStatus.empty);
    await empty.close();
  });
}
