import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/catalog_cubit.dart';
import 'data/catalog_repository.dart';
import 'screens/home_screen.dart';

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CatalogCubit(CatalogRepository())..load(),
    child: MaterialApp(
      title: 'GemStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D2D2D),
          primary: const Color(0xFF2D2D2D),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const HomeScreen(),
    ),
  );
}
