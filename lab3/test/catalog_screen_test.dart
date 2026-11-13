import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gem_store/app.dart';
import 'package:gem_store/cubit/catalog_cubit.dart';
import 'package:gem_store/data/catalog_repository.dart';
import 'package:gem_store/screens/catalog_screen.dart';
import 'package:gem_store/screens/home_screen.dart';
import 'package:gem_store/screens/product_detail.dart';

class TestBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => ByteData.sublistView(
    Uint8List.fromList(utf8.encode(File('lab v1.json').readAsStringSync())),
  );
}

Future<CatalogCubit> mount(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final cubit = CatalogCubit(CatalogRepository(bundle: TestBundle()));
  addTearDown(cubit.close);
  await cubit.load();
  await tester.pumpWidget(
    BlocProvider.value(
      value: cubit,
      child: MaterialApp(home: screen),
    ),
  );
  return cubit;
}

Future<void> finishTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets(
    'Home lab2: secțiuni originale, Show all și favorite sincronizate cu detalii',
    (tester) async {
      final cubit = await mount(tester, const HomeScreen());
      expect(find.text('GemStore'), findsOneWidget);
      expect(find.text('Women'), findsOneWidget);
      expect(find.text('Feature Products'), findsOneWidget);
      expect(find.text('Recommended'), findsOneWidget);
      expect(find.text('Top Collection'), findsOneWidget);
      await tester.tap(find.byTooltip('Favorites'));
      await finishTransition(tester);
      expect(find.text('Sportwear Set'), findsOneWidget);
      await tester.ensureVisible(find.text('Sportwear Set'));
      await finishTransition(tester);
      await tester.tap(find.text('Sportwear Set'));
      await finishTransition(tester);
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      expect(find.text('Sportwear Set'), findsOneWidget);
      await tester.tap(find.byTooltip('Remove from favorites').first);
      await tester.pump();
      expect(cubit.state.favorites, isEmpty);
      await tester.tap(find.byTooltip('Back'));
      await finishTransition(tester);
      expect(find.text('No products found'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Căutare, resetare și sortare pe ecran de 320 px', (
    tester,
  ) async {
    final cubit = await mount(
      tester,
      const CatalogScreen(),
      size: const Size(320, 740),
    );
    await tester.enterText(find.byType(TextField), 'inexistent');
    await tester.pump();
    expect(find.text('No products found'), findsOneWidget);
    await tester.ensureVisible(find.text('Reset filters'));
    await finishTransition(tester);
    await tester.tap(find.text('Reset filters'));
    await tester.pump();
    expect(cubit.state.visible, hasLength(8));
    expect(find.text('No products found'), findsNothing);
    await tester.ensureVisible(find.byType(DropdownButton<ProductSort>));
    await finishTransition(tester);
    await tester.tap(find.byType(DropdownButton<ProductSort>));
    await finishTransition(tester);
    await tester.tap(find.text('Preț descrescător').last);
    await finishTransition(tester);
    expect(cubit.state.visible.first.id, 'p003');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home pe ecran îngust păstrează layoutul fără overflow', (
    tester,
  ) async {
    await mount(tester, const HomeScreen(), size: const Size(320, 740));
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -1100),
    );
    await finishTransition(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Detalii: mărimi indisponibile, galerie și adăugare în coș', (
    tester,
  ) async {
    final cubit = await mount(
      tester,
      const HomeScreen(),
      size: const Size(320, 740),
    );
    final product = cubit.state.catalog!.products.singleWhere(
      (p) => p.id == 'p003',
    );
    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(home: ProductDetailScreen(product: product)),
      ),
    );
    expect(find.text('47 Reviews'), findsOneWidget);
    await tester.drag(find.byType(PageView), const Offset(-320, 0));
    await finishTransition(tester);
    await tester.ensureVisible(find.text('S'));
    await finishTransition(tester);
    final smallSize = tester.widget<GestureDetector>(
      find
          .ancestor(of: find.text('S'), matching: find.byType(GestureDetector))
          .first,
    );
    expect(smallSize.onTap, isNull);
    await tester.tap(find.text('Add To Cart'));
    await tester.pump();
    expect(cubit.cartItemCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Aplicația reală încarcă JSON-ul declarat în pubspec', (
    tester,
  ) async {
    await tester.pumpWidget(const GemStoreApp());
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    });
    await tester.pump();
    expect(find.text('Feature Products'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
