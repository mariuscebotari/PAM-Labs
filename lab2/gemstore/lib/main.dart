import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GemStoreApp());
}

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GemStore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D2D2D),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}