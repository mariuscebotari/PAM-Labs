import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/catalog_remote_datasource.dart';
import 'data/repositories/catalog_repository_impl.dart';
import 'domain/usecases/get_catalog_usecase.dart';
import 'domain/usecases/get_product_details_usecase.dart';
import 'presentation/cubit/catalog_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = CatalogRemoteDataSourceImpl();
    final repository = CatalogRepositoryImpl(remoteDataSource: remoteDataSource);
    final getCatalogUseCase = GetCatalogUseCase(repository);
    final getProductDetailsUseCase = GetProductDetailsUseCase(repository);

    return MaterialApp(
      title: 'GemStore - Lab 4',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => CatalogCubit(
          getCatalogUseCase: getCatalogUseCase,
          getProductDetailsUseCase: getProductDetailsUseCase,
        )..loadCatalog(),
        child: const HomeScreen(),
      ),
    );
  }
}
